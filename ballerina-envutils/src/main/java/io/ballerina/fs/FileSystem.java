package io.ballerina.fs;

import java.util.Optional;

public interface FileSystem {
    void save(Path path, String content);

    Optional<String> readAsString(Path path);

    static FileSystem getInstance() {
        return InMemoryFileSystem.INSTANCE;
    }
}
