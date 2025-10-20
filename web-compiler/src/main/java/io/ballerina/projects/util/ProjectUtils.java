/*
 * Copyright (c) 2020, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
package io.ballerina.projects.util;

import io.ballerina.compiler.syntax.tree.IdentifierToken;
import io.ballerina.compiler.syntax.tree.ImportDeclarationNode;
import io.ballerina.compiler.syntax.tree.ModulePartNode;
import io.ballerina.compiler.syntax.tree.SeparatedNodeList;
import io.ballerina.fs.Path;
import io.ballerina.projects.Document;
import io.ballerina.projects.DocumentId;
import io.ballerina.projects.JvmTarget;
import io.ballerina.projects.Module;
import io.ballerina.projects.ModuleId;
import io.ballerina.projects.Package;
import io.ballerina.projects.PackageDependencyScope;
import io.ballerina.projects.PackageDescriptor;
import io.ballerina.projects.PackageManifest;
import io.ballerina.projects.PackageName;
import io.ballerina.projects.PackageOrg;
import io.ballerina.projects.PackageVersion;
import io.ballerina.projects.Project;
import io.ballerina.projects.ProjectException;
import io.ballerina.projects.ProjectKind;
import io.ballerina.projects.ResolvedPackageDependency;
import io.ballerina.projects.SemanticVersion;
import io.ballerina.projects.environment.PackageLockingMode;
import io.ballerina.projects.internal.model.BuildJson;
import io.ballerina.projects.internal.model.Dependency;
import io.ballerina.projects.internal.model.ToolDependency;
import io.ballerina.tools.diagnostics.Diagnostic;
import io.ballerina.tools.diagnostics.DiagnosticSeverity;
import io.ballerina.tools.envutils.EnvConstants;
import io.ballerina.tools.envutils.PropertyConstants;
import org.ballerinalang.compiler.BLangCompilerException;
import org.wso2.ballerinalang.compiler.util.Names;
import org.wso2.ballerinalang.util.RepoUtils;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.StringJoiner;
import java.util.stream.Collectors;

import static io.ballerina.projects.util.ProjectConstants.BALLERINA_HOME;
import static io.ballerina.projects.util.ProjectConstants.BLANG_COMPILED_JAR_EXT;
import static io.ballerina.projects.util.ProjectConstants.BLANG_COMPILED_PKG_BINARY_EXT;
import static io.ballerina.projects.util.ProjectConstants.BUILD_FILE;

/**
 * Project related util methods.
 *
 * @since 2.0.0
 */
public final class ProjectUtils {

    private static final String USER_HOME = "user.home";
    private static final List<Diagnostic> projectLoadingDiagnostic = new ArrayList<>();

    private ProjectUtils() {
    }

    public static Set<String> getPackageImports(Package pkg) {
        Set<String> imports = new HashSet<>();
        for (ModuleId moduleId : pkg.moduleIds()) {
            Module module = pkg.module(moduleId);
            Collection<DocumentId> documentIds = module.documentIds();
            getPackageImports(imports, module, documentIds);
            Collection<DocumentId> testDocumentIds = module.testDocumentIds();
            getPackageImports(imports, module, testDocumentIds);
        }
        return imports;
    }

    private static void getPackageImports(Set<String> imports, Module module, Collection<DocumentId> documentIds) {
        for (DocumentId docId : documentIds) {
            Document document = module.document(docId);
            ModulePartNode modulePartNode = document.syntaxTree().rootNode();
            for (ImportDeclarationNode importDcl : modulePartNode.imports()) {
                boolean isErrorInImport = false;
                for (Diagnostic diagnostic : importDcl.diagnostics()) {
                    if (diagnostic.diagnosticInfo().severity() == DiagnosticSeverity.ERROR) {
                        isErrorInImport = true;
                        break;
                    }
                }
                if (isErrorInImport) {
                    continue;
                }
                String orgName = "";
                if (importDcl.orgName().isPresent()) {
                    orgName = importDcl.orgName().get().orgName().text();
                }
                SeparatedNodeList<IdentifierToken> identifierTokenList = importDcl.moduleName();
                StringJoiner stringJoiner = new StringJoiner(".");
                for (int i = 0; i < identifierTokenList.size(); i++) {
                    stringJoiner.add(identifierTokenList.get(i).text());
                }
                String moduleName = stringJoiner.toString();
                imports.add(orgName + "/" + moduleName);
            }
        }
    }

