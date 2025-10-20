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
package org.wso2.ballerinalang.compiler.bir.codegen.model;

import java.util.Objects;

import org.ballerinalang.model.elements.PackageID;
import org.wso2.ballerinalang.compiler.bir.model.BIRNode;

/**
 * A wrapper used with JInterop to wrap Ballerina Functions with JFunc description and data.
 *
 * @since 1.2.0
 *
 */
public final class BIRFunctionWrapper {

    private final PackageID packageID;
    private final BIRNode.BIRFunction func;
    private final String fullQualifiedClassName;
    private final String jvmMethodDescription;

    /**
     * @param packageID              Package ID
     * @param func                   BIR function
     * @param fullQualifiedClassName full qualified class name
     * @param jvmMethodDescription   JVM method description
     */
    public BIRFunctionWrapper(PackageID packageID, BIRNode.BIRFunction func, String fullQualifiedClassName,
                              String jvmMethodDescription) {
        this.packageID = packageID;
        this.func = func;
        this.fullQualifiedClassName = fullQualifiedClassName;
        this.jvmMethodDescription = jvmMethodDescription;
    }

    public PackageID packageID() {
        return packageID;
    }

    public BIRNode.BIRFunction func() {
        return func;
    }

    public String fullQualifiedClassName() {
        return fullQualifiedClassName;
    }

    public String jvmMethodDescription() {
        return jvmMethodDescription;
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) return true;
        if (obj == null || obj.getClass() != this.getClass()) return false;
        var that = (BIRFunctionWrapper) obj;
        return Objects.equals(this.packageID, that.packageID) &&
                Objects.equals(this.func, that.func) &&
                Objects.equals(this.fullQualifiedClassName, that.fullQualifiedClassName) &&
                Objects.equals(this.jvmMethodDescription, that.jvmMethodDescription);
    }

    @Override
    public int hashCode() {
        return Objects.hash(packageID, func, fullQualifiedClassName, jvmMethodDescription);
    }

    @Override
    public String toString() {
        return "BIRFunctionWrapper[" +
                "packageID=" + packageID + ", " +
                "func=" + func + ", " +
                "fullQualifiedClassName=" + fullQualifiedClassName + ", " +
                "jvmMethodDescription=" + jvmMethodDescription + ']';
    }

}
