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
 * FunctionAtomicType node.
 *
 * @since 2201.12.0
 */
public final class FunctionAtomicType
        implements AtomicType {

    private final SemType paramType;
    private final SemType retType;
    private final SemType qualifiers;
    private final boolean isGeneric;

    /**
     * @param paramType  semtype of parameters represented as a tuple
     * @param retType    semtype of the return value
     * @param qualifiers qualifiers of the function
     * @param isGeneric  atomic type represent a generic (i.e. have parameters/return type with {@code typeParam}
     *                   annotation)
     *
     */
    public FunctionAtomicType(SemType paramType, SemType retType, SemType qualifiers, boolean isGeneric) {
        this.paramType = paramType;
        this.retType = retType;
        this.qualifiers = qualifiers;
        this.isGeneric = isGeneric;
    }

    public static FunctionAtomicType from(SemType paramType, SemType rest, SemType qualifiers) {
        return new FunctionAtomicType(paramType, rest, qualifiers, false);
    }

    public static FunctionAtomicType genericFrom(SemType paramType, SemType rest, SemType qualifiers) {
        return new FunctionAtomicType(paramType, rest, qualifiers, true);
    }

    @Override
    public Atom.Kind atomKind() {
        return Atom.Kind.FUNCTION_ATOM;
    }

    public SemType paramType() {
        return paramType;
    }

    public SemType retType() {
        return retType;
    }

    public SemType qualifiers() {
        return qualifiers;
    }

    public boolean isGeneric() {
        return isGeneric;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) return true;
        if (obj == null || obj.getClass() != this.getClass()) return false;
        var that = (FunctionAtomicType) obj;
        return Objects.equals(this.paramType, that.paramType) &&
                Objects.equals(this.retType, that.retType) &&
                Objects.equals(this.qualifiers, that.qualifiers) &&
                this.isGeneric == that.isGeneric;
    }

    @Override
    public int hashCode() {
        return Objects.hash(paramType, retType, qualifiers, isGeneric);
    }

    @Override
    public String toString() {
        return "FunctionAtomicType[" +
                "paramType=" + paramType + ", " +
                "retType=" + retType + ", " +
                "qualifiers=" + qualifiers + ", " +
                "isGeneric=" + isGeneric + ']';
    }

}
