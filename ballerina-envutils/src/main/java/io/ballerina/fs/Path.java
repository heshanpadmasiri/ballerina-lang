package io.ballerina.fs;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;

public interface Path extends Comparable<Path> {

    static Path of(String first, String... more) {
        return new NativePath(first, more);
    }

    Path toAbsolutePath();

    Path normalize();

    // FIXME: this also needs to be fixed
    File toFile();

    boolean isAbsolute();

    Path resolve(Path relativePath);

    Path getFileName();

    Path getParent();

    Path resolve(String name);

    boolean isDirectory();

    boolean exists();

    boolean isRegularFile();

    boolean canWrite();

    boolean canRead();

    boolean canExecute();

    void createDirectories();

    boolean deleteDirectory();

    BufferedReader bufferedReader();

    void deleteIfExists() throws IOException;

    boolean notExists();

    void delete();

    void createFile();

    String readString();
}
