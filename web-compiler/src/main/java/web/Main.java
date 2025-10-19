package web;

import java.io.PrintStream;
import io.ballerina.fs.Path;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Set;

import io.ballerina.projects.CodeGeneratorResult;
import io.ballerina.projects.CodeModifierResult;
import io.ballerina.projects.JBallerinaBackend;
import io.ballerina.projects.JvmTarget;
import io.ballerina.projects.PackageCompilation;
import io.ballerina.projects.PackageResolution;
import io.ballerina.projects.Project;
import io.ballerina.projects.ProjectException;
import io.ballerina.projects.ProjectKind;
import io.ballerina.projects.directory.SingleFileProject;
import io.ballerina.projects.environment.ResolutionOptions;
import io.ballerina.projects.internal.ProjectDiagnosticErrorCode;
import io.ballerina.projects.util.ProjectUtils;
import io.ballerina.tools.diagnostics.Diagnostic;
import org.ballerinalang.central.client.CentralClientConstants;


public class Main {
    private static final PrintStream out = System.out;
    public static void main(String[] args) {
        System.setProperty("ballerina.home", "/Users/heshanp/.ballerina");
        SingleFileProject project = SingleFileProject.load(Path.of("/Users/heshanp/Test/jballerina-j2cl-migration-test/test.bal"));
        codeGen(project);
    }

    private static void codeGen(SingleFileProject project) {


        String sourceName = project.currentPackage().getDefaultModule().document(
                project.currentPackage().getDefaultModule().documentIds().iterator().next()).name();
        // Print the source
        System.out.println("\t" + sourceName);
        System.setProperty(CentralClientConstants.ENABLE_OUTPUT_STREAM, "true");

        try {
            List<Diagnostic> diagnostics = new ArrayList<>();
//            if (this.compileForBalBuild) {
//                addDiagnosticForProvidedPlatformLibs(project, diagnostics);
//            }
            long start = 0;

            Set<String> packageImports = Set.of();
            PackageResolution packageResolution = project.currentPackage().getResolution();

            CodeGeneratorResult codeGeneratorResult = project.currentPackage().runCodeGeneratorPlugins();
            diagnostics.addAll(codeGeneratorResult.reportedDiagnostics().diagnostics());
            CodeModifierResult codeModifierResult = project.currentPackage().runCodeModifierPlugins();
            diagnostics.addAll(codeModifierResult.reportedDiagnostics().diagnostics());

            Set<String> newPackageImports = Set.of();
            ResolutionOptions resolutionOptions = ResolutionOptions.builder().setOffline(true).build();
            if (!packageImports.equals(newPackageImports)) {
                resolutionOptions = ResolutionOptions.builder().setOffline(false).build();
            }

            if (packageResolution != project.currentPackage().getResolution(resolutionOptions)) {
                packageResolution = project.currentPackage().getResolution();
            }


            Optional<Diagnostic> projectLoadingDiagnostic = ProjectUtils.getProjectLoadingDiagnostic().stream().filter(
                    diagnostic -> diagnostic.diagnosticInfo().code().equals(
                            ProjectDiagnosticErrorCode.DEPRECATED_RESOURCES_STRUCTURE.diagnosticId())).findAny();

            projectLoadingDiagnostic.ifPresent(out::println);
            PackageCompilation packageCompilation = project.currentPackage().getCompilation();
            JBallerinaBackend jBallerinaBackend = JBallerinaBackend.from(packageCompilation, JvmTarget.JAVA_21);

//            // Report package compilation and backend diagnostics
//            diagnostics.addAll(jBallerinaBackend.diagnosticResult().diagnostics(false));
//            diagnostics.forEach(d -> {
//                if (d.diagnosticInfo().code() == null || (!d.diagnosticInfo().code().equals(
//                        ProjectDiagnosticErrorCode.BUILT_WITH_OLDER_SL_UPDATE_DISTRIBUTION.diagnosticId()) &&
//                        !d.diagnosticInfo().code().startsWith(TOOL_DIAGNOSTIC_CODE_PREFIX))) {
//                    err.println(d);
//                }
//            });
//            // Add tool resolution diagnostics to diagnostics
//            diagnostics.addAll(project.currentPackage().getBuildToolResolution().getDiagnosticList());
//            boolean hasErrors = false;
//            for (Diagnostic d : diagnostics) {
//                if (d.diagnosticInfo().severity().equals(DiagnosticSeverity.ERROR)) {
//                    hasErrors = true;
//                }
//            }
//            if (hasErrors) {
//                throw createLauncherException("compilation contains errors");
//            }
//            project.save();
        } catch (ProjectException e) {
            throw new RuntimeException(e);
        }
    }
}
