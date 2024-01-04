package ch.epfl.alumni;

import java.io.File;
import java.io.FilenameFilter;
import java.io.IOException;
import java.net.MalformedURLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.apache.commons.exec.OS;
import org.apache.ivy.Ivy;
import org.apache.ivy.core.module.descriptor.DefaultDependencyDescriptor;
import org.apache.ivy.core.module.descriptor.DefaultModuleDescriptor;
import org.apache.ivy.core.module.descriptor.DependencyDescriptor;
import org.apache.ivy.core.module.descriptor.ModuleDescriptor;
import org.apache.ivy.core.module.id.ModuleRevisionId;
import org.apache.ivy.core.report.ResolveReport;
import org.apache.ivy.core.resolve.ResolveOptions;
import org.apache.ivy.core.settings.IvySettings;
import org.apache.ivy.core.settings.IvySettings;
import org.apache.ivy.plugins.parser.xml.XmlModuleDescriptorWriter;
import org.apache.ivy.plugins.resolver.DependencyResolver;
import org.apache.ivy.plugins.resolver.URLResolver;
import org.apache.maven.execution.MavenSession;
import org.apache.maven.plugin.AbstractMojo;
import org.apache.maven.plugin.MojoExecutionException; // there is no way to continue
import org.apache.maven.plugins.annotations.Component;
import org.apache.maven.plugins.annotations.Parameter;
import org.apache.maven.project.MavenProject;
import org.apache.maven.toolchain.Toolchain;
import org.apache.maven.toolchain.ToolchainManager;

abstract class ScalaAbstractMojo extends AbstractMojo {

    @Parameter(property="project", required=true, readonly=true)
    protected MavenProject project;

    @Parameter(property="session", required=true, readonly=true)
    protected MavenSession session;

    @Parameter
    protected String[] additionalClasspathElements = new String[0];

    @Parameter(property="project.build.outputDirectory")
    protected File outputDir;

    @Parameter(defaultValue="3.1.1")
    protected String scalaVersion;

    @Parameter(defaultValue="false")
    protected boolean localInstall;

    @Parameter
    protected String[] jvmArgs;

    @Parameter(defaultValue="true")
    protected boolean addOutputToClasspath;

    @Component
    protected ToolchainManager toolchainManager;

    protected static String findJavaExec(Toolchain toolchain) {
        String toolName = OS.isFamilyDOS() ? "java.exe" : "java";
        String javaExec = toolchain == null ? null : toolchain.findTool(toolName);
        if (javaExec == null) {
            javaExec = System.getenv("JAVA_HOME");
            if (javaExec == null && (javaExec = System.getenv("JDK_HOME")) == null && (javaExec = System.getProperty("java.home")) == null) {
                throw new IllegalStateException("Java executable not found.");
            }
            javaExec = javaExec + File.separator + "bin" + File.separator + toolName;
        }
        return javaExec;
    }

    protected File resolveArtifact(String groupId, String artifactId, String version) throws IOException, MalformedURLException, ParseException {
        IvySettings ivySettings = new IvySettings();
        URLResolver resolver = new URLResolver();
        resolver.setM2compatible(true);
        resolver.setName("central");
        resolver.addArtifactPattern("http://central.maven.org/maven2/[organisation]/[module]/[revision]/[artifact](-[revision]).[ext]");
        ivySettings.addResolver((DependencyResolver)resolver);
        ivySettings.setDefaultResolver(resolver.getName());
        Ivy ivy = Ivy.newInstance((IvySettings)ivySettings);
        File ivyfile = File.createTempFile("ivy", ".xml");
        ivyfile.deleteOnExit();
        String[] dep = new String[]{groupId, artifactId, version};
        DefaultModuleDescriptor md = DefaultModuleDescriptor.newDefaultInstance((ModuleRevisionId)ModuleRevisionId.newInstance((String)this.project.getGroupId(), (String)this.project.getArtifactId(), (String)this.project.getVersion()));
        DefaultDependencyDescriptor dd = new DefaultDependencyDescriptor((ModuleDescriptor)md, ModuleRevisionId.newInstance((String)dep[0], (String)dep[1], (String)dep[2]), false, false, true);
        md.addDependency((DependencyDescriptor)dd);
        XmlModuleDescriptorWriter.write((ModuleDescriptor)md, (File)ivyfile);
        String[] confs = new String[]{"default"};
        ResolveOptions resolveOptions = new ResolveOptions().setConfs(confs);
        ResolveReport report = ivy.resolve(ivyfile.toURI().toURL(), resolveOptions);
        File jarArtifactFile = report.getAllArtifactsReports()[0].getLocalFile();
        return jarArtifactFile;
    }

