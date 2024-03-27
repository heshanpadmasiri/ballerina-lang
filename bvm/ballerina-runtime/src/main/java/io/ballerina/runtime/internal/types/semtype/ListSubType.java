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

import static io.ballerina.runtime.internal.types.semtype.BddUtils.bddSubtypeDiff;
import static io.ballerina.runtime.internal.types.semtype.BddUtils.bddSubtypeIntersect;
import static io.ballerina.runtime.internal.types.semtype.BddUtils.bddSubtypeUnion;

public class ListSubType implements SubType {

    private final BddNode data;

    public ListSubType(BddNode data) {
        this.data = data;
    }

    @Override
    public SubType union(SubType other) {
        ListSubType otherList = (ListSubType) other;
        BddNode data = (BddNode) bddSubtypeUnion(this.data, otherList.data());
        return new ListSubType(data);
    }

    @Override
    public SubType intersect(SubType other) {
        ListSubType otherList = (ListSubType) other;
        BddNode data = (BddNode) bddSubtypeIntersect(this.data, otherList.data());
        return new ListSubType(data);
    }

    @Override
    public SubType diff(SubType other) {
        ListSubType otherList = (ListSubType) other;
        BddNode data = (BddNode) bddSubtypeDiff(this.data, otherList.data());
        return new ListSubType(data);
    }

    @Override
    public SubType complement() {
        BddNode data = (BddNode) BddUtils.bddSubtypeComplement(this.data);
        return new ListSubType(data);
    }

    @Override
    public boolean isEmpty() {
        throw new UnsupportedOperationException("unimplemented");
    }

    public BddNode data() {
        return data;
    }
}
