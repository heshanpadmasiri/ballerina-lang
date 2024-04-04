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
import org.objectweb.asm.Handle;
import org.objectweb.asm.MethodVisitor;
import org.objectweb.asm.Type;
import org.wso2.ballerinalang.compiler.bir.codegen.BallerinaClassWriter;
import org.wso2.ballerinalang.compiler.bir.codegen.JvmCodeGenUtil;
import org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants;
import org.wso2.ballerinalang.compiler.bir.codegen.JvmSignatures;
import org.wso2.ballerinalang.compiler.bir.codegen.JvmTypeGen;
import org.wso2.ballerinalang.compiler.bir.codegen.internal.BTypeHashComparator;
import org.wso2.ballerinalang.compiler.semantics.model.types.BType;
import org.wso2.ballerinalang.compiler.semantics.model.types.BUnionType;

import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import static org.objectweb.asm.Opcodes.AASTORE;
import static org.objectweb.asm.Opcodes.ACC_PRIVATE;
import static org.objectweb.asm.Opcodes.ACC_PUBLIC;
import static org.objectweb.asm.Opcodes.ACC_STATIC;
import static org.objectweb.asm.Opcodes.ANEWARRAY;
import static org.objectweb.asm.Opcodes.ARETURN;
import static org.objectweb.asm.Opcodes.CHECKCAST;
import static org.objectweb.asm.Opcodes.DUP;
import static org.objectweb.asm.Opcodes.GETSTATIC;
import static org.objectweb.asm.Opcodes.H_INVOKESTATIC;
import static org.objectweb.asm.Opcodes.INVOKEINTERFACE;
import static org.objectweb.asm.Opcodes.INVOKESPECIAL;
import static org.objectweb.asm.Opcodes.INVOKESTATIC;
import static org.objectweb.asm.Opcodes.INVOKEVIRTUAL;
import static org.objectweb.asm.Opcodes.NEW;
import static org.objectweb.asm.Opcodes.PUTSTATIC;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.JVM_INIT_METHOD;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.TYPE;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.TYPE_CREATOR_METHOD;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.TYPE_SUPPLIER;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmSignatures.BINARY_TYPE_OPERATION_DESCRIPTOR;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmSignatures.BINARY_TYPE_OPERATION_WITH_IDENTIFIER_DESCRIPTOR;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.B_SEMTYPE_TYPE_INIT_METHOD;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.MAX_CONSTANTS_PER_METHOD;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.TYPE_BUILDER;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmSignatures.GET_TYPE;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmSignatures.GET_TYPE_SUPPLIER;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmSignatures.TYPE_CREATOR_DESC;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmSignatures.TYPE_SUPPLIER_GET_DESCRIPTOR;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmSignatures.VOID_METHOD_DESC;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmTypeGen.hasIdentifier;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmTypeGen.loadTypeIdentifier;
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
    private final Map<BType, String> typeCreatorMethods;
    private final Map<BType, String> tyepSupplierFields;
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
        typeCreatorMethods = new TreeMap<>(bTypeHashComparator);
        tyepSupplierFields = new TreeMap<>(bTypeHashComparator);
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

    private String generateBSemTypeInitMethod(BType type) {
        if (type instanceof BUnionType unionType) {
            loadUnionTypeSupplier(unionType);
        } else {
            throw new UnsupportedOperationException("Type generation is not supported for type: " + type);
        }
        loadTypeFromTypeSupplier();
        String varName = JvmConstants.SEMTYPE_TYPE_VAR_PREFIX + constantIndex++;
        createSemTypeField(varName);
        mv.visitFieldInsn(PUTSTATIC, semTypeConstantsClass, varName, GET_TYPE);
        return varName;
    }

    private void loadUnionTypeSupplier(BUnionType unionType) {
        String fieldName = tyepSupplierFields.get(unionType);
        if (fieldName == null) {
            fieldName = JvmConstants.SEMTYPE_TYPE_VAR_PREFIX + constantIndex++;
            tyepSupplierFields.put(unionType, fieldName);
            if (constantIndex % MAX_CONSTANTS_PER_METHOD == 0 && constantIndex != 0) {
                mv.visitMethodInsn(INVOKESTATIC, semTypeConstantsClass, B_SEMTYPE_TYPE_INIT_METHOD + methodCount,
                        VOID_METHOD_DESC, false);
                genMethodReturn(mv);
                mv = cw.visitMethod(ACC_PUBLIC + ACC_STATIC, B_SEMTYPE_TYPE_INIT_METHOD + methodCount++,
                        VOID_METHOD_DESC,
                        null, null);
            }
            createUnionTypeSupplier(unionType, fieldName);
        } else {
            mv.visitFieldInsn(GETSTATIC, semTypeConstantsClass, fieldName, GET_TYPE_SUPPLIER);
        }
    }

    private void loadTypeFromTypeSupplier() {
        mv.visitMethodInsn(INVOKEINTERFACE, TYPE_SUPPLIER, "get", TYPE_SUPPLIER_GET_DESCRIPTOR, true);
        mv.visitTypeInsn(CHECKCAST, TYPE);
    }

    private void createUnionTypeSupplier(BUnionType unionType, String fieldName) {
        FieldVisitor fv = cw.visitField(ACC_PUBLIC + ACC_STATIC, fieldName, GET_TYPE_SUPPLIER, null, null);
        fv.visitEnd();

        mv.visitTypeInsn(NEW, JvmConstants.UNION_TYPE_SUPPLIER);
        mv.visitInsn(DUP);
        if (JvmTypeGen.hasIdentifier(unionType)) {
            loadTypeIdentifier(mv, unionType);
            mv.visitMethodInsn(INVOKESPECIAL, JvmConstants.UNION_TYPE_SUPPLIER, JVM_INIT_METHOD,
                    JvmSignatures.NAMED_UNION_TYPE_SUPPLIER_INIT_DESC, false);
        } else {
            mv.visitMethodInsn(INVOKESPECIAL, JvmConstants.UNION_TYPE_SUPPLIER, JVM_INIT_METHOD, VOID_METHOD_DESC,
                    false);
        }
        mv.visitInsn(DUP);
        mv.visitFieldInsn(PUTSTATIC, semTypeConstantsClass, fieldName, GET_TYPE_SUPPLIER);

        mv.visitInsn(DUP);
        List<BType> members = unionType.getMemberTypes().stream().toList();
        mv.visitLdcInsn(members.size());
        // create new array
        mv.visitTypeInsn(ANEWARRAY, TYPE_SUPPLIER);
        // for each member type
        for (int i = 0; i < members.size(); i++) {
            mv.visitInsn(DUP);
            mv.visitLdcInsn(i);
            loadAnonTypeSupplier(members.get(i));
            mv.visitInsn(AASTORE);
        }
        // set memberTypeSuppliers
        mv.visitMethodInsn(INVOKEVIRTUAL, JvmConstants.UNION_TYPE_SUPPLIER, "setMembers",
                JvmSignatures.UNION_TYPE_SUPPLIER_SET_MEMBERS, false);
    }

    private void loadBUnionType(BUnionType unionType) {
        int numberOfTypesOnStack = 0;
        for (BType member : unionType.getMemberTypes()) {
            loadTypeUsingTypeSupplier(member);
            numberOfTypesOnStack++;
        }
        boolean needToSetIdentifier = hasIdentifier(unionType);
        while (numberOfTypesOnStack > 1) {
            if (needToSetIdentifier && numberOfTypesOnStack == 2) {
                loadTypeIdentifier(mv, unionType);
                mv.visitMethodInsn(INVOKESTATIC, TYPE_BUILDER, "union",
                        BINARY_TYPE_OPERATION_WITH_IDENTIFIER_DESCRIPTOR,
                        false);
            } else {
                mv.visitMethodInsn(INVOKESTATIC, TYPE_BUILDER, "union", BINARY_TYPE_OPERATION_DESCRIPTOR, false);
            }
            numberOfTypesOnStack--;
        }
    }

    private void loadTypeUsingTypeSupplier(BType type) {
        loadAnonTypeSupplier(type);
        loadTypeFromTypeSupplier();
    }

    private void loadAnonTypeSupplier(BType type) {
        String typeCreatorMethodName = typeCreatorMethods.get(type);
        if (typeCreatorMethodName == null) {
            typeCreatorMethodName = createTypeCreatorMethod(type);
            typeCreatorMethods.put(type, typeCreatorMethodName);
        }
        Handle typeCreatorMethodHandle = new Handle(H_INVOKESTATIC, semTypeConstantsClass, typeCreatorMethodName,
                TYPE_CREATOR_DESC, false);
        Handle bootstrapMethodHandle = new Handle(H_INVOKESTATIC, JvmConstants.LAMBDA_METAFACTORY, "metafactory",
                JvmSignatures.LAMBDA_META_FACTORY_DESC, false);
        String desc = "()L" + TYPE_SUPPLIER + ";";
        mv.visitInvokeDynamicInsn("get", desc, bootstrapMethodHandle,
                Type.getType("()Ljava/lang/Object;"), typeCreatorMethodHandle, Type.getType(TYPE_CREATOR_DESC));
    }

    private String createTypeCreatorMethod(BType type) {
        String typeCreatorMethodName = TYPE_CREATOR_METHOD + methodCount++;
        MethodVisitor typeCreatorMv =
                cw.visitMethod(ACC_PRIVATE + ACC_STATIC, typeCreatorMethodName, TYPE_CREATOR_DESC, null, null);
        typeCreatorMv.visitCode();
        jvmTypeGen.loadType(typeCreatorMv, type);
        // TODO: convert to BSemType
        typeCreatorMv.visitInsn(ARETURN);
        // TODO: there is a function for this
        typeCreatorMv.visitMaxs(0, 0);
        return typeCreatorMethodName;
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
