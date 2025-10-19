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
package io.ballerina.projects.directory;

import io.ballerina.projects.BuildOptions;
import io.ballerina.projects.DependencyGraph;
import io.ballerina.projects.DocumentId;
import io.ballerina.projects.Module;
import io.ballerina.projects.ModuleId;
import io.ballerina.projects.PackageConfig;
import io.ballerina.projects.Project;
import io.ballerina.projects.ProjectEnvironmentBuilder;
import io.ballerina.projects.ProjectException;
import io.ballerina.projects.ProjectKind;
import io.ballerina.projects.ProjectLoadResult;
import io.ballerina.projects.ResolvedPackageDependency;
import io.ballerina.projects.internal.PackageConfigCreator;
import io.ballerina.projects.internal.ProjectFiles;
import io.ballerina.projects.util.ProjectConstants;
import io.ballerina.projects.util.ProjectPaths;

import io.ballerina.fs.Path;

import java.util.Optional;

import static io.ballerina.projects.util.ProjectUtils.getDependenciesTomlContent;

/**
 * {@code BuildProject} represents Ballerina project instance created from the project directory.
 *
 * @since 2.0.0
 */
public class BuildProject extends Project implements Comparable<Project> {

    private DependencyGraph<ResolvedPackageDependency> dependencyGraph;

    static ProjectLoadResult loadProject(Path projectPath, ProjectEnvironmentBuilder environmentBuilder,
                                         BuildOptions buildOptions, String org) {
        PackageConfig packageConfig = PackageConfigCreator.createBuildProjectConfig(projectPath,
                buildOptions.disableSyntaxTree(), org);
        BuildOptions mergedBuildOptions = ProjectFiles.createBuildOptions(
                packageConfig, buildOptions, projectPath, org);

        BuildProject buildProject = new BuildProject(environmentBuilder, projectPath, mergedBuildOptions);
        buildProject.addPackage(packageConfig);
        return new ProjectLoadResult(buildProject, buildProject.currentPackage().manifest().diagnostics());
    }

    /**
     * @deprecated Use {@link io.ballerina.projects.directory.ProjectLoader#load(Path, ProjectEnvironmentBuilder)}
     * instead.
     * Loads a BuildProject from the provided path.
     *
     * @param projectPath Ballerina project path
     * @return build project
     */
    @Deprecated(since = "2201.13.0", forRemoval = true)
    public static BuildProject load(ProjectEnvironmentBuilder environmentBuilder, Path projectPath) {
        return load(environmentBuilder, projectPath, BuildOptions.builder().build());
    }

    /**
     * @deprecated Use {@link ProjectLoader#load(Path)} instead.
     * Loads a BuildProject from the provided path.
     *
     * @param projectPath Ballerina project path
     * @return BuildProject instance
     */
    @Deprecated(since = "2201.13.0", forRemoval = true)
    public static BuildProject load(Path projectPath) {
        return load(projectPath, BuildOptions.builder().build());
    }

    /**
     * @deprecated Use {@link ProjectLoader#load(Path, ProjectEnvironmentBuilder, BuildOptions)} instead.
     * Loads a BuildProject from provided path and build options.
     *
     * @param projectPath  Ballerina project path
     * @param buildOptions build options
     * @return BuildProject instance
     */
    @Deprecated(since = "2201.13.0", forRemoval = true)
    public static BuildProject load(Path projectPath, BuildOptions buildOptions) {
        ProjectEnvironmentBuilder environmentBuilder = ProjectEnvironmentBuilder.getDefaultBuilder();
        return load(environmentBuilder, projectPath, buildOptions);
    }