    protected String getMainClasspath() throws MojoExecutionException {
        String cp = this.getLibraryFiles().stream()
            .map(File::getAbsolutePath)
            .collect(Collectors.joining(File.pathSeparator));
        return cp;
    }

    protected String getClasspath() throws MojoExecutionException {
        StringBuilder sb = new StringBuilder(getMainClasspath());
        if (this.additionalClasspathElements.length > 0) {
            String cpathElems = Arrays.stream(this.additionalClasspathElements).collect(Collectors.joining(File.pathSeparator));
            if (OS.isFamilyDOS()) {
                cpathElems = cpathElems.replaceAll("/", "\\\\");
            }
            sb.append(File.pathSeparator);
            sb.append(cpathElems);
        }
        if (this.addOutputToClasspath) {
            sb.append(File.pathSeparator);
            sb.append(this.outputDir);
        }
        return sb.toString();
    }

    protected static String getRegex(String version) {
        String regex = ".*\\.jar";
        if (version.startsWith("3.")) {
            regex = "(compiler-interface|scala3-|jline-|jna-|scala-|tasty-)" + regex;
        } else if (version.matches("^0\\.2[0-7]\\..*")) {
            regex = "(compiler-interface|dotty-(compiler_0\\.|interfaces|library_0\\.2)|jline-|jna-|scala-)" + regex;
        } else if (version.matches("^0\\.1[0-9]\\..*")) {
            regex = "(compiler-interface|dotty-(compiler_0\\.|interfaces|library_0\\.1)|jline-|scala-)" + regex;
        } else if (version.startsWith("0.9.")) {
            regex = "(compiler-interface|dotty-(compiler_0\\.9|interfaces|library_0\\.9)|jline|scala-)" + regex;
        } else if (version.startsWith("0.8.")) {
            regex = "(compiler-interface|dotty-(compiler_0\\.8|interfaces|library_0\\.8)|scala-)" + regex;
        }
        return regex;
    }

