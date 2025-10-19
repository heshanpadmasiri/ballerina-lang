/*
 *  Copyright (c) 2023, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  WSO2 Inc. licenses this file to you under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
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

import io.ballerina.projects.BalToolsManifest;
import io.ballerina.projects.BalToolsToml;
import io.ballerina.projects.PackageVersion;
import io.ballerina.projects.TomlDocument;

import java.util.HashMap;
import java.util.Map;

/**
 * {@code BalToolsManifestBuilder} processes the bal-tools toml file parsed
 * and populate a {@link BalToolsManifest}.
 * Note: TOML parsing is not supported in web-compiler. This is a stub
 * implementation.
 *
 * @since 2201.6.0
 */
public class BalToolsManifestBuilder {
    private final Map<String, OldTool> oldTools;

    private BalToolsManifestBuilder(TomlDocument balToolsToml) {
        oldTools = new HashMap<>();
    }

    public static BalToolsManifestBuilder from(TomlDocument balToolsToml) {
        return new BalToolsManifestBuilder(balToolsToml);
    }

    public static BalToolsManifestBuilder from(BalToolsToml balToolsToml) {
        throw new UnsupportedOperationException("TOML parsing is not supported in web-compiler");
    }

    public BalToolsManifest getBalToolsManifest() {
        throw new UnsupportedOperationException("TOML parsing is not supported in web-compiler");
    }

    public Map<String, OldTool> getOldTools() {
        return oldTools;
    }

    public BalToolsManifestBuilder removeTool(String id) {
        throw new UnsupportedOperationException("TOML parsing is not supported in web-compiler");
    }

    public BalToolsManifestBuilder addTool(String id, String org, String name, PackageVersion version,
            boolean isActive) {
        throw new UnsupportedOperationException("TOML parsing is not supported in web-compiler");
    }

    public BalToolsManifestBuilder updateTool(String id, String org, String name, PackageVersion version,
            boolean isActive) {
        throw new UnsupportedOperationException("TOML parsing is not supported in web-compiler");
    }

    /**
     * Represents an old tool entry.
     */
    public static class OldTool {
        private final String id;
        private final String org;
        private final String name;
        private final PackageVersion version;

        public OldTool(String id, String org, String name, PackageVersion version) {
            this.id = id;
            this.org = org;
            this.name = name;
            this.version = version;
        }

        public String id() {
            return id;
        }

        public String org() {
            return org;
        }

        public String name() {
            return name;
        }

        public PackageVersion version() {
            return version;
        }
    }
}
