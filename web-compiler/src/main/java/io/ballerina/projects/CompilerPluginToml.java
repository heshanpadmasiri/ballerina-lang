package io.ballerina.projects;

import io.ballerina.projects.util.ProjectConstants;

/**
 * Represents the 'Compiler-plugin.toml' file in a package.
 *
 * @since 2.0.0
 */
public class CompilerPluginToml {
    private final TomlDocumentContext compilerPluginTomlContext;
    private final Package packageInstance;

    private CompilerPluginToml(TomlDocumentContext compilerPluginTomlContext, Package packageInstance) {
        this.compilerPluginTomlContext = compilerPluginTomlContext;
        this.packageInstance = packageInstance;
    }

    public static CompilerPluginToml from(TomlDocumentContext compilerPluginTomlContext, Package pkg) {
        return new CompilerPluginToml(compilerPluginTomlContext, pkg);
    }

    TomlDocumentContext compilerPluginTomlContext() {
        return this.compilerPluginTomlContext;
    }

    public Package packageInstance() {
        return this.packageInstance;
    }

    public String name() {
        return ProjectConstants.COMPILER_PLUGIN_TOML;
    }
    /**
     * Returns an instance of the Document.Modifier.
     *
     * @return  module modifier
     */
    public CompilerPluginToml.Modifier modify() {
        return new CompilerPluginToml.Modifier(this);
    }

    /**
     * Inner class that handles Document modifications.
     */
    public static class Modifier {
        private final Package oldPackage;

        private Modifier(CompilerPluginToml oldDocument) {
            this.oldPackage = oldDocument.packageInstance();
        }

        /**
         * Returns a new document with updated content.
         *
         * @return document with updated content
         */
        public CompilerPluginToml apply() {
            throw new RuntimeException();
        }
    }
}