    public static String getBalaName(PackageManifest pkgDesc) {
        return ProjectUtils.getBalaName(pkgDesc.org().toString(),
                                        pkgDesc.name().toString(),
                                        pkgDesc.version().toString(),
                                        null
        );
    }

    public static String getBalaName(String org, String pkgName, String version, String platform) {
        // <orgname>-<packagename>-<platform>-<version>.bala
        if (platform == null || platform.isEmpty()) {
            platform = "any";
        }
        return org + "-" + pkgName + "-" + platform + "-" + version + BLANG_COMPILED_PKG_BINARY_EXT;
    }

    /**
     * Returns the relative path of extracted bala beginning from the package org.
     *
     * @param org package org
     * @param pkgName package name
     * @param version package version
     * @param platform version, null converts to `any`
     * @return relative bala path
     */
    public static Path getRelativeBalaPath(String org, String pkgName, String version, String platform) {
        // <orgname>-<packagename>-<platform>-<version>.bala
        if (platform == null || platform.isEmpty()) {
            platform = "any";
        }
        return Path.of(org, pkgName, version, platform);
    }

    public static String getExecutableName(Package pkg) {
        // <packagename>.jar
        return pkg.packageName().toString() + BLANG_COMPILED_JAR_EXT;
    }

    public static Path getBalHomePath() {
        return Path.of(PropertyConstants.getProperty(BALLERINA_HOME));
    }

    /**
     * Create and get the home repository path.
     *
     * @return home repository path
     */
    public static Path createAndGetHomeReposPath() {
        Path homeRepoPath;
        String homeRepoDir = EnvConstants.getEnv(ProjectConstants.HOME_REPO_ENV_KEY);
        if (homeRepoDir == null || homeRepoDir.isEmpty()) {
            String userHomeDir = PropertyConstants.getProperty(USER_HOME);
            if (userHomeDir == null || userHomeDir.isEmpty()) {
                throw new BLangCompilerException("Error creating home repository: unable to get user home directory");
            }
            homeRepoPath = Path.of(userHomeDir, ProjectConstants.HOME_REPO_DEFAULT_DIRNAME);
        } else {
            // User has specified the home repo path with env variable.
            homeRepoPath = Path.of(homeRepoDir);
        }

        homeRepoPath = homeRepoPath.toAbsolutePath();
        if (homeRepoPath.exists() && !homeRepoPath.isDirectory()) {
            throw new BLangCompilerException("Home repository is not a directory: " + homeRepoPath);
        }
        return homeRepoPath;
    }

    public static void checkWritePermission(Path path) {
        if (!path.canWrite()) {
            throw new ProjectException("'" + path.normalize() + "' does not have write permissions");
        }
    }

    /**
     * Get `Dependencies.toml` content as a string.
     *
     * @param pkgGraphDependencies    direct dependencies of the package dependency graph
     * @return Dependencies.toml` content
     */
    public static String getDependenciesTomlContent(Collection<ResolvedPackageDependency> pkgGraphDependencies) {
        String comment = "# AUTO-GENERATED FILE. DO NOT MODIFY.\n" +
                "\n" +
                "# This file is auto-generated by Ballerina for managing dependency versions.\n" +
                "# It should not be modified by hand.\n" +
                "\n";
        StringBuilder content = new StringBuilder(comment);
        content.append("[ballerina]\n");
        content.append("version = \"").append(RepoUtils.getBallerinaShortVersion()).append("\"\n");
        content.append("dependencies-toml-version = \"").append(ProjectConstants.DEPENDENCIES_TOML_VERSION)
                .append("\"\n");

        // write dependencies from package dependency graph
        pkgGraphDependencies.forEach(graphDependency -> {
            content.append("\n");
            PackageDescriptor descriptor = graphDependency.packageInstance().descriptor();
            addDependencyContent(content, descriptor.org().value(), descriptor.name().value(),
                                 descriptor.version().value().toString(), null, Collections.emptyList(),
                                 Collections.emptyList());
        });
        return String.valueOf(content);
    }

