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

package io.ballerina.projects.internal;


import io.ballerina.fs.Path;
import io.ballerina.projects.DependencyGraph;
import io.ballerina.projects.ModuleDescriptor;
import io.ballerina.projects.PackageDescriptor;
import io.ballerina.projects.internal.bala.BalaJson;
import io.ballerina.projects.internal.model.PackageJson;

import java.nio.charset.Charset;
import java.util.List;
import java.util.Map;

import static io.ballerina.projects.DependencyGraph.DependencyGraphBuilder.getBuilder;

/**
 * Contains a set of utility methods that create an in-memory representation of a Ballerina project using a bala.
 *
 * @since 2.0.0
 */
public final class BalaFiles {


    // TODO change class name to utils
    private BalaFiles() {
    }

    public static DocumentData loadDocument(Path documentFilePath) {
        if (documentFilePath.notExists()) {
            return null;
        } else {
            return ProjectFiles.getDocumentData(documentFilePath, false, Charset.defaultCharset());
        }
    }

    public static DependencyGraphResult createPackageDependencyGraph(Path balaPath) {
        throw new RuntimeException();
    }

    /**
     * {@code DependencyGraphResult} contains package and module dependency graphs.
     */
    public static class DependencyGraphResult {
        private final DependencyGraph<PackageDescriptor> packageDependencyGraph;
        private final Map<ModuleDescriptor, List<ModuleDescriptor>> moduleDependencies;

        DependencyGraphResult(DependencyGraph<PackageDescriptor> packageDependencyGraph,
                              Map<ModuleDescriptor, List<ModuleDescriptor>> moduleDependencies) {
            this.packageDependencyGraph = packageDependencyGraph;
            this.moduleDependencies = moduleDependencies;
        }

        public DependencyGraph<PackageDescriptor> packageDependencyGraph() {
            return packageDependencyGraph;
        }

        public Map<ModuleDescriptor, List<ModuleDescriptor>> moduleDependencies() {
            return moduleDependencies;
        }
    }

    /**
     * Returns a PacakgeJson instance from the provided bala.
     *
     * @param balaPath path to .bala file or extracted directory
     * @return a PackageJson instance
     */
    public static PackageJson readPackageJson(Path balaPath) {
        throw new RuntimeException();
    }

    public static BalaJson readBalaJson(Path balaPath) {

        throw new RuntimeException();

    }

}
