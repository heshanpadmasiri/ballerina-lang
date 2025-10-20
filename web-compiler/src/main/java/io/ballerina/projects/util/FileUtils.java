/*
 * Copyright (c) 2020, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
package io.ballerina.projects.util;

import io.ballerina.fs.Path;

/**
 * Utilities related to files.
 *
 * @since 2.0.0
 */
public final class FileUtils {

    private FileUtils() {
    }

    /**
     * Get the name of the without the extension.
     *
     * @param filePath Path of the file.
     * @return File name without extension.
     */
    public static String getFileNameWithoutExtension(String filePath) {
        throw new RuntimeException();
    }

    /**
     * Get last modified timestamp of a ballerina project.
     *
     * @param projectRoot project root path
     * @return last modified time of the ballerina project
     */
    public static long lastModifiedTimeOfBalProject(Path projectRoot) {
        throw new RuntimeException();
    }

    /**
     * Add deprecated meta file.
     *
     * @param metaFilePath deprecated message meta file path
     * @param message deprecated message
     */
    public static void addDeprecatedMetaFile(Path metaFilePath, String message) {
        throw new RuntimeException();
    }

    /**
     * Delete deprecated meta file.
     *
     * @param metaFilePath deprecated message meta file path
     */
    public static void deleteDeprecatedMetaFile(Path metaFilePath) {
        throw new RuntimeException();
    }

}
