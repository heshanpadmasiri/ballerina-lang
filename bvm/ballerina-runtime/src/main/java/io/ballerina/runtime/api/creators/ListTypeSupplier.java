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
 */

package io.ballerina.runtime.api.creators;

import io.ballerina.runtime.internal.types.semtype.BSemType;
import io.ballerina.runtime.internal.types.semtype.Env;
import io.ballerina.runtime.internal.types.semtype.FixedLengthArray;
import io.ballerina.runtime.internal.types.semtype.ListDefinition;

public class ListTypeSupplier implements TypeSupplier {

    private ListDefinition ld = null;
    private final FixLengthArraySupplier fixLengthArraySupplier;
    private final TypeSupplier restTypeSupplier;

    public ListTypeSupplier(FixLengthArraySupplier fixedLengthSupplier, TypeSupplier restTypeSupplier) {
        this.fixLengthArraySupplier = fixedLengthSupplier;
        this.restTypeSupplier = restTypeSupplier;
    }

    @Override
    public BSemType get() {
        Env env = Env.getInstance();
        if (ld != null) {
            return ld.getSemType(env);
        }
        ld = new ListDefinition();
        FixedLengthArray members = fixLengthArraySupplier.get();
        BSemType rest = restTypeSupplier.get();
        return ld.define(env, members, rest);
        // TODO: remove the fixedLengthSupplier and restTypeSupplier
    }
}
