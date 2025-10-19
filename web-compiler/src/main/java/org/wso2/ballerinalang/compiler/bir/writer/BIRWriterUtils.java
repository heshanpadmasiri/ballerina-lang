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
 *
 */

package org.wso2.ballerinalang.compiler.bir.writer;

import io.ballerina.tools.diagnostics.Location;
import org.ballerinalang.model.elements.PackageID;
import org.ballerinalang.model.symbols.AnnotationAttachmentSymbol;
import org.wso2.ballerinalang.compiler.bir.model.BIRNode;
import org.wso2.ballerinalang.compiler.semantics.analyzer.Types;
import org.wso2.ballerinalang.compiler.semantics.model.symbols.BAnnotationAttachmentSymbol;
import org.wso2.ballerinalang.compiler.semantics.model.types.BType;
import org.wso2.ballerinalang.compiler.tree.BLangConstantValue;
import org.wso2.ballerinalang.compiler.util.Name;
import org.wso2.ballerinalang.compiler.util.TypeTags;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Common functions used in BIR writers.
 *
 * @since 2.0.0
 */
public final class BIRWriterUtils {

    private BIRWriterUtils() {
    }

    public static List<BIRNode.BIRAnnotationAttachment> getBIRAnnotAttachments(
            List<? extends AnnotationAttachmentSymbol> astAnnotAttachments) {
        List<BIRNode.BIRAnnotationAttachment> annotationAttachments = new ArrayList<>(astAnnotAttachments.size());
        for (AnnotationAttachmentSymbol annotationAttachmentSymbol : astAnnotAttachments) {
            annotationAttachments.add(createBIRAnnotationAttachment(
                    (BAnnotationAttachmentSymbol) annotationAttachmentSymbol));
        }
        return annotationAttachments;
    }

    public static BIRNode.BIRAnnotationAttachment createBIRAnnotationAttachment(
            BAnnotationAttachmentSymbol annotAttachmentSymbol) {
        Location pos = annotAttachmentSymbol.pos;
        PackageID annotPkgID = annotAttachmentSymbol.annotPkgID;
        Name annotTag = annotAttachmentSymbol.annotTag;

        if (!annotAttachmentSymbol.isConstAnnotation()) {
            return new BIRNode.BIRAnnotationAttachment(pos, annotPkgID, annotTag);
        }

        BLangConstantValue attachmentValue =
                ((BAnnotationAttachmentSymbol.BConstAnnotationAttachmentSymbol) annotAttachmentSymbol)
                        .attachmentValueSymbol.value;
        return new BIRNode.BIRConstAnnotationAttachment(pos, annotPkgID, annotTag, getBIRConstantVal(attachmentValue));
    }

    public static BIRNode.ConstValue getBIRConstantVal(BLangConstantValue constValue) {
        BType type = constValue.type;
        int tag = Types.getImpliedType(type).tag;

        if (tag == TypeTags.RECORD) {
            Map<String, BIRNode.ConstValue> mapConstVal = new HashMap<>();
            ((Map<String, BLangConstantValue>) constValue.value)
                    .forEach((key, value) -> mapConstVal.put(key, getBIRConstantVal(value)));
            return new BIRNode.ConstValue(mapConstVal, type);
        }

        if (tag == TypeTags.TUPLE) {
            List<BLangConstantValue> constantValueList = (List<BLangConstantValue>) constValue.value;
            BIRNode.ConstValue[] tupleConstVal = new BIRNode.ConstValue[constantValueList.size()];
            for (int exprIndex = 0; exprIndex < constantValueList.size(); exprIndex++) {
                tupleConstVal[exprIndex] = getBIRConstantVal(constantValueList.get(exprIndex));
            }
            return new BIRNode.ConstValue(tupleConstVal, type);
        }

        return new BIRNode.ConstValue(constValue.value, constValue.type);
    }
}
