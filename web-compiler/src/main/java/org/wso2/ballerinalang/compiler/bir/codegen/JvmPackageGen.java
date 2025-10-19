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

package org.wso2.ballerinalang.compiler.bir.codegen;

import io.ballerina.identifier.Utils;
import io.ballerina.types.Env;
import org.ballerinalang.compiler.BLangCompilerException;
import org.ballerinalang.model.elements.PackageID;
import org.ballerinalang.model.symbols.SymbolKind;
import org.ballerinalang.util.diagnostic.DiagnosticErrorCode;
import org.wso2.ballerinalang.compiler.PackageCache;
import org.wso2.ballerinalang.compiler.bir.codegen.exceptions.JInteropException;
import org.wso2.ballerinalang.compiler.bir.codegen.internal.CompiledJarFile;
import org.wso2.ballerinalang.compiler.bir.codegen.internal.JavaClass;
import org.wso2.ballerinalang.compiler.bir.codegen.model.BIRFunctionWrapper;
import org.wso2.ballerinalang.compiler.bir.codegen.utils.JvmCodeGenUtil;
import org.wso2.ballerinalang.compiler.bir.model.BIRNode;
import org.wso2.ballerinalang.compiler.bir.model.BIRNode.BIRFunction;
import org.wso2.ballerinalang.compiler.bir.model.BIRNode.BIRPackage;
import org.wso2.ballerinalang.compiler.bir.model.BIRNode.BIRTypeDefinition;
import org.wso2.ballerinalang.compiler.bir.model.BIRNode.BIRVariableDcl;
import org.wso2.ballerinalang.compiler.bir.model.BIRNonTerminator.NewInstance;
import org.wso2.ballerinalang.compiler.diagnostic.BLangDiagnosticLog;
import org.wso2.ballerinalang.compiler.semantics.analyzer.TypeHashVisitor;
import org.wso2.ballerinalang.compiler.semantics.analyzer.Types;
import org.wso2.ballerinalang.compiler.semantics.model.Scope;
import org.wso2.ballerinalang.compiler.semantics.model.SymbolTable;
import org.wso2.ballerinalang.compiler.semantics.model.symbols.BObjectTypeSymbol;
import org.wso2.ballerinalang.compiler.semantics.model.symbols.BPackageSymbol;
import org.wso2.ballerinalang.compiler.semantics.model.symbols.BSymbol;
import org.wso2.ballerinalang.compiler.semantics.model.symbols.Symbols;
import org.wso2.ballerinalang.compiler.semantics.model.types.BInvokableType;
import org.wso2.ballerinalang.compiler.semantics.model.types.BType;
import org.wso2.ballerinalang.compiler.util.Name;
import org.wso2.ballerinalang.compiler.util.Names;
import org.wso2.ballerinalang.compiler.util.TypeTags;
import org.wso2.ballerinalang.compiler.util.Unifier;
import org.wso2.ballerinalang.util.Flags;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;

import static org.ballerinalang.model.symbols.SymbolOrigin.VIRTUAL;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.BALLERINA;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.CLASS_FILE_SUFFIX;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.CURRENT_MODULE_VAR_NAME;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.ENCODED_DOT_CHARACTER;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.ENCODED_JAVA_MODULE;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.GLOBAL_VARIABLES_PACKAGE_NAME;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.JVM_INIT_METHOD;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.JVM_STATIC_INIT_METHOD;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.LOCK_STORE;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.LOCK_STORE_VAR_NAME;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.MAIN_METHOD;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.MAX_GENERATED_METHODS_PER_CLASS;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.MODULE_EXECUTE_METHOD;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.MODULE_GENERATED_FUNCTIONS_CLASS_NAME;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.MODULE_INIT_CLASS_NAME;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.MODULE_STARTED;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.MODULE_START_ATTEMPTED;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.MODULE_STOP_METHOD;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.NO_OF_DEPENDANT_MODULES;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.OBJECT;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.PARENT_MODULE_START_ATTEMPTED;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.SERVICE_EP_AVAILABLE;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.TEST_EXECUTE_METHOD;
import static org.wso2.ballerinalang.compiler.bir.codegen.JvmConstants.VALUE_CREATOR;
import static org.wso2.ballerinalang.compiler.bir.codegen.utils.JvmCodeGenUtil.isExternFunc;
import static org.wso2.ballerinalang.compiler.bir.codegen.utils.JvmCodeGenUtil.toNameString;
import static org.wso2.ballerinalang.compiler.bir.codegen.utils.JvmModuleUtils.getModuleLevelClassName;
import static org.wso2.ballerinalang.compiler.bir.codegen.utils.JvmModuleUtils.getPackageName;
import static org.wso2.ballerinalang.compiler.bir.codegen.utils.JvmModuleUtils.isBallerinaBuiltinModule;
import static org.wso2.ballerinalang.compiler.bir.codegen.utils.JvmModuleUtils.isSameModule;

