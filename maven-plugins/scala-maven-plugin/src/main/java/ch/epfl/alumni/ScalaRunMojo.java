package ch.epfl.alumni;

import java.io.IOException;
import java.io.OutputStream;

import org.apache.commons.exec.CommandLine;
import org.apache.commons.exec.DefaultExecutor;
import org.apache.commons.exec.ExecuteException;
import org.apache.commons.exec.ExecuteStreamHandler;
import org.apache.commons.exec.PumpStreamHandler;
import org.apache.maven.plugin.MojoExecutionException;
import org.apache.maven.plugins.annotations.LifecyclePhase;
import org.apache.maven.plugins.annotations.Mojo;
import org.apache.maven.plugins.annotations.Parameter;
import org.apache.maven.plugins.annotations.ResolutionScope;
import org.apache.maven.toolchain.Toolchain;

@Mojo(name="run", defaultPhase=LifecyclePhase.TEST, requiresDependencyResolution=ResolutionScope.RUNTIME)
public class ScalaRunMojo extends ScalaAbstractMojo {

    //@Parameter(property="project", required=true, readonly=true)
    //private MavenProject project;

    //@Parameter(property="session", required=true, readonly=true)
    //private MavenSession session;

    //@Parameter
    //private String[] additionalClasspathElements = new String[0];

    //@Parameter(property="project.build.outputDirectory")
    //protected File outputDir;

    //@Parameter(defaultValue="3.1.1")
    //private String scalaVersion;

    //@Parameter(defaultValue="false")
    //private boolean localInstall;

    @Parameter(defaultValue="false")
    private boolean withCompiler;

    //@Parameter
    //private String[] jvmArgs;

    //@Parameter(defaultValue="true")
    //private boolean addOutputToClasspath;

    @Parameter(property="mainClass", required=true)
    private String mainClass;

    @Parameter
    private String[] arguments;

    //@Component
    //protected ToolchainManager toolchainManager;

    public void execute() throws MojoExecutionException {
        Toolchain toolchain = this.toolchainManager.getToolchainFromBuildContext("jdk", this.session);
        CommandLine cmdLine = new CommandLine(ScalaRunMojo.findJavaExec(toolchain));
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
        cmdLine.addArgument(this.getClasspath());
        cmdLine.addArgument(this.mainClass);
        cmdLine.addArguments(this.arguments);
        this.getLog().debug((CharSequence)("[execute] " + String.join((CharSequence)" ", cmdLine.toStrings())));
        int exitValue = 0;
        try {
            DefaultExecutor exec = new DefaultExecutor();
            exec.setStreamHandler((ExecuteStreamHandler)new PumpStreamHandler((OutputStream)System.out, (OutputStream)System.err, System.in));
            exitValue = exec.execute(cmdLine);
        }
        catch (ExecuteException e) {
            exitValue = e.getExitValue();
            throw new MojoExecutionException("Execution failed", (Throwable)e);
        }
        catch (IOException e) {
            this.getLog().error((CharSequence)e.getMessage());
            exitValue = 1;
        }
    }

}
