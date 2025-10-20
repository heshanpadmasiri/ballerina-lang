/*
 *  Copyright (c) 2020, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  WSO2 Inc. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */
package io.ballerina.projects;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;

import io.ballerina.fs.Path;
import io.ballerina.projects.environment.PackageCache;
import io.ballerina.projects.environment.ProjectEnvironment;
import io.ballerina.projects.internal.DefaultDiagnosticResult;
import io.ballerina.projects.internal.PackageDiagnostic;
import io.ballerina.projects.internal.model.Target;
import io.ballerina.tools.diagnostics.Diagnostic;
import io.ballerina.tools.diagnostics.DiagnosticSeverity;
import org.wso2.ballerinalang.compiler.bir.codegen.CodeGenerator;
import org.wso2.ballerinalang.compiler.bir.codegen.interop.InteropValidator;
import org.wso2.ballerinalang.compiler.util.CompilerContext;

/**
 * This class represents the Ballerina compiler backend that produces executables that runs on the JVM.
 *
 * @since 2.0.0
 */
// TODO move this class to a separate Java package. e.g. io.ballerina.projects.platform.jballerina
//    todo that, we would have to move PackageContext class into an internal package.
public class JBallerinaBackend extends CompilerBackend {

    private static final String JAR_FILE_EXTENSION = ".jar";
    private static final String TEST_JAR_FILE_NAME_SUFFIX = "-testable";
    private static final String JAR_FILE_NAME_SUFFIX = "";
    private static final String OS = System.getProperty("os.name").toLowerCase(Locale.getDefault());
    public static final String JAR_NAME_SEPARATOR = "-";

    private final PackageResolution pkgResolution;
    private final JvmTarget jdkVersion;
    private final PackageContext packageContext;
    private final PackageCache packageCache;
    private final CompilerContext compilerContext;
    private final CodeGenerator jvmCodeGenerator;
    private final InteropValidator interopValidator;
    private final JarResolver jarResolver;
    private final PackageCompilation packageCompilation;
    private DiagnosticResult diagnosticResult;
    private boolean codeGenCompleted;
    List<Diagnostic> conflictedResourcesDiagnostics = new ArrayList<>();

    public static JBallerinaBackend from(PackageCompilation packageCompilation, JvmTarget jdkVersion) {
        return from(packageCompilation, jdkVersion, true);
    }

    public static JBallerinaBackend from(PackageCompilation packageCompilation, JvmTarget jdkVersion, boolean shrink) {
        // Check if the project has write permissions
        if (packageCompilation.packageContext().project().kind().equals(ProjectKind.BUILD_PROJECT)) {
            try {
                new Target(packageCompilation.packageContext().project().targetDir());
            } catch (IOException e) {
                throw new ProjectException("error while checking permissions of target directory", e);
            }
        }
        return packageCompilation.getCompilerBackend(jdkVersion,
                (targetPlatform -> new JBallerinaBackend(packageCompilation, jdkVersion, shrink)));
    }

    private JBallerinaBackend(PackageCompilation packageCompilation, JvmTarget jdkVersion, boolean shrink) {
        this.jdkVersion = jdkVersion;
        this.packageCompilation = packageCompilation;
        this.packageContext = packageCompilation.packageContext();
        this.pkgResolution = packageContext.getResolution();
        this.jarResolver = new JarResolver(this, packageContext.getResolution());

        ProjectEnvironment projectEnvContext = this.packageContext.project().projectEnvironmentContext();
        this.packageCache = projectEnvContext.getService(PackageCache.class);
        this.compilerContext = projectEnvContext.getService(CompilerContext.class);
        this.interopValidator = InteropValidator.getInstance(compilerContext);
        this.jvmCodeGenerator = CodeGenerator.getInstance(compilerContext);
        performCodeGen(shrink);
    }

    PackageContext packageContext() {
        return this.packageContext;
    }

