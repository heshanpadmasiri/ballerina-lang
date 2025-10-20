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
package io.ballerina.projects.util;

import io.ballerina.fs.Path;
import io.ballerina.projects.Project;
import io.ballerina.projects.ProjectException;
import org.wso2.ballerinalang.compiler.util.ProjectDirConstants;

/**
 * Consists of static methods that may be used to obtain {@link Project}
 * information using file paths.
 *
 * @since 2.0.0
 */
public final class ProjectPaths {

    public static final String PACKAGE_KEY = "package";

    private ProjectPaths() {
    }

    /**
     * Finds the root directory of a Ballerina package using the filepath provided.
     *
     * @param filepath ballerina file that belongs to a package
     * @return path to the package root directory
     * @throws ProjectException if the provided path is invalid or if it is a standalone ballerina file
     */
    public static Path packageRoot(Path filepath) throws ProjectException {
        throw new RuntimeException();
    }

    /**
     * Returns whether the provided path is a valid Ballerina source file.
     *
     * @param filepath Ballerina file path
     * @return true if the path is a Ballerina source file
     */
    public static boolean isBalFile(Path filepath) {
        return filepath.exists()
                && filepath.isRegularFile()
                && filepath.toString().endsWith(ProjectDirConstants.BLANG_SOURCE_EXT);
    }

}
