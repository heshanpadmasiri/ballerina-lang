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

import java.util.List;

import static io.ballerina.runtime.internal.types.semtype.SemTypeUtils.BasicTypeCodes.BT_CELL;

public record FixedLengthArray(List<BSemType> initial, int fixedLength) {

    public FixedLengthArray {
        // TODO: normalize the initial part
        validate(initial, fixedLength);
    }

    private static void validate(List<BSemType> initial, int fixedLength) {
        if (initial.size() > fixedLength) {
            throw new IllegalArgumentException("initial list has more members than the fixed length");
        }
        initial.forEach(bSemType -> {
            if (bSemType.all != 0 && bSemType.some != 1 << BT_CELL) {
                throw new IllegalStateException("FixedLengthArray can only contain Cell types");
            }
        });
        if (initial.size() > 2) {
            BSemType last = initial.get(initial.size() - 1);
            BSemType oneBeforeLast = initial.get(initial.size() - 2);
            if (last == oneBeforeLast) {
                throw new IllegalStateException(
                        "FixedLengthArray cannot have consecutive members of the same type in the end");
            }
        }
    }
}
