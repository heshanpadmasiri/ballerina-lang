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
package io.ballerina.projects.internal;

import io.ballerina.fs.Path;
import io.ballerina.projects.ModuleDescriptor;
import io.ballerina.projects.Project;
import io.ballerina.projects.ProjectKind;
import io.ballerina.tools.diagnostics.Diagnostic;
import io.ballerina.tools.diagnostics.DiagnosticFactory;
import io.ballerina.tools.diagnostics.DiagnosticInfo;
import io.ballerina.tools.diagnostics.DiagnosticProperty;
import io.ballerina.tools.diagnostics.Location;
import io.ballerina.tools.text.LinePosition;
import io.ballerina.tools.text.LineRange;
import io.ballerina.tools.text.TextRange;

import java.util.List;
import java.util.Optional;

/**
 * Decorator for diagnostics exposed via the Project API.
 * All diagnostics in a package will be enriched with this before exposing via the project API classes.
 *
 * @since 2.0.0
 */
public class PackageDiagnostic extends Diagnostic {
    protected Diagnostic diagnostic;
    protected Location location;
    protected Project project;
    protected ModuleDescriptor moduleDescriptor;

    public PackageDiagnostic(DiagnosticInfo diagnosticInfo, Location location) {
        this.diagnostic = DiagnosticFactory.createDiagnostic(diagnosticInfo, location);
        this.location = location;
    }

    public PackageDiagnostic(DiagnosticInfo diagnosticInfo, String filePath) {
        this(diagnosticInfo, new NullLocation(filePath));
    }

    public PackageDiagnostic(Diagnostic diagnostic, ModuleDescriptor moduleDescriptor, Project project) {
        throw new RuntimeException();
    }

    @Override
    public Location location() {
        return this.location;
    }

    @Override
    public DiagnosticInfo diagnosticInfo() {
        return this.diagnostic.diagnosticInfo();
    }

    @Override
    public String message() {
        return this.diagnostic.message();
    }

    @Override
    public List<DiagnosticProperty<?>> properties() {
        return this.diagnostic.properties();
    }

    @Override
    public String toString() {
        String filePath = this.location.lineRange().filePath();
        // add package info if it is a dependency
        if (this.project != null && ProjectKind.BALA_PROJECT.equals(this.project.kind())) {
            filePath = moduleDescriptor.org() + "/" +
                    moduleDescriptor.name().toString() + "/" +
                    moduleDescriptor.version() + "::" + Optional.of(Path.of(filePath).getFileName()).get();
        }
        // Handle null location based diagnostics
        if (this.diagnostic.location() instanceof NullLocation) {
            return diagnosticInfo().severity().toString() + " ["
                    + filePath + "] " + this.diagnosticInfo().messageFormat();
        }
        LineRange lineRange = diagnostic.location().lineRange();
        LineRange oneBasedLineRange = LineRange.from(
                filePath,
                LinePosition.from(lineRange.startLine().line() + 1, lineRange.startLine().offset() + 1),
                LinePosition.from(lineRange.endLine().line() + 1, lineRange.endLine().offset() + 1));

        return diagnosticInfo().severity().toString() + " ["
                + filePath + ":" + oneBasedLineRange + "] " + message();
    }

    private static class NullLocation implements Location {
        private final String filepath;

        NullLocation(String filePath) {
            this.filepath = filePath;
        }

        @Override
        public LineRange lineRange() {
            LinePosition from = LinePosition.from(0, 0);
            return LineRange.from(filepath, from, from);
        }

        @Override
        public TextRange textRange() {
            return TextRange.from(0, 0);
        }
    }
}