/**
 * BIR module to JVM byte code generation class.
 *
 * @since 1.2.0
 */
public class JvmPackageGen {

    private static final Unifier unifier = new Unifier();
    public final SymbolTable symbolTable;
    public final PackageCache packageCache;
    private final Map<String, BIRFunctionWrapper> birFunctionMap;
    private final BLangDiagnosticLog dlog;
    public final Types types;
    private final Env typeEnv;
    public final BIRPackage currentModule;

    JvmPackageGen(BIRNode.BIRPackage currentModule, SymbolTable symbolTable, PackageCache packageCache,
                  BLangDiagnosticLog dlog, Types types, boolean isRemoteMgtEnabled) {
        birFunctionMap = new HashMap<>();
        this.symbolTable = symbolTable;
        this.packageCache = packageCache;
        this.dlog = dlog;
        this.types = types;
        this.typeEnv = symbolTable.typeEnv();
        this.currentModule = currentModule;
    }

    private static String getBvmAlias(String orgName, String moduleName) {
        if (Names.ANON_ORG.value.equals(orgName)) {
            return moduleName;
        }
        return orgName + "/" + moduleName;
    }

    private static void addBuiltinImports(BIRPackage birPackage, Set<PackageID> dependentModuleArray) {
        // Add the builtin and utils modules to the imported list of modules
        PackageID currentModule = birPackage.packageID;
        if (isSameModule(currentModule, PackageID.ANNOTATIONS)) {
            return;
        }
        dependentModuleArray.add(PackageID.ANNOTATIONS);
        if (isSameModule(currentModule, PackageID.JAVA)) {
            return;
        }

        if (isLangModule(currentModule) || hasNonLangLibImports(birPackage.importModules)) {
            return;
        }
        dependentModuleArray.add(PackageID.JAVA);
        dependentModuleArray.add(PackageID.INTERNAL);
        dependentModuleArray.add(PackageID.ARRAY);
        dependentModuleArray.add(PackageID.DECIMAL);
        dependentModuleArray.add(PackageID.VALUE);
        dependentModuleArray.add(PackageID.ERROR);
        dependentModuleArray.add(PackageID.FLOAT);
        dependentModuleArray.add(PackageID.FUNCTION);
        dependentModuleArray.add(PackageID.FUTURE);
        dependentModuleArray.add(PackageID.INT);
        dependentModuleArray.add(PackageID.MAP);
        dependentModuleArray.add(PackageID.OBJECT);
        dependentModuleArray.add(PackageID.STREAM);
        dependentModuleArray.add(PackageID.REGEXP);
        dependentModuleArray.add(PackageID.STRING);
        dependentModuleArray.add(PackageID.TABLE);
        dependentModuleArray.add(PackageID.XML);
        dependentModuleArray.add(PackageID.TYPEDESC);
        dependentModuleArray.add(PackageID.BOOLEAN);
        dependentModuleArray.add(PackageID.QUERY);
        dependentModuleArray.add(PackageID.TRANSACTION);
    }

