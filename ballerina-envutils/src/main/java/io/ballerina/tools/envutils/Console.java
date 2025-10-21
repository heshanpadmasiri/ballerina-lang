package io.ballerina.tools.envutils;

public final class Console {
    private Console() {
    }

    public static void println(String message) {
        System.out.println(message);
    }

    public static void print(String message) {
        System.out.print(message);
    }

    public static void error(String message) {
        System.err.println(message);
    }

    public static void error(Object message) {
        System.err.println(message.toString());
    }
}