    /**
     * Get `Dependencies.toml` content as a string.
     *
     * @param pkgDependencies       direct dependencies of the package dependency graph
     * @return Dependencies.toml` content
     */
    public static String getDependenciesTomlContent(List<Dependency> pkgDependencies,
                                                    List<ToolDependency> toolDependencies) {
        String comment = "# AUTO-GENERATED FILE. DO NOT MODIFY.\n" +
                "\n" +
                "# This file is auto-generated by Ballerina for managing dependency versions.\n" +
                "# It should not be modified by hand.\n" +
                "\n";
        StringBuilder content = new StringBuilder(comment);
        content.append("[ballerina]\n");
        content.append("dependencies-toml-version = \"").append(ProjectConstants.DEPENDENCIES_TOML_VERSION)
                .append("\"\n");
        content.append("distribution-version = \"").append(RepoUtils.getBallerinaShortVersion()).append("\"\n");

        // write dependencies from package dependency graph
        pkgDependencies.forEach(dependency -> {
            content.append("\n");
            addDependencyContent(content, dependency.getOrg(), dependency.getName(), dependency.getVersion(),
                                 getDependencyScope(dependency.getScope()), dependency.getDependencies(),
                                 dependency.getModules());
        });

        // write tool dependencies
        toolDependencies.forEach(toolDependency -> {
            content.append("\n");
            addToolDependencyContent(
                    content,
                    toolDependency.getId(),
                    toolDependency.getOrg(),
                    toolDependency.getName(),
                    toolDependency.getVersion());
        });
        return String.valueOf(content);
    }

    private static void addDependencyContent(StringBuilder content, String org, String name, String version,
                                             String scope, List<Dependency> dependencies,
                                             List<Dependency.Module> modules) {
        content.append("[[package]]\n");
        content.append("org = \"").append(org).append("\"\n");
        content.append("name = \"").append(name).append("\"\n");
        content.append("version = \"").append(version).append("\"\n");
        if (scope != null) {
            content.append("scope = \"").append(scope).append("\"\n");
        }

        // write dependencies
        if (!dependencies.isEmpty()) {
            var count = 1;
            content.append("dependencies = [\n");
            for (Dependency transDependency : dependencies) {
                content.append("\t{");
                content.append("org = \"").append(transDependency.getOrg()).append("\", ");
                content.append("name = \"").append(transDependency.getName()).append("\"");
                content.append("}");

                if (count != dependencies.size()) {
                    content.append(",\n");
                } else {
                    content.append("\n");
                }
                count++;
            }
            content.append("]\n");
        }

        // write modules
        if (!modules.isEmpty()) {
            var count = 1;
            content.append("modules = [\n");
            for (Dependency.Module module : modules) {
                content.append("\t{");
                content.append("org = \"").append(module.org()).append("\", ");
                content.append("packageName = \"").append(module.packageName()).append("\", ");
                content.append("moduleName = \"").append(module.moduleName()).append("\"");
                content.append("}");

                if (count != modules.size()) {
                    content.append(",\n");
                } else {
                    content.append("\n");
                }
                count++;
            }
            content.append("]\n");
        }
    }

