package org.ballerinalang.nativeimpl.jvm.servicetests;

import io.ballerina.identifier.Utils;
import io.ballerina.runtime.api.types.ServiceType;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.runtime.api.values.BValue;
import io.ballerina.runtime.internal.values.ArrayValue;

/** Provides the resource-annotation lookup exercised by this migrated test. */
public final class ServiceValue {
    private ServiceValue() {
    }

    public static BValue getResourceMethodAnnotations(BObject service, BString method,
                                                       ArrayValue resourcePath, BString annotName) {
        String methodName = generateMethodName(method, resourcePath);
        for (var methodType : ((ServiceType) service.getType()).getResourceMethods()) {
            if (methodType.getName().equals(methodName)) {
                BValue annotation = (BValue) methodType.getAnnotation(annotName);
                if (annotation != null) {
                    return annotation;
                }
                for (BString annotationKey : methodType.getAnnotations().getKeys()) {
                    if (annotationKey.getValue().endsWith(":" + annotName.getValue())) {
                        return (BValue) methodType.getAnnotation(annotationKey);
                    }
                }
            }
        }
        return null;
    }

    private static String generateMethodName(BString methodName, ArrayValue path) {
        StringBuilder functionName = new StringBuilder("$").append(methodName.getValue());
        for (int i = 0; i < path.size(); i++) {
            functionName.append("$").append(path.getBString(i).getValue());
        }
        return Utils.encodeFunctionIdentifier(functionName.toString());
    }
}
