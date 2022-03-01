package ch.epfl.alumni;

import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.exec.CommandLine;
import org.apache.commons.exec.DefaultExecutor;
import org.apache.commons.exec.ExecuteException;
import org.apache.commons.exec.ExecuteStreamHandler;
import org.apache.commons.exec.PumpStreamHandler;
import org.apache.maven.artifact.Artifact;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugin.MojoFailureException;
import org.apache.maven.plugins.annotations.LifecyclePhase;
import org.apache.maven.plugins.annotations.Mojo;
import org.apache.maven.plugins.annotations.Parameter;
import org.apache.maven.plugins.annotations.ResolutionScope;
import org.apache.maven.toolchain.Toolchain;
import org.codehaus.plexus.util.DirectoryScanner;

@Mojo(name="compile", defaultPhase=LifecyclePhase.COMPILE, requiresDependencyResolution=ResolutionScope.COMPILE)
public class ScalaCompileMojo extends ScalaAbstractMojo {

    //@Parameter(property="project", required=true, readonly=true)
    //private MavenProject project;

    //@Parameter(property="session", required=true, readonly=true)
    //private MavenSession session;

    //@Parameter
    //private String[] additionalClasspathElements = new String[0];

    @Parameter
    private String[] includes = new String[]{"**/*.scala"};

    @Parameter
    private String[] excludes;

    //@Parameter(property="project.build.outputDirectory")
    //protected File outputDir;

    //@Parameter(defaultValue="3.1.1")
    //private String scalaVersion;

    //@Parameter(defaultValue="false")
    //private boolean localInstall;

    @Parameter
    private String[] compilerArgs;

    //@Parameter(defaultValue="true")
    //private boolean addOutputToClasspath;

    //@Component
    //protected ToolchainManager toolchainManager;

    public void execute() throws MojoExecutionException, MojoFailureException {
        List<String> sources = this.scan(this.project.getCompileSourceRoots());
        sources.addAll(this.scan(this.project.getTestCompileSourceRoots()));
        if (sources.isEmpty()) {
            return;
        }
        Toolchain toolchain = this.toolchainManager.getToolchainFromBuildContext("jdk", this.session);
        CommandLine cmdLine = new CommandLine(ScalaCompileMojo.findJavaExec(toolchain));
        cmdLine.addArguments(this.jvmArgs);
        if (this.localInstall) {
            cmdLine.addArgument("-Dscala.home=" + this.getInstallationDir());
        }
        // see https://stackoverflow.com/questions/1492000/how-to-get-access-to-mavens-dependency-hierarchy-within-a-plugin
        // for (final Artifact artifact : project.getArtifacts()) {
        //     // Do whatever you need here.
        //     this.getLog().debug("[execute] "+artifact.getFile().getAbsolutePath());
        //     // If having the actual file (artifact.getFile()) is not important, you do not need requiresDependencyResolution.
        // }
        cmdLine.addArgument("-cp");
        cmdLine.addArgument(this.getMainClasspath());
        cmdLine.addArgument("-Dscala.usejavacp=true");
        cmdLine.addArgument(this.getMainClassName());
        cmdLine.addArguments(this.compilerArgs);
        cmdLine.addArgument("-classpath");
        cmdLine.addArgument(this.getClasspath());
        cmdLine.addArgument("-d");
        cmdLine.addArgument(this.outputDir.getAbsolutePath());
        cmdLine.addArguments(sources.toArray(new String[sources.size()]));
        this.getLog().debug((CharSequence)("[execute] " + String.join((CharSequence)" ", cmdLine.toStrings())));
        int exitValue = 0;
        try {
            if (!this.outputDir.exists()) {
                this.outputDir.mkdirs();
            }
            DefaultExecutor exec = new DefaultExecutor();
            exec.setStreamHandler((ExecuteStreamHandler)new PumpStreamHandler((OutputStream)System.out, (OutputStream)System.err, System.in));
            exitValue = exec.execute(cmdLine);
        }
        catch (ExecuteException e) {
            exitValue = e.getExitValue();
            throw new MojoFailureException("Compilation failed", (Throwable)e);
        }
        catch (IOException e) {
            this.getLog().error((CharSequence)e.getMessage());
            exitValue = 1;
        }
    }

    private List<String> scan(List<String> roots) throws MojoExecutionException {
        ArrayList<String> fileList = new ArrayList<String>();
        for (String root : roots) {
            fileList.addAll(this.scan(new File(root)));
        }
        return fileList;
    }

    private List<String> scan(File root) throws MojoExecutionException {
        ArrayList<String> fileList = new ArrayList<String>();
        if (!root.exists()) {
            return fileList;
        }
        DirectoryScanner directoryScanner = new DirectoryScanner();
        directoryScanner.setIncludes(this.includes);
        directoryScanner.setExcludes(this.excludes);
        directoryScanner.setBasedir(root);
        directoryScanner.scan();
        for (String fileName : directoryScanner.getIncludedFiles()) {
            File file = new File(root, fileName);
            fileList.add(file.getAbsolutePath());
        }
        return fileList;
    }

    private String getMainClassName() {
        boolean isScala2 = this.scalaVersion.startsWith("2.");
        return isScala2 ? "scala.tools.nsc.Main" : "dotty.tools.dotc.Main";
    }

}
