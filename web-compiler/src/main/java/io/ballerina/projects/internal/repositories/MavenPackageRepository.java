/*
 * Copyright (c) 2023, WSO2 LLC. (http://wso2.com).
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package io.ballerina.projects.internal.repositories;


import io.ballerina.fs.Path;
import io.ballerina.projects.DependencyGraph;
import io.ballerina.projects.ModuleDescriptor;
import io.ballerina.projects.Package;
import io.ballerina.projects.PackageDescriptor;
import io.ballerina.projects.PackageName;
import io.ballerina.projects.PackageOrg;
import io.ballerina.projects.PackageVersion;
import io.ballerina.projects.ProjectException;
import io.ballerina.projects.Settings;
import io.ballerina.projects.environment.Environment;
import io.ballerina.projects.environment.ResolutionOptions;
import io.ballerina.projects.environment.ResolutionRequest;
import io.ballerina.projects.internal.model.Proxy;
import io.ballerina.projects.internal.model.Repository;
import org.wso2.ballerinalang.util.RepoUtils;

import java.util.Collection;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * This class represents the maven package repositories.
 *
 * @since 2201.8.0
 */

public class MavenPackageRepository extends AbstractPackageRepository {

    public static final String PLATFORM = "platform";
    private final FileSystemRepository fileSystemCache;


    public MavenPackageRepository(Environment environment, Path cacheDirectory, String distributionVersion) {
        this.fileSystemCache = new FileSystemRepository(environment, cacheDirectory, distributionVersion);
    }

    public static MavenPackageRepository from(Environment environment, Path cacheDirectory, Repository repository) {
        if (cacheDirectory.notExists()) {
            throw new ProjectException("cache directory does not exists: " + cacheDirectory);
        }

        if (repository.url().isEmpty()) {
            throw new ProjectException("repository url is not provided");
        }
        String ballerinaShortVersion = RepoUtils.getBallerinaShortVersion();

        return new MavenPackageRepository(environment, cacheDirectory, ballerinaShortVersion);
    }

    @Override
    public Optional<Package> getPackage(ResolutionRequest request, ResolutionOptions options) {
        isPackageExists(request.orgName(), request.packageName(), request.version().orElse(null),
                options.offline());
        return this.fileSystemCache.getPackage(request, options);
    }

    @Override
    public Collection<PackageVersion> getPackageVersions(ResolutionRequest request, ResolutionOptions options) {
        isPackageExists(request.orgName(), request.packageName(), request.version().orElse(null),
                options.offline());
        return getPackageVersions(request.orgName(), request.packageName(),
                request.version().orElse(null));
    }

    @Override
    public Map<String, List<String>> getPackages() {
        return this.fileSystemCache.getPackages();
    }


    @Override
    public boolean isPackageExists(PackageOrg org,
                                   PackageName name,
                                   PackageVersion version) {
        return this.fileSystemCache.isPackageExists(org, name, version);
    }

    // This method should be called before calling other methods
    public boolean isPackageExists(PackageOrg org,
                                   PackageName name,
                                   PackageVersion version, boolean offline) {
        boolean isPackageExist = this.fileSystemCache.isPackageExists(org, name, version);
        if (!isPackageExist && !offline) {
            return getPackageFromRemoteRepo(org.value(), name.value(), version.value().toString());
        }
        return isPackageExist;
    }

    @Override
    protected List<PackageVersion> getPackageVersions(PackageOrg org, PackageName name, PackageVersion version) {
        if (version == null) {
            return Collections.emptyList();
        }

        Path balaPath = this.fileSystemCache.getPackagePath(org.toString(), name.toString(), version.toString());
        if (balaPath.exists()) {
            return Collections.singletonList(version);
        } else {
            return Collections.emptyList();
        }
    }

    @Override
    protected DependencyGraph<PackageDescriptor> getDependencyGraph(PackageOrg org, PackageName name,
                                                                    PackageVersion version) {
        return this.fileSystemCache.getDependencyGraph(org, name, version);
    }

    @Override
    public Collection<ModuleDescriptor> getModules(PackageOrg org, PackageName name, PackageVersion version) {
        boolean packageExists = isPackageExists(org, name, version);
        if (!packageExists) {
            return Collections.emptyList();
        }
        return this.fileSystemCache.getModules(org, name, version);
    }

    public boolean getPackageFromRemoteRepo(String org,
                                            String name,
                                            String version) {
        // Stub implementation - web compiler doesn't support remote repositories
        return false;
    }
}
