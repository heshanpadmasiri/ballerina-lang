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
 *
 */

package org.wso2.ballerinalang.compiler.bir.codegen.split.constants;

import org.ballerinalang.model.elements.PackageID;
import org.objectweb.asm.ClassWriter;
import org.objectweb.asm.FieldVisitor;
import org.objectweb.asm.MethodVisitor;
import org.wso2.ballerinalang.compiler.bir.codegen.BallerinaClassWriter;
import org.wso2.ballerinalang.compiler.bir.codegen.JvmCodeGenUtil;
import org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants;
import org.wso2.ballerinalang.compiler.bir.codegen.JvmTypeGen;
import org.wso2.ballerinalang.compiler.bir.codegen.internal.BTypeHashComparator;
import org.wso2.ballerinalang.compiler.semantics.model.types.BType;
import org.wso2.ballerinalang.compiler.semantics.model.types.BUnionType;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import static org.objectweb.asm.Opcodes.AASTORE;
import static org.objectweb.asm.Opcodes.ANEWARRAY;
import static org.objectweb.asm.Opcodes.CHECKCAST;
import static org.objectweb.asm.Opcodes.DUP;
import static org.objectweb.asm.Opcodes.INVOKESPECIAL;
import static org.objectweb.asm.Opcodes.INVOKEVIRTUAL;
import static org.objectweb.asm.Opcodes.NEW;
import static org.objectweb.asm.Opcodes.ACC_PUBLIC;
import static org.objectweb.asm.Opcodes.ACC_STATIC;
import static org.objectweb.asm.Opcodes.GETSTATIC;
import static org.objectweb.asm.Opcodes.INVOKESTATIC;
import static org.objectweb.asm.Opcodes.PUTSTATIC;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.BINARY_TYPE_OPERATION_DESCRIPTOR;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.BINARY_TYPE_OPERATION_WITH_IDENTIFIER_DESCRIPTOR;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.B_SEMTYPE_TYPE_INIT_METHOD;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.GET_TYPE_SUPPLIER;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.JVM_INIT_METHOD;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.MAX_CONSTANTS_PER_METHOD;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.TYPE_BUILDER;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.TYPE_SUPPLIER;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.TYPE_SUPPLIER_UTLS;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.UNION_TYPE_SUPPLIER;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmSignatures.GET_TYPE;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmSignatures.VOID_METHOD_DESC;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmTypeGen.hasIdentifier;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmTypeGen.loadTypeBuilderIdentifier;
import static org.wso2.ballerinalang.compiler.bir.codegen.split.constants.JvmConstantGenCommons.genMethodReturn;
import static org.wso2.ballerinalang.compiler.bir.codegen.split.constants.JvmConstantGenCommons.generateConstantsClassInit;

// TODO: eventually this should replace all other *TypeConstantsGen classes

/**
 * Generates Jvm class for the SemTypes of a given module.
 *
 * @since 2201.10.0
 */
public class JvmSemTypeConstantsGen {

    private final String semTypeConstantsClass;
    private final Map<BType, String> typeVarMap;
    private final Map<BType, String> typeSupplierMap;
    private final ClassWriter cw;
    private MethodVisitor mv;
    private int constantIndex = 0;
    private int methodCount = 1;
    private JvmTypeGen jvmTypeGen;

    public JvmSemTypeConstantsGen(PackageID packageID, BTypeHashComparator bTypeHashComparator) {
        semTypeConstantsClass = JvmCodeGenUtil.getModuleLevelClassName(packageID,
                JvmConstants.SEMTYPE_TYPE_CONSTANT_CLASS_NAME);
        cw = new BallerinaClassWriter(ClassWriter.COMPUTE_FRAMES);
        generateConstantsClassInit(cw, semTypeConstantsClass);
        mv = cw.visitMethod(ACC_PUBLIC + ACC_STATIC, B_SEMTYPE_TYPE_INIT_METHOD, VOID_METHOD_DESC, null, null);
        typeVarMap = new TreeMap<>(bTypeHashComparator);
        typeSupplierMap = new TreeMap<>(bTypeHashComparator);
    }

    public void setJvmTypeGen(JvmTypeGen jvmTypeGen) {
        this.jvmTypeGen = jvmTypeGen;
    }

    public String add(BType type) {
        String typeVarName = typeVarMap.get(type);
        if (typeVarName == null) {
            typeVarName = generateBSemTypeInitMethod(type);
            typeVarMap.put(type, typeVarName);
        }
        return typeVarName;
    }

