package org.ballerinalang.nativeimpl.jvm.tests;

import io.ballerina.runtime.api.creators.ErrorCreator;
import io.ballerina.runtime.api.utils.StringUtils;

import java.util.Arrays;

public final class StaticMethods {
    private StaticMethods() {
    }

    public static void errorStacktraceTest() {
        foo();
    }

    static void foo() {
        bar();
    }

    static void bar() {
        Arrays.asList(0).forEach(i -> {
            throw ErrorCreator.createError(StringUtils.fromString("error!!!"));
        });
    }
}
