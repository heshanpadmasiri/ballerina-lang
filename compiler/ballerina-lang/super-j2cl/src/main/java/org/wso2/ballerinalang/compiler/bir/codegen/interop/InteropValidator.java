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

import io.ballerina.projects.CompilerBackend;
import io.ballerina.projects.ModuleId;
import org.wso2.ballerinalang.compiler.diagnostic.BLangDiagnosticLog;
import org.wso2.ballerinalang.compiler.semantics.model.SymbolTable;
import org.wso2.ballerinalang.compiler.tree.BLangPackage;
import org.wso2.ballerinalang.compiler.util.CompilerContext;

/**
 * Stub Java interop validation class for web version.
 * This class provides the interface expected by the compiler pipeline
 * but performs no validation since JVM interop is not supported.
 *
 * @since 1.2.0
 */
public class InteropValidator {

    private static final CompilerContext.Key<InteropValidator> INTEROP_VALIDATE = new CompilerContext.Key<>();
    private final SymbolTable symbolTable;
    private final BLangDiagnosticLog dlog;

    private InteropValidator(CompilerContext compilerContext) {
        compilerContext.put(INTEROP_VALIDATE, this);
        this.symbolTable = SymbolTable.getInstance(compilerContext);
        this.dlog = BLangDiagnosticLog.getInstance(compilerContext);
    }

    public static InteropValidator getInstance(CompilerContext context) {
        InteropValidator interopValidator = context.get(INTEROP_VALIDATE);
        if (interopValidator == null) {
            interopValidator = new InteropValidator(context);
        }
        return interopValidator;
    }

    public void validate(ModuleId moduleId, CompilerBackend compilerBackend, BLangPackage bLangPackage) {
        // No-op: Java interop validation is not supported in web version
    }
}
