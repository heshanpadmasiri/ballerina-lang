/*
 *  Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  WSO2 Inc. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */

package org.wso2.ballerinalang.compiler.packaging.converters;


import java.util.stream.Stream;

import io.ballerina.fs.Path;
import org.ballerinalang.model.elements.PackageID;
import org.ballerinalang.repository.CompilerInput;
import org.ballerinalang.toml.model.Manifest;
import org.wso2.ballerinalang.compiler.util.Name;
import org.wso2.ballerinalang.compiler.util.Names;
import org.wso2.ballerinalang.compiler.util.ProjectDirConstants;
import org.wso2.ballerinalang.compiler.util.ProjectDirs;
import org.wso2.ballerinalang.util.RepoUtils;
import org.wso2.ballerinalang.util.TomlParserUtils;

/**
 * Provide functions need to covert a patten to steam of sources.
 */
public class PathConverter implements Converter<Path> {

    private final Path root;

    public PathConverter(Path root) {
            throw new RuntimeException();
    }

    @Override
    public Path combine(Path path, String pathPart) {
        return path.resolve(pathPart);
    }

    @Override
    public Stream<Path> getLatestVersion(Path path, PackageID packageID) {
        throw new RuntimeException();
    }

    @Override
    public Stream<Path> expandBalWithTest(Path path) {
        throw new RuntimeException();
    }

    @Override
    public Stream<Path> expandBal(Path path) {
        throw new RuntimeException();
    }

    @Override
    public Path start() {
        return root;
    }

    @Override
    public Stream<CompilerInput> finalize(Path path, PackageID pkgId) {
        // Set package version if its empty
        if (pkgId.version.value.isEmpty() && !pkgId.orgName.equals(Names.BUILTIN_ORG)
                && !pkgId.orgName.equals(Names.ANON_ORG)) {
            Manifest manifest = TomlParserUtils.getManifest(root);
            pkgId.version = new Name(manifest.getProject().getVersion());
        }

        if ((!ProjectDirs.isProject(root) || RepoUtils.isBallerinaStandaloneFile(path))
                && path.isRegularFile()) {
            return Stream.of(new FileSystemSourceInput(path, root.resolve(pkgId.name.value)));
        } else if (path.isRegularFile()) {
            return Stream.of(new FileSystemSourceInput(path,
                    root.resolve(ProjectDirConstants.SOURCE_DIR_NAME)
                            .resolve(pkgId.name.value)));
        } else {
            return Stream.of();
        }
    }

    @Override
    public String toString() {
//        FileSystem fs = root.getFileSystem();
//        if (fs instanceof ZipFileSystem) {
//            return fs.toString();
//        } else {
            return root.toString();
//        }
    }

    public Path getRoot() {
        return root;
    }
}
