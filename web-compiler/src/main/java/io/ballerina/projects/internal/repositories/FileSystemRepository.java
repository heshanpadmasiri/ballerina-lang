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
package io.ballerina.projects.internal.repositories;

import io.ballerina.fs.Path;
import io.ballerina.projects.DependencyGraph;
import io.ballerina.projects.JvmTarget;
import io.ballerina.projects.ModuleDescriptor;
import io.ballerina.projects.Package;
import io.ballerina.projects.PackageDescriptor;
import io.ballerina.projects.PackageName;
import io.ballerina.projects.PackageOrg;
import io.ballerina.projects.PackageVersion;
import io.ballerina.projects.Project;
import io.ballerina.projects.ProjectEnvironmentBuilder;
import io.ballerina.projects.ProjectException;
import io.ballerina.projects.bala.BalaProject;
import io.ballerina.projects.environment.Environment;
import io.ballerina.projects.environment.ResolutionOptions;
import io.ballerina.projects.environment.ResolutionRequest;
import io.ballerina.projects.internal.BalaFiles;
import io.ballerina.projects.repos.FileSystemCache;
import io.ballerina.projects.util.FileUtils;
import io.ballerina.projects.util.ProjectConstants;
import io.ballerina.projects.util.ProjectUtils;

import io.ballerina.fs.File;
import java.nio.file.Files;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * Package Repository stored in file system.
 * The structure of the repository is as below
 * <pre>
 * - bala
 *     - org
 *         - package-name
 *             - version
 *                 - platform (contains extracted bala)
 *
 * - cache[-&lt;distShortVersion&gt;]
 *     - org
 *         - package-name
 *             - version
 *                 - bir
 *                     - mod1.bir
 *                     - mod2.bir
 *                 - jar
 *                     - org-package-name-version.jar
 * </pre>
 * @since 2.0.0
 */
public class FileSystemRepository extends AbstractPackageRepository {
    Path bala;
    private final Path cacheDir;
    private final Environment environment;

    // TODO Refactor this when we do repository/cache split
    public FileSystemRepository(Environment environment, Path cacheDirectory) {
        this.cacheDir = cacheDirectory.resolve(ProjectConstants.CACHES_DIR_NAME);
        this.bala = cacheDirectory.resolve(ProjectConstants.REPO_BALA_DIR_NAME);
        this.environment = environment;
    }

    public FileSystemRepository(Environment environment, Path cacheDirectory, String distributionVersion) {
        this.cacheDir = cacheDirectory.resolve(ProjectConstants.CACHES_DIR_NAME + "-" + distributionVersion);
        this.bala = cacheDirectory.resolve(ProjectConstants.REPO_BALA_DIR_NAME);
        this.environment = environment;
    }

    @Override
    public Optional<Package> getPackage(ResolutionRequest request, ResolutionOptions options) {
        // if version and org name is empty we add empty string so we return empty package anyway
        String packageName = request.packageName().value();
        String orgName = request.orgName().value();
        String version = request.version().isPresent() ?
                request.version().get().toString() : "0.0.0";

        Path balaPath = getPackagePath(orgName, packageName, version);
        if (!balaPath.exists()) {
            return Optional.empty();
        }

        ProjectEnvironmentBuilder environmentBuilder = ProjectEnvironmentBuilder.getBuilder(environment);
        environmentBuilder = environmentBuilder.addCompilationCacheFactory(
                new FileSystemCache.FileSystemCacheFactory(cacheDir));
        Project project = BalaProject.loadProject(environmentBuilder, balaPath);
        return Optional.of(project.currentPackage());
    }

    /**
     * Update the deprecated status of the package in file system cache.
     *
     * @param descriptor Package descriptor
     */
    void updateDeprecatedStatusForPackage(PackageDescriptor descriptor) {
        Path balaPath = getPackagePath(descriptor.org().value(), descriptor.name().value(),
                descriptor.version().value().toString());
        if (balaPath != null && balaPath.exists()) {
            Path deprecateMsgMetaFile = Path.of(balaPath.toString(), ProjectConstants.DEPRECATED_META_FILE_NAME);
            if (descriptor.getDeprecated() && !deprecateMsgMetaFile.exists()) {
                FileUtils.addDeprecatedMetaFile(deprecateMsgMetaFile, descriptor.getDeprecationMsg());
            }

            if (!descriptor.getDeprecated() && deprecateMsgMetaFile.exists()) {
                FileUtils.deleteDeprecatedMetaFile(deprecateMsgMetaFile);
            }
        }
    }

    @Override
    public boolean isPackageExists(PackageOrg org,
                                   PackageName name,
                                   PackageVersion version) {
        if (org.value() == null || name.value() == null) {
            return false;
        }
        Path balaPath = getPackagePath(org.value(), name.value(), version.value().toString());
        return balaPath.exists();
    }

    @Override
    public Collection<PackageVersion> getPackageVersions(ResolutionRequest request, ResolutionOptions options) {
        // if version and org name is empty we add empty string so we return empty package anyway
        return getPackageVersions(request.orgName(), request.packageName(),
                request.version().orElse(null));
    }

    /**
     * Get the list of packages in the bala cache.
     *
     * @return {@link List} of package names
     */
    @Override
    public Map<String, List<String>> getPackages() {
        throw new RuntimeException();
    }

    @Override
    protected List<PackageVersion> getPackageVersions(PackageOrg org, PackageName name, PackageVersion version) {
        throw new RuntimeException();
    }

    @Override
    protected DependencyGraph<PackageDescriptor> getDependencyGraph(PackageOrg org,
                                                                    PackageName name,
                                                                    PackageVersion version) {
        Path balaPath = getPackagePath(org.toString(), name.toString(), version.toString());
        BalaFiles.DependencyGraphResult dependencyGraphResult = BalaFiles.createPackageDependencyGraph(balaPath);
        return dependencyGraphResult.packageDependencyGraph();
    }

    @Override
    public Collection<ModuleDescriptor> getModules(PackageOrg org,
                                                      PackageName name,
                                                      PackageVersion version) {
        Path balaPath = getPackagePath(org.toString(), name.toString(), version.toString());
        BalaFiles.DependencyGraphResult dependencyGraphResult = BalaFiles.createPackageDependencyGraph(balaPath);
        return dependencyGraphResult.moduleDependencies().keySet();
    }

    protected Path getPackagePath(String org, String name, String version) {
        //First we will check for a bala that match any platform
        Path balaPath = this.bala.resolve(
                ProjectUtils.getRelativeBalaPath(org, name, version, null));
        if (!balaPath.exists()) {
            // If bala for any platform not exist check for specific platform
            for (JvmTarget jvmTarget : JvmTarget.values()) {
                balaPath = this.bala.resolve(ProjectUtils.getRelativeBalaPath(org, name, version, jvmTarget.code()));
                if (balaPath.exists()) {
                    break;
                }
            }
        }
        return balaPath;
    }

    protected List<PackageVersion> pathToVersions(List<Path> versions) {
        List<PackageVersion> availableVersions = new ArrayList<>();
        versions.stream().map(path -> Optional.ofNullable(path)
                .map(Path::getFileName)
                .map(Path::toString)
                .orElse("0.0.0")).forEach(version -> {
                    try {
                        availableVersions.add(PackageVersion.from(version));
                    } catch (ProjectException ignored) {
                        // We consider only the semver compatible versions as valid
                        // bala directories. Since we only allow building and pushing
                        // semver compatible packages, it is safe to pick only
                        // the semver compatible versions.
                    }
        });
        return availableVersions;
    }
}
