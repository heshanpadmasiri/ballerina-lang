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
package io.ballerina.projects.internal;

import io.ballerina.fs.Path;
import io.ballerina.projects.BuildOptions;
import io.ballerina.projects.DocumentConfig;
import io.ballerina.projects.PackageConfig;
import io.ballerina.projects.ProjectException;
import io.ballerina.projects.TomlDocument;
import io.ballerina.projects.util.ProjectConstants;

import java.nio.charset.Charset;
import java.util.Collections;
import java.util.List;
import java.util.stream.Stream;

import static io.ballerina.projects.util.ProjectConstants.DOT;
import static io.ballerina.projects.util.ProjectConstants.GENERATED_MODULES_ROOT;
import static io.ballerina.projects.util.ProjectConstants.TEST_DIR_NAME;

/**
 * Contains a set of utility methods that create an in-memory representation of a Ballerina project directory.
 *
 * @since 2.0.0
 */
public final class ProjectFiles {

    private ProjectFiles() {
    }

    public static PackageData loadSingleFileProjectPackageData(Path filePath) {
        DocumentData documentData = DocumentData.fromHardCode("test.bal", """
                public function main() {
                }
                """);
        ModuleData defaultModule = ModuleData
                .from(filePath, DOT, Collections.singletonList(documentData), Collections.emptyList(), null);
        return PackageData.from(filePath, defaultModule, Collections.emptyList(),
                null, null, null, null,
                null, null, Collections.emptyList(), Collections.emptyList());
    }

    public static PackageData loadBuildProjectPackageData(Path packageDirPath) {
        ModuleData defaultModule = loadModule(packageDirPath);
        List<ModuleData> otherModules = loadOtherModules(packageDirPath);
        List<ModuleData> newModules = loadNewGeneratedModules(packageDirPath);
        otherModules = Stream.concat(otherModules.stream(), newModules.stream()).toList();

        DocumentData ballerinaToml = loadDocument(packageDirPath.resolve(ProjectConstants.BALLERINA_TOML));
        DocumentData dependenciesToml = loadDocument(packageDirPath.resolve(ProjectConstants.DEPENDENCIES_TOML));
        DocumentData cloudToml = loadDocument(packageDirPath.resolve(ProjectConstants.CLOUD_TOML));
        DocumentData compilerPluginToml = loadDocument(packageDirPath.resolve(ProjectConstants.COMPILER_PLUGIN_TOML));
        DocumentData balToolToml = loadDocument(packageDirPath.resolve(ProjectConstants.BAL_TOOL_TOML));
        DocumentData packageMd = loadDocument(packageDirPath.resolve(ProjectConstants.PACKAGE_MD_FILE_NAME));
        List<Path> resources = loadResources(packageDirPath);
        // load generated resources
        List<Path> generatedResources = loadResources(packageDirPath.resolve(GENERATED_MODULES_ROOT));
        if (!generatedResources.isEmpty()) {
            resources.addAll(generatedResources);
        }
        List<Path> testResources = loadResources(packageDirPath.resolve(ProjectConstants.TEST_DIR_NAME));
        // load generated test resources
        List<Path> generatedTestResources = loadResources(packageDirPath.resolve(
                GENERATED_MODULES_ROOT).resolve(TEST_DIR_NAME));
        if (!generatedTestResources.isEmpty()) {
            testResources.addAll(generatedTestResources);
        }
        return PackageData.from(packageDirPath, defaultModule, otherModules, ballerinaToml, dependenciesToml,
                cloudToml, compilerPluginToml, balToolToml, packageMd, resources, testResources);
    }

    private static List<ModuleData> loadNewGeneratedModules(Path packageDirPath) {
        throw new RuntimeException();
    }

    private static boolean isNewModule(Path packageDirPath, Path path) {
        throw new RuntimeException();
    }

    private static List<ModuleData> loadOtherModules(Path packageDirPath) {
        throw new RuntimeException();
    }

    private static ModuleData loadModule(Path moduleDirPath) {
        throw new RuntimeException();
    }

    private static void verifyDuplicateNames(List<DocumentData> srcDocs, List<DocumentData> generatedDocs,
                                             String moduleName, Path modulesDirPath, boolean isTestDocs) {
        for (DocumentData doc : srcDocs) {
            generatedDocs.forEach(generatedDoc -> {
                if (doc.name().equals(generatedDoc.name())) {
                    if (isTestDocs) {
                        throw new ProjectException("Test source file with a duplicate name '" +
                                doc.name() + "' detected in both generated and module tests for the module '" +
                                moduleName + "'. Please provide a unique name for '" +
                                modulesDirPath.resolve(TEST_DIR_NAME).resolve(doc.name()) + "'");
                    }
                    throw new ProjectException("Source file with a duplicate name '" + doc.name() + "' detected in " +
                            "both generated and module sources for the module '" + moduleName + "'. Please provide a " +
                            "unique name for '" + modulesDirPath.resolve(doc.name()) + "'");
                }
            });
        }
    }

    public static List<Path> loadResources(Path packagePath) {
        throw new RuntimeException();
    }

    public static List<DocumentData> loadDocuments(Path dirPath) {
        throw new RuntimeException();
    }

    public static DocumentData loadDocument(Path documentFilePath) {
        throw new RuntimeException();
    }

    // Overloaded helper to allow custom Charset
    public static DocumentData getDocumentData(Path documentFilePath, boolean isTest, Charset charset) {
        throw new RuntimeException();
    }

    public static BuildOptions createBuildOptions(PackageConfig packageConfig, BuildOptions theirOptions,
                                                  Path projectDirPath, String org) {
        // Todo figure out how to pass the build options without a performance hit
        TomlDocument ballerinaToml = TomlDocument.from(ProjectConstants.BALLERINA_TOML,
                packageConfig.ballerinaToml().map(DocumentConfig::content).orElse(""));
        TomlDocument pluginToml = TomlDocument.from(ProjectConstants.COMPILER_PLUGIN_TOML,
                packageConfig.dependenciesToml().map(DocumentConfig::content).orElse(""));
        TomlDocument balToolToml = TomlDocument.from(ProjectConstants.BAL_TOOL_TOML,
                packageConfig.balToolToml().map(DocumentConfig::content).orElse(""));
        ManifestBuilder manifestBuilder = ManifestBuilder
                .from(ballerinaToml, pluginToml, balToolToml, projectDirPath, org);
        BuildOptions defaultBuildOptions = manifestBuilder.buildOptions();
        if (defaultBuildOptions == null) {
            defaultBuildOptions = BuildOptions.builder().build();
        }
        return defaultBuildOptions.acceptTheirs(theirOptions);
    }

    public static void validateBuildProjectDirPath(Path projectDirPath) {
        throw new RuntimeException();
    }

    public static void validateBalaProjectPath(Path balaPath) {
        throw new RuntimeException();
    }

    private static boolean isValidBalaDir(Path balaPath) {
        throw new RuntimeException();
    }

    private static boolean isValidBalaFile(Path balaPath) {
        throw new RuntimeException();
    }
}