    private void performCodeGen(boolean shrink) {
        if (codeGenCompleted) {
            return;
        }

        List<Diagnostic> diagnostics = new ArrayList<>();
        // add package resolution diagnostics
        diagnostics.addAll(this.packageContext.getResolution().diagnosticResult().allDiagnostics);
        // add ballerina toml diagnostics
        diagnostics.addAll(this.packageContext.packageManifest().diagnostics().diagnostics());
        // collect compilation diagnostics
        List<Diagnostic> moduleDiagnostics = new ArrayList<>();
        for (ModuleContext moduleContext : pkgResolution.topologicallySortedModuleList()) {
            if (shrink) {
                ModuleContext.shrinkDocuments(moduleContext);
            }
            if (moduleContext.moduleId().packageId().equals(packageContext.packageId())) {
                if (packageCompilation.diagnosticResult().hasErrors()) {
                    for (Diagnostic diagnostic : moduleContext.diagnostics()) {
                        moduleDiagnostics.add(
                                new PackageDiagnostic(diagnostic, moduleContext.descriptor(), moduleContext.project()));
                    }
                    continue;
                }
            }
            // We can't generate backend code when one of its dependencies have errors.
            if (!this.packageContext.getResolution().diagnosticResult().hasErrors() && !hasErrors(moduleDiagnostics)) {
                moduleContext.generatePlatformSpecificCode(compilerContext, this);
            }
            for (Diagnostic diagnostic : moduleContext.diagnostics()) {
                if (this.packageContext.project().buildOptions().showDependencyDiagnostics() ||
                        !ProjectKind.BALA_PROJECT.equals(moduleContext.project().kind()) ||
                        (diagnostic.diagnosticInfo().severity() == DiagnosticSeverity.ERROR)) {
                    moduleDiagnostics.add(
                            new PackageDiagnostic(diagnostic, moduleContext.descriptor(), moduleContext.project()));
                }
            }

            if (moduleContext.project().kind() == ProjectKind.BALA_PROJECT) {
                moduleContext.cleanBLangPackage();
            }
        }

        // add compilation diagnostics
        diagnostics.addAll(moduleDiagnostics);
        // add plugin diagnostics
        diagnostics.addAll(this.packageContext.getPackageCompilation().pluginDiagnostics());
        // add conflicting resources diagnostics
        diagnostics.addAll(conflictedResourcesDiagnostics);

        this.diagnosticResult = new DefaultDiagnosticResult(diagnostics);
        codeGenCompleted = true;
    }

    private boolean hasErrors(List<Diagnostic> diagnostics) {
        for (Diagnostic diagnostic : diagnostics) {
            if (diagnostic.diagnosticInfo().severity() == DiagnosticSeverity.ERROR) {
                return true;
            }
        }
        return false;
    }

    public DiagnosticResult diagnosticResult() {
        return diagnosticResult;
    }

    public EmitResult emit(OutputType outputType, Path filePath) {
        Path generatedArtifact;

        if (diagnosticResult.hasErrors()) {
            return new EmitResult(false, new DefaultDiagnosticResult(new ArrayList<>()), null);
        }

        List<Diagnostic> emitResultDiagnostics = new ArrayList<>();
        generatedArtifact = switch (outputType) {
            case GRAAL_EXEC -> emitGraalExecutable(filePath, emitResultDiagnostics);
            case EXEC -> emitExecutable(filePath, emitResultDiagnostics);
            case BALA -> emitBala(filePath);
            default -> throw new RuntimeException("Unexpected output type: " + outputType);
        };

        return getEmitResult(filePath, generatedArtifact, BalCommand.BUILD, emitResultDiagnostics);
    }

    public EmitResult emit(TestEmitArgs testEmitArgs) {
        Path generatedArtifact = null;

        if (diagnosticResult.hasErrors()) {
            return new EmitResult(false, new DefaultDiagnosticResult(new ArrayList<>()), null);
        }

        if (testEmitArgs.outputType() == OutputType.TEST) {
            generatedArtifact = emitTestExecutable(testEmitArgs.filePath(), testEmitArgs.jarDependencies(),
                    testEmitArgs.testSuiteJsonPath(), testEmitArgs.jsonCopyPath(),
                    testEmitArgs.excludedClasses(), testEmitArgs.classPathTextCopyPath());
        } else {
            throw new RuntimeException("Unexpected output type: " + testEmitArgs.outputType());
        }

        return getEmitResult(testEmitArgs.filePath(), generatedArtifact, BalCommand.TEST, new ArrayList<>());
    }

