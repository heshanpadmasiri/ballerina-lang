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

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Objects;

/**
 * Represent a fixed length semtype member list similar to a tuple. The length of the list is `fixedLength`, the last
 * member of the `initial` is repeated to achieve this semantic. { initial: [int], fixedLength: 3, } is same as {
 * initial: [int, int, int], fixedLength: 3 } { initial: [string, int], fixedLength: 100 } means `int` is repeated 99
 * times to get a list of 100 members. `fixedLength` must be `0` when `inital` is empty and the `fixedLength` must be at
 * least `initial.length()`
 *
 * @since 2201.12.0
 */
public final class FixedLengthArray {

    private final List<CellSemType> initial;
    private final int fixedLength;

    public FixedLengthArray(List<CellSemType> initial, int fixedLength) {
        initial = List.copyOf(initial);
        assert fixedLength >= 0;
        this.initial = initial;
        this.fixedLength = fixedLength;
    }

    public static FixedLengthArray from(List<CellSemType> initial, int fixedLength) {
        return new FixedLengthArray(initial, fixedLength);
    }

    public List<CellSemType> initial() {
        return Collections.unmodifiableList(initial);
    }

    public static FixedLengthArray empty() {
        return from(new ArrayList<>(), 0);
    }

    public int fixedLength() {
        return fixedLength;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) return true;
        if (obj == null || obj.getClass() != this.getClass()) return false;
        var that = (FixedLengthArray) obj;
        return Objects.equals(this.initial, that.initial) &&
                this.fixedLength == that.fixedLength;
    }

    @Override
    public int hashCode() {
        return Objects.hash(initial, fixedLength);
    }

    @Override
    public String toString() {
        return "FixedLengthArray[" +
                "initial=" + initial + ", " +
                "fixedLength=" + fixedLength + ']';
    }

}
