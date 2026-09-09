package org.ballerinalang.nativeimpl.jvm.tests;

public class ClassWithDefaultConstructor extends AbstractClass {
    private final int a;

    public ClassWithDefaultConstructor() {
        a = 11;
    }

    public Integer getValue() {
        return a;
    }
}
