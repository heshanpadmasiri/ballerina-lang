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
package io.ballerina.projects.buildtools;

import io.ballerina.fs.Path;
import io.ballerina.projects.Package;
import io.ballerina.projects.PackageManifest;
import io.ballerina.tools.diagnostics.Diagnostic;

import java.io.PrintStream;
import java.util.ArrayList;
import java.util.List;

import static io.ballerina.projects.util.ProjectConstants.GENERATED_MODULES_ROOT;

/**
 * Represents a build tool instance.
 *
 * @since 22201.9.0
 */
public class ToolContext {

    private final Package currentPackage;
    private final String toolId;
    private final String filePath;
    private final String targetModule;
    private final String type;
    private final PrintStream printStream;
    private final List<Diagnostic> diagnostics = new ArrayList<>();

    ToolContext(Package currentPackage, String toolId, String filePath,
                String targetModule, String type, PrintStream printStream) {
        this.currentPackage = currentPackage;
        this.toolId = toolId;
        this.filePath = filePath;
        this.targetModule = targetModule;
        this.type = type;
        this.printStream = printStream;
    }

    public static ToolContext from(PackageManifest.Tool tool, Package currentPackage, PrintStream printStream) {
        return new ToolContext(currentPackage, tool.id().value(),
                tool.filePath().value(), tool.targetModule().value(),
                tool.type().value(), printStream);
    }

    /**
     * Returns the tool id.
     *
     * @return the id of the tool configuration.
     */
    public String toolId() {
        return this.toolId;
    }

    /**
     * Returns the filepath.
     *
     * @return the filepath extracted from tool configuration.
     */
    public String filePath() {
        return this.filePath;
    }

    /**
     * Returns the target module.
     *
     * @return the target module extracted from tool configuration.
     */
    public String targetModule() {
        return targetModule;
    }

    /**
     * Returns the type of the tool.
     *
     * @return the tool type.
     */
    public String type() {
        return type;
    }

    /**
     * Returns the output path.
     *
     * @return the output path derived using the target module
     */
    public Path outputPath() {
        Path sourceRoot = currentPackage.project().sourceRoot();
        if (targetModule == null || targetModule.isEmpty()) {
            return sourceRoot.resolve(GENERATED_MODULES_ROOT);
        } else {
            return sourceRoot.resolve(GENERATED_MODULES_ROOT).resolve(targetModule);
        }
    }

    /**
     * Returns the current package instance.
     *
     * @return the current package instance.
     */
    public Package currentPackage() {
        return currentPackage;
    }

    /**
     * Returns the tool diagnostics list.
     *
     * @return a list of tool diagnostics.
     */
    public List<Diagnostic> diagnostics() {
        return diagnostics;
    }

    /**
     * Reports a diagnostic against the build tool executed.
     *
     * @param diagnostic the {@code Diagnostic} to be reported
     */
    public void reportDiagnostic(Diagnostic diagnostic) {
        diagnostics.add(diagnostic);
    }

    /**
     * Prints a message from the tool to the printStream.
     *
     * @param message message to be printed
     */
    public void println(String message) {
        printStream.printf("\t\t%s%n", message);
    }

    /**
     * Represents a single option Toml node in Ballerina.toml file.
     *
     * @since 2201.9.0
     */
    public static class Option {

        public Option() {
        }

        /**
         * Returns the value of the option.
         *
         * @return the option value.
         */
        public Object value() {
            throw new RuntimeException();
        }

    }
}