    private String generateTypeSupplierInitMethod(BType type) {
        String name = typeSupplierMap.get(type);
        if (name != null) {
            return name;
        }
        String varName = JvmConstants.SEMTYPE_TYPE_SUPPLIER_PREFIX + constantIndex++;
        typeSupplierMap.put(type, varName);
        if (constantIndex % MAX_CONSTANTS_PER_METHOD == 0 && constantIndex != 0) {
            mv.visitMethodInsn(INVOKESTATIC, semTypeConstantsClass, B_SEMTYPE_TYPE_INIT_METHOD + methodCount,
                    VOID_METHOD_DESC, false);
            genMethodReturn(mv);
            mv = cw.visitMethod(ACC_PUBLIC + ACC_STATIC, B_SEMTYPE_TYPE_INIT_METHOD + methodCount++, VOID_METHOD_DESC,
                    null, null);
        }
        if (!(type instanceof BUnionType unionType)) {
            throw new UnsupportedOperationException("Unsupported BType" + type);
        }
        List<BType> members = new ArrayList<>(unionType.getMemberTypes());
        // create UnionType supplier
        mv.visitTypeInsn(NEW, UNION_TYPE_SUPPLIER);
        mv.visitInsn(DUP);
        mv.visitMethodInsn(INVOKESPECIAL, UNION_TYPE_SUPPLIER, JVM_INIT_METHOD, VOID_METHOD_DESC, false);
        FieldVisitor fv = cw.visitField(ACC_PUBLIC + ACC_STATIC, varName, GET_TYPE_SUPPLIER, null, null);
        fv.visitEnd();
        // Assign it to local field
        mv.visitInsn(DUP);
        mv.visitFieldInsn(PUTSTATIC, semTypeConstantsClass, varName, GET_TYPE_SUPPLIER);
        // load number of members
        mv.visitLdcInsn(members.size());
        // create new array
        mv.visitTypeInsn(ANEWARRAY, TYPE_SUPPLIER);
        // for each member type
        for (int i = 0; i < members.size(); i++) {
            mv.visitInsn(DUP);
            mv.visitLdcInsn(i);
            // -- load type
            BType member = members.get(i);
            jvmTypeGen.loadTypeUsingTypeBuilder(mv, member);
            // cast to BSemType
            mv.visitTypeInsn(CHECKCAST, "io/ballerina/runtime/internal/types/semtype/BSemType");
            // -- create identity supplier
            mv.visitMethodInsn(INVOKESTATIC, TYPE_SUPPLIER_UTLS, "createIdentitySupplier",
                    "(Lio/ballerina/runtime/internal/types/semtype/BSemType;)Lio/ballerina/runtime/api/creators/TypeSupplier;",
                    false);
            // -- store it in the array
            mv.visitInsn(AASTORE);
        }
        // call resolve (stack must be union supplier, array)
        mv.visitMethodInsn(INVOKEVIRTUAL, UNION_TYPE_SUPPLIER, "resolve",
                "([Lio/ballerina/runtime/api/creators/TypeSupplier;)Lio/ballerina/runtime/internal/types/semtype/BSemType;",
                false);
        return varName;
    }

    private String generateBSemTypeInitMethod(BType type) {
        generateTypeSupplierInitMethod(type); // FIXME:
        String varName = JvmConstants.SEMTYPE_TYPE_VAR_PREFIX + constantIndex++;
        if (constantIndex % MAX_CONSTANTS_PER_METHOD == 0 && constantIndex != 0) {
            mv.visitMethodInsn(INVOKESTATIC, semTypeConstantsClass, B_SEMTYPE_TYPE_INIT_METHOD + methodCount,
                    VOID_METHOD_DESC, false);
            genMethodReturn(mv);
            mv = cw.visitMethod(ACC_PUBLIC + ACC_STATIC, B_SEMTYPE_TYPE_INIT_METHOD + methodCount++, VOID_METHOD_DESC,
                    null, null);
        }
        createSemTypeField(varName);
        if (type instanceof BUnionType unionType) {
            loadBUnionType(unionType);
        } else {
            throw new UnsupportedOperationException("Unsupported BType " + type);
        }
        mv.visitFieldInsn(PUTSTATIC, semTypeConstantsClass, varName, GET_TYPE);
        return varName;
    }

    private void loadBUnionType(BUnionType unionType) {
        int numberOfTypesOnStack = 0;
        for (BType member : unionType.getMemberTypes()) {
            jvmTypeGen.loadTypeUsingTypeBuilder(mv, member);
            numberOfTypesOnStack++;
        }
        boolean needToSetIdentifier = hasIdentifier(unionType);
        while (numberOfTypesOnStack > 1) {
            if (needToSetIdentifier && numberOfTypesOnStack == 2) {
                loadTypeBuilderIdentifier(mv, unionType);
                mv.visitMethodInsn(INVOKESTATIC, TYPE_BUILDER, "union",
                        BINARY_TYPE_OPERATION_WITH_IDENTIFIER_DESCRIPTOR,
                        false);
            } else {
                mv.visitMethodInsn(INVOKESTATIC, TYPE_BUILDER, "union", BINARY_TYPE_OPERATION_DESCRIPTOR, false);
            }
            numberOfTypesOnStack--;
        }
    }

    private void createTypeSupplierField(String typeVarName) {
        FieldVisitor fv =
                cw.visitField(ACC_PUBLIC + ACC_STATIC, typeVarName, TYPE_SUPPLIER, null, null);
    }

    private void createSemTypeField(String typeVarName) {
        FieldVisitor fv = cw.visitField(ACC_PUBLIC + ACC_STATIC, typeVarName, GET_TYPE, null, null);
        fv.visitEnd();
    }

    public void generateClass(Map<String, byte[]> jarEntries) {
        genMethodReturn(mv);
        cw.visitEnd();
        jarEntries.put(semTypeConstantsClass + JvmConstants.CLASS_FILE_SUFFIX, cw.toByteArray());
    }

    public void generateGetSemType(MethodVisitor mv, String varName) {
        mv.visitFieldInsn(GETSTATIC, semTypeConstantsClass, varName, GET_TYPE);
    }

    public String getSemTypeConstantsClass() {
        return this.semTypeConstantsClass;
    }
}
