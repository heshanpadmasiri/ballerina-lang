package io.ballerina.fs;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import io.ballerina.tools.envutils.Console;

public class InMemoryFileSystem implements FileSystem{

    public static final FileSystem INSTANCE = new InMemoryFileSystem();
    private final Map<Path, String> fileStorage = new HashMap<>();

    @Override
    public void save(Path path, String content) {
        synchronized (fileStorage) {
            fileStorage.put(path, content);
        }
    }

    @Override
    public Optional<String> readAsString(Path path) {
        Console.println("Reading file from in-memory file system: " + path.toString());
        synchronized (fileStorage) {
            return Optional.ofNullable(fileStorage.get(path));
        }
    }
}
