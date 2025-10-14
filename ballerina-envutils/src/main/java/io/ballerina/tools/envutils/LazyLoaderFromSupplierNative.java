package io.ballerina.tools.envutils;

import java.lang.ref.WeakReference;

public class LazyLoaderFromSupplierNative<T> extends LazyLoaderFromSupplier<T> {
    private WeakReference<T> valueRef;

    public LazyLoaderFromSupplierNative(java.util.function.Supplier<T> supplier) {
        super(supplier);
        valueRef = new WeakReference<>(null);
    }

    @Override
    public T get() {
        T cached = valueRef.get();
        if (cached == null) {
            cached = super.supplier.get();
            valueRef = new WeakReference<>(cached);
        }
        return cached;
    }

}
