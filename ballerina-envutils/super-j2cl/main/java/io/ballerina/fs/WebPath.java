package io.ballerina.fs;

import java.io.IOException;

class WebPath implements io.ballerina.fs.Path {

    public WebPath(String first, String... more) {
        // Stub constructor - no actual implementation needed
    }

    @Override
    public io.ballerina.fs.Path toAbsolutePath() {
        throw new RuntimeException("Path operations not supported in web environment");
    }

    @Override
    public io.ballerina.fs.Path normalize() {
        throw new RuntimeException("Path operations not supported in web environment");
    }

    @Override
    public io.ballerina.fs.File toFile() {
        throw new RuntimeException("Path operations not supported in web environment");
    }

    @Override
    public boolean isAbsolute() {
        throw new RuntimeException("Path operations not supported in web environment");
    }

    @Override
    public io.ballerina.fs.Path resolve(io.ballerina.fs.Path relativePath) {
        throw new RuntimeException("Path operations not supported in web environment");
    }

    @Override
    public io.ballerina.fs.Path getFileName() {
        throw new RuntimeException("Path operations not supported in web environment");
    }

    @Override
    public io.ballerina.fs.Path getParent() {
        throw new RuntimeException("Path operations not supported in web environment");
    }

    @Override
    public io.ballerina.fs.Path resolve(String other) {
        throw new RuntimeException("Path operations not supported in web environment");
    }

    @Override
    public boolean isDirectory() {
        throw new RuntimeException("Path operations not supported in web environment");
    }

    @Override
    public boolean exists() {
        throw new RuntimeException("Path operations not supported in web environment");
    }

    @Override
    public boolean isRegularFile() {
        throw new RuntimeException("Path operations not supported in web environment");
    }

    @Override
    public boolean canWrite() {
        throw new RuntimeException("Path operations not supported in web environment");
    }

    @Override
    public boolean canRead() {
        throw new RuntimeException("Path operations not supported in web environment");
    }

    @Override
    public boolean canExecute() {
        throw new RuntimeException("Path operations not supported in web environment");
    }

    @Override
    public void createDirectories() {
        throw new RuntimeException("Path operations not supported in web environment");
    }

    @Override
    public boolean deleteDirectory() {
        throw new RuntimeException("Path operations not supported in web environment");
    }

    @Override
    public void deleteIfExists() throws IOException {
        throw new RuntimeException("Path operations not supported in web environment");
    }

    @Override
    public boolean notExists() {
        throw new RuntimeException("Path operations not supported in web environment");
    }

    @Override
    public void delete() {
        throw new RuntimeException("Path operations not supported in web environment");
    }

    @Override
    public void createFile() {
        throw new RuntimeException("Path operations not supported in web environment");
    }

    @Override
    public String readString() {
        throw new RuntimeException("Path operations not supported in web environment");
    }

    @Override
    public int compareTo(io.ballerina.fs.Path o) {
        throw new RuntimeException("Path operations not supported in web environment");
    }
}
