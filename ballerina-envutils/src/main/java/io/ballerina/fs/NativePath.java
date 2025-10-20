package io.ballerina.fs;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

class NativePath implements io.ballerina.fs.Path {
    private final Path nativePath;

    private NativePath(Path nativePath) {
        this.nativePath = nativePath;
    }

    public NativePath(String first, String... more) {
        this(Path.of(first, more));
    }

    @Override
    public io.ballerina.fs.Path toAbsolutePath() {
        return new NativePath(nativePath.toAbsolutePath());
    }

    @Override
    public io.ballerina.fs.Path normalize() {
        return new NativePath(nativePath.normalize());
    }

    @Override
    public io.ballerina.fs.File toFile() {
        return new NativeFile(nativePath.toFile());
    }

    @Override
    public boolean isAbsolute() {
        return nativePath.isAbsolute();
    }

    @Override
    public io.ballerina.fs.Path resolve(io.ballerina.fs.Path relativePath) {
        if (relativePath instanceof NativePath other) {
            return new NativePath(nativePath.resolve(other.nativePath));
        }
        throw new IllegalArgumentException("Incompatible path type");
    }

    @Override
    public io.ballerina.fs.Path getFileName() {
        return new NativePath(nativePath.getFileName());
    }

    @Override
    public io.ballerina.fs.Path getParent() {
        return new NativePath(nativePath.getParent());
    }

    @Override
    public io.ballerina.fs.Path resolve(String other) {
        return new NativePath(nativePath.resolve(other));
    }

    @Override
    public boolean isDirectory() {
        return nativePath.toFile().isDirectory();
    }

    @Override
    public boolean exists() {
        return nativePath.toFile().exists();
    }

    @Override
    public boolean isRegularFile() {
        return Files.isRegularFile(nativePath);
    }

    @Override
    public boolean canWrite() {
        return nativePath.toFile().canWrite();
    }

    @Override
    public boolean canRead() {
        return nativePath.toFile().canRead();
    }

    @Override
    public boolean canExecute() {
        return nativePath.toFile().canExecute();
    }

    @Override
    public void createDirectories() {
        throw new RuntimeException();
    }

    @Override
    public boolean deleteDirectory() {
        return deleteDirectory(nativePath);
    }

    @Override
    public void deleteIfExists() throws IOException {
       throw new RuntimeException();
    }

    @Override
    public boolean notExists() {
        throw new RuntimeException();
    }

    @Override
    public void delete() {
        throw new RuntimeException();
    }

    @Override
    public void createFile() {
        throw new RuntimeException();
    }

    @Override
    public String readString() {
        throw new RuntimeException();
    }

    private  static boolean  deleteDirectory(Path path) {
        File file = new File(String.valueOf(path));
        if (file.isDirectory()) {
            File[] files = file.listFiles();
            if (files != null) {
                for (File f : files) {
                    boolean success = deleteDirectory(f.toPath());
                    if (!success) {
                        return false;
                    }
                }
            }
        }
        return file.delete();
    }

    @Override
    public String toString() {
        return nativePath.toString();
    }

    @Override
    public int compareTo(io.ballerina.fs.Path o) {
        return this.nativePath.compareTo(((NativePath) o).nativePath);
    }
}
