// Copyright (c) 2024 WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

package io.ballerina.projects;

import java.util.HashSet;
import java.util.List;
import java.util.Objects;

import io.ballerina.fs.Path;

/**
 * Record for storing arguments to use in JBallerinaBackend's emit of TEST.
 *
 * @since 2201.9.0
 */

/**
 * Record for storing arguments to use in JBallerinaBackend's emit of TEST.
 */
public final class TestEmitArgs {

    private final JBallerinaBackend.OutputType outputType;
    private final Path filePath;
    private final HashSet<JarLibrary> jarDependencies;
    private final Path testSuiteJsonPath;
    private final String jsonCopyPath;
    private final List<String> excludedClasses;
    private final String classPathTextCopyPath;

    /**
     * @param outputType            Output type to indicate the type of the emitting output
     * @param filePath              File path to specify where the output should be emitted
     * @param jarDependencies       Jar dependencies required for emitting the output
     * @param testSuiteJsonPath     Path to the test suite json that should be packed inside the output
     * @param jsonCopyPath          The path inside the output where the test suite json should be copied
     * @param excludedClasses       List of excluded classes
     * @param classPathTextCopyPath Path inside the output where the class path text should be copied
     */
    public TestEmitArgs(JBallerinaBackend.OutputType outputType, Path filePath, HashSet<JarLibrary> jarDependencies,
                        Path testSuiteJsonPath, String jsonCopyPath, List<String> excludedClasses,
                        String classPathTextCopyPath) {
        this.outputType = outputType;
        this.filePath = filePath;
        this.jarDependencies = jarDependencies;
        this.testSuiteJsonPath = testSuiteJsonPath;
        this.jsonCopyPath = jsonCopyPath;
        this.excludedClasses = excludedClasses;
        this.classPathTextCopyPath = classPathTextCopyPath;
    }

    public JBallerinaBackend.OutputType outputType() {
        return outputType;
    }

    public Path filePath() {
        return filePath;
    }

    public HashSet<JarLibrary> jarDependencies() {
        return jarDependencies;
    }

    public Path testSuiteJsonPath() {
        return testSuiteJsonPath;
    }

    public String jsonCopyPath() {
        return jsonCopyPath;
    }

    public List<String> excludedClasses() {
        return excludedClasses;
    }

    public String classPathTextCopyPath() {
        return classPathTextCopyPath;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) return true;
        if (obj == null || obj.getClass() != this.getClass()) return false;
        var that = (TestEmitArgs) obj;
        return Objects.equals(this.outputType, that.outputType) &&
                Objects.equals(this.filePath, that.filePath) &&
                Objects.equals(this.jarDependencies, that.jarDependencies) &&
                Objects.equals(this.testSuiteJsonPath, that.testSuiteJsonPath) &&
                Objects.equals(this.jsonCopyPath, that.jsonCopyPath) &&
                Objects.equals(this.excludedClasses, that.excludedClasses) &&
                Objects.equals(this.classPathTextCopyPath, that.classPathTextCopyPath);
    }

    @Override
    public int hashCode() {
        return Objects.hash(outputType, filePath, jarDependencies, testSuiteJsonPath, jsonCopyPath, excludedClasses,
                classPathTextCopyPath);
    }

    @Override
    public String toString() {
        return "TestEmitArgs[" +
                "outputType=" + outputType + ", " +
                "filePath=" + filePath + ", " +
                "jarDependencies=" + jarDependencies + ", " +
                "testSuiteJsonPath=" + testSuiteJsonPath + ", " +
                "jsonCopyPath=" + jsonCopyPath + ", " +
                "excludedClasses=" + excludedClasses + ", " +
                "classPathTextCopyPath=" + classPathTextCopyPath + ']';
    }

}
