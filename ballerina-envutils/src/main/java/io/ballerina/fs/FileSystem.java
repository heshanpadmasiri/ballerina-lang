package io.ballerina.fs;

import java.util.Optional;
import java.util.stream.Stream;

public interface FileSystem {
    void save(Path path, String content);

    Optional<String> readAsString(Path path);

    static FileSystem getInstance() {
        return InMemoryFileSystem.INSTANCE;
    }

    boolean exists(Path path);

    boolean isDirectory(Path path);

    void createDirectory(Path path);

    Stream<Path> walk(Path startPath, int maxDepth);
    Stream<Path> walk(Path startPath);
}
