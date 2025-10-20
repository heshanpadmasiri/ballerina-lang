/*
 *  Copyright (c) 2023, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  WSO2 Inc. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */
package io.ballerina.projects;

import io.ballerina.projects.util.ProjectConstants;

import io.ballerina.fs.Path;

import static io.ballerina.projects.util.ProjectConstants.BAL_TOOLS_TOML;

/**
 * Represents the 'bal-tools.toml' file `.ballerina` repository.
 *
 * @since 2201.6.0
 */
public class BalToolsToml {
    private final Path balToolsTomlPath;
    private TomlDocumentContext balToolsTomlContext;

    private BalToolsToml(Path balToolsTomlPath) {
        String content = read(balToolsTomlPath);
        this.balToolsTomlContext = TomlDocumentContext.from(TomlDocument.from(BAL_TOOLS_TOML, content));
        this.balToolsTomlPath = balToolsTomlPath;
    }

    public static BalToolsToml from(Path balToolsTomlPath) {
        return new BalToolsToml(balToolsTomlPath);
    }

    private static String read(Path balToolsTomlPath) {
        throw new RuntimeException();
    }

    public String name() {
        return ProjectConstants.BAL_TOOLS_TOML;
    }
    public TomlDocument tomlDocument() {
        return this.balToolsTomlContext.tomlDocument();
    }

    public Path path() {
        return this.balToolsTomlPath;
    }

    public void modify(BalToolsManifest balToolsManifest) {
        throw new RuntimeException();
    }

}
