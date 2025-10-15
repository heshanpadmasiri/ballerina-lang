/*
 *  Copyright (c) 2025, WSO2 LLC. (http://www.wso2.com).
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

package io.ballerina.types.definition;

import io.ballerina.types.Core;
import io.ballerina.types.Env;
import io.ballerina.types.PredefinedType;
import io.ballerina.types.SemType;
import io.ballerina.types.SemTypes;

import java.util.List;
import java.util.Objects;

/**
 * Wrapper class for the semtype representing the {@code function-quals} of a function.
 *
 * @since 2201.12.0
 */
public final class FunctionQualifiers {

    private final SemType semType;

    public FunctionQualifiers(SemType semType) {
        assert semType != null;
        assert Core.isSubtypeSimple(semType, PredefinedType.LIST);
        this.semType = semType;
    }

    public static FunctionQualifiers from(Env env, boolean isolated, boolean transactional) {
        return new FunctionQualifiers(createSemType(env, isolated, transactional));
    }

    private static SemType createSemType(Env env, boolean isolated, boolean transactional) {
        ListDefinition ld = new ListDefinition();
        return ld.defineListTypeWrapped(env, List.of(
                        isolated ? SemTypes.booleanConst(true) : PredefinedType.BOOLEAN,
                        transactional ? PredefinedType.BOOLEAN : SemTypes.booleanConst(false)),
                2);
    }

    public SemType semType() {
        return semType;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) return true;
        if (obj == null || obj.getClass() != this.getClass()) return false;
        var that = (FunctionQualifiers) obj;
        return Objects.equals(this.semType, that.semType);
    }

    @Override
    public int hashCode() {
        return Objects.hash(semType);
    }

    @Override
    public String toString() {
        return "FunctionQualifiers[" +
                "semType=" + semType + ']';
    }

}
