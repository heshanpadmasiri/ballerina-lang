/*
 *  Copyright (c) 2023, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

import io.ballerina.projects.util.ProjectConstants;

/**
 * Represents the 'BalTool.toml' file in a package.
 *
 * @since 2201.6.0
 */
public class BalToolToml {
    private final TomlDocumentContext balToolTomlContext;
    private final Package packageInstance;

    private BalToolToml(TomlDocumentContext balToolTomlContext, Package packageInstance) {
        this.balToolTomlContext = balToolTomlContext;
        this.packageInstance = packageInstance;
    }

    public static BalToolToml from(TomlDocumentContext balToolTomlContext, Package pkg) {
        return new BalToolToml(balToolTomlContext, pkg);
    }

    TomlDocumentContext balToolTomlContext() {
        return this.balToolTomlContext;
    }

    public Package packageInstance() {
        return this.packageInstance;
    }

    public String name() {
        return ProjectConstants.BAL_TOOL_TOML;
    }

    /**
     * Returns an instance of the Document.Modifier.
     *
     * @return  module modifier
     */
    public BalToolToml.Modifier modify() {
        return new BalToolToml.Modifier(this);
    }

    /**
     * Inner class that handles Document modifications.
     */
    public static class Modifier {
        private final Package oldPackage;

        private Modifier(BalToolToml oldDocument) {
            this.oldPackage = oldDocument.packageInstance();
        }

        /**
         * Returns a new document with updated content.
         *
         * @return document with updated content
         */
        public BalToolToml apply() {
            throw new RuntimeException();
        }
    }
}
