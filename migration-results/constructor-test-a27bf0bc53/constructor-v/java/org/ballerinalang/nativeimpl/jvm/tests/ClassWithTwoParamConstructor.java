package org.ballerinalang.nativeimpl.jvm.tests;

public class ClassWithTwoParamConstructor {
    private final String str;

    public ClassWithTwoParamConstructor(String prefix, String name) {
        this.str = prefix + name;
    }

    public String getValue() {
        return this.str;
    }
}