    private static boolean hasNonLangLibImports(Set<BIRNode.BIRImportModule> importModules) {
        for (BIRNode.BIRImportModule importModule : importModules) {
            if (!BALLERINA.equals(importModule.packageID.orgName.value)) {
                return true;
            }
        }
        return false;
    }

    public static boolean isLangModule(PackageID moduleId) {
        if (!BALLERINA.equals(moduleId.orgName.value)) {
            return false;
        }
        return moduleId.name.value.startsWith("lang" + ENCODED_DOT_CHARACTER) ||
                moduleId.name.value.equals(ENCODED_JAVA_MODULE);
    }

    // Stub methods for JVM bytecode generation - not supported in web compiler
    // Removed to eliminate ASM dependency

    public static BIRFunctionWrapper getFunctionWrapper(Env typeEnv, BIRFunction currentFunc, PackageID packageID,
                                                        String moduleClass) {
        BInvokableType functionTypeDesc = currentFunc.type;
        BIRVariableDcl receiver = currentFunc.receiver;

        BType retType = functionTypeDesc.retType;
        if (isExternFunc(currentFunc) && Symbols.isFlagOn(retType.getFlags(), Flags.PARAMETERIZED)) {
            retType = unifier.build(typeEnv, retType);
        }
        String jvmMethodDescription;
        if (receiver == null) {
            jvmMethodDescription = JvmCodeGenUtil.getMethodDesc(typeEnv, functionTypeDesc.paramTypes, retType);
        } else {
            jvmMethodDescription = JvmCodeGenUtil.getMethodDesc(typeEnv, functionTypeDesc.paramTypes, retType,
                    receiver.type);
        }
        return new BIRFunctionWrapper(packageID, currentFunc, moduleClass, jvmMethodDescription);
    }

    private static BIRFunction findFunction(BIRNode parentNode, String funcName) {
        BIRFunction func;
        if (parentNode instanceof BIRTypeDefinition typeDef) {
            func = findFunction(typeDef.attachedFuncs, funcName);
        } else if (parentNode instanceof BIRPackage pkg) {
            func = findFunction(pkg.functions, funcName);
        } else {
            // some generated functions will not have bir function
            return null;
        }
        return func;
    }

    private static BIRFunction findFunction(List<BIRFunction> functions, String funcName) {
        for (BIRFunction func : functions) {
            if (func.name.value.equals(funcName)) {
                return func;
            }
        }
        return null;
    }

    // generateModuleClasses removed - JVM bytecode generation not supported

    /**
     * Java Class will be generated for each source file. This method add class mappings to globalVar and filters the
     * functions based on their source file name and then returns map of associated java class contents.
     *
     * @param module           bir module
     * @param initClass        module init class name
     * @param isEntry          is entry module flag
     * @return The map of javaClass records on given source file name
     */
    private Map<String, JavaClass> generateClassNameLinking(BIRPackage module, String initClass, boolean isEntry) {

        Map<String, JavaClass> jvmClassMap = new HashMap<>();

        // link module functions with class names

        linkModuleFunctions(module, initClass, isEntry, jvmClassMap);

        // link module stop function that will be generated
        linkModuleFunction(module.packageID, initClass, MODULE_STOP_METHOD);

        // link module execute function that will be generated
        linkModuleFunction(module.packageID, initClass, MODULE_EXECUTE_METHOD);

        // link typedef - object attached native functions
        linkTypeDefinitions(module, isEntry);
        return jvmClassMap;
    }

    private void linkTypeDefinitions(BIRPackage module, boolean isEntry) {
        throw new RuntimeException();
    }

    private void linkModuleFunction(PackageID packageID, String initClass, String funcName) {
        BInvokableType funcType =
                new BInvokableType(typeEnv, Collections.emptyList(), null, symbolTable.nilType, null);
        BIRFunction moduleStopFunction = new BIRFunction(null, new Name(funcName), 0, funcType, new Name(""), 0,
                VIRTUAL);
        birFunctionMap.put(getPackageName(packageID) + funcName, getFunctionWrapper(typeEnv, moduleStopFunction,
                packageID, initClass));
    }

