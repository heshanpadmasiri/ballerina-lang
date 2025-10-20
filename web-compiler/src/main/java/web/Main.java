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
import io.ballerina.projects.ProjectException;
import io.ballerina.projects.directory.SingleFileProject;
import io.ballerina.projects.environment.ResolutionOptions;
import io.ballerina.projects.internal.ProjectDiagnosticErrorCode;
import io.ballerina.projects.util.ProjectUtils;
import io.ballerina.tools.diagnostics.Diagnostic;


public class Main {
    private static final PrintStream out = System.out;
    public static void main(String[] args) {
        SingleFileProject project = SingleFileProject.load(Path.of("/Users/heshanp/Test/jballerina-j2cl-migration-test/test.bal"));
        codeGen(project);
    }

    private static void codeGen(SingleFileProject project) {


        String sourceName = project.currentPackage().getDefaultModule().document(
                project.currentPackage().getDefaultModule().documentIds().iterator().next()).name();
        // Print the source
        System.out.println("\t" + sourceName);

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
        } catch (ProjectException e) {
            throw new RuntimeException(e);
        }
    }
}
