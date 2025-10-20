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

import java.util.Objects;

/**
 * Represents a semantic version according to the semvar specification.
 *
 * @since 2.0.0
 */
public class SemanticVersion {

    private SemanticVersion() {

    }

    public static SemanticVersion from(String versionString) {
        throw new RuntimeException();
    }

    public int major() {
        throw new RuntimeException();
    }

    public int minor() {
        throw new RuntimeException();
    }

    public int patch() {
        throw new RuntimeException();
    }

    public String preReleasePart() {
        throw new RuntimeException();
    }

    public String buildMetadata() {
        throw new RuntimeException();
    }

    public boolean isStable() {
        throw new RuntimeException();
    }

    public boolean isPreReleaseVersion() {
        throw new RuntimeException();
    }

    public boolean isInitialVersion() {
        throw new RuntimeException();
    }

    public boolean greaterThan(SemanticVersion other) {
        throw new RuntimeException();
    }

    public boolean greaterThanOrEqualTo(SemanticVersion other) {
        throw new RuntimeException();
    }

    public boolean lessThan(SemanticVersion other) {
        throw new RuntimeException();
    }

    public boolean lessThanOrEqualTo(SemanticVersion other) {
        throw new RuntimeException();
    }

    @Override
    public boolean equals(Object other) {
        throw new RuntimeException();
    }

    @Override
    public String toString() {
        throw new RuntimeException();
    }

    @Override
    public int hashCode() {
        throw new RuntimeException();
    }

    public VersionCompatibilityResult compareTo(SemanticVersion other) {
        throw new RuntimeException();
    }

    public enum VersionCompatibilityResult {
        INCOMPATIBLE,
        EQUAL,
        LESS_THAN,
        GREATER_THAN
    }

}
