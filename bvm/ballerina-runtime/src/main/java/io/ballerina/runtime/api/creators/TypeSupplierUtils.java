/*
 *  Copyright (c) 2024, WSO2 LLC. (http://www.wso2.org).
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
 *
 */

package io.ballerina.runtime.api.creators;

import io.ballerina.runtime.internal.types.BType;
import io.ballerina.runtime.internal.types.semtype.BSemType;
import io.ballerina.runtime.internal.types.semtype.SemTypeUtils;

public final class TypeSupplierUtils {

    private TypeSupplierUtils() {
    }

    public static TypeSupplier createIdentitySupplier(BSemType type) {
        return () -> type;
    }

    public static TypeSupplier from(Object value) {
        if (value instanceof TypeSupplier supplier) {
            return supplier;
        }
        if (value instanceof BSemType type) {
            return createIdentitySupplier(type);
        }
        if (value instanceof BType bType) {
            return from(SemTypeUtils.SemTypeBuilder.from(bType));
        }
        throw new IllegalArgumentException("Invalid type supplier value: " + value);
    }

    public record Identifier(String name, String org, String pkgName, String version) {

    }
}