    /**
     * @deprecated Use {@link ProjectLoader#load(Path, ProjectEnvironmentBuilder, BuildOptions)}  instead.
     * Loads a BuildProject from provided environment builder, path, build options.
     *
     * @param environmentBuilder custom environment builder
     * @param projectPath Ballerina project path
     * @param buildOptions build options
     * @return BuildProject instance
     */
    @Deprecated(since = "2201.13.0", forRemoval = true)
    public static BuildProject load(ProjectEnvironmentBuilder environmentBuilder, Path projectPath,
                                    BuildOptions buildOptions) {
        PackageConfig packageConfig = PackageConfigCreator.createBuildProjectConfig(projectPath,
                buildOptions.disableSyntaxTree());
        BuildOptions mergedBuildOptions = ProjectFiles.createBuildOptions(
                packageConfig, buildOptions, projectPath, null);

        BuildProject buildProject = new BuildProject(environmentBuilder, projectPath, mergedBuildOptions);
        buildProject.addPackage(packageConfig);
        return buildProject;
    }

    private BuildProject(ProjectEnvironmentBuilder environmentBuilder, Path projectPath, BuildOptions buildOptions) {
        super(ProjectKind.BUILD_PROJECT, projectPath, environmentBuilder, buildOptions);
        populateCompilerContext();
    }

    private Optional<Path> modulePath(ModuleId moduleId) {
        if (currentPackage().moduleIds().contains(moduleId)) {
            if (currentPackage().getDefaultModule().moduleId() == moduleId) {
                return Optional.of(sourceRoot);
            } else {
                return Optional.of(sourceRoot.resolve(ProjectConstants.MODULES_ROOT).resolve(
                        currentPackage().module(moduleId).moduleName().moduleNamePart()));
            }
        }
        return Optional.empty();
    }

    private Optional<Path> generatedModulePath(ModuleId moduleId) {
        if (currentPackage().moduleIds().contains(moduleId)) {
            Optional<Path> generatedModulePath = Optional.of(sourceRoot.
                    resolve(ProjectConstants.GENERATED_MODULES_ROOT));
            if (currentPackage().getDefaultModule().moduleId() == moduleId
                    && generatedModulePath.get().isDirectory()) {
                return generatedModulePath;
            }
            String moduleName = currentPackage().module(moduleId).moduleName().moduleNamePart();
            if (generatedModulePath.get().isDirectory()) {
                Optional<Path> generatedModuleDirPath = Optional.of(generatedModulePath.get().resolve(moduleName));
                if (generatedModuleDirPath.get().isDirectory()) {
                    return Optional.of(generatedModulePath.get().resolve(moduleName));
                }
            }
        }
        return Optional.empty();
    }

    @Override
    public Optional<Path> documentPath(DocumentId documentId) {
        for (ModuleId moduleId : currentPackage().moduleIds()) {
            Module module = currentPackage().module(moduleId);
            Optional<Path> modulePath = modulePath(moduleId);
            if (module.documentIds().contains(documentId)) {
                Optional<Path> generatedModulePath = generatedModulePath(moduleId);
                if (generatedModulePath.isPresent() && generatedModulePath.get().resolve(module.document(documentId).name()).exists()) {
                    return Optional.of(generatedModulePath.get().resolve(module.document(documentId).name()));
                }
                if (modulePath.isPresent()) {
                    return Optional.of(modulePath.get().resolve(module.document(documentId).name()));
                }
            } else if (module.testDocumentIds().contains(documentId)) {
                Optional<Path> generatedModulePath = generatedModulePath(moduleId);
                if (generatedModulePath.isPresent() && generatedModulePath.get().resolve(ProjectConstants.TEST_DIR_NAME).
                                resolve(module.document(documentId).name()
                                        .split(ProjectConstants.TEST_DIR_NAME + "/")[1]).exists()) {
                    return Optional.of(generatedModulePath.get().resolve(ProjectConstants.TEST_DIR_NAME).
                            resolve(module.document(documentId).name()
                                    .split(ProjectConstants.TEST_DIR_NAME + "/")[1]));
                }
                if (modulePath.isPresent()) {
                    return Optional.of(modulePath.get()
                            .resolve(ProjectConstants.TEST_DIR_NAME).resolve(
                                    module.document(documentId).name().split(ProjectConstants.TEST_DIR_NAME + "/")[1]));
                }
            }
        }
        return Optional.empty();
    }

