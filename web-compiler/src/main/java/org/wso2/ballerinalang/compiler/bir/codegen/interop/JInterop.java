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
 */
package org.wso2.ballerinalang.compiler.bir.codegen.interop;

import org.wso2.ballerinalang.compiler.bir.codegen.model.JMethodKind;

/**
 * This class contains a set of utility methods and constants used in this implementation.
 *
 * @since 1.2.0
 */
final class JInterop {

    static final String INTEROP_ANNOT_ORG = "ballerina";
    static final String INTEROP_ANNOT_MODULE = "jballerina.java";

    static final String CONSTRUCTOR_ANNOT_TAG = "Constructor";
    static final String METHOD_ANNOT_TAG = "Method";
    static final String FIELD_GET_ANNOT_TAG = "FieldGet";
    static final String FIELD_PUT_ANNOT_TAG = "FieldSet";

    static JMethodKind getMethodKindFromAnnotTag(String annotTagRef) {

        if (CONSTRUCTOR_ANNOT_TAG.equals(annotTagRef)) {
            return JMethodKind.CONSTRUCTOR;
        } else {
            return JMethodKind.METHOD;
        }
    }

    static JFieldMethod getFieldMethodFromAnnotTag(String annotTagRef) {

        if (FIELD_GET_ANNOT_TAG.equals(annotTagRef)) {
            return JFieldMethod.ACCESS;
        } else {
            return JFieldMethod.MUTATE;
        }
    }

    static boolean isInteropAnnotationTag(String annotTag) {

        return switch (annotTag) {
            case CONSTRUCTOR_ANNOT_TAG, METHOD_ANNOT_TAG, FIELD_GET_ANNOT_TAG, FIELD_PUT_ANNOT_TAG -> true;
            default -> false;
        };
    }

    static boolean isMethodAnnotationTag(String annotTag) {

        return CONSTRUCTOR_ANNOT_TAG.equals(annotTag) || METHOD_ANNOT_TAG.equals(annotTag);
    }

    private JInterop() {
    }
}
