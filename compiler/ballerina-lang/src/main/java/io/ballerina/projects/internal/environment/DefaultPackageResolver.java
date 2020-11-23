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

package io.ballerina.projects.internal.environment;

import io.ballerina.projects.Package;
import io.ballerina.projects.PackageDescriptor;
import io.ballerina.projects.PackageVersion;
import io.ballerina.projects.Project;
import io.ballerina.projects.environment.PackageCache;
import io.ballerina.projects.environment.PackageRepository;
import io.ballerina.projects.environment.PackageResolver;
import io.ballerina.projects.environment.ResolutionRequest;
import io.ballerina.projects.environment.ResolutionResponse;
import io.ballerina.projects.environment.ResolutionResponse.ResolutionStatus;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Optional;

/**
 * Default Package resolver for Ballerina project.
 *
 * @since 2.0.0
 */
public class DefaultPackageResolver implements PackageResolver {
    private final PackageRepository packageRepository;
    private final WritablePackageCache packageCache;

    public DefaultPackageResolver(PackageRepository packageRepository, PackageCache packageCache) {
        this.packageRepository = packageRepository;
        this.packageCache = (WritablePackageCache) packageCache;
    }

    @Override
    public Collection<ResolutionResponse> resolvePackages(Collection<ResolutionRequest> packageLoadRequests,
                                                          Project currentProject) {
        List<ResolutionResponse> resolutionResponses = new ArrayList<>();
        List<ResolutionRequest> pendingRequests = new ArrayList<>();
        Package currentPkg = currentProject != null ? currentProject.currentPackage() : null;
        for (ResolutionRequest resolutionRequest : packageLoadRequests) {
            Package resolvedPackage = null;
            // Check whether the requested package is same as the current package
            if (currentPkg != null && resolutionRequest.packageDescriptor().equals(currentPkg.descriptor())) {
                resolvedPackage = currentPkg;
            }

            // If not try to load the package from the cache
            if (resolvedPackage == null) {
                resolvedPackage = loadFromCache(resolutionRequest);
            }

            if (resolvedPackage == null) {
                // If not add it to the pending requests and ask from the package repository
                pendingRequests.add(resolutionRequest);
            } else {
                // Otherwise add the resolved package to the resolved list
                resolutionResponses.add(ResolutionResponse.from(ResolutionStatus.RESOLVED,
                        resolvedPackage, resolutionRequest));
            }
        }

        resolutionResponses.addAll(resolveFromRepository(pendingRequests));
        return resolutionResponses;
    }

    @Override
    public Collection<ResolutionResponse> resolvePackages(Collection<ResolutionRequest> resolutionRequests) {
        return resolvePackages(resolutionRequests, null);
    }

    private Collection<ResolutionResponse> resolveFromRepository(Collection<ResolutionRequest> resolutionRequests) {
        List<ResolutionResponse> resolutionResponses = new ArrayList<>();
        for (ResolutionRequest resolutionRequest : resolutionRequests) {
            Package resolvedPackage = loadFromRepository(resolutionRequest);
            ResolutionStatus resolutionStatus = resolvedPackage != null ? ResolutionStatus.RESOLVED :
                    ResolutionStatus.UNRESOLVED;
            resolutionResponses.add(ResolutionResponse.from(resolutionStatus,
                    resolvedPackage, resolutionRequest));
        }
        return resolutionResponses;
    }

    private Package loadFromCache(ResolutionRequest packageLoadRequest) {
        // TODO improve the logic
        List<Package> packageList = packageCache.getPackages(packageLoadRequest.orgName(),
                packageLoadRequest.packageName());

        if (packageList.isEmpty()) {
            return null;
        }

        return packageList.get(0);
    }

    private Package loadFromRepository(ResolutionRequest resolutionRequest) {
        // If version is null load the latest package
        if (resolutionRequest.version().isEmpty()) {
            // find the latest version
            List<PackageVersion> packageVersions = packageRepository.getPackageVersions(resolutionRequest);
            if (packageVersions.isEmpty()) {
                // no versions found.
                // todo handle package not found with exception
                return null;
            }
            PackageVersion latest = findLatest(packageVersions);
            resolutionRequest = ResolutionRequest.from(
                    PackageDescriptor.from(resolutionRequest.orgName(), resolutionRequest.packageName(), latest));
        }

        Optional<Package> packageOptional = packageRepository.getPackage(resolutionRequest);
        packageOptional.ifPresent(packageCache::cache);
        return packageOptional.orElse(null);
    }

    private PackageVersion findLatest(List<PackageVersion> packageVersions) {
        // todo Fix me
        return packageVersions.get(0);
    }
}