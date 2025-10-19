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
package io.ballerina.projects.repos;

import io.ballerina.fs.Path;
import io.ballerina.projects.CompilationCache;
import io.ballerina.projects.CompilationCacheFactory;
import io.ballerina.projects.CompilerBackend;
import io.ballerina.projects.ModuleName;
import io.ballerina.projects.Package;
import io.ballerina.projects.PackageManifest;
import io.ballerina.projects.Project;
import io.ballerina.projects.util.ProjectConstants;

import java.io.ByteArrayOutputStream;
import java.util.Optional;

/**
 * An implementation of the {@code PackageCompilationCache} that is aware of the file system structure.
 * <p>
 * The structure of the repository is as bellow
 * - cache
 * - org
 * - package-name
 * - version
 * - bir
 * - mod1.bir
 * - mod2.bir
 * - jar
 * - org-package-name-version.jar
 *
 * @since 2.0.0
 */
public class FileSystemCache extends CompilationCache {
    private final Path cacheDirPath;
    private Path birPath;
    private Path packageCacheDirPath;

    public FileSystemCache(Project project, Path cacheDirPath) {
        super(project);
        this.cacheDirPath = cacheDirPath;
    }

    @Override
    public byte[] getBir(ModuleName moduleName) {
        throw new RuntimeException("getBir is not supported in web compiler");
    }

    @Override
    public void cacheBir(ModuleName moduleName, ByteArrayOutputStream birContent) {
        throw new RuntimeException("cacheBir is not supported in web compiler");
    }

    @Override
    public Optional<Path> getPlatformSpecificLibrary(CompilerBackend compilerBackend, String libraryName) {
        String libraryFileName = libraryName + compilerBackend.libraryFileExtension();
        Path targetPlatformCacheDirPath = getTargetPlatformCacheDirPath(compilerBackend);
        Path jarFilePath = targetPlatformCacheDirPath.resolve(libraryFileName);
        return jarFilePath.exists() ? Optional.of(jarFilePath) : Optional.empty();
    }

    @Override
    public void cachePlatformSpecificLibrary(CompilerBackend compilerBackend,
                                             String libraryName,
                                             ByteArrayOutputStream libraryContent) {
        throw new RuntimeException("cachePlatformSpecificLibrary is not supported in web compiler");
    }

    /**
     * Returns the path to the BIR cache directory for this repository.
     *
     * @since 2201.13.0
     *
     * @return path to the cache directory.
     */
    public Path cachePath() {
        return getBirPath().getParent();
    }

    private Path getTargetPlatformCacheDirPath(CompilerBackend compilerBackend) {
        String targetPlatformCode = compilerBackend.targetPlatform().code();
        return packageCacheDirPath().resolve(targetPlatformCode);
    }

    private void createDirectories(Path dirPath) {
        if (dirPath.exists()) {
            return;
        }

        dirPath.createDirectories();
    }

    private Path getBirPath() {
        if (birPath != null) {
            return birPath;
        }

        birPath = packageCacheDirPath().resolve(ProjectConstants.REPO_BIR_CACHE_NAME);
        return birPath;
    }

    private Path packageCacheDirPath() {
        if (packageCacheDirPath != null) {
            return packageCacheDirPath;
        }

        // TODO Update the following logic to support singleBalFileCase
        Package currentPkg = project.currentPackage();
        PackageManifest pkgDescriptor = currentPkg.manifest();
        packageCacheDirPath = cacheDirPath.resolve(pkgDescriptor.org().value())
                .resolve(pkgDescriptor.name().value())
                .resolve(pkgDescriptor.version().toString());
        return packageCacheDirPath;
    }

    /**
     * A factory that creates instances of {@code FileSystemCache} for the given project.
     *
     * @since 2.0.0
     */
    public static class FileSystemCacheFactory implements CompilationCacheFactory {
        private final Path cacheDirPath;

        public FileSystemCacheFactory(Path cacheDirPath) {
            this.cacheDirPath = cacheDirPath;
        }

        @Override
        public CompilationCache createCompilationCache(Project project) {
            return new FileSystemCache(project, cacheDirPath);
        }
    }
}
