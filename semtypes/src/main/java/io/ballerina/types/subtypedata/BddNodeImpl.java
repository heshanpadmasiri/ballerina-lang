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
package io.ballerina.types.subtypedata;

import java.util.Objects;

import io.ballerina.types.Atom;
import io.ballerina.types.Bdd;

/**
 * Actual implementation of a generic Bdd node.
 *
 * @since 2201.12.0
 */
public final class BddNodeImpl implements BddNode {

    private final Atom atom;
    private final Bdd left;
    private final Bdd middle;
    private final Bdd right;

    /**
     * @param atom   the atom that this node represents
     * @param left   path that include this node's atom positively
     * @param middle path that doesn't include this node's atom
     * @param right  path that include this node's atom negatively
     *
     */
    public BddNodeImpl(Atom atom, Bdd left, Bdd middle, Bdd right) {
        this.atom = atom;
        this.left = left;
        this.middle = middle;
        this.right = right;
    }

    @Override
    public Atom atom() {
        return atom;
    }

    @Override
    public Bdd left() {
        return left;
    }

    @Override
    public Bdd middle() {
        return middle;
    }

    @Override
    public Bdd right() {
        return right;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) return true;
        if (obj == null || obj.getClass() != this.getClass()) return false;
        var that = (BddNodeImpl) obj;
        return Objects.equals(this.atom, that.atom) &&
                Objects.equals(this.left, that.left) &&
                Objects.equals(this.middle, that.middle) &&
                Objects.equals(this.right, that.right);
    }

    @Override
    public int hashCode() {
        return Objects.hash(atom, left, middle, right);
    }

    @Override
    public String toString() {
        return "BddNodeImpl[" +
                "atom=" + atom + ", " +
                "left=" + left + ", " +
                "middle=" + middle + ", " +
                "right=" + right + ']';
    }

}
