/*
 *  Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
package org.wso2.ballerinalang.compiler;

import org.ballerinalang.repository.CompiledPackage;
import org.wso2.ballerinalang.compiler.util.ProjectDirConstants;
import org.wso2.ballerinalang.util.RepoUtils;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintStream;

import io.ballerina.fs.Path;

import java.util.ArrayList;
import java.util.List;

/**
 * File system based project directory implementation.
 *
 * @since 0.965.0
 */
public class FileSystemProjectDirectory extends FileSystemProgramDirectory {
    private final Path projectDirPath;
    private final Path sourceDirPath;
    private List<String> packageNames;
    protected boolean scanned = false;
    private static final PrintStream OUT_STREAM = System.out;

    public FileSystemProjectDirectory(Path projectDirPath) {
        super(projectDirPath);
        // TODO This path expect absolute path. This is validated by the SourceDirectoryManager
        this.projectDirPath = projectDirPath;
        this.sourceDirPath = projectDirPath.resolve(ProjectDirConstants.SOURCE_DIR_NAME);
    }

    @Override
    public boolean canHandle(Path dirPath) {
        return RepoUtils.isBallerinaProject(dirPath);
    }

    @Override
    public Path getPath() {
        return this.projectDirPath;
    }

    @Override
    public List<String> getSourceFileNames() {
        return new ArrayList<>(0);
    }

    @Override
    public List<String> getSourcePackageNames() {
        throw new RuntimeException();
    }

    @Override
    public InputStream getManifestContent() {
        throw new RuntimeException();
    }

    @Override
    public InputStream getLockFileContent() {
        throw new RuntimeException();
    }

    @Override
    public Path saveCompiledProgram(InputStream source, String fileName) {
        throw new RuntimeException();
    }

    @Override
    public void saveCompiledPackage(CompiledPackage compiledPackage,
                                    Path dirPath,
                                    String fileName) throws IOException {

        throw new RuntimeException();
    }

    // private methods

    private void createDirectory(Path targetPath) {
        throw new RuntimeException();
    }

    private Path ensureAndGetTargetDirPath() {
        Path targetPath = this.projectDirPath.resolve(ProjectDirConstants.TARGET_DIR_NAME);
        if (!targetPath.exists()) {
            createDirectory(targetPath);
        }

        return targetPath;
    }

}
