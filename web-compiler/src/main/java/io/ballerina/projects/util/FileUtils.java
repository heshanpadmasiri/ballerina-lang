/*
 * Copyright (c) 2020, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
package io.ballerina.projects.util;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.nio.file.FileSystems;
import java.nio.file.FileVisitResult;
import java.nio.file.PathMatcher;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.StandardCopyOption;
import java.nio.file.attribute.BasicFileAttributes;

import io.ballerina.fs.Path;

import static io.ballerina.projects.util.ProjectConstants.EMPTY_STRING;

/**
 * Utilities related to files.
 *
 * @since 2.0.0
 */
public final class FileUtils {

    private static final PathMatcher FILE_MATCHER = FileSystems.getDefault().getPathMatcher("glob:**/Ballerina.toml");

    private FileUtils() {
    }

    /**
     * Get the name of the without the extension.
     *
     * @param filePath Path of the file.
     * @return File name without extension.
     */
    public static String getFileNameWithoutExtension(String filePath) {
        Path fileName = Path.of(filePath).getFileName();
        if (null != fileName) {
            int index = indexOfExtension(fileName.toString());
            return index == -1 ? fileName.toString() :
                    fileName.toString().substring(0, index);
        } else {
            return null;
        }
    }

    public static boolean hasExtension(Path filePath) {
        Path fileName = filePath.getFileName();
        if (null != fileName) {
            int index = indexOfExtension(fileName.toString());
            return index != -1;
        } else {
            return false;
        }
    }

    private static int indexOfExtension(String filename) {
        if (filename == null) {
            return -1;
        } else {
            int extensionPos = filename.lastIndexOf(46);
            int lastSeparator = indexOfLastSeparator(filename);
            return lastSeparator > extensionPos ? -1 : extensionPos;
        }
    }

    private static int indexOfLastSeparator(String filename) {
        if (filename == null) {
            return -1;
        } else {
            int lastUnixPos = filename.lastIndexOf(47);
            int lastWindowsPos = filename.lastIndexOf(92);
            return Math.max(lastUnixPos, lastWindowsPos);
        }
    }

    /**
     * Read the content of the given file.
     *
     * @param path path of the file
     * @return content of the given file
     * @throws IOException if IO exception occurs
     */
    public static String readFileAsString(String path) throws IOException {
        InputStream is = FileUtils.class.getClassLoader().getResourceAsStream(path);
        if (is == null) {
            throw new FileNotFoundException("Schema file not found: " + path);
        }
        InputStreamReader inputStreamReader = null;
        BufferedReader br = null;
        StringBuilder sb = new StringBuilder();
        try {
            inputStreamReader = new InputStreamReader(is, StandardCharsets.UTF_8);
            br = new BufferedReader(inputStreamReader);
            String content = br.readLine();
            if (content == null) {
                return sb.toString();
            }

            sb.append(content);

            while ((content = br.readLine()) != null) {
                sb.append('\n').append(content);
            }
            sb.append('\n');
        } finally {
            if (inputStreamReader != null) {
                try {
                    inputStreamReader.close();
                } catch (IOException ignore) {
                }
            }
            if (br != null) {
                try {
                    br.close();
                } catch (IOException ignore) {
                }
            }
        }
        return sb.toString();
    }

    /**
     * Get last modified timestamp of a ballerina project.
     *
     * @param projectRoot project root path
     * @return last modified time of the ballerina project
     */
    public static long lastModifiedTimeOfBalProject(Path projectRoot) {
        throw new RuntimeException();
    }

    /**
     * Add deprecated meta file.
     *
     * @param metaFilePath deprecated message meta file path
     * @param message deprecated message
     */
    public static void addDeprecatedMetaFile(Path metaFilePath, String message) {
        throw new RuntimeException();
    }

    /**
     * Delete deprecated meta file.
     *
     * @param metaFilePath deprecated message meta file path
     */
    public static void deleteDeprecatedMetaFile(Path metaFilePath) {
        throw new RuntimeException();
    }

    public static void replaceTemplateName(Path path, String templateName, String packageName) {
        throw new RuntimeException();
    }

    /**
     * Copy files to the given destination.
     */
    public static class Copy extends SimpleFileVisitor<Path> {
        private final Path fromPath;
        private final Path toPath;
        private final String templateName;
        private final String packageName;
        private final StandardCopyOption copyOption;


        public Copy(Path fromPath, Path toPath, String templateName, String packageName,
                    StandardCopyOption copyOption) {
            this.fromPath = fromPath;
            this.toPath = toPath;
            this.templateName = templateName;
            this.packageName = packageName;
            this.copyOption = copyOption;
        }

        public Copy(Path fromPath, Path toPath) {
            this(fromPath, toPath, EMPTY_STRING, EMPTY_STRING, StandardCopyOption.REPLACE_EXISTING);
        }

        public Copy(Path fromPath, Path toPath, String templateName, String packageName) {
            this(fromPath, toPath, templateName, packageName, StandardCopyOption.REPLACE_EXISTING);
        }

        @Override
        public FileVisitResult preVisitDirectory(Path dir, BasicFileAttributes attrs)
                throws IOException {
            throw new RuntimeException();
        }

        @Override
        public FileVisitResult visitFile(Path file, BasicFileAttributes attrs)
                throws IOException {
            throw new RuntimeException();
        }
    }

    /**
     * Look for existing Ballerina.toml file in the given directory up to 10 levels.
     */
    public static class BallerinaTomlChecker extends SimpleFileVisitor<Path> {
        private final Path startingPath;
        private boolean ballerinaTomlFound = false;

        public boolean isBallerinaTomlFound() {
            return ballerinaTomlFound;
        }

        public void setBallerinaTomlFound(boolean ballerinaTomlFound) {
            this.ballerinaTomlFound = ballerinaTomlFound;
        }

        public BallerinaTomlChecker(Path startingPath) {
            this.startingPath = startingPath;
        }

        @Override
        public FileVisitResult preVisitDirectory(Path dir, BasicFileAttributes attrs) {
            throw new RuntimeException();
        }

        @Override
        public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) {
            throw new RuntimeException();
        }
    }
}
