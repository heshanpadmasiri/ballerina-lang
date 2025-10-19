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
package org.wso2.ballerinalang.compiler.util;

import org.ballerinalang.compiler.BLangCompilerException;
import org.ballerinalang.model.elements.PackageID;
import org.wso2.ballerinalang.compiler.tree.BLangPackage;

import java.io.IOException;

import io.ballerina.fs.Path;

import java.util.stream.Stream;

import static org.wso2.ballerinalang.compiler.util.ProjectDirConstants.BLANG_SOURCE_EXT;

/**
 * This class contains a set of file manipulation utility methods.
 *
 * @since 0.970.0
 */
public final class FileUtils {

    private FileUtils() {
    }

    public static void deleteFile(Path filePath) throws IOException {
        filePath.deleteIfExists();
    }

    /**
     * Generates the bala/zip of the package.
     *
     * @param bLangPackage bLangPackage node
     * @param projectPath  project path
     * @param paths        paths of bal files inside the package
     */
    static void generateBala(BLangPackage bLangPackage, String projectPath, Stream<Path> paths) {
        PackageID packageID = bLangPackage.packageID;
        Path destPath = Path.of(projectPath, ProjectDirConstants.DOT_BALLERINA_DIR_NAME,
                                  ProjectDirConstants.CACHES_DIR_NAME,
                                  ProjectDirConstants.BALLERINA_CENTRAL_DIR_NAME,
                                  packageID.getOrgName().getValue(),
                                  packageID.getName().getValue(),
                                  packageID.getPackageVersion().getValue());
        if (!destPath.exists()) {
            destPath.createDirectories();
        }
        String fileName = packageID.getName() + ".zip";
        Path balaDirPath = destPath.resolve(fileName);
        deleteBala(balaDirPath);
        createArchive(paths, balaDirPath);
    }

    /**
     * Delete the bala if it exist before creating a new bala.
     *
     * @param balaDirPath path of the bala
     */
    private static void deleteBala(Path balaDirPath) {
        try {
            balaDirPath.deleteIfExists();
        } catch (IOException ignore) {
            throw new BLangCompilerException("error deleting artifact : " + balaDirPath);
        }
    }

    /**
     * Create archive when creating the bala.
     *
     * @param filesToBeArchived files to be archived
     * @param outDirPath        output archive file path
     */
    private static void createArchive(Stream<Path> filesToBeArchived, Path outDirPath) {
        throw new RuntimeException();
    }

    public static String cleanupFileExtension(String targetFileName) {
        String updatedFileName = targetFileName;
        if (updatedFileName == null || updatedFileName.isEmpty()) {
            throw new IllegalArgumentException("invalid target file name");
        }

        if (updatedFileName.endsWith(BLANG_SOURCE_EXT)) {
            updatedFileName = updatedFileName.substring(0, updatedFileName.length() - BLANG_SOURCE_EXT.length());
        }
        return updatedFileName;
    }
}
