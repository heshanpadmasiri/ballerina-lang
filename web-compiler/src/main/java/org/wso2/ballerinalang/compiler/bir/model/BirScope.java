/*
 *  Copyright (c) 2020, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  WSO2 Inc. licenses this file to you under the Apache License,
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

package org.wso2.ballerinalang.compiler.bir.model;

import java.util.Objects;

/**
 * Hold the scope of the instruction w.r.t variable declarations.
 *
 * @since 2.0.0
 */
public final class BirScope {

    private final int id;
    private final BirScope parent;

    /**
     * @param id     the BIR scope id
     * @param parent the parent scope
     *
     */
    public BirScope(int id, BirScope parent) {
        this.id = id;
        this.parent = parent;
    }

    public int id() {
        return id;
    }

    public BirScope parent() {
        return parent;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) return true;
        if (obj == null || obj.getClass() != this.getClass()) return false;
        var that = (BirScope) obj;
        return this.id == that.id &&
                Objects.equals(this.parent, that.parent);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id, parent);
    }

    @Override
    public String toString() {
        return "BirScope[" +
                "id=" + id + ", " +
                "parent=" + parent + ']';
    }

}
