/*
 *  Copyright (c) 2024, WSO2 LLC. (http://www.wso2.com).
 *
 *  WSO2 LLC. licenses this file to you under the Apache License,
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
package org.wso2.ballerinalang.compiler.semantics.model.types;

import io.ballerina.types.SemType;

import java.util.Objects;
import java.util.Optional;

/**
 * Represents a sem-type and its user-specified string representation.
 *
 */
public final class SemNamedType {

    private final SemType semType;
    private final Optional<String> optName;

    /**
     * @param semType Sem-type representation of a type
     * @param optName User-specified string representation for the type, if available
     */
    public SemNamedType(SemType semType, Optional<String> optName) {
        this.semType = semType;
        this.optName = optName;
    }

    public SemType semType() {
        return semType;
    }

    public Optional<String> optName() {
        return optName;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) return true;
        if (obj == null || obj.getClass() != this.getClass()) return false;
        var that = (SemNamedType) obj;
        return Objects.equals(this.semType, that.semType) &&
                Objects.equals(this.optName, that.optName);
    }

    @Override
    public int hashCode() {
        return Objects.hash(semType, optName);
    }

    @Override
    public String toString() {
        return "SemNamedType[" +
                "semType=" + semType + ", " +
                "optName=" + optName + ']';
    }

}
