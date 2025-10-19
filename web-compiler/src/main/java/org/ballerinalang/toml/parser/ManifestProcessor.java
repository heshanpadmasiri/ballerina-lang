/*
 *  Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  WSO2 Inc. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */
package org.ballerinalang.toml.parser;

import io.ballerina.fs.Path;
import org.ballerinalang.toml.exceptions.TomlException;
import org.ballerinalang.toml.model.Dependency;
import org.ballerinalang.toml.model.Manifest;
import org.wso2.ballerinalang.compiler.util.CompilerContext;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;

/**
 * Manifest Processor which processes the toml file parsed and populate the
 * Manifest POJO.
 * Note: TOML parsing is not supported in web-compiler. This is a stub
 * implementation.
 *
 * @since 0.964
 */
public class ManifestProcessor {

    private static final CompilerContext.Key<ManifestProcessor> MANIFEST_PROC_KEY = new CompilerContext.Key<>();
    private final Manifest manifest;

    public static ManifestProcessor getInstance(CompilerContext context) {
        throw new UnsupportedOperationException("TOML parsing is not supported in web-compiler");
    }

    private ManifestProcessor(Manifest manifest) {
        this.manifest = manifest;
    }

    public Manifest getManifest() {
        return this.manifest;
    }

    /**
     * Get the char stream of the content from file.
     *
     * @param tomlPath path of the toml file
     * @return manifest object
     * @throws IOException   exception if the file cannot be found
     * @throws TomlException exception when parsing toml
     */
    public static Manifest parseTomlContentFromFile(Path tomlPath) throws IOException, TomlException {
        throw new UnsupportedOperationException("TOML parsing is not supported in web-compiler");
    }

    /**
     * Get the char stream from string content.
     *
     * @param content toml file content as a string
     * @return manifest object
     * @throws TomlException exception when parsing toml
     */
    public static Manifest parseTomlContentFromString(String content) throws TomlException {
        throw new UnsupportedOperationException("TOML parsing is not supported in web-compiler");
    }

    /**
     * Get the char stream from inputstream.
     *
     * @param inputStream inputstream of the toml file content
     * @return manifest object
     * @throws TomlException exception when parsing toml
     */
    public static Manifest parseTomlContentAsStream(InputStream inputStream) throws TomlException {
        throw new UnsupportedOperationException("TOML parsing is not supported in web-compiler");
    }

    public static byte[] addDependenciesToManifest(ByteArrayInputStream manifestStream, List<Dependency> deps) {
        throw new UnsupportedOperationException("TOML parsing is not supported in web-compiler");
    }
}
