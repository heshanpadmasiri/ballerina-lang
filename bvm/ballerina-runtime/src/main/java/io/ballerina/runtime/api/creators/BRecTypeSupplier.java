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
 */

package io.ballerina.runtime.api.creators;

import io.ballerina.runtime.api.types.Type;
import io.ballerina.runtime.internal.types.BMapType;
import io.ballerina.runtime.internal.types.BTableType;
import io.ballerina.runtime.internal.types.semtype.BSemType;
import io.ballerina.runtime.internal.types.semtype.SemTypeUtils;

public final class BRecTypeSupplier implements TypeSupplier {

    private final TypeSupplier constrainSupplier;
    private final boolean isReadonly;
    private final UnderlyingType underlyingType;
    private Type type = null;
    private BSemType semType = null;

    private BRecTypeSupplier(TypeSupplier constrainSupplier, boolean isReadonly, UnderlyingType underlyingType) {
        this.constrainSupplier = constrainSupplier;
        this.isReadonly = isReadonly;
        this.underlyingType = underlyingType;
    }

    public static BRecTypeSupplier createMap(TypeSupplier constrainSupplier, boolean isReadonly) {
        return new BRecTypeSupplier(constrainSupplier, isReadonly, UnderlyingType.MAP);
    }

    public static BRecTypeSupplier createTable(TypeSupplier constrainSupplier, boolean isReadonly) {
        return new BRecTypeSupplier(constrainSupplier, isReadonly, UnderlyingType.TABLE);
    }

    @Override
    public BSemType get() {
        if (semType != null) {
            return semType;
        }
        if (type != null) {
            semType = SemTypeUtils.SemTypeBuilder.from(type);
            return semType;
        }
        switch (underlyingType) {
            case MAP -> {
                BMapType bMapType = new BMapType();
                type = bMapType;
                bMapType.setValues(constrainSupplier.get(), isReadonly);
            }
            case TABLE -> {
                BTableType bTableType = new BTableType();
                type = bTableType;
                bTableType.setValues(constrainSupplier.get(), isReadonly);
            }
        }
        return SemTypeUtils.SemTypeBuilder.from(type);
    }

    private enum UnderlyingType {
        MAP,
        TABLE
    }
}