    @Override
    public void clearCaches() {
        resetPackage(this);
        this.projectEnvironment = ProjectEnvironmentBuilder.getDefaultBuilder().build(this);
    }

    @Override
    public Project duplicate() {
        BuildOptions duplicateBuildOptions = BuildOptions.builder().build().acceptTheirs(buildOptions());
        BuildProject buildProject = new BuildProject(
                ProjectEnvironmentBuilder.getDefaultBuilder(), this.sourceRoot, duplicateBuildOptions);
        return resetPackage(buildProject);
    }

    @Override
    public DocumentId documentId(Path file) {
        if (isFilePathInProject(file)) {
            Path parent = Optional.of(file.toAbsolutePath().getParent()).get();
            String parentFileName = Optional.of(parent.getFileName()).get().toString();
            boolean isDefaultModule = false;
            for (ModuleId moduleId : this.currentPackage().moduleIds()) {
                String moduleDirName;
                // Check for the module name contains a dot and not being the default module
                if (!this.currentPackage().getDefaultModule().moduleId().equals(moduleId)) {
                    moduleDirName = currentPackage().module(moduleId).moduleName().toString()
                            .split(this.currentPackage().packageName().toString() + "\\.")[1];
                } else {
                    moduleDirName = Optional.of(this.sourceRoot.getFileName()).get().toString();
                    isDefaultModule = true;
                }

                Module module = this.currentPackage().module(moduleId);
                if (parentFileName.equals(moduleDirName) ||
                        (isDefaultModule && ProjectConstants.GENERATED_MODULES_ROOT.equals(parentFileName))) {
                    // this is a source file
                    for (DocumentId documentId : module.documentIds()) {
                        if (module.document(documentId).name().equals(
                                Optional.of(file.getFileName()).get().toString())) {
                            return documentId;
                        }
                    }
                } else if (ProjectConstants.TEST_DIR_NAME.equals(parentFileName)) {
                    // this is a test file
                    Path modulePath = Optional.of(parent.getParent()).get();
                    if (Optional.of(modulePath.getFileName()).get().toString()
                            .equals(moduleDirName) || Optional.of(Optional.of(modulePath.getParent()).get()
                            .getFileName()).get().toString().equals(moduleDirName)) {
                        for (DocumentId documentId : module.testDocumentIds()) {
                            String[] splitName = module.document(documentId).name()
                                    .split(ProjectConstants.TEST_DIR_NAME + "/");
                            if (splitName.length > 1 && splitName[1]
                                    .equals(Optional.of(file.getFileName()).get().toString())) {
                                return documentId;
                            }
                        }
                    }
                }
            }
        }
        throw new ProjectException("'" + file.toString() + "' does not belong to the current project");
    }

    private boolean isFilePathInProject(Path filepath) {
        try {
            ProjectPaths.packageRoot(filepath);
        } catch (ProjectException e) {
            return false;
        }
        return true;
    }

    @Override
    public Path targetDir() {
        if (this.buildOptions().getTargetPath() == null) {
            return this.sourceRoot.resolve(ProjectConstants.TARGET_DIR_NAME);
        } else {
            return Path.of(this.buildOptions().getTargetPath());
        }
    }

    @Override
    public Path generatedResourcesDir() {
        throw new RuntimeException();
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (!(obj instanceof BuildProject other)) {
            return false;
        }

        return this.sourceRoot.equals(other.sourceRoot());
    }

    @Override
    public int hashCode() {
        return sourceRoot.hashCode();
    }

    @Override
    public int compareTo(Project other) {
        return this.sourceRoot.compareTo(other.sourceRoot());
    }
}
