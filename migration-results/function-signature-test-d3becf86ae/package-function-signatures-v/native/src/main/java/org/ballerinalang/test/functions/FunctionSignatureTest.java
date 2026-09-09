package org.ballerinalang.test.functions;

import io.ballerina.runtime.api.types.PredefinedTypes;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BString;
import io.ballerina.runtime.internal.types.BTupleType;
import io.ballerina.runtime.internal.values.ArrayValue;
import io.ballerina.runtime.internal.values.TupleValueImpl;

import java.util.Arrays;

public class FunctionSignatureTest {
    public static BArray mockedNativeFuncWithOptionalParams(long a, double b, BString c, long d, BString e) {
        BTupleType tupleType = new BTupleType(
                Arrays.asList(PredefinedTypes.TYPE_INT, PredefinedTypes.TYPE_FLOAT, PredefinedTypes.TYPE_STRING,
                        PredefinedTypes.TYPE_INT, PredefinedTypes.TYPE_STRING));
        ArrayValue tuple = new TupleValueImpl(tupleType);
        tuple.add(0, a);
        tuple.add(1, b);
        tuple.add(2, c);
        tuple.add(3, d);
        tuple.add(4, e);
        return tuple;
    }
}