    private static void addToolDependencyContent(
            StringBuilder content,
            String id,
            String org,
            String name,
            String version) {
        content.append("[[tool]]\n");
        content.append("id = \"").append(id).append("\"\n");
        content.append("org = \"").append(org).append("\"\n");
        content.append("name = \"").append(name).append("\"\n");
        content.append("version = \"").append(version).append("\"\n");
    }

    private static String getDependencyScope(PackageDependencyScope scope) {
        if (scope == PackageDependencyScope.TEST_ONLY) {
            return "testOnly";
        }
        return null;
    }

    public static List<PackageName> getPossiblePackageNames(PackageOrg packageOrg, String moduleName) {
        var pkgNameBuilder = new StringJoiner(".");

        // If built in package, return moduleName as it is
        if (isBuiltInPackage(packageOrg, moduleName)) {
            pkgNameBuilder.add(moduleName);
            return Collections.singletonList(PackageName.from(pkgNameBuilder.toString()));
        }

        String[] modNameParts = moduleName.split("\\.");
        List<PackageName> possiblePkgNames = new ArrayList<>(modNameParts.length);
        for (String modNamePart : modNameParts) {
            pkgNameBuilder.add(modNamePart);
            possiblePkgNames.add(PackageName.from(pkgNameBuilder.toString()));
        }
        return possiblePkgNames;
    }

    public static boolean isBuiltInPackage(PackageOrg org, String moduleName) {
        return (org.isBallerinaOrg() && moduleName.startsWith("lang.")) ||
                (org.value().equals(Names.BALLERINA_INTERNAL_ORG.getValue())) ||
                (org.isBallerinaOrg() && moduleName.equals(Names.JAVA.getValue())) ||
                (org.isBallerinaOrg() && moduleName.equals(Names.TEST.getValue()));
    }

    public static boolean isLangLibPackage(PackageOrg org, PackageName packageName) {
        return (org.isBallerinaOrg() && packageName.value().startsWith("lang.")) ||
                (org.isBallerinaOrg() && packageName.value().equals(Names.JAVA.getValue()));
    }

    /**
     * Delete the given directory along with all files and sub directories.
     *
     * @param directoryPath Directory to delete.
     */
    public static boolean deleteDirectory(Path directoryPath) {
        return directoryPath.deleteDirectory();
    }

    /**
     * Read build file from given path.
     *
     * @param buildJsonPath build file path
     * @return build json object
     * @throws IOException if json read fails
     */
    public static BuildJson readBuildJson(Path buildJsonPath) throws IOException {
        throw new RuntimeException();
    }

    /**
     * Compare and get latest of two package versions.
     *
     * @param v1 package version 1
     * @param v2 package version 2
     * @return latest package version from given two package versions
     */
    public static PackageVersion getLatest(PackageVersion v1, PackageVersion v2) {
        SemanticVersion semVer1 = v1.value();
        SemanticVersion semVer2 = v2.value();
        boolean isV1PreReleaseVersion = semVer1.isPreReleaseVersion();
        boolean isV2PreReleaseVersion = semVer2.isPreReleaseVersion();
        if (isV1PreReleaseVersion ^ isV2PreReleaseVersion) {
            // Only one version is a pre-release version
            // Return the version which is not a pre-release version
            return isV1PreReleaseVersion ? v2 : v1;
        } else {
            // Both versions are pre-release versions or both are not pre-release versions
            // Find the latest version
            return semVer1.greaterThanOrEqualTo(semVer2) ? v1 : v2;
        }
    }

    /**
     * Return the path of a bala with the available platform directory (java21 or any).
     *
     * @param balaDirPath path to the bala directory
     * @param org org name of the bala
     * @param name package name of the bala
     * @param version version of the bala
     * @return path of the bala file
     */
    public static Path getPackagePath(Path balaDirPath, String org, String name, String version) {
        //First we will check for a bala that match any platform
        Path balaPath = balaDirPath.resolve(
                ProjectUtils.getRelativeBalaPath(org, name, version, null));
        if (!balaPath.exists()) {
            for (JvmTarget jvmTarget : JvmTarget.values()) {
                balaPath = balaDirPath.resolve(ProjectUtils.getRelativeBalaPath(org, name, version, jvmTarget.code()));
                if (balaPath.exists()) {
                    break;
                }
            }
        }
        return balaPath;
    }

