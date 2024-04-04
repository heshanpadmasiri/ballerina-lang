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

import static io.ballerina.runtime.internal.types.semtype.SemTypeUtils.BasicTypeCodes.BT_CELL;

public record ListAtomicType(FixedLengthArray members, BSemType rest) implements AtomicType {

    public ListAtomicType {
        //validate(members, rest);
    }

    private static void validate(FixedLengthArray members, BSemType rest) {
        if (rest.all() != 0 && rest.some() != 1 << BT_CELL) {
            throw new IllegalStateException("rest type must be a cell atomic type");
        }
    }
}
