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

import io.ballerina.types.subtypedata.Range;

import java.util.Collections;
import java.util.List;
import java.util.Objects;

/**
 * Holds a pair of SemType list and Range list.
 * <i>Note: Member types at the indices that are not contained in `Range` array represent `never.
 * The SemTypes in this list are not `never`.</i>
 *
 * @since 2201.12.0
 */
public final class ListMemberTypes {

    private final List<Range> ranges;
    private final List<SemType> semTypes;

    public ListMemberTypes(List<Range> ranges, List<SemType> semTypes) {
        ranges = Collections.unmodifiableList(ranges);
        semTypes = Collections.unmodifiableList(semTypes);
        this.ranges = ranges;
        this.semTypes = semTypes;
    }

    public List<Range> ranges() {
        return Collections.unmodifiableList(ranges);
    }

    public List<SemType> semTypes() {
        return Collections.unmodifiableList(semTypes);
    }

    public static ListMemberTypes from(List<Range> ranges, List<SemType> semTypes) {
        assert ranges != null && semTypes != null;
        return new ListMemberTypes(ranges, semTypes);
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) return true;
        if (obj == null || obj.getClass() != this.getClass()) return false;
        var that = (ListMemberTypes) obj;
        return Objects.equals(this.ranges, that.ranges) &&
                Objects.equals(this.semTypes, that.semTypes);
    }

    @Override
    public int hashCode() {
        return Objects.hash(ranges, semTypes);
    }

    @Override
    public String toString() {
        return "ListMemberTypes[" +
                "ranges=" + ranges + ", " +
                "semTypes=" + semTypes + ']';
    }

}
