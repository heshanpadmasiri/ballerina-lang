package org.ballerinalang.test.javainterop.varargs;

import io.ballerina.runtime.internal.values.ArrayValue;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.StringJoiner;

/** Java support for the varargs interop migration case. */
public class JavaVarargsTest {

    public static int getSum(int... vals) {
        return Arrays.stream(vals).reduce(0, Integer::sum);
    }

    public static int getMax(int a, int b, int... vals) {
        return Integer.max(Integer.max(a, b), Arrays.stream(vals).reduce(0, Integer::max));
    }

    public static long getLongSum(long... vals) {
        return Arrays.stream(vals).reduce(0, Long::sum);
    }

    public static int[] getIntArray(int size) {
        int[] array = new int[size];
        for (int i = 0; i < size; i++) {
            array[i] = i;
        }
        return array;
    }

    public static int getSumOfIntArrays(int[]... vals) {
        int sum = 0;
        for (int[] val : vals) {
            sum += Arrays.stream(val).reduce(0, Integer::sum);
        }
        return sum;
    }

    public static List<String> getList(String... vals) {
        return Arrays.asList(vals);
    }

    public static List<String> merge(List<String>... lists) {
        List<String> mergedList = new ArrayList<>();
        for (List<String> list : lists) {
            mergedList.addAll(list);
        }
        return mergedList;
    }

    public static int toShort(Object vals) {
        return ((Number) vals).shortValue();
    }

    public static <T> T getGenericValue(T value) {
        return value;
    }

    public static String getRefVararg(Object... values) {
        StringJoiner joiner = new StringJoiner(", ", "[", "]");
        for (Object value : values) {
            joiner.add(value.toString());
        }
        return joiner.toString();
    }

    public static String getArrayTypeVararg(ArrayValue... values) {
        StringJoiner joiner = new StringJoiner(", ", "[", "]");
        for (ArrayValue value : values) {
            joiner.add(value.toString());
        }
        return joiner.toString();
    }
}
