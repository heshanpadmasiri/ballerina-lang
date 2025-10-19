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

package io.ballerina.projects;

import io.ballerina.projects.util.ProjectConstants;

/**
 * Represents the 'Cloud.toml' file in a package.
 *
 * @since 2.0.0
 */
public class CloudToml {
    private final TomlDocumentContext cloudTomlContext;
    private final Package packageInstance;

    private CloudToml(Package aPackage, TomlDocumentContext cloudTomlContext) {
        this.packageInstance = aPackage;
        this.cloudTomlContext = cloudTomlContext;
    }

    public static CloudToml from(TomlDocumentContext cloudTomlContext, Package pkg) {
        return new CloudToml(pkg, cloudTomlContext);
    }

    TomlDocumentContext cloudTomlContext() {
        return cloudTomlContext;
    }

    public Package packageInstance() {
        return packageInstance;
    }


    public String name() {
        return ProjectConstants.CLOUD_TOML;
    }

    /**
     * Returns an instance of the Document.Modifier.
     *
     * @return  module modifier
     */
    public CloudToml.Modifier modify() {
        return new CloudToml.Modifier(this);
    }

    /**
     * Inner class that handles Document modifications.
     */
    public static class Modifier {
        private final Package oldPackage;

        private Modifier(CloudToml oldDocument) {
            this.oldPackage = oldDocument.packageInstance();
        }

        /**
         * Returns a new document with updated content.
         *
         * @return document with updated content
         */
        public CloudToml apply() {
            throw new RuntimeException();
        }
    }
}
