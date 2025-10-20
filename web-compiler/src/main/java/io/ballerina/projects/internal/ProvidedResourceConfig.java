/*
 *  Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

package io.ballerina.projects.internal;

import io.ballerina.projects.DocumentId;
import io.ballerina.projects.ResourceConfig;
import io.ballerina.projects.util.ProjectConstants;
import io.ballerina.tools.envutils.PropertyConstants;

import io.ballerina.fs.Path;
import java.util.Locale;

/**
 * {@code Resource} contains necessary configuration elements required to create an instance of a {@code Resource}.
 *
 * This config is used to load the resources provided in the module resource directories in the package
 * when loading the project.
 *
 * This is internal and not expected to expose to Project API users.
 *
 * @since 2.0.0
 */
public class ProvidedResourceConfig extends ResourceConfig {

    public static final String OS = PropertyConstants.getProperty("os.name").toLowerCase(Locale.getDefault());

    private ProvidedResourceConfig(DocumentId documentId, Path path, String name, byte[] content) {
        super(documentId, path, name, content);
    }

    public static ProvidedResourceConfig from(DocumentId documentId, Path resource, Path packagePath) {
        throw new RuntimeException();
    }

    public static String convertWinPathToUnixFormat(String path) {
        if (OS.contains("win")) {
            path = path.replace("\\", "/");
        }
        return path;
    }

}
