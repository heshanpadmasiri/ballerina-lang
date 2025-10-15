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
package io.ballerina.types;

import java.util.Objects;

import io.ballerina.types.subtypedata.Range;

/**
 * Represents a combined range.
 *
 * @since 2201.12.0
 */
public final class CombinedRange {

    private final Range range;
    private final Long i1;
    private final Long i2;

    /**
     * @param range range
     * @param i1    i1
     * @param i2    i2
     *
     */
    public CombinedRange(Range range, Long i1, Long i2) {
        this.range = range;
        this.i1 = i1;
        this.i2 = i2;
    }

    public static CombinedRange from(Range range, Long i1, Long i2) {
        return new CombinedRange(range, i1, i2);
    }

    public Range range() {
        return range;
    }

    public Long i1() {
        return i1;
    }

    public Long i2() {
        return i2;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) return true;
        if (obj == null || obj.getClass() != this.getClass()) return false;
        var that = (CombinedRange) obj;
        return Objects.equals(this.range, that.range) &&
                Objects.equals(this.i1, that.i1) &&
                Objects.equals(this.i2, that.i2);
    }

    @Override
    public int hashCode() {
        return Objects.hash(range, i1, i2);
    }

    @Override
    public String toString() {
        return "CombinedRange[" +
                "range=" + range + ", " +
                "i1=" + i1 + ", " +
                "i2=" + i2 + ']';
    }

}
