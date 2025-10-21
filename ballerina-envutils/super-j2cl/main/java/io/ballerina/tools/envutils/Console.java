package io.ballerina.tools.envutils;
import jsinterop.annotations.JsMethod;
import jsinterop.annotations.JsPackage;

public final class Console {
    private Console() {
    }

    @JsMethod(namespace = JsPackage.GLOBAL, name = "console.log")
    public static native void println(String message);

    @JsMethod(namespace = JsPackage.GLOBAL, name = "console.log")
    public static native void print(String message);

    @JsMethod(namespace = JsPackage.GLOBAL, name = "console.error")
    public static native void error(String message);

    @JsMethod(namespace = JsPackage.GLOBAL, name = "console.error")
    public static native void error(Object message);
}
