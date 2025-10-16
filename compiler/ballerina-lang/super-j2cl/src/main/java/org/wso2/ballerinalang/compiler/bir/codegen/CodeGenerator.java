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
package org.wso2.ballerinalang.compiler.bir.codegen;

import org.wso2.ballerinalang.compiler.PackageCache;
import org.wso2.ballerinalang.compiler.bir.codegen.internal.CompiledJarFile;
import org.wso2.ballerinalang.compiler.diagnostic.BLangDiagnosticLog;
import org.wso2.ballerinalang.compiler.semantics.analyzer.Types;
import org.wso2.ballerinalang.compiler.semantics.model.SymbolTable;
import org.wso2.ballerinalang.compiler.tree.BLangPackage;
import org.wso2.ballerinalang.compiler.util.CompilerContext;

/**
 * Stub JVM byte code generator for web version.
 * This class provides the interface expected by the compiler pipeline
 * but throws RuntimeException when bytecode generation is attempted.
 *
 * @since 1.2.0
 */
public class CodeGenerator {

    private static final CompilerContext.Key<CodeGenerator> CODE_GEN = new CompilerContext.Key<>();
    private final SymbolTable symbolTable;
    private final PackageCache packageCache;
    private final BLangDiagnosticLog dlog;
    private final Types types;

    private CodeGenerator(CompilerContext compilerContext) {
        compilerContext.put(CODE_GEN, this);
        this.symbolTable = SymbolTable.getInstance(compilerContext);
        this.packageCache = PackageCache.getInstance(compilerContext);
        this.dlog = BLangDiagnosticLog.getInstance(compilerContext);
        this.types = Types.getInstance(compilerContext);
    }

    public static CodeGenerator getInstance(CompilerContext context) {
        CodeGenerator codeGenerator = context.get(CODE_GEN);
        if (codeGenerator == null) {
            codeGenerator = new CodeGenerator(context);
        }
        return codeGenerator;
    }

    public CompiledJarFile generate(BLangPackage bLangPackage, boolean isRemoteMgtEnabled) {
        throw new RuntimeException("JVM bytecode generation is not supported in the web version. Use BIR emission instead.");
    }

    public CompiledJarFile generateTestModule(BLangPackage bLangTestablePackage, boolean isRemoteMgtEnabled) {
        throw new RuntimeException("JVM bytecode generation is not supported in the web version. Use BIR emission instead.");
    }
}
