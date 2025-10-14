package io.ballerina.tools.envutils;

import java.util.function.Supplier;

public class Env {
    public static <T> LazyLoaderFromSupplier<T> createLazyLoader(Supplier<T> supplier) {
        return new LazyLoaderFromSupplierNative<>(supplier);
    }

}
