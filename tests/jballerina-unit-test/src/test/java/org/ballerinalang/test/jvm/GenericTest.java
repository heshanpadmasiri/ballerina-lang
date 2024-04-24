/*
 *  Copyright (c) 2024, WSO2 LLC. (http://www.wso2.com).
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

package org.ballerinalang.test.jvm;

import io.ballerina.tools.diagnostics.Diagnostic;
import org.ballerinalang.test.BCompileUtil;
import org.ballerinalang.test.CompileResult;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

public class GenericTest {

    private CompileResult compileResult;

    @BeforeClass
    public void setup() {
        compileResult = BCompileUtil.compile("test-src/jvm/TypeParam");
    }

    @Test
    public void testTypeParam() {
        for (Diagnostic diagnostics : compileResult.getDiagnostics()) {
            System.err.println(diagnostics);
        }
        assert compileResult.getErrorCount() == 0;
    }
}