    private EmitResult getEmitResult(Path filePath, Path generatedArtifact, BalCommand balCommand,
                                    List<Diagnostic> emitDiagnostics) {
        if (filePath != null) {
            List<Diagnostic> pluginDiagnostics = notifyCompilationCompletion(filePath, balCommand);
            if (!pluginDiagnostics.isEmpty()) {
                emitDiagnostics.addAll(pluginDiagnostics);
            }
        }
        List<Diagnostic> allDiagnostics = new ArrayList<>(diagnosticResult.allDiagnostics);
        emitDiagnostics.addAll(jarResolver().diagnosticResult().diagnostics());
        allDiagnostics.addAll(emitDiagnostics);
        diagnosticResult = new DefaultDiagnosticResult(allDiagnostics);

        // TODO handle the EmitResult properly
        return new EmitResult(true, new DefaultDiagnosticResult(emitDiagnostics), generatedArtifact);
    }

    public List<Diagnostic> notifyCompilationCompletion(Path filePath, BalCommand balCommand) {
        return packageCompilation.notifyCompilationCompletion(filePath, balCommand);
    }

    private Path emitBala(Path filePath) {
        throw new RuntimeException();
    }

    @Override
    public Collection<PlatformLibrary> platformLibraryDependencies(PackageId packageId) {
        return getPlatformLibraries(packageId);
    }

    @Override
    public Collection<PlatformLibrary> platformLibraryDependencies(PackageId packageId,
                                                                   PlatformLibraryScope scope) {

        return getPlatformLibraries(packageId)
                .stream()
                .filter(platformLibrary -> platformLibrary.scope() == scope)
                .collect(Collectors.toList());
    }

    private List<PlatformLibrary> getPlatformLibraries(PackageId packageId) {
        throw new RuntimeException();
    }

    @Override
    public PlatformLibrary codeGeneratedLibrary(PackageId packageId, ModuleName moduleName) {
        return codeGeneratedLibrary(packageId, moduleName, PlatformLibraryScope.DEFAULT, JAR_FILE_NAME_SUFFIX);
    }

    @Override
    public PlatformLibrary codeGeneratedTestLibrary(PackageId packageId, ModuleName moduleName) {
        return codeGeneratedLibrary(packageId, moduleName, PlatformLibraryScope.DEFAULT,
                TEST_JAR_FILE_NAME_SUFFIX + JAR_FILE_NAME_SUFFIX);
    }

    @Override
    public PlatformLibrary codeGeneratedResourcesLibrary(PackageId packageId) {
        return codeGeneratedResourcesLibrary(packageId, PlatformLibraryScope.DEFAULT);
    }

    @Override
    public PlatformLibrary runtimeLibrary() {
        throw new RuntimeException();
    }

    @Override
    public TargetPlatform targetPlatform() {
        return jdkVersion;
    }

    @Override
    public String libraryFileExtension() {
        return JAR_FILE_EXTENSION;
    }

    public JarResolver jarResolver() {
        return jarResolver;
    }

    private PlatformLibrary codeGeneratedLibrary(PackageId packageId,
                                                 ModuleName moduleName,
                                                 PlatformLibraryScope scope,
                                                 String fileNameSuffix) {
                    throw new RuntimeException();
    }

    private Path emitExecutable(Path executableFilePath, List<Diagnostic> emitResultDiagnostics) {
        throw new RuntimeException();
    }

    private Path emitTestExecutable(Path executableFilePath, HashSet<JarLibrary> jarDependencies,
                          Path testSuiteJsonPath, String jsonCopyPath, List<String> excludedClasses,
                          String classPathTextCopyPath) {
        throw new RuntimeException();
    }

    private Path emitGraalExecutable(Path executableFilePath, List<Diagnostic> emitResultDiagnostics) {
        throw new RuntimeException();
    }

    /**
     * Enum to represent output types.
     */
    public enum OutputType {
        EXEC("exec"),
        BALA("bala"),
        GRAAL_EXEC("graal_exec"),
        TEST("test")
        ;

        private final String value;

        OutputType(String value) {
            this.value = value;
        }
    }

    private PlatformLibrary codeGeneratedResourcesLibrary(PackageId packageId, PlatformLibraryScope scope) {
                throw new RuntimeException();
    }

}
