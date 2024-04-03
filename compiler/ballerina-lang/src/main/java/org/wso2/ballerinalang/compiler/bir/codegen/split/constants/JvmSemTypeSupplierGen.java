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
import org.wso2.ballerinalang.compiler.semantics.model.types.BArrayType;
import org.wso2.ballerinalang.compiler.semantics.model.types.BTupleType;
import org.wso2.ballerinalang.compiler.semantics.model.types.BType;
import org.wso2.ballerinalang.compiler.semantics.model.types.BTypeReferenceType;
import org.wso2.ballerinalang.compiler.semantics.model.types.BUnionType;

import java.util.ArrayList;
import java.util.Collections;
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
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.B_SEMTYPE_CREATOR_METHOD;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.B_SEMTYPE_TYPE_INIT_METHOD;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.GET_TYPE_SUPPLIER;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.JVM_INIT_METHOD;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.LAZY_TYPE_SUPPLIER;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.MAX_CONSTANTS_PER_METHOD;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.TYPE_SUPPLIER;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.TYPE_SUPPLIER_UTLS;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmSignatures.INIT_WITH_IDENTIFIER;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmSignatures.TYPE_CREATOR_DESC;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmSignatures.TYPE_SUPPLIER_GET_DESCRIPTOR;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmSignatures.VOID_METHOD_DESC;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmTypeGen.hasIdentifier;
import static org.wso2.ballerinalang.compiler.bir.codegen.split.constants.JvmConstantGenCommons.genMethodReturn;
import static org.wso2.ballerinalang.compiler.bir.codegen.split.constants.JvmConstantGenCommons.generateConstantsClassInit;

// TODO: eventually this should replace all other *TypeConstantsGen classes

/**
 * Generates {@code TypeSuppliers} for the SemTypes of a given module.
 *
 * @since 2201.10.0
 */
public class JvmSemTypeSupplierGen {

    private final String semTypeConstantsClass;
    private final Map<BType, String> typeSupplierMap;
    private final Map<BType, String> typeCreatorMap;
    private final ClassWriter cw;
    private MethodVisitor mv;
    private int constantIndex = 0;
    private int methodCount = 1;
    private JvmTypeGen jvmTypeGen;

    public JvmSemTypeSupplierGen(PackageID packageID, BTypeHashComparator bTypeHashComparator) {
        semTypeConstantsClass = JvmCodeGenUtil.getModuleLevelClassName(packageID,
                JvmConstants.SEMTYPE_TYPE_CONSTANT_CLASS_NAME);
        cw = new BallerinaClassWriter(ClassWriter.COMPUTE_FRAMES);
        generateConstantsClassInit(cw, semTypeConstantsClass);
        mv = cw.visitMethod(ACC_PUBLIC + ACC_STATIC, B_SEMTYPE_TYPE_INIT_METHOD, VOID_METHOD_DESC, null, null);
        typeSupplierMap = new TreeMap<>(bTypeHashComparator);
        typeCreatorMap = new TreeMap<>(bTypeHashComparator);
    }

    public void setJvmTypeGen(JvmTypeGen jvmTypeGen) {
        this.jvmTypeGen = jvmTypeGen;
    }

    public String get(BType type) {
        String name = typeSupplierMap.get(type);
        if (name == null) {
            name = generateTypeSupplierInitMethod(type);
            typeSupplierMap.put(type, name);
        }
        return name;
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
        if (type instanceof BUnionType unionType) {
            generateUnionTypeSupplier(unionType, varName);
        } else if (type instanceof BArrayType arrayType) {
            generateListTypeSupplier(arrayType, varName);
        } else if (type instanceof BTupleType tupleType) {
            generateListTypeSupplier(tupleType, varName);
        } else if (type instanceof BTypeReferenceType referenceType) {
            generateTypeRefSupplier(referenceType, varName);
        } else {
            throw new UnsupportedOperationException("Unsupported BType" + type);
        }
        return varName;
    }

    // TODO: think about how to do "anonymous" list types
    private void generateListTypeSupplier(BTupleType tupleType, String varName) {
        List<BType> memberTypes = tupleType.getMembers().stream().map(member -> member.type).toList();
        BType restType = tupleType.restType == null ? BType.createNeverType() : tupleType.restType;
        generateListTypeSupplierInner(memberTypes, restType, varName);
    }

    private void generateTypeRefSupplier(BTypeReferenceType referenceType, String varName) {
        createLazyTypeSupplier(referenceType, List.of(referenceType.referredType), varName);
//        loadTypeSupplierFromBType(referenceType.referredType);
//        createAndInitializeTypeSupplierField(varName);
//        mv.visitInsn(POP);
    }

