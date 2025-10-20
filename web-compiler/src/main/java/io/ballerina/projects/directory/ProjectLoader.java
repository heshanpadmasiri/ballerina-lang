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
package io.ballerina.projects.directory;

import io.ballerina.fs.Path;
import io.ballerina.projects.BuildOptions;
import io.ballerina.projects.Project;
import io.ballerina.projects.ProjectEnvironmentBuilder;
import io.ballerina.projects.ProjectException;
import io.ballerina.projects.ProjectLoadResult;

/**
 * Contains a set of utility methods to create a project.
 *
 * @since 2.0.0
 */
public final class ProjectLoader {

    private ProjectLoader() {
    }

    public static ProjectLoadResult load(Path path) {
        return load(path, BuildOptions.builder().build());
    }

    public static ProjectLoadResult load(Path path, BuildOptions buildOptions) {
        return load(path, ProjectEnvironmentBuilder.getDefaultBuilder(), buildOptions);
    }

    public static ProjectLoadResult load(Path path, ProjectEnvironmentBuilder projectEnvironmentBuilder) {
        return load(path, projectEnvironmentBuilder, BuildOptions.builder().build());
    }

    /**
     * Returns a project by deriving the type from the path provided.
     *
     * @param path path of a .bal file or a .bala file
     * @return Project instance
     * @throws ProjectException if an invalid path is provided
     */
    public static ProjectLoadResult load(Path path, ProjectEnvironmentBuilder projectEnvironmentBuilder,
                                      BuildOptions buildOptions) throws ProjectException {
        throw new RuntimeException("web");
    }

    /**
     * @deprecated Use {@link #load(Path, ProjectEnvironmentBuilder, BuildOptions)} instead.
     * Returns a project by deriving the type from the path provided.
     *
     * @param path path of a .bal file or a .bala file
     * @return Project instance
     * @throws ProjectException if an invalid path is provided
     */
    @Deprecated
    public static Project loadProject(Path path) {
        return loadProject(path, ProjectEnvironmentBuilder.getDefaultBuilder(), BuildOptions.builder().build());
    }

    /**
     * @deprecated Use {@link #load(Path, ProjectEnvironmentBuilder, BuildOptions)} instead.
     * Returns a project by deriving the type from the path provided.
     *
     * @param path path of a .bal file or a .bala file
     * @param buildOptions build options
     * @return Project instance
     * @throws ProjectException if an invalid path is provided
     */
    @Deprecated
    public static Project loadProject(Path path, BuildOptions buildOptions) {
        return loadProject(path, ProjectEnvironmentBuilder.getDefaultBuilder(), buildOptions);
    }

    /**
     * @deprecated Use {@link #load(Path, ProjectEnvironmentBuilder, BuildOptions)} instead.
     * Returns a project by deriving the type from the path provided.
     *
     * @param path path of a .bal file or a .bala file
     * @param projectEnvironmentBuilder project environment builder
     * @return Project instance
     * @throws ProjectException if an invalid path is provided
     */
    @Deprecated
    public static Project loadProject(Path path, ProjectEnvironmentBuilder projectEnvironmentBuilder) {
        return loadProject(path, projectEnvironmentBuilder, BuildOptions.builder().build());
    }

    /**
     * @deprecated Use {@link #load(Path, ProjectEnvironmentBuilder, BuildOptions)} instead.
     * Returns a project by deriving the type from the path provided.
     *
     * @param path path of a .bal file or a .bala file
     * @return Project instance
     * @throws ProjectException if an invalid path is provided
     */
    @Deprecated
    public static Project loadProject(Path path, ProjectEnvironmentBuilder projectEnvironmentBuilder,
                                      BuildOptions buildOptions) throws ProjectException {
        throw new RuntimeException();
    }
}
