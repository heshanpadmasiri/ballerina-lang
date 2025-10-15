/*
 *  Copyright (c) 2024, WSO2 LLC. (https://www.wso2.com).
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
 *  KIND, either express or implied. See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */
package io.ballerina.types.typeops;

import java.util.Objects;

import io.ballerina.types.CellSemType;

/**
 * Represent the FieldPair record.
 *
 * @since 2201.10.0
 */
public final class FieldPair {

    private final String name;
    private final CellSemType type1;
    private final CellSemType type2;
    private final Integer index1;
    private final Integer index2;

    /**
     * @param name   name of the field
     * @param type1  type of the field in the first mapping
     * @param type2  type of the field in the second mapping
     * @param index1 index of the field in the first mapping
     * @param index2 index of the field in the second mapping
     *
     */
    public FieldPair(String name, CellSemType type1, CellSemType type2, Integer index1, Integer index2) {
        this.name = name;
        this.type1 = type1;
        this.type2 = type2;
        this.index1 = index1;
        this.index2 = index2;
    }

    public static FieldPair create(String name, CellSemType type1, CellSemType type2, Integer index1,
                                   Integer index2) {
        return new FieldPair(name, type1, type2, index1, index2);
    }

    public String name() {
        return name;
    }

    public CellSemType type1() {
        return type1;
    }

    public CellSemType type2() {
        return type2;
    }

    public Integer index1() {
        return index1;
    }

    public Integer index2() {
        return index2;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) return true;
        if (obj == null || obj.getClass() != this.getClass()) return false;
        var that = (FieldPair) obj;
        return Objects.equals(this.name, that.name) &&
                Objects.equals(this.type1, that.type1) &&
                Objects.equals(this.type2, that.type2) &&
                Objects.equals(this.index1, that.index1) &&
                Objects.equals(this.index2, that.index2);
    }

    @Override
    public int hashCode() {
        return Objects.hash(name, type1, type2, index1, index2);
    }

    @Override
    public String toString() {
        return "FieldPair[" +
                "name=" + name + ", " +
                "type1=" + type1 + ", " +
                "type2=" + type2 + ", " +
                "index1=" + index1 + ", " +
                "index2=" + index2 + ']';
    }

}
