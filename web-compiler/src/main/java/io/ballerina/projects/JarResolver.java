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

import io.ballerina.projects.internal.DefaultDiagnosticResult;
import io.ballerina.tools.diagnostics.Diagnostic;

import java.util.ArrayList;
import java.util.List;

// TODO move this class to a separate Java package. e.g. io.ballerina.projects.platform.jballerina
//    todo that, we would have to move PackageContext class into an internal package.

/**
 * This class works closely with JBallerinaBackend to provide various codeGenerated jars
 * and class loaders required run Ballerina programs.
 *
 * @since 2.0.0
 */
public class JarResolver {
    private final JBallerinaBackend jBalBackend;
    private final PackageResolution pkgResolution;
    private final PackageContext rootPackageContext;
    private final List<Diagnostic> diagnosticList;
    private DiagnosticResult diagnosticResult;
    private final List<PlatformLibrary> providedPlatformLibs;

    JarResolver(JBallerinaBackend jBalBackend, PackageResolution pkgResolution) {
        this.jBalBackend = jBalBackend;
        this.pkgResolution = pkgResolution;
        this.rootPackageContext = pkgResolution.packageContext();
        this.diagnosticList = new ArrayList<>();
        this.providedPlatformLibs = new ArrayList<>();
    }

    DiagnosticResult diagnosticResult() {
        if (this.diagnosticResult == null) {
            this.diagnosticResult = new DefaultDiagnosticResult(this.diagnosticList);
        }
        return diagnosticResult;
    }

}
