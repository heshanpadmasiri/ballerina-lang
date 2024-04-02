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

import io.ballerina.runtime.api.Module;
import io.ballerina.runtime.api.PredefinedTypes;
import io.ballerina.runtime.api.types.Type;
import io.ballerina.runtime.internal.types.semtype.BSemType;

import static io.ballerina.runtime.internal.types.semtype.Core.union;

public class LazyTypeSupplier implements TypeSupplier {

    private BSemType type = null;
    private State state = State.UNRESOLVED;
    private TypeSupplier[] members;
    private final TypeSupplierUtils.Identifier identifier;

    public LazyTypeSupplier(TypeSupplierUtils.Identifier identifier) {
        this.identifier = identifier;
    }

    public LazyTypeSupplier() {
        this.identifier = null;
    }

    @Override
    public BSemType get() {
        return switch (state) {
            case RESOLVED -> type;
            case UNRESOLVED -> throw new IllegalStateException("Union type is not resolved");
            case RESOLVING, READY -> resolve(members);
        };
    }

    public void setMemberSuppliers(TypeSupplier... members) {
        this.members = members;
        this.state = State.READY;
    }

    private BSemType resolve(TypeSupplier... members) {
        BSemType resolvingType = (BSemType) PredefinedTypes.TYPE_NEVER;
        this.members = members;
        state = State.RESOLVING;
        Type[] orderedMembers = new Type[members.length];
        for (int i = 0; i < members.length; i++) {
            TypeSupplier member = members[i];
            BSemType memberType = member.get();
            resolvingType = union(resolvingType, memberType);
            orderedMembers[i] = memberType;
        }
        state = State.RESOLVED;
        this.members = null;
        type = resolvingType;
        // TODO: don't set the identifier if the name is empty
        if (identifier != null && !identifier.name().isEmpty()) {
            type.setIdentifiers(identifier.name(),
                    new Module(identifier.org(), identifier.pkgName(), identifier.version()));
        } else {
            type.setOrderedUnionMembers(orderedMembers);
        }
        return resolvingType;
    }

    private enum State {
        UNRESOLVED,
        RESOLVING,
        READY,
        RESOLVED
    }
}
