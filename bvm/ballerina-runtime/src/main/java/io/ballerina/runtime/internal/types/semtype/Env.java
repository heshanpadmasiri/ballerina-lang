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

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Env {

    private Env instance;
    private final List<ListAtomicType> recListAtoms;
    private final Map<AtomicType, TypeAtom> atomTable = new HashMap<>();
    private volatile int recAtomCount = 0;

    public synchronized Env getInstance() {
        if (instance == null) {
            instance = new Env();
        }
        return instance;
    }

    private Env() {
        recListAtoms = new ArrayList<>();
    }

    // TODO: make synchronization more granular
    synchronized RecAtom recListAtom() {
        int nextIndex = recListAtoms.size();
        recListAtoms.add(null);
        return new RecAtom(nextIndex);
    }

    synchronized void setRecListAtom(RecAtom recAtom, ListAtomicType atomicType) {
        assert recListAtoms.get(recAtom.index()) == null;
        recListAtoms.set(recAtom.index(), atomicType);
        recAtomCount++;
    }

    Atom listAtom(ListAtomicType atomicType) {
        return typeAtom(atomicType);
    }

    private synchronized TypeAtom typeAtom(AtomicType atomicType) {
        TypeAtom typeAtom = atomTable.get(atomicType);
        if (typeAtom != null) {
            return typeAtom;
        }
        typeAtom = new TypeAtom(atomTable.size(), atomicType);
        atomTable.put(atomicType, typeAtom);
        return typeAtom;
    }
}
