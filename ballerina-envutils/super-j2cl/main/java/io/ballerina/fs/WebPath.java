package io.ballerina.fs;

import java.io.IOException;

class WebPath implements io.ballerina.fs.Path {
    private final String path;
    private final FileSystem fs;

    public WebPath(String first, String... more) {
        if (first == null) {
            throw new IllegalArgumentException("First path component cannot be null");
        }

        StringBuilder pathBuilder = new StringBuilder(first);
        for (String component : more) {
            if (component != null && !component.isEmpty()) {
                if (!pathBuilder.toString().endsWith("/") && !component.startsWith("/")) {
                    pathBuilder.append("/");
                }
                pathBuilder.append(component);
            }
        }
        this.path = pathBuilder.toString();
        this.fs = FileSystem.getInstance();
    }

    @Override
    public io.ballerina.fs.Path toAbsolutePath() {
        if (isAbsolute()) {
            return this;
        }
        throw new RuntimeException("Cannot resolve absolute path in web environment - no working directory");
    }

    @Override
    public io.ballerina.fs.Path normalize() {
        if (path.isEmpty()) {
            return new WebPath("");
        }

        String[] components = path.split("/");
        java.util.List<String> normalized = new java.util.ArrayList<>();

        for (String component : components) {
            if (component.isEmpty() || ".".equals(component)) {
                // Skip empty components and current directory
                continue;
            } else if ("..".equals(component)) {
                // Go up one directory if possible
                if (!normalized.isEmpty() && !"..".equals(normalized.get(normalized.size() - 1))) {
                    normalized.remove(normalized.size() - 1);
                } else if (!isAbsolute()) {
                    // Keep .. for relative paths when we can't go up further
                    normalized.add("..");
                }
            } else {
                normalized.add(component);
            }
        }

        String result = String.join("/", normalized);
        if (isAbsolute() && !result.startsWith("/")) {
            result = "/" + result;
        }
        if (result.isEmpty() && !isAbsolute()) {
            result = ".";
        }

        return new WebPath(result);
    }

    @Override
    public io.ballerina.fs.File toFile() {
        throw new RuntimeException("Path operations not supported in web environment");
    }

    @Override
    public boolean isAbsolute() {
        return path.startsWith("/");
    }

    @Override
    public io.ballerina.fs.Path resolve(io.ballerina.fs.Path relativePath) {
        if (relativePath instanceof WebPath webPath) {
            return resolve(webPath.path);
        }
        throw new IllegalArgumentException("Incompatible path type");
    }

    @Override
    public io.ballerina.fs.Path getFileName() {
        if (path.isEmpty()) {
            return new WebPath("");
        }

        int lastSlash = path.lastIndexOf('/');
        if (lastSlash == -1) {
            return new WebPath(path);
        }

        String fileName = path.substring(lastSlash + 1);
        return new WebPath(fileName);
    }

    @Override
    public io.ballerina.fs.Path getParent() {
        if (path.isEmpty()) {
            return null;
        }

        int lastSlash = path.lastIndexOf('/');
        if (lastSlash == -1) {
            return null;
        }

        if (lastSlash == 0) {
            return new WebPath("/");
        }

        String parent = path.substring(0, lastSlash);
        return new WebPath(parent);
    }

    @Override
    public io.ballerina.fs.Path resolve(String other) {
        if (other == null) {
            throw new IllegalArgumentException("Path component cannot be null");
        }

        if (other.isEmpty()) {
            return this;
        }

        if (other.startsWith("/")) {
            return new WebPath(other);
        }

        if (path.isEmpty()) {
            return new WebPath(other);
        }

        if (path.endsWith("/")) {
            return new WebPath(path + other);
        } else {
            return new WebPath(path + "/" + other);
        }
    }

    @Override
    public boolean isDirectory() {
        throw new RuntimeException("Path operations not supported in web environment");
    }

    @Override
    public boolean exists() {
        return existsInFileSystem();
    }

    @Override
    public boolean isRegularFile() {
        return existsInFileSystem();
    }

    @Override
    public boolean canWrite() {
        return existsInFileSystem();
    }

    @Override
    public boolean canRead() {
        return existsInFileSystem();
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
        return !existsInFileSystem();
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
        return fs.readAsString(this).orElseThrow(() ->
            new RuntimeException("File not found: " + path));
    }

    @Override
    public int compareTo(io.ballerina.fs.Path o) {
        if (o instanceof WebPath other) {
            return this.path.compareTo(other.path);
        }
        throw new IllegalArgumentException("Cannot compare with incompatible path type");
    }

    @Override
    public String toString() {
        return path;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null || getClass() != obj.getClass()) {
            return false;
        }
        WebPath webPath = (WebPath) obj;
        return path.equals(webPath.path);
    }

    @Override
    public int hashCode() {
        return path.hashCode();
    }

    @Override
    public FileSystem fileSystem() {
        return fs;
    }

    private boolean existsInFileSystem() {
        return fs.readAsString(this).isPresent();
    }
}