    /**
     * Get the sticky status of a project.
     *
     * @param project project instance
     * @return true if the project is sticky, false otherwise
     */
    public static boolean getSticky(Project project) {
        boolean sticky = project.buildOptions().sticky();
        if (sticky) {
            return true;
        }

        // set sticky only if `build` file exists and `last_update_time` not passed 24 hours
        if (project.kind() == ProjectKind.BUILD_PROJECT) {
            Path buildFilePath = project.targetDir().resolve(BUILD_FILE);
            if (buildFilePath.exists() && buildFilePath.toFile().length() > 0) {
                try {
                    BuildJson buildJson = readBuildJson(buildFilePath);
                    // if distribution is not same, we anyway return sticky as false
                    if (buildJson != null && buildJson.distributionVersion() != null &&
                            buildJson.distributionVersion().equals(RepoUtils.getBallerinaShortVersion()) &&
                            !buildJson.isExpiredLastUpdateTime()) {
                        return true;
                    }
                } catch (IOException e) {
                    // ignore
                }
            }
        }
        return false;
    }

    /**
     * From a list of versions, get the versions within the compatible range.
     *
     * @param minVersion minimum compatible version
     * @param versions all versions available
     * @param compatibleRange compatibility range
     * @return compatible versions
     */
    public static List<SemanticVersion> getVersionsInCompatibleRange(
            SemanticVersion minVersion,
            List<SemanticVersion> versions,
            CompatibleRange compatibleRange) {
        if (compatibleRange.equals(CompatibleRange.LATEST)) {
            // If minVersion is null, range is LATEST
            return versions;
        }
        if (compatibleRange.equals(CompatibleRange.LOCK_MAJOR)) {
            return versions.stream().filter(version ->
                    version.major() == minVersion.major() && version.greaterThanOrEqualTo(minVersion)).collect(Collectors.toList());
        }
        if (compatibleRange.equals(CompatibleRange.LOCK_MINOR)) {
            return versions.stream().filter(version ->
                            version.major() == minVersion.major() && version.minor() == minVersion.minor()
                                    && version.greaterThanOrEqualTo(minVersion)).collect(Collectors.toList());
        }
        if (versions.contains(minVersion)) {
            return Collections.singletonList(minVersion);
        }
        return Collections.emptyList();
    }

    /**
     * Get the range of version compatibility of a given project.
     *
     * @param version minimum compatible version
     * @param packageLockingMode locking mode of the project
     * @return compatible range
     */
    public static CompatibleRange getCompatibleRange(SemanticVersion version, PackageLockingMode packageLockingMode) {
        if (version == null) {
            return CompatibleRange.LATEST;
        }
        if (packageLockingMode.equals(PackageLockingMode.HARD)) {
            return CompatibleRange.EXACT;
        }
        if (packageLockingMode.equals(PackageLockingMode.MEDIUM) || version.isInitialVersion()) {
            return CompatibleRange.LOCK_MINOR;
        }
        // Locking mode SOFT
        return CompatibleRange.LOCK_MAJOR;
    }

    /**
     * Denote the compatibility range of a given tool version.
     */
    public enum CompatibleRange {
        /**
         * Latest stable (if any), else latest pre-release.
         */
        LATEST,
        /**
         * Latest minor version of the locked major version.
         */
        LOCK_MAJOR,
        /**
         * Latest patch version of the locked major and minor versions.
         */
        LOCK_MINOR,
        /**
         * Exact version provided.
         */
        EXACT
    }

    public static List<Diagnostic> getProjectLoadingDiagnostic() {
        return projectLoadingDiagnostic;
    }

}
