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
package io.ballerina.types.definition;

import java.util.Objects;

import io.ballerina.types.CellSemType;

/**
 * Represents a cell field in a mapping type.
 *
 * @since 2201.12.0
 */
public final class CellField {

    private final String name;
    private final CellSemType type;

    /**
     * @param name name of the field
     * @param type cell-sem-type of the field
     *
     */
    public CellField(String name, CellSemType type) {
        this.name = name;
        this.type = type;
    }

    public static CellField from(String name, CellSemType type) {
        return new CellField(name, type);
    }

    public String name() {
        return name;
    }

    public CellSemType type() {
        return type;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) return true;
        if (obj == null || obj.getClass() != this.getClass()) return false;
        var that = (CellField) obj;
        return Objects.equals(this.name, that.name) &&
                Objects.equals(this.type, that.type);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name, type);
    }

    @Override
    public String toString() {
        return "CellField[" +
                "name=" + name + ", " +
                "type=" + type + ']';
    }

}
