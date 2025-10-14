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
package io.ballerina.tools.diagnostics;

import io.ballerina.tools.diagnostics.Diagnostic;
import io.ballerina.tools.diagnostics.DiagnosticInfo;
import io.ballerina.tools.diagnostics.DiagnosticProperty;
import io.ballerina.tools.diagnostics.Location;
import io.ballerina.tools.text.LinePosition;
import io.ballerina.tools.text.LineRange;

import java.util.List;

/**
 * An internal implementation of the {@code Diagnostic} class that is used by the {@code DiagnosticFactory}
 * to create diagnostics.
 *
 * @since 2.0.0
 */
class DefaultDiagnostic extends Diagnostic {
    private final DiagnosticInfo diagnosticInfo;
    private final Location location;
    private final List<DiagnosticProperty<?>> properties;
    private final String message;

    DefaultDiagnostic(DiagnosticInfo diagnosticInfo,
                      Location location,
                      List<DiagnosticProperty<?>> properties,
                      Object[] args) {
        this.diagnosticInfo = diagnosticInfo;
        this.location = location;
        this.properties = properties;
        this.message = formatMessage(diagnosticInfo.messageFormat(), args);
    }

    @Override
    public Location location() {
        return location;
    }

    @Override
    public DiagnosticInfo diagnosticInfo() {
        return diagnosticInfo;
    }

    @Override
    public String message() {
        return message;
    }

    @Override
    public List<DiagnosticProperty<?>> properties() {
        return properties;
    }

    @Override
    public String toString() {
        LineRange lineRange = this.location.lineRange();
        String filePath = lineRange.fileName();
        LineRange oneBasedLineRange = LineRange.from(
                filePath,
                LinePosition.from(lineRange.startLine().line() + 1, lineRange.startLine().offset() + 1),
                LinePosition.from(lineRange.endLine().line() + 1, lineRange.endLine().offset() + 1));

        return diagnosticInfo().severity().toString() + " ["
                + filePath + ":" + oneBasedLineRange + "] " + message();
    }

    /**
     * Formats a message using StringBuilder iteration for J2CL compatibility.
     * Replaces MessageFormat patterns ({0}, {1}, etc.) with corresponding arguments.
     *
     * @param pattern the message pattern
     * @param args the arguments to substitute
     * @return the formatted message
     */
    private static String formatMessage(String pattern, Object[] args) {
        if (pattern == null || args == null || args.length == 0) {
            return pattern;
        }

        StringBuilder result = new StringBuilder();
        int patternLength = pattern.length();

        for (int i = 0; i < patternLength; i++) {
            char currentChar = pattern.charAt(i);

            if (currentChar == '{' && i + 1 < patternLength) {
                // Look for the closing brace to find the placeholder
                int closingBraceIndex = pattern.indexOf('}', i + 1);
                if (closingBraceIndex != -1) {
                    // Extract the number between braces
                    String numberStr = pattern.substring(i + 1, closingBraceIndex);
                    try {
                        int argIndex = Integer.parseInt(numberStr);
                        if (argIndex >= 0 && argIndex < args.length) {
                            // Replace with the argument
                            result.append(args[argIndex] != null ? args[argIndex].toString() : "null");
                            i = closingBraceIndex; // Skip to after the closing brace
                            continue;
                        }
                    } catch (NumberFormatException e) {
                        // Not a valid number, treat as regular text
                    }
                }
            }

            // Add the current character to result
            result.append(currentChar);
        }

        return result.toString();
    }
}
