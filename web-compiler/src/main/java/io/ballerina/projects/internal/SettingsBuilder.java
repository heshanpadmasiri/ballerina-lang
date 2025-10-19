/*
 *  Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

import io.ballerina.projects.DiagnosticResult;
import io.ballerina.projects.Settings;
import io.ballerina.projects.TomlDocument;

/**
 * {@code SettingsBuilder} processes the settings toml file parsed and populate
 * a {@link Settings}.
 * Note: TOML parsing is not supported in web-compiler. This is a stub
 * implementation.
 *
 * @since 0.964
 */
public class SettingsBuilder {

    private SettingsBuilder(TomlDocument settingsToml) {
        // Stub implementation - fields not needed
    }

    public static SettingsBuilder from(TomlDocument settingsToml) {
        return new SettingsBuilder(settingsToml);
    }

    public Settings settings() {
        return Settings.from();
    }

    public DiagnosticResult diagnostics() {
        throw new UnsupportedOperationException("TOML parsing is not supported in web-compiler");
    }

    public String getErrorMessage() {
        throw new UnsupportedOperationException("TOML parsing is not supported in web-compiler");
    }
}
