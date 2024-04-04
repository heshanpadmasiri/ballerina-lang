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

package io.ballerina.runtime.internal.types;

import io.ballerina.runtime.api.Module;
import io.ballerina.runtime.api.PredefinedTypes;
import io.ballerina.runtime.api.TypeBuilder;
import io.ballerina.runtime.api.types.Type;
import io.ballerina.runtime.api.types.TypeIdentifier;
import io.ballerina.runtime.api.types.TypeSupplier;
import io.ballerina.runtime.internal.types.semtype.BSemType;
import io.ballerina.runtime.internal.types.semtype.Core;

public class UnionTypeSupplier implements TypeSupplier {

    private State state = State.UNINITIALIZED;
    private Type type;
    private TypeSupplier[] memberTypeSuppliers;
    private final TypeIdentifier identifier;

    public UnionTypeSupplier() {
        this.identifier = null;
    }

    public UnionTypeSupplier(TypeIdentifier identifier) {
        this.identifier = identifier;
    }

    public void setMembers(TypeSupplier[] memberTypeSuppliers) {
        this.memberTypeSuppliers = memberTypeSuppliers;
        this.state = State.INITIALIZED;
    }

    @Override
    public Type get() {
        return switch (state) {
            case UNINITIALIZED -> {
                throw new IllegalStateException("Union type supplier is not initialized");
            }
            case RESOLVING, INITIALIZED -> resolve();
            case READY -> type;
        };
    }

    private Type resolve() {
        state = State.RESOLVING;
        Type[] memberTypes = new Type[memberTypeSuppliers.length];
        BSemType type = (BSemType) PredefinedTypes.TYPE_NEVER;
        for (int i = 0; i < memberTypeSuppliers.length; i++) {
            BSemType memberType = TypeBuilder.toSemType(memberTypeSuppliers[i].get());
            memberTypes[i] = memberType;
            type = Core.union(type, memberType);
        }
        if (identifier != null && !identifier.name().isEmpty()) {
            type.setIdentifiers(identifier.name(),
                    new Module(identifier.org(), identifier.pkgName(), identifier.version()));
        }
        type.setOrderedUnionMembers(memberTypes);
        this.type = type;
        this.state = State.READY;
        return type;
    }

    private enum State {
        UNINITIALIZED,
        INITIALIZED,
        RESOLVING,
        READY
    }
}
