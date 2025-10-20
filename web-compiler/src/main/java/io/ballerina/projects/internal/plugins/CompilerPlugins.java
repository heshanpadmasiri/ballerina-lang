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
package io.ballerina.projects.internal.plugins;

import java.util.ArrayList;
import java.util.List;

import io.ballerina.fs.Path;
import io.ballerina.projects.plugins.CompilerPlugin;

/**
 * This class contains a set of utility method related to compiler plugin implementation.
 *
 * @since 2.0.0
 */
public final class CompilerPlugins {

    static List<CompilerPlugin> builtInPlugins = new ArrayList<>();

    private CompilerPlugins() {
    }

    public static List<CompilerPlugin> getBuiltInPlugins() {
        return builtInPlugins;
    }

    public static CompilerPlugin loadCompilerPlugin(String pluginClassName, List<Path> jarDependencyPaths) {
        throw new RuntimeException();
    }

}
