package org.ballerinalang.nativeimpl.jvm.tests;

public class ClassWithOneParamConstructor {
    private String str = "Hello ";

    public ClassWithOneParamConstructor(String name) {
        this.str = this.str + name;
    }

    public String getValue() {
        return this.str;
    }
}
