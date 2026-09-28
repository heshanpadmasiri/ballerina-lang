package org.ballerinalang.test.javainterop;

import io.ballerina.runtime.api.values.BFuture;
import io.ballerina.runtime.internal.values.ArrayValue;
import io.ballerina.runtime.internal.values.FPValue;

public class RefTypeNegativeTests {
    public static int getAllInts() {
        return 3;
    }

    public static int acceptAllInts(int x) {
        return x;
    }

    public static float getAllFloats() {
        return (float) 3.54;
    }

    public static int acceptAllFloats(float x) {
        return (int) x;
    }

    public static void acceptImmutableValue(int m) {
    }

    public static Object acceptAndReturnImmutableArray(ArrayValue a) {
        return a;
    }

    public static void acceptReadOnlyValue(long r) {
    }

    public static BFuture returnReadOnlyValue(FPValue f) {
        return null;
    }
}
