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

package io.ballerina.runtime.internal.types.semtype;

import static io.ballerina.runtime.internal.types.semtype.BddUtils.bddAtom;
import static io.ballerina.runtime.internal.types.semtype.SemTypeUtils.BasicTypeCodes.BT_LIST;
import static io.ballerina.runtime.internal.types.semtype.SemTypeUtils.SemTypeBuilder.basicSubtype;

public class ListDefinition implements Definition {

    private RecAtom recAtom = null;
    private BSemType semType = null;

    @Override
    public BSemType getSemType(Env env) {
        if (semType != null) {
            return semType;
        }
        recAtom = env.recListAtom();
        return createSemType(recAtom);
    }

    public BSemType define(Env env, FixedLengthArray members, BSemType rest) {
        // We don't need to normalize the members here, since we enforce it being normalized at construction
        ListAtomicType atomicType = new ListAtomicType(members, rest);
        Atom atom;
        if (recAtom != null) {
            atom = recAtom;
            env.setRecListAtom(recAtom, atomicType);
            // FIXME:
//        } else if (members.fixedLength() == 0 && rest == CELL_SEMTYPE_INNER) {
//            self.semType = LIST;
//            return LIST;
        } else {
            atom = env.listAtom(atomicType);
        }
        return createSemType(atom);
    }

    private BSemType createSemType(Atom atom) {
        BddNode bdd = bddAtom(atom);
        semType = basicSubtype(BT_LIST, bdd);
        return semType;
    }
}
