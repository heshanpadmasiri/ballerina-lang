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
import org.wso2.ballerinalang.compiler.bir.codegen.JvmSignatures;
import org.wso2.ballerinalang.compiler.bir.codegen.JvmTypeGen;
import org.wso2.ballerinalang.compiler.bir.codegen.internal.BTypeHashComparator;
import org.wso2.ballerinalang.compiler.semantics.model.types.BType;
import org.wso2.ballerinalang.compiler.semantics.model.types.BUnionType;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import static org.objectweb.asm.Opcodes.AASTORE;
import static org.objectweb.asm.Opcodes.ANEWARRAY;
import static org.objectweb.asm.Opcodes.CHECKCAST;
import static org.objectweb.asm.Opcodes.DUP;
import static org.objectweb.asm.Opcodes.INVOKEINTERFACE;
import static org.objectweb.asm.Opcodes.INVOKESPECIAL;
import static org.objectweb.asm.Opcodes.INVOKEVIRTUAL;
import static org.objectweb.asm.Opcodes.NEW;
import static org.objectweb.asm.Opcodes.ACC_PUBLIC;
import static org.objectweb.asm.Opcodes.ACC_STATIC;
import static org.objectweb.asm.Opcodes.GETSTATIC;
import static org.objectweb.asm.Opcodes.INVOKESTATIC;
import static org.objectweb.asm.Opcodes.POP;
import static org.objectweb.asm.Opcodes.PUTSTATIC;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.B_SEMTYPE_TYPE_INIT_METHOD;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.GET_TYPE_SUPPLIER;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.JVM_INIT_METHOD;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.MAX_CONSTANTS_PER_METHOD;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.TYPE_SUPPLIER;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmSignatures.INIT_WITH_IDENTIFIER;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmSignatures.TYPE_SUPPLIER_GET_DESCRIPTOR;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.TYPE_SUPPLIER_UTLS;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.UNION_TYPE_SUPPLIER;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmSignatures.GET_TYPE;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmSignatures.VOID_METHOD_DESC;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmTypeGen.hasIdentifier;
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
        generateUnionTypeSupplier(unionType, varName);
        return varName;
    }

    private void generateUnionTypeSupplier(BUnionType unionType, String varName) {
        List<BType> members = new ArrayList<>(unionType.getMemberTypes());
        createUnionTypeSupplier(unionType);
        createAndInitializeTypeSupplierField(varName);
        loadMemberTypeSuppliers(members);
        resolveUnionTypeSupplier();
    }

    private void createUnionTypeSupplier(BUnionType unionType) {
        mv.visitTypeInsn(NEW, UNION_TYPE_SUPPLIER);
        mv.visitInsn(DUP);
        if (hasIdentifier(unionType)) {
            JvmTypeGen.loadTypeSupplierIdentifier(mv, unionType);
            mv.visitMethodInsn(INVOKESPECIAL, UNION_TYPE_SUPPLIER, JVM_INIT_METHOD, INIT_WITH_IDENTIFIER, false);
        } else {
            mv.visitMethodInsn(INVOKESPECIAL, UNION_TYPE_SUPPLIER, JVM_INIT_METHOD, VOID_METHOD_DESC, false);
        }
    }

    private void resolveUnionTypeSupplier() {
        mv.visitMethodInsn(INVOKEVIRTUAL, UNION_TYPE_SUPPLIER, JvmConstants.TYPE_SUPPLIER_RESOLVE,
                JvmSignatures.TYPE_SUPPLIER_RESOLVE_DESC, false);
        // TODO: for the moment we don't care about the result and instead reload it by calling the supplier
        mv.visitInsn(POP);
    }

    private void loadMemberTypeSuppliers(List<BType> members) {
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
            mv.visitMethodInsn(INVOKESTATIC, TYPE_SUPPLIER_UTLS, JvmConstants.TYPE_SUPPLIER_FROM_OBJECT,
                    JvmSignatures.TYPE_SUPPLIER_FROM_OBJECT_DESC, false);
            // -- store it in the array
            mv.visitInsn(AASTORE);
        }
    }

    // TODO: remove this, and instead use the type supplier to get the type
    private String generateBSemTypeInitMethod(BType type) {
        String typeSupplier = generateTypeSupplierInitMethod(type); // FIXME:
        String varName = JvmConstants.SEMTYPE_TYPE_VAR_PREFIX + constantIndex++;
        if (constantIndex % MAX_CONSTANTS_PER_METHOD == 0 && constantIndex != 0) {
            mv.visitMethodInsn(INVOKESTATIC, semTypeConstantsClass, B_SEMTYPE_TYPE_INIT_METHOD + methodCount,
                    VOID_METHOD_DESC, false);
            genMethodReturn(mv);
            mv = cw.visitMethod(ACC_PUBLIC + ACC_STATIC, B_SEMTYPE_TYPE_INIT_METHOD + methodCount++, VOID_METHOD_DESC,
                    null, null);
        }
        createSemTypeField(varName);
        mv.visitFieldInsn(GETSTATIC, semTypeConstantsClass, typeSupplier, GET_TYPE_SUPPLIER);
        mv.visitMethodInsn(INVOKEINTERFACE, TYPE_SUPPLIER, "get",
                TYPE_SUPPLIER_GET_DESCRIPTOR, true);
        mv.visitTypeInsn(CHECKCAST, "io/ballerina/runtime/internal/types/semtype/BSemType");
        mv.visitFieldInsn(PUTSTATIC, semTypeConstantsClass, varName, GET_TYPE);
        return varName;
    }

    private void createAndInitializeTypeSupplierField(String varName) {
        mv.visitInsn(DUP);
        FieldVisitor fv = cw.visitField(ACC_PUBLIC + ACC_STATIC, varName, GET_TYPE_SUPPLIER, null, null);
        fv.visitEnd();
        mv.visitFieldInsn(PUTSTATIC, semTypeConstantsClass, varName, GET_TYPE_SUPPLIER);
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
