package io.ballerina.tools.envutils;

public class LazyLoaderFromSupplierWeb<T> extends LazyLoaderFromSupplier<T> {

    public LazyLoaderFromSupplierWeb(java.util.function.Supplier<T> supplier) {
        super(supplier);
    }

    @Override
    public T get() {
        return supplier.get();
    }

}
