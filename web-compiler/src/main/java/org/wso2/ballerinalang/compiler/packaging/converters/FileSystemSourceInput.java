package org.wso2.ballerinalang.compiler.packaging.converters;

import java.util.function.Supplier;

import io.ballerina.compiler.syntax.tree.SyntaxTree;
import io.ballerina.fs.Path;
import io.ballerina.tools.text.TextDocuments;
import org.ballerinalang.repository.CompilerInput;

import static org.wso2.ballerinalang.compiler.util.ProjectDirConstants.BLANG_COMPILED_PKG_BINARY_EXT;

/**
 * Source file in the real file system (as opposed to in memory).
 */
public class FileSystemSourceInput implements CompilerInput {

    private final Path path;
    private Path packageRoot;

    // Cached Value.
    private byte[] code = null;
    private SyntaxTree tree = null;
    private String entryName = null;

    public FileSystemSourceInput(Path path) {
        this.path = path;
    }

    public FileSystemSourceInput(Path filePath, Path packageRoot) {
        this.path = filePath;
        this.packageRoot = packageRoot;
    }

    @Override
    public String getEntryName() {
        throw new RuntimeException();
    }

    @Override
    public byte[] getCode() {
        throw new RuntimeException();
    }

    @Override
    public SyntaxTree getTree() {
        if (this.tree != null) {
            return this.tree;
        }
        this.tree = SyntaxTree.from(TextDocuments.from(getCodeSupplier(isBLangBinaryFile(path), path)),
                this.path.getFileName().toString());
        return this.tree;
    }

    public Path getPath() {
        return this.path;
    }

    @Override
    public String toString() {
        return this.path.toString();
    }

    private boolean isBLangBinaryFile(Path path) {
        return path.toString().endsWith(BLANG_COMPILED_PKG_BINARY_EXT);
    }

    private static Supplier<String> getCodeSupplier(boolean isBLangBinaryFile, Path path) {
        throw new RuntimeException();
    }
}
