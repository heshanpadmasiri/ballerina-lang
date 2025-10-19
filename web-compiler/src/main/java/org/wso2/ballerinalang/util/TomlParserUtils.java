/*
 *  Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
package org.wso2.ballerinalang.util;

import io.ballerina.fs.Path;
import io.ballerina.projects.Settings;
import org.ballerinalang.toml.model.Manifest;

/**
 * Toml parser util methods.
 * Note: TOML parsing is not supported in web-compiler. This is a stub
 * implementation.
 *
 * @since 0.982.0
 */
public final class TomlParserUtils {

    private TomlParserUtils() {
    }

    /**
     * Read Settings.toml to populate the configurations.
     *
     * @return {@link Settings} settings object
     */
    public static Settings readSettings() {
        throw new UnsupportedOperationException("TOML parsing is not supported in web-compiler");
    }

    /**
     * Read Ballerina.toml (Manifest) to populate the configurations.
     *
     * @param projectDirPath Project Directory Path
     * @return {@link Manifest} manifest object
     */
    public static Manifest getManifest(Path projectDirPath) {
        throw new UnsupportedOperationException("TOML parsing is not supported in web-compiler");
    }
}