    private void generateListTypeSupplier(BArrayType arrayType, String varName) {
        BType elementType = arrayType.eType;
        int length = arrayType.size;
        if (length == -1) {
            generateListTypeSupplierInner(List.of(), elementType, varName);
        } else {
            generateListTypeSupplierInner(Collections.nCopies(length, elementType), BType.createNeverType(), varName);
        }
    }

    private void generateListTypeSupplierInner(List<BType> memberTypes, BType restType, String varName) {
        mv.visitTypeInsn(NEW, "io/ballerina/runtime/api/creators/ListTypeSupplier");
        mv.visitInsn(DUP);
        mv.visitMethodInsn(INVOKESPECIAL, "io/ballerina/runtime/api/creators/ListTypeSupplier", "<init>",
                VOID_METHOD_DESC, false);
        createAndInitializeTypeSupplierField(varName);
        loadFixedLengthArraySupplier(memberTypes);
        loadTypeSupplierFromBType(restType);
        mv.visitMethodInsn(INVOKEVIRTUAL, "io/ballerina/runtime/api/creators/ListTypeSupplier", "setTypeSuppliers",
                "(Lio/ballerina/runtime/api/creators/FixLengthArraySupplier;Lio/ballerina/runtime/api/creators/TypeSupplier;)V",
                false);
    }

    private void loadFixedLengthArraySupplier(List<BType> memberTypes) {
        // create new FixedLengthArraySupplier
        mv.visitTypeInsn(NEW, "io/ballerina/runtime/api/creators/FixLengthArraySupplier");
        mv.visitInsn(DUP);
        // load array of type suppliers
        loadMemberTypeSuppliers(memberTypes);
        // load fixedLength
        mv.visitLdcInsn(memberTypes.size());
        // call constructor
        mv.visitMethodInsn(INVOKESPECIAL, "io/ballerina/runtime/api/creators/FixLengthArraySupplier", "<init>",
                "([Lio/ballerina/runtime/api/creators/TypeSupplier;I)V", false);
    }

    private void generateUnionTypeSupplier(BUnionType unionType, String varName) {
        List<BType> members = new ArrayList<>(unionType.getMemberTypes());
        createLazyTypeSupplier(unionType, members, varName);
    }

    private void createLazyTypeSupplier(BType type, List<BType> members, String varName) {
        createLazyTypeSupplier(type);
        createAndInitializeTypeSupplierField(varName);
        loadMemberTypeSuppliers(members);
        setMemberSuppliers();
    }

    private void createLazyTypeSupplier(BType type) {
        mv.visitTypeInsn(NEW, LAZY_TYPE_SUPPLIER);
        mv.visitInsn(DUP);
        if (hasIdentifier(type)) {
            JvmTypeGen.loadTypeSupplierIdentifier(mv, type);
            mv.visitMethodInsn(INVOKESPECIAL, LAZY_TYPE_SUPPLIER, JVM_INIT_METHOD, INIT_WITH_IDENTIFIER, false);
        } else {
            mv.visitMethodInsn(INVOKESPECIAL, LAZY_TYPE_SUPPLIER, JVM_INIT_METHOD, VOID_METHOD_DESC, false);
        }
    }

    private void setMemberSuppliers() {
        mv.visitMethodInsn(INVOKEVIRTUAL, LAZY_TYPE_SUPPLIER, JvmConstants.LAZY_TYPE_SUPPLIER_SET_MEMBERS,
                JvmSignatures.LAZY_TYPE_SUPPLIER_SET_MEMBER_DESC, false);
    }

    private void loadMemberTypeSuppliers(List<BType> members) {
        mv.visitLdcInsn(members.size());
        // create new array
        mv.visitTypeInsn(ANEWARRAY, TYPE_SUPPLIER);
        // for each member type
        for (int i = 0; i < members.size(); i++) {
            mv.visitInsn(DUP);
            mv.visitLdcInsn(i);
            loadTypeSupplierFromBType(members.get(i));
            mv.visitInsn(AASTORE);
        }
    }

