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
package io.ballerina.types;

import java.util.Objects;

/**
 * CellAtomicType node.
 *
 * @since 2201.12.0
 */
public final class CellAtomicType implements AtomicType {

    private final SemType ty;
    private final CellMutability mut;

    public CellAtomicType(SemType ty, CellMutability mut) {
        assert ty != null;
        this.ty = ty;
        this.mut = mut;
    }

    public static CellAtomicType from(SemType ty, CellMutability mut) {
        assert ty != null;
        // TODO: return final fields where applicable
        return new CellAtomicType(ty, mut);
    }

    @Override
    public Atom.Kind atomKind() {
        return Atom.Kind.CELL_ATOM;
    }

    public SemType ty() {
        return ty;
    }

    public CellMutability mut() {
        return mut;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) return true;
        if (obj == null || obj.getClass() != this.getClass()) return false;
        var that = (CellAtomicType) obj;
        return Objects.equals(this.ty, that.ty) &&
                Objects.equals(this.mut, that.mut);
    }

    @Override
    public int hashCode() {
        return Objects.hash(ty, mut);
    }

    @Override
    public String toString() {
        return "CellAtomicType[" +
                "ty=" + ty + ", " +
                "mut=" + mut + ']';
    }

    public enum CellMutability {
        CELL_MUT_NONE,
        CELL_MUT_LIMITED,
        CELL_MUT_UNLIMITED
    }
}