    private List<File> getLibraryFiles() throws MojoExecutionException {
        this.getLog().debug((CharSequence)("[getLibraryFiles] localInstall=" + this.localInstall));
        if (this.localInstall) {
            String installationDir = this.getInstallationDir();
            this.getLog().debug((CharSequence)("[getLibraryFiles] installationDir=" + installationDir));
            File libDir = new File(installationDir, "lib");
            if (!libDir.isDirectory()) {
                throw new MojoExecutionException("Directory '" + libDir + "' not found");
            }
            final String regex = getRegex(scalaVersion);
            File[] jars = libDir.listFiles(new FilenameFilter(){

                @Override
                public boolean accept(File dir, String name) {
                    return name.matches(regex) && new File(dir, name).isFile();
                }
            });
            return Arrays.asList(jars);
        }
        ArrayList<File> jars = new ArrayList<File>();
        try {
            // Scala 3.4.x
            if (this.scalaVersion.startsWith("3.4.")) {
                jars.add(this.resolveArtifact("org.scala-lang", "scala3-library_3", this.scalaVersion));
                jars.add(this.resolveArtifact("org.scala-lang", "scala3-compiler_3", this.scalaVersion));
                jars.add(this.resolveArtifact("org.scala-lang", "scala3-interfaces", this.scalaVersion));
                jars.add(this.resolveArtifact("jline", "jline-reader", "3.19.0"));
                jars.add(this.resolveArtifact("jline", "jline-terminal", "3.19.0"));
                jars.add(this.resolveArtifact("jline", "jline-terminal-jna", "3.19.0"));
                jars.add(this.resolveArtifact("net.java.dev.jna", "jna", "5.3.1"));
                jars.add(this.resolveArtifact("org.scala-lang.modules", "scala-asm", "9.5.0-scala-1"));
                jars.add(this.resolveArtifact("org.scala-sbt", "compiler-interface", "1.3.5"));           // ???
            // Scala 3.3.x
            } else if (this.scalaVersion.startsWith("3.3.")) {
                String minorVersion = this.scalaVersion.substring(4);
                // 3.3.2+ introduce compiler-interface-1.9.3.jar (was 1.3.5)
                String interfaceVersion = minorVersion.matches("^[2-9]\\..*") ? "1.9.3" : "1.3.5";
                jars.add(this.resolveArtifact("org.scala-lang", "scala-library", ".2.13.10"));
                jars.add(this.resolveArtifact("org.scala-lang", "scala3-library_3", this.scalaVersion));
                jars.add(this.resolveArtifact("org.scala-lang", "scala3-compiler_3", this.scalaVersion));
                jars.add(this.resolveArtifact("org.scala-lang", "scala3-interfaces", this.scalaVersion));
                jars.add(this.resolveArtifact("jline", "jline-reader", "3.19.0"));
                jars.add(this.resolveArtifact("jline", "jline-terminal", "3.19.0"));
                jars.add(this.resolveArtifact("jline", "jline-terminal-jna", "3.19.0"));
                jars.add(this.resolveArtifact("net.java.dev.jna", "jna", "5.3.1"));
                jars.add(this.resolveArtifact("org.scala-lang.modules", "scala-asm", "9.5.0-scala-1"));   // NEW
                jars.add(this.resolveArtifact("org.scala-sbt", "compiler-interface", interfaceVersion));  // NEW
            // Scala 3.2.x
            } else if (this.scalaVersion.startsWith("3.2.")) {
                jars.add(this.resolveArtifact("org.scala-lang", "scala-library", "2.13.10"));
                jars.add(this.resolveArtifact("org.scala-lang", "scala3-library_3", this.scalaVersion));
                jars.add(this.resolveArtifact("org.scala-lang", "scala3-compiler_3", this.scalaVersion));
                jars.add(this.resolveArtifact("org.scala-lang", "scala3-interfaces", this.scalaVersion));
                jars.add(this.resolveArtifact("jline", "jline-reader", "3.19.0"));
                jars.add(this.resolveArtifact("jline", "jline-terminal", "3.19.0"));
                jars.add(this.resolveArtifact("jline", "jline-terminal-jna", "3.19.0"));
                jars.add(this.resolveArtifact("net.java.dev.jna", "jna", "5.3.1"));
                jars.add(this.resolveArtifact("org.scala-lang.modules", "scala-asm", "9.3.0-scala-1"));   // NEW
                jars.add(this.resolveArtifact("org.scala-sbt", "compiler-interface", "1.3.5"));
            // Scala 3.1.x
            } else if (this.scalaVersion.startsWith("3.1.")) {
                String minorVersion = this.scalaVersion.substring(4);
                // 3.1.2+ introduce scala-library-2.13.8.jar
                String scalaLibVersion = minorVersion.matches("^[2-9]\\..*") ? "2.13.8" : "2.13.6";
                jars.add(this.resolveArtifact("org.scala-lang", "scala-library", scalaLibVersion));
                jars.add(this.resolveArtifact("org.scala-lang", "scala3-library_3", this.scalaVersion));
                jars.add(this.resolveArtifact("org.scala-lang", "scala3-compiler_3", this.scalaVersion));
                jars.add(this.resolveArtifact("org.scala-lang", "scala3-interfaces", this.scalaVersion));
                jars.add(this.resolveArtifact("jline", "jline-reader", "3.19.0"));
                jars.add(this.resolveArtifact("jline", "jline-terminal", "3.19.0"));
                jars.add(this.resolveArtifact("jline", "jline-terminal-jna", "3.19.0"));
                jars.add(this.resolveArtifact("net.java.dev.jna", "jna", "5.3.1"));
                jars.add(this.resolveArtifact("org.scala-lang.modules", "scala-asm", "9.0.1-scala-1"));
                jars.add(this.resolveArtifact("org.scala-sbt", "compiler-interface", "1.3.5"));
            // Scala 3.0.x (up to 3.0.2)
            } else if (this.scalaVersion.startsWith("3.0.")) {
                String minorVersion = this.scalaVersion.substring(4);
                // 3.0.1+ introduce scala-library-2.13.6.jar
                String scalaLibVersion = minorVersion.matches("^[1-9]\\..*") ? "2.13.6" : "2.13.5";
                jars.add(this.resolveArtifact("org.scala-lang", "scala-library", scalaLibVersion));
                jars.add(this.resolveArtifact("org.scala-lang", "scala3-library_3", this.scalaVersion));
                jars.add(this.resolveArtifact("org.scala-lang", "scala3-compiler_3", this.scalaVersion));
                jars.add(this.resolveArtifact("org.scala-lang", "scala3-interfaces", this.scalaVersion));
                jars.add(this.resolveArtifact("jline", "jline-reader", "3.19.0"));
                jars.add(this.resolveArtifact("jline", "jline-terminal", "3.19.0"));
                jars.add(this.resolveArtifact("jline", "jline-terminal-jna", "3.19.0"));
                jars.add(this.resolveArtifact("net.java.dev.jna", "jna", "5.3.1"));
                jars.add(this.resolveArtifact("org.scala-lang.modules", "scala-asm", "9.0.1-scala-1"));
                jars.add(this.resolveArtifact("org.scala-sbt", "compiler-interface", "1.3.5"));

            //////////////////////////////////////////////////////////////////
            // Scala 2 versions
            //
            // Scala 2.13.x (up to 2.13.12)
            } else if (this.scalaVersion.startsWith("2.13.")) {
                jars.add(this.resolveArtifact("org.scala-lang", "scala-library", this.scalaVersion));
                jars.add(this.resolveArtifact("org.scala-lang", "scala-compiler", this.scalaVersion));
                jars.add(this.resolveArtifact("org.scala-lang", "scala-reflect", this.scalaVersion));
                String minorVersion = this.scalaVersion.substring(5);
                if (minorVersion.startsWith("11") || minorVersion.startsWith("12")) {
                    jars.add(this.resolveArtifact("org.jline", "jline", "3.22.0"));
                    jars.add(this.resolveArtifact("net.java.dev.jna", "jna", "5.13.0"));
                    jars.add(this.resolveArtifact("io.github.java-diff-utils", "java-diff-utils", "4.12"));
                } else if (minorVersion.startsWith("9") || minorVersion.startsWith("10")) {
                    jars.add(this.resolveArtifact("org.jline", "jline", "3.21.0"));
                    jars.add(this.resolveArtifact("net.java.dev.jna", "jna", "5.9.0"));
                    jars.add(this.resolveArtifact("io.github.java-diff-utils", "java-diff-utils", "4.12"));
                } else if (minorVersion.startsWith("8")) {
                    jars.add(this.resolveArtifact("org.jline", "jline", "3.21.0"));
                    jars.add(this.resolveArtifact("net.java.dev.jna", "jna", "5.9.0"));
                } else if (minorVersion.startsWith("7")) {
                    jars.add(this.resolveArtifact("org.jline", "jline", "3.20.0"));
                    jars.add(this.resolveArtifact("net.java.dev.jna", "jna", "5.8.0"));
                } else if (minorVersion.startsWith("6")) {
                    jars.add(this.resolveArtifact("org.jline", "jline", "3.19.0"));
                    jars.add(this.resolveArtifact("net.java.dev.jna", "jna", "5.3.1"));
                } else if (minorVersion.startsWith("5")) {
                    jars.add(this.resolveArtifact("org.jline", "jline", "3.19.0"));
                    jars.add(this.resolveArtifact("net.java.dev.jna", "jna", "5.3.1"));
                } else if (minorVersion.startsWith("4")) {
                    jars.add(this.resolveArtifact("org.jline", "jline", "3.16.0"));
                    jars.add(this.resolveArtifact("net.java.dev.jna", "jna", "5.3.1"));
                } else if (minorVersion.startsWith("3")) {
                    jars.add(this.resolveArtifact("org.jline", "jline", "3.15.0"));
                    jars.add(this.resolveArtifact("net.java.dev.jna", "jna", "5.3.1"));
                } else if (minorVersion.startsWith("2")) {
                    jars.add(this.resolveArtifact("org.jline", "jline", "3.14.1"));
                    jars.add(this.resolveArtifact("net.java.dev.jna", "jna", "5.3.1"));
                } else {
                    jars.add(this.resolveArtifact("org.jline", "jline", "2.14.6"));
                    jars.add(this.resolveArtifact("org.fusesource.jansi", "jansi", "1.12"));
                }
            // Scala 2.12.x
            } else if (this.scalaVersion.startsWith("2.12.")) {
                String minorVersion = this.scalaVersion.substring(4);
                // 2.12.17+ introduce scala-xml-2.12-2.1.0.jar (was 1.0.6)
                String xmlLibVersion = minorVersion.matches("^[17-99]\\..*") ? "2.1.0" : "1.0.6";
                jars.add(this.resolveArtifact("org.scala-lang", "scala-library", this.scalaVersion));
                jars.add(this.resolveArtifact("org.scala-lang", "scala-reflect", this.scalaVersion));
                jars.add(this.resolveArtifact("org.scala-lang", "scala-compiler", this.scalaVersion));
                jars.add(this.resolveArtifact("org.scala-lang.modules", "scala-xml_2.12", xmlLibVersion));
                jars.add(this.resolveArtifact("org.jline", "jline", "2.14.6"));
            // Scala 2.11.x
            } else if (this.scalaVersion.startsWith("2.11.")) {
                jars.add(this.resolveArtifact("org.scala-lang", "scala-library", this.scalaVersion));
                jars.add(this.resolveArtifact("org.scala-lang", "scala-compiler", this.scalaVersion));
                jars.add(this.resolveArtifact("org.scala-lang", "scala-reflect", this.scalaVersion));
                jars.add(this.resolveArtifact("org.scala-lang.modules", "scala-xml_2.11", "1.0.2"));
                jars.add(this.resolveArtifact("org.scala-lang.modules", "scala-parser-combinators_2.11", "1.0.2"));
                jars.add(this.resolveArtifact("org.jline", "jline", "2.12"));
            // Scala 2.10.x
            } else if (this.scalaVersion.startsWith("2.10.")) {
                jars.add(this.resolveArtifact("org.scala-lang", "scala-library", this.scalaVersion));
                jars.add(this.resolveArtifact("org.scala-lang", "scala-compiler", this.scalaVersion));
                jars.add(this.resolveArtifact("org.scala-lang", "scala-reflect", this.scalaVersion));
                jars.add(this.resolveArtifact("org.scala-lang", "jline", "2.10.7"));
            
            //////////////////////////////////////////////////////////////////
            // Development versions
            //
            // Scala 0.2x
            } else if (this.scalaVersion.matches("^0\\.2[0-7]\\..*")) {
                String suffix = this.scalaVersion.substring(0, 4); // eg. "0.27", "0.26"
                jars.add(this.resolveArtifact("ch.epfl.lamp", "dotty-library_" + suffix, this.scalaVersion));
                jars.add(this.resolveArtifact("org.scala-lang", "scala-library", "2.12.7"));
                jars.add(this.resolveArtifact("ch.epfl.lamp", "dotty-compiler_" + suffix, this.scalaVersion));
                jars.add(this.resolveArtifact("ch.epfl.lamp", "dotty-interfaces", this.scalaVersion));
                jars.add(this.resolveArtifact("org.jline", "jline-reader", "3.9.0"));
                jars.add(this.resolveArtifact("org.jline", "jline-terminal", "3.9.0"));
                jars.add(this.resolveArtifact("org.jline", "jline-terminal-jna", "3.9.0"));
                jars.add(this.resolveArtifact("net.java.dev.jna", "jna", "4.2.2"));
                jars.add(this.resolveArtifact("org.scala-lang.modules", "scala-asm", "6.0.0-scala-1"));
                jars.add(this.resolveArtifact("org.scala-lang.modules", "scala-xml_2.12", "1.1.0"));
                jars.add(this.resolveArtifact("org.scala-sbt", "compiler-interface", "1.2.2"));
            // Scala 0.12 (Scala 3 development versions)
            } else if (this.scalaVersion.startsWith("0.12.")) {
                jars.add(this.resolveArtifact("ch.epfl.lamp", "dotty-compiler_0.12", this.scalaVersion));
                jars.add(this.resolveArtifact("ch.epfl.lamp", "dotty-library_0.12", this.scalaVersion));
                jars.add(this.resolveArtifact("ch.epfl.lamp", "dotty-interfaces", this.scalaVersion));
                jars.add(this.resolveArtifact("org.jline", "jline-reader", "3.9.0"));
                jars.add(this.resolveArtifact("org.jline", "jline-terminal", "3.9.0"));
                jars.add(this.resolveArtifact("org.jline", "jline-terminal-jna", "3.9.0"));
                jars.add(this.resolveArtifact("org.scala-lang", "scala-library", "2.12.8"));
                jars.add(this.resolveArtifact("org.scala-lang.modules", "scala-asm", "6.0.0-scala-1"));
                jars.add(this.resolveArtifact("org.scala-lang.modules", "scala-xml_2.12", "1.1.0"));
                jars.add(this.resolveArtifact("org.scala-sbt", "compiler-interface", "1.2.5"));
            // Scala 0.1x (Scala 3 development versions)
            } else if (this.scalaVersion.matches("^0\\.1[0-1]\\..*")) {
                String suffix = this.scalaVersion.substring(0, 4);
                jars.add(this.resolveArtifact("ch.epfl.lamp", "dotty-compiler_" + suffix, this.scalaVersion));
                jars.add(this.resolveArtifact("ch.epfl.lamp", "dotty-library_" + suffix, this.scalaVersion));
                jars.add(this.resolveArtifact("ch.epfl.lamp", "dotty-interfaces", this.scalaVersion));
                jars.add(this.resolveArtifact("org.jline", "jline-reader", "3.9.0"));
                jars.add(this.resolveArtifact("org.jline", "jline-terminal", "3.9.0"));
                jars.add(this.resolveArtifact("org.jline", "jline-terminal-jna", "3.9.0"));
                jars.add(this.resolveArtifact("org.scala-lang", "scala-library", "2.12.7"));
                jars.add(this.resolveArtifact("org.scala-lang.modules", "scala-asm", "6.0.0-scala-1"));
                jars.add(this.resolveArtifact("org.scala-lang.modules", "scala-xml_2.12", "1.1.0"));
                jars.add(this.resolveArtifact("org.scala-sbt", "compiler-interface", "1.2.2"));
            // Scala 0.9 (Scala 3 development version)
            } else if (this.scalaVersion.startsWith("0.9.")) {
                jars.add(this.resolveArtifact("ch.epfl.lamp", "dotty-compiler_0.9", this.scalaVersion));
                jars.add(this.resolveArtifact("ch.epfl.lamp", "dotty-library_0.9", this.scalaVersion));
                jars.add(this.resolveArtifact("ch.epfl.lamp", "dotty-interfaces", this.scalaVersion));
                jars.add(this.resolveArtifact("org.jline", "jline", "3.7.0"));
                jars.add(this.resolveArtifact("org.jline", "jline-terminal-jna", "3.7.0"));
                jars.add(this.resolveArtifact("org.scala-lang", "scala-library", "2.12.6"));
                jars.add(this.resolveArtifact("org.scala-lang.modules", "scala-asm", "6.0.0-scala-1"));
                jars.add(this.resolveArtifact("org.scala-lang.modules", "scala-xml_2.12", "1.1.0"));
                jars.add(this.resolveArtifact("org.scala-sbt", "compiler-interface", "1.1.6"));
            // Scala 0.8 (Scala 3 development version)
            } else if (this.scalaVersion.startsWith("0.8.")) {
                jars.add(this.resolveArtifact("ch.epfl.lamp", "dotty-compiler_0.8", this.scalaVersion));
                jars.add(this.resolveArtifact("ch.epfl.lamp", "dotty-library_0.8", this.scalaVersion));
                jars.add(this.resolveArtifact("ch.epfl.lamp", "dotty-interfaces", this.scalaVersion));
                jars.add(this.resolveArtifact("org.scala-lang", "scala-library", "2.12.4"));
                jars.add(this.resolveArtifact("org.scala-lang.modules", "scala-asm", "6.0.0-scala-1"));
                jars.add(this.resolveArtifact("org.scala-lang.modules", "scala-xml_2.12", "1.0.6"));
                jars.add(this.resolveArtifact("org.scala-sbt", "compiler-interface", "1.1.4"));
            // Scala 0.7 (Scala 3 development version)
            } else if (this.scalaVersion.matches("^0\\.[6-7]\\..*")) {
                String suffix = this.scalaVersion.substring(0, 3);
                jars.add(this.resolveArtifact("ch.epfl.lamp", "dotty-compiler_" + suffix, this.scalaVersion));
                jars.add(this.resolveArtifact("ch.epfl.lamp", "dotty-library_" + suffix, this.scalaVersion));
                jars.add(this.resolveArtifact("ch.epfl.lamp", "dotty-interfaces", this.scalaVersion));
                jars.add(this.resolveArtifact("org.scala-lang", "scala-library", "2.12.4"));
                jars.add(this.resolveArtifact("org.scala-lang.modules", "scala-asm", "6.0.0-scala-1"));
                jars.add(this.resolveArtifact("org.scala-lang.modules", "scala-xml_2.12", "1.0.6"));
                jars.add(this.resolveArtifact("com.typesafe.sbt", "sbt-interface", "0.13.15"));
            } else {
                this.getLog().error((CharSequence)("Scala version " + this.scalaVersion + " not supported"));
            }
        }
        catch (Exception e) {
            this.getLog().error((Throwable)e);
        }
        return jars;
    }

    protected static String getCompilerCmd(boolean isDotty) {
        String os = System.getProperty("os.name").toLowerCase();
        String ext = os.indexOf("win") >= 0 ? ".bat" : "";
        return (isDotty ? "dotc" : "scalac") + ext;
    }

    protected String getInstallationDir() throws MojoExecutionException {
        boolean isDotty = this.scalaVersion.startsWith("0.");
        boolean isScala3 = this.scalaVersion.startsWith("3.");
        String scalaHome = System.getenv(isDotty || isScala3 ? "SCALA3_HOME" : "SCALA_HOME");
        if (scalaHome == null) {
            String cmd = getCompilerCmd(isDotty);
            String path = System.getenv("PATH");
            String[] parents = path.split(File.pathSeparator);
            Optional<File> cmdFile = Arrays.stream(parents).map(parent -> new File((String)parent, cmd)).filter(f -> f.canExecute()).findFirst();
            this.getLog().debug((CharSequence)("cmdFile=" + cmdFile));
            if (cmdFile.isPresent()) {
                scalaHome = cmdFile.get().getParentFile().getParent();
            }
        }
        if (scalaHome == null) {
            throw new MojoExecutionException("Scala installation directory not found");
        }
        return scalaHome;
    }

}
