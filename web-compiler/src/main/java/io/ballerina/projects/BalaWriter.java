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

package io.ballerina.projects;

import io.ballerina.fs.Path;
import io.ballerina.projects.internal.model.BalToolDescriptor;
import io.ballerina.projects.internal.model.CompilerPluginDescriptor;
import org.wso2.ballerinalang.util.RepoUtils;

import java.util.Optional;

import static io.ballerina.projects.util.ProjectUtils.getBalaName;

/**
 * {@code BalaWriter} writes a package to bala format.
 *
 * @since 2.0.0
 */
public abstract class BalaWriter {
    private static final String MODULES_ROOT = "modules";
    private static final String RESOURCE_DIR_NAME = "resources";
    private static final String BLANG_SOURCE_EXT = ".bal";
    protected static final String PLATFORM = "platform";
    protected static final String PATH = "path";
    private static final String MAIN_BAL = "main.bal";

    // Set the target as any for default bala.
    protected String target = "any";
    private static final String IMPLEMENTATION_VENDOR = "WSO2";
    private static final String BALLERINA_SHORT_VERSION = RepoUtils.getBallerinaShortVersion();
    private static final String BALLERINA_SPEC_VERSION = RepoUtils.getBallerinaSpecVersion();
    protected PackageContext packageContext;
    Optional<CompilerPluginDescriptor> compilerPluginToml;
    protected Optional<BalToolDescriptor> balToolToml;

    protected BalaWriter() {
    }

    /**
     * Write a package to a .bala and return the created .bala path.
     *
     * @param balaPath Directory where the .bala should be created.
     */
    public Path write(Path balaPath) {
        throw new RuntimeException();
    }

    // TODO when iterating and adding source files should create source files from Package sources

}