    private void linkModuleFunctions(BIRPackage birPackage, String initClass, boolean isEntry,
                                     Map<String, JavaClass> jvmClassMap) {
        // filter out functions.
        List<BIRFunction> functions = birPackage.functions;
        if (functions.isEmpty()) {
            return;
        }
        int funcSize = functions.size();
        int count = 0;
        // Generate init class. Init function should be the first function of the package, hence check first
        // function.
        BIRFunction initFunc = functions.getFirst();
        String functionName = Utils.encodeFunctionIdentifier(initFunc.name.value);
        String fileName = initFunc.pos.lineRange().fileName();
        JavaClass klass = new JavaClass(fileName, fileName);
        klass.functions.addFirst(initFunc);
        PackageID packageID = birPackage.packageID;
        jvmClassMap.put(initClass, klass);
        String pkgName = getPackageName(packageID);
        birFunctionMap.put(pkgName + functionName, getFunctionWrapper(typeEnv, initFunc, packageID, initClass));
        count += 1;

        // Add start function
        BIRFunction startFunc = functions.get(1);
        functionName = Utils.encodeFunctionIdentifier(startFunc.name.value);
        birFunctionMap.put(pkgName + functionName, getFunctionWrapper(typeEnv, startFunc, packageID, initClass));
        klass.functions.add(1, startFunc);
        count += 1;

        // Add stop function
        BIRFunction stopFunc = functions.get(2);
        functionName = Utils.encodeFunctionIdentifier(stopFunc.name.value);
        birFunctionMap.put(pkgName + functionName, getFunctionWrapper(typeEnv, stopFunc, packageID, initClass));
        klass.functions.add(2, stopFunc);
        count += 1;
        int genMethodsCount = 0;
        int genClassNum = 0;

        // Generate classes for other functions.
        while (count < funcSize) {
            BIRFunction birFunc = functions.get(count);
            count = count + 1;
            // link the bir function for lookup
            String birFuncName = birFunc.name.value;
            String balFileName;
            if (birFunc.pos == symbolTable.builtinPos) {
                balFileName = MODULE_INIT_CLASS_NAME;
            }  else if (birFunc.pos == null) {
                balFileName = MODULE_GENERATED_FUNCTIONS_CLASS_NAME + genClassNum;
                if (genMethodsCount > MAX_GENERATED_METHODS_PER_CLASS) {
                    genMethodsCount = 0;
                    genClassNum++;
                } else {
                    genMethodsCount++;
                }
            } else {
                balFileName = birFunc.pos.lineRange().fileName();
            }

            String cleanedBalFileName = balFileName;
            if (!birFunc.name.value.startsWith(".<test")) {
                // skip removing `.bal` from generated file names. otherwise `.<testinit>` brakes because,
                // it's "file name" may end in `.bal` due to module. see #27201
                cleanedBalFileName = JvmCodeGenUtil.cleanupPathSeparators(balFileName);
            }
            String birModuleClassName = getModuleLevelClassName(packageID, cleanedBalFileName);

            if (!isBallerinaBuiltinModule(packageID.orgName.value, packageID.name.value)) {
                JavaClass javaClass = jvmClassMap.get(birModuleClassName);
                if (javaClass != null) {
                    javaClass.functions.add(birFunc);
                } else {
                    klass = new JavaClass(balFileName, cleanedBalFileName);
                    klass.functions.addFirst(birFunc);
                    jvmClassMap.put(birModuleClassName, klass);
                }
            }
            try {
                BIRFunctionWrapper birFuncWrapperOrError = getBirFunctionWrapper(isEntry, packageID, birFunc,
                        birModuleClassName);
                birFunctionMap.put(pkgName + birFuncName, birFuncWrapperOrError);
            } catch (JInteropException e) {
                dlog.error(birFunc.pos, e.getCode(), e.getMessage());
            }
        }
    }

    private BIRFunctionWrapper getBirFunctionWrapper(boolean isEntry, PackageID packageID,
                                                     BIRFunction birFunc, String birModuleClassName) {
        // Simplified: only non-extern case since generate() throws exception anyway
        return getFunctionWrapper(typeEnv, birFunc, packageID, birModuleClassName);
    }