    private void loadTypeSupplierFromBType(BType type) {
        if (typeSupplierMap.containsKey(type)) {
            mv.visitFieldInsn(GETSTATIC, semTypeConstantsClass, typeSupplierMap.get(type), GET_TYPE_SUPPLIER);
            return;
        } else if (canUseTypeSupplier(type)) {
            String name = get(type);
            mv.visitFieldInsn(GETSTATIC, semTypeConstantsClass, name, GET_TYPE_SUPPLIER);
            return;
        }
        createTypeSupplierForBType(type);
//        jvmTypeGen.loadType(mv, type);
//        mv.visitMethodInsn(INVOKESTATIC, TYPE_SUPPLIER_UTLS, JvmConstants.TYPE_SUPPLIER_FROM_OBJECT,
//                JvmSignatures.TYPE_SUPPLIER_FROM_OBJECT_DESC, false);
    }

    private void createTypeSupplierForBType(BType type) {
        String typeCreatorMethodName = typeCreatorMap.get(type);
        if (typeCreatorMethodName == null) {
//            if (isRecursiveMap(type)) {
//                typeCreatorMethodName = createTypeCreatorMethod(new BMapType(TypeTags.MAP, new BAnyType(null), null));
//            } else {
            typeCreatorMethodName = createTypeCreatorMethod(type);
//            }
            typeCreatorMap.put(type, typeCreatorMethodName);
        }
        Handle typeCreatorMethodHandle = new Handle(H_INVOKESTATIC, semTypeConstantsClass, typeCreatorMethodName,
                TYPE_CREATOR_DESC, false);
        Handle bootstrapMethodHandle = new Handle(H_INVOKESTATIC, "java/lang/invoke/LambdaMetafactory", "metafactory",
                "(Ljava/lang/invoke/MethodHandles$Lookup;Ljava/lang/String;Ljava/lang/invoke/MethodType;Ljava/lang/invoke/MethodType;Ljava/lang/invoke/MethodHandle;Ljava/lang/invoke/MethodType;)Ljava/lang/invoke/CallSite;",
                false);
        mv.visitInvokeDynamicInsn("get", "()Ljava/util/function/Supplier;", bootstrapMethodHandle,
                Type.getType("()Ljava/lang/Object;"), typeCreatorMethodHandle, Type.getType(TYPE_CREATOR_DESC));
        // We need to pass this lambda to a value of the correct type so that JVM will convert this to the correct type

        mv.visitMethodInsn(INVOKESTATIC, TYPE_SUPPLIER_UTLS, JvmConstants.TYPE_SUPPLIER_FROM,
                "(Ljava/util/function/Supplier;)L" + TYPE_SUPPLIER + ";", false);
    }

    private String createTypeCreatorMethod(BType type) {
        String typeCreatorMethodName = B_SEMTYPE_CREATOR_METHOD + methodCount++;
        MethodVisitor typeCreatorMv =
                cw.visitMethod(ACC_PRIVATE + ACC_STATIC, typeCreatorMethodName, TYPE_CREATOR_DESC, null, null);
        typeCreatorMv.visitCode();
        jvmTypeGen.loadType(typeCreatorMv, type);
        typeCreatorMv.visitInsn(ARETURN);
        typeCreatorMv.visitMaxs(0, 0);
        return typeCreatorMethodName;
    }

    private static boolean canUseTypeSupplier(BType type) {
        return switch (type.getKind()) {
            case UNION, ARRAY, TUPLE, TYPEREFDESC -> true;
            default -> false;
        };
    }

    private void createAndInitializeTypeSupplierField(String varName) {
        mv.visitInsn(DUP);
        FieldVisitor fv = cw.visitField(ACC_PUBLIC + ACC_STATIC, varName, GET_TYPE_SUPPLIER, null, null);
        fv.visitEnd();
        mv.visitFieldInsn(PUTSTATIC, semTypeConstantsClass, varName, GET_TYPE_SUPPLIER);
    }

    public void generateClass(Map<String, byte[]> jarEntries) {
        genMethodReturn(mv);
        cw.visitEnd();
        jarEntries.put(semTypeConstantsClass + JvmConstants.CLASS_FILE_SUFFIX, cw.toByteArray());
    }

    public void generateGetSemType(MethodVisitor mv, String typeSupplierName) {
        mv.visitFieldInsn(GETSTATIC, semTypeConstantsClass, typeSupplierName, GET_TYPE_SUPPLIER);
        mv.visitMethodInsn(INVOKEINTERFACE, TYPE_SUPPLIER, "get",
                TYPE_SUPPLIER_GET_DESCRIPTOR, true);
        mv.visitTypeInsn(CHECKCAST, "io/ballerina/runtime/internal/types/semtype/BSemType");
    }

    public String getSemTypeConstantsClass() {
        return this.semTypeConstantsClass;
    }
}
