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
package io.ballerina.projects.internal.model;

import io.ballerina.projects.TomlDocument;
import io.ballerina.projects.internal.bala.CompilerPluginJson;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * {@code CompilerPluginDescriptor} Model for `Compiler-plugin.toml` file.
 * Note: TOML parsing is not supported in web-compiler. This is a stub
 * implementation.
 *
 * @since 2.0.0
 */
public class CompilerPluginDescriptor {

    private final Plugin plugin;
    private final List<Dependency> dependencies;

    private CompilerPluginDescriptor(Plugin plugin, List<Dependency> dependencies) {
        this.plugin = plugin;
        this.dependencies = dependencies;
    }

    public static CompilerPluginDescriptor from(TomlDocument tomlDocument) {
        throw new UnsupportedOperationException("TOML parsing is not supported in web-compiler");
    }

    public static CompilerPluginDescriptor from(CompilerPluginJson compilerPluginJson) {
        List<Dependency> dependencyList = new ArrayList<>();
        for (String path : compilerPluginJson.dependencyPaths()) {
            dependencyList.add(new Dependency(path));
        }
        return new CompilerPluginDescriptor(new Plugin(compilerPluginJson.pluginId(), compilerPluginJson.pluginClass()),
                                            dependencyList);
    }

    public Plugin plugin() {
        return plugin;
    }

    public List<Dependency> dependencies() {
        return dependencies;
    }

    public List<String> getCompilerPluginDependencies() {
        List<String> compilerPluginDependencies = new ArrayList<>();
        for (Dependency dependency : this.dependencies) {
            compilerPluginDependencies.add(dependency.getPath());
        }
        return compilerPluginDependencies;
    }

    /**
     * {@code Plugin} Model for plugin toml table of `Compiler-plugin.toml` file.
     */
    public static class Plugin {
        private String id;
        private String className;

        Plugin(String id, String className) {
            this.id = id;
            this.className = className;
        }

        public String getClassName() {
            return className;
        }

        public void setClassName(String className) {
            this.className = className;
        }

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }
    }

    /**
     * {@code Dependency} Model for dependency of `Compiler-plugin.toml` file.
     */
    public static class Dependency {
        private String path;

        Dependency(String path) {
            this.path = path;
        }

        public String getPath() {
            return path;
        }

        public void setPath(String path) {
            this.path = path;
        }
    }

}
