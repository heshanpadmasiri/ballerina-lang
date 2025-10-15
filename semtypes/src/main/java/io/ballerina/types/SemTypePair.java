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
 * Holds a pair of semtypes.
 *
 * @since 2201.12.0
 */
public final class SemTypePair {

    private final SemType t1;
    private final SemType t2;

    /**
     * @param t1 first semtype
     * @param t2 second semtype
     *
     */
    public SemTypePair(SemType t1, SemType t2) {
        this.t1 = t1;
        this.t2 = t2;
    }

    public static SemTypePair from(SemType t1, SemType t2) {
        assert t1 != null && t2 != null;
        return new SemTypePair(t1, t2);
    }

    public SemType t1() {
        return t1;
    }

    public SemType t2() {
        return t2;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) return true;
        if (obj == null || obj.getClass() != this.getClass()) return false;
        var that = (SemTypePair) obj;
        return Objects.equals(this.t1, that.t1) &&
                Objects.equals(this.t2, that.t2);
    }

    @Override
    public int hashCode() {
        return Objects.hash(t1, t2);
    }

    @Override
    public String toString() {
        return "SemTypePair[" +
                "t1=" + t1 + ", " +
                "t2=" + t2 + ']';
    }

}
