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
 *
 */

package io.ballerina.runtime.internal.types.semtype;

import static io.ballerina.runtime.internal.types.semtype.BddUtils.bddAtom;
import static io.ballerina.runtime.internal.types.semtype.BddUtils.bddSubtypeComplement;
import static io.ballerina.runtime.internal.types.semtype.BddUtils.bddSubtypeDiff;
import static io.ballerina.runtime.internal.types.semtype.BddUtils.bddSubtypeIntersect;
import static io.ballerina.runtime.internal.types.semtype.BddUtils.bddSubtypeUnion;
import static io.ballerina.runtime.internal.types.semtype.SemTypeUtils.ATOM_CELL_NEVER;
import static io.ballerina.runtime.internal.types.semtype.SemTypeUtils.ATOM_CELL_VAL;

public class CellSubType implements SubType {

    private final SubTypeData data;

    public CellSubType(SubTypeData data) {
        this.data = data;
    }

    @Override
    public SubType union(SubType other) {
        CellSubType otherCell = (CellSubType) other;
        return new CellSubType(cellSubtypeDataEnsureProper(bddSubtypeUnion(data, otherCell.data)));
    }

    @Override
    public SubType intersect(SubType other) {
        CellSubType otherCell = (CellSubType) other;
        return new CellSubType(cellSubtypeDataEnsureProper(bddSubtypeIntersect(data, otherCell.data)));
    }

    @Override
    public SubType diff(SubType other) {
        CellSubType otherCell = (CellSubType) other;
        return new CellSubType(cellSubtypeDataEnsureProper(bddSubtypeDiff(data, otherCell.data)));
    }

    @Override
    public SubType complement() {
        return new CellSubType(cellSubtypeDataEnsureProper(bddSubtypeComplement(data)));
    }

    @Override
    public boolean isEmpty() {
        throw new UnsupportedOperationException("unimplemented");
    }

    private SubTypeData cellSubtypeDataEnsureProper(SubTypeData subTypeData) {
        if (subTypeData instanceof BddLeafNode bddLeaf) {
            Atom atom = bddLeaf == BddLeafNode.TRUE ? ATOM_CELL_VAL : ATOM_CELL_NEVER;
            return bddAtom(atom);
        }
        return subTypeData;
    }
}
