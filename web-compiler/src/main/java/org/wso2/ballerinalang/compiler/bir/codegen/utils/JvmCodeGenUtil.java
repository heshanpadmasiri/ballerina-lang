/*
 * Copyright (c) 2020, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
package org.wso2.ballerinalang.compiler.bir.codegen.utils;

import io.ballerina.types.Env;
import org.wso2.ballerinalang.compiler.bir.model.BIRNode;
import org.wso2.ballerinalang.compiler.semantics.model.types.BIntersectionType;
import org.wso2.ballerinalang.compiler.semantics.model.types.BType;
import org.wso2.ballerinalang.compiler.semantics.model.types.BTypeReferenceType;
import org.wso2.ballerinalang.compiler.util.TypeTags;
import org.wso2.ballerinalang.util.Flags;

import java.io.File;
import java.util.Comparator;
import java.util.List;

/**
 * Minimal JVM code generation utilities for web compiler.
 * Most methods throw UnsupportedOperationException since the web compiler
 * only runs up to BIR generation.
 *
 * @since 1.2.0
 */
public class JvmCodeGenUtil {

    public static final Comparator<BIRNode.BIRTypeDefinition> NAME_HASH_COMPARATOR =
            Comparator.comparingInt(o -> o.internalName.value.hashCode());

    /**
     * Retrieve the referred type if a given type is a type reference type or
     * retrieve the effective type if the given type is an intersection type.
     *
     * @param type type to retrieve the implied type
     * @return the implied type if provided with a type reference type or an intersection type,
     * else returns the original type
     */
    public static BType getImpliedType(BType type) {
        if (type == null) {
            return null;
        }

        if (type.tag == TypeTags.TYPEREFDESC) {
            return getImpliedType(((BTypeReferenceType) type).referredType);
        }

        if (type.tag == TypeTags.INTERSECTION) {
            return getImpliedType(((BIntersectionType) type).effectiveType);
        }

        return type;
    }

    public static boolean isExternFunc(BIRNode.BIRFunction func) {
        return (func.flags & Flags.NATIVE) == Flags.NATIVE;
    }

    public static String toNameString(BType t) {
        return t.toString();
    }

    public static String cleanupPathSeparators(String name) {
        return name.replace("\\",  File.separator);
    }

    // Methods below are only called from JvmPackageGen.generate() which now throws exception
    // Keeping signatures for compilation compatibility

    public static String getMethodDesc(Env typeEnv, List<BType> paramTypes, BType retType) {
        throw new UnsupportedOperationException("JVM bytecode generation is not supported in the web compiler.");
    }

    public static String getMethodDesc(Env typeEnv, List<BType> paramTypes, BType retType, BType attachedType) {
        throw new UnsupportedOperationException("JVM bytecode generation is not supported in the web compiler.");
    }

    public static String getMethodSig(List<BType> paramTypes, BType retType, BType attachedType, Env env) {
        throw new UnsupportedOperationException("JVM bytecode generation is not supported in the web compiler.");
    }

    public static String getSig(BType bType, Env env) {
        throw new UnsupportedOperationException("JVM bytecode generation is not supported in the web compiler.");
    }
}
