package io.ballerina.tools.envutils;

import java.util.function.Supplier;

public abstract class LazyLoaderFromSupplier <T> {
    protected final Supplier<T> supplier;

    protected LazyLoaderFromSupplier(Supplier<T> supplier) {
        this.supplier = supplier;
    }

    public abstract T get();
}
