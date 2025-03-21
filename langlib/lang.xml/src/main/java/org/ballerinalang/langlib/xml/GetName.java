/*
 *   Copyright (c) 2019, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  WSO2 Inc. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License.
 *  You may obtain a copy of the License at
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
package org.ballerinalang.langlib.xml;

import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.runtime.api.values.BXml;
import io.ballerina.runtime.internal.errors.ErrorCodes;
import io.ballerina.runtime.internal.errors.ErrorHelper;

/**
 * Returns the string giving the expanded name of provided xml element.
 *
 * @since 1.0
 */
public final class GetName {

    private static final String OPERATION = "get element name in xml";

    private GetName() {
    }

    public static BString getName(BXml xmlVal) {
        if (!IsElement.isElement(xmlVal)) {
            throw ErrorHelper.getRuntimeException(ErrorCodes.XML_FUNC_TYPE_ERROR, "getName", "element");
        }
        try {
            return StringUtils.fromString(xmlVal.getElementName());
        } catch (Throwable e) {
            ErrorHelper.handleXMLException(OPERATION, e);
        }

        return null;
    }
}
