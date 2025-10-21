package io.ballerina.fs;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Stream;

import io.ballerina.tools.envutils.Console;

public class InMemoryFileSystem implements FileSystem{

    public static final FileSystem INSTANCE = new InMemoryFileSystem();
    private final Map<Path, String> fileStorage = new HashMap<>();
    private final Set<Path> directories = new HashSet<>();

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

    @Override
    public boolean exists(Path path) {
        return directories.contains(path) || fileStorage.containsKey(path);
    }

    @Override
    public boolean isDirectory(Path path) {
        return directories.contains(path);
    }

    @Override
    public void createDirectory(Path path) {
       directories.add(path);
    }

    /**
     * Calculates the depth of a descendant path relative to an ancestor path.
     * Assumes Unix-style path separators (/).
     *
     * @param ancestor The ancestor path
     * @param descendant The descendant path
     * @return The depth (0 if same path, 1 for direct child, etc.), or -1 if not a descendant
     */
    private int calculateDepth(Path ancestor, Path descendant) {
        if (ancestor.equals(descendant)) {
            return 0;
        }

        String ancestorStr = ancestor.toString();
        String descendantStr = descendant.toString();

        // Ensure ancestor path ends with separator for proper prefix matching
        if (!ancestorStr.endsWith("/")) {
            ancestorStr = ancestorStr + "/";
        }

        // Check if descendant starts with ancestor
        if (!descendantStr.startsWith(ancestorStr)) {
            return -1;
        }

        // Calculate depth by counting path separators in the remaining path
        String relativePath = descendantStr.substring(ancestorStr.length());
        if (relativePath.isEmpty()) {
            return 0;
        }

        // Count separators in relative path + 1 for the path itself
        int depth = 1;
        for (int i = 0; i < relativePath.length(); i++) {
            if (relativePath.charAt(i) == '/') {
                depth++;
            }
        }

        return depth;
    }

    @Override
    public Stream<Path> walk(Path startPath, int maxDepth) {
        // Handle negative depth
        if (maxDepth < 0) {
            return Stream.empty();
        }

        // Take synchronized snapshots of both collections
        Set<Path> allPaths;
        synchronized (fileStorage) {
            allPaths = new HashSet<>(fileStorage.keySet());
        }
        synchronized (directories) {
            allPaths.addAll(directories);
        }

        // If start path doesn't exist, return empty stream
        if (!allPaths.contains(startPath)) {
            return Stream.empty();
        }

        // Filter paths that are descendants of startPath and within maxDepth
        return allPaths.stream()
                .filter(path -> {
                    int depth = calculateDepth(startPath, path);
                    return depth >= 0 && depth <= maxDepth;
                })
                .sorted();
    }

    @Override
    public Stream<Path> walk(Path startPath) {
        return walk(startPath, Integer.MAX_VALUE);
    }
}