    // getBytes removed - JVM bytecode generation not supported

    private void clearPackageGenInfo() {
        birFunctionMap.clear();
    }

    public BIRFunctionWrapper lookupBIRFunctionWrapper(String lookupKey) {
        return this.birFunctionMap.get(lookupKey);
    }

    BType lookupTypeDef(NewInstance objectNewIns) {
        if (!objectNewIns.isExternalDef) {
            return objectNewIns.def.type;
        } else {
            PackageID id = objectNewIns.externalPackageId;
            assert id != null;
            BPackageSymbol symbol = packageCache.getSymbol(id.orgName + "/" + id.name);
            if (symbol != null) {
                Name lookupKey = new Name(Utils.decodeIdentifier(objectNewIns.objectName));
                BSymbol typeSymbol = symbol.scope.lookup(lookupKey).symbol;
                BObjectTypeSymbol objectTypeSymbol;
                if (typeSymbol.kind == SymbolKind.TYPE_DEF) {
                    objectTypeSymbol = (BObjectTypeSymbol) typeSymbol.type.tsymbol;
                } else {
                    //class symbols
                    objectTypeSymbol = (BObjectTypeSymbol) typeSymbol;
                }
                if (objectTypeSymbol != null) {
                    return objectTypeSymbol.type;
                }
            }
            throw new BLangCompilerException("Reference to unknown type " + objectNewIns.externalPackageId
                    + "/" + objectNewIns.objectName);
        }
    }

    CompiledJarFile generate() {
        throw new UnsupportedOperationException(
                "JVM bytecode generation is not supported in the web compiler. " +
                "The web compiler only runs up to BIR (Ballerina Intermediate Representation) stage.");
    }

    private List<BIRTypeDefinition> filterRecordTypes() {
        List<BIRTypeDefinition> recordTypes = new ArrayList<>();
        for (BIRTypeDefinition typeDef : currentModule.typeDefs) {
            if (typeDef.type.tag == TypeTags.RECORD && !Symbols.isFlagOn(typeDef.type.tsymbol.flags, Flags.ANONYMOUS)) {
                recordTypes.add(typeDef);
            }
        }
        return recordTypes;
    }

    private void removeSourceAnnotationTypeDefs(List<BIRTypeDefinition> typeDefs) {
        typeDefs.removeIf(def -> Symbols.isFlagOn(def.flags, Flags.SOURCE_ANNOTATION));
    }

    private BIRFunction getMainFunction(BIRPackage module) {
        BIRFunction mainFunc = null;
        if (module.packageID.skipTests) {
            mainFunc = getFunction(module, MAIN_METHOD);
        }
        return mainFunc;
    }

    private BIRFunction getTestExecuteFunction(BIRPackage module) {
        BIRFunction testExecuteFunc = null;
        if (!module.packageID.skipTests) {
            testExecuteFunc = getFunction(module, TEST_EXECUTE_METHOD);
        }
        return testExecuteFunc;
    }

    private BIRFunction getFunction(BIRPackage module, String funcName) {
        BIRFunction function = null;
        for (BIRFunction birFunc : module.functions) {
            if (birFunc.name.value.equals(funcName)) {
                function = birFunc;
                break;
            }
        }
        return function;
    }

    private boolean listenerDeclarationFound(BPackageSymbol packageSymbol) {
        if (packageSymbol.bir == null) {
            for (Scope.ScopeEntry entry : packageSymbol.scope.entries.values()) {
                BSymbol symbol = entry.symbol;
                if (symbol != null && Symbols.isFlagOn(symbol.flags, Flags.LISTENER)) {
                    return true;
                }
            }
        } else {
            return packageSymbol.bir.isListenerAvailable;
        }
        for (BPackageSymbol importPkgSymbol : packageSymbol.imports) {
            if (importPkgSymbol != null && listenerDeclarationFound(importPkgSymbol)) {
                return true;
            }
        }
        return false;
    }
}
