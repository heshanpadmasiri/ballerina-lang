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
package io.ballerina.projects.internal.model;

import io.ballerina.fs.Path;
import io.ballerina.projects.Module;
import io.ballerina.projects.Package;
import io.ballerina.projects.util.ProjectConstants;
import io.ballerina.projects.util.ProjectUtils;
import org.wso2.ballerinalang.compiler.util.ProjectDirConstants;

import java.io.IOException;

/**
 * Represents the target directory model.
 *
 * @since 2.0.0
 */
public class Target {
    private final Path targetPath;
    private Path outputPath = null;
    private final Path cache;
    private final Path jarCachePath;
    private final Path balaCachePath;
    private final Path birCachePath;
    private final Path testsCachePath;
    private final Path binPath;
    private final Path reportPath;
    private final Path docPath;
    private final Path nativePath;
    private final Path nativeConfigPath;
    private final Path profilerPath;
    private final Path resourcesPath;

    public Target(Path targetPath) throws IOException {
        this.targetPath = targetPath;
        this.cache = this.targetPath.resolve(ProjectConstants.CACHES_DIR_NAME);
        this.balaCachePath = this.targetPath.resolve(ProjectConstants.TARGET_BALA_DIR_NAME);
        this.jarCachePath = this.cache.resolve(ProjectDirConstants.JAR_CACHE_DIR_NAME);
        this.birCachePath = this.cache.resolve(ProjectConstants.BIR_CACHE_DIR_NAME);
        this.testsCachePath = this.cache.resolve(ProjectConstants.TESTS_CACHE_DIR_NAME);
        this.binPath = this.targetPath.resolve(ProjectConstants.BIN_DIR_NAME);
        this.reportPath = this.targetPath.resolve(ProjectConstants.REPORT_DIR_NAME);
        this.docPath = this.targetPath.resolve(ProjectConstants.TARGET_API_DOC_DIRECTORY);
        this.nativePath = this.targetPath.resolve(ProjectConstants.NATIVE_DIR_NAME);
        this.nativeConfigPath = this.testsCachePath.resolve(ProjectConstants.NATIVE_CONFIG_DIR_NAME);
        this.profilerPath = this.targetPath.resolve(ProjectConstants.PROFILER_DIR_NAME);
        this.resourcesPath = this.targetPath.resolve(ProjectConstants.RESOURCE_DIR_NAME);

        if (this.targetPath.exists()) {
            ProjectUtils.checkWritePermission(this.targetPath);
        } else {
            this.targetPath.createDirectories();
        }

        if (this.cache.exists()) {
            ProjectUtils.checkWritePermission(this.cache);
        }
        if (this.binPath.exists()) {
            ProjectUtils.checkWritePermission(this.binPath);
        }
        if (this.balaCachePath.exists()) {
            ProjectUtils.checkWritePermission(this.balaCachePath);
        }
        if (this.docPath.exists()) {
            ProjectUtils.checkWritePermission(this.docPath);
        }

        if (this.reportPath.exists()) {
            ProjectUtils.checkWritePermission(this.reportPath);
        }
        if (this.profilerPath.exists()) {
            ProjectUtils.checkWritePermission(this.profilerPath);
        }
        if (this.resourcesPath.exists()) {
            ProjectUtils.checkWritePermission(this.resourcesPath);
        }
    }

    /**
     * Returns the bala dir path.
     *
     * @return path of the bala file
     */
    public Path getBalaPath() throws IOException {
        balaCachePath.createDirectories();
        return balaCachePath;
    }

    /**
     * Returns the jar-cache path.
     *
     * @return path of the executable
     */
    public Path getJarCachePath() throws IOException {
        jarCachePath.createDirectories();
        return jarCachePath;
    }

    /**
     * Returns the path of the executable jar.
     *
     * @param pkg Package instance
     * @return the path of the executable
     */
    public Path getExecutablePath(Package pkg) throws IOException {
        if (outputPath != null) {
            return outputPath;
        }
        return getBinPath().resolve(ProjectUtils.getExecutableName(pkg));
    }

    public Path getTestExecutablePath(Module module) throws IOException {
        if (outputPath != null) {
            return outputPath;
        }
        String name = module.moduleName().toString();
        return getTestBinPath().resolve(name +
                ProjectConstants.TEST_UBER_JAR_SUFFIX +
                ProjectConstants.BLANG_COMPILED_JAR_EXT);
    }

    public Path getTestExecutableBasePath() throws IOException {
        if (outputPath != null) {
            return outputPath.getParent();
        }

        return getTestBinPath();
    }

    /**
     * Returns the bin directory path.
     *
     * @return bin path
     */
    public Path getBinPath() throws IOException {
        binPath.createDirectories();
        return binPath;
    }

    public Path getTestBinPath() throws IOException {
        binPath.resolve(ProjectConstants.TEST_DIR_NAME).createDirectories();
        return binPath.resolve(ProjectConstants.TEST_DIR_NAME);
    }

    /**
     * Returns the caches directory path.
     *
     * @return caches path
     */
    public Path cachesPath() {
        return this.targetPath.resolve(ProjectConstants.CACHES_DIR_NAME);
    }

    /**
     * Returns the path of the target directory.
     *
     * @return target path
     */
    public Path path() {
        return this.targetPath;
    }

    /**
     * Clean any files that created from the build.
     */
    @Deprecated
    public void clean(boolean isModified, boolean cacheEnabled) {
        if (isModified || !cacheEnabled) {
            // Remove cache directory
            ProjectUtils.deleteDirectory(this.cache);
        }

        // Remove any generated bala
        ProjectUtils.deleteDirectory(this.balaCachePath);
        ProjectUtils.deleteDirectory(this.binPath);
        ProjectUtils.deleteDirectory(this.docPath);
        ProjectUtils.deleteDirectory(this.reportPath);
        ProjectUtils.deleteDirectory(this.resourcesPath);
    }

}
