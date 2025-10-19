/*
 *  Copyright (c) 2020, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

package io.ballerina.projects;

import io.ballerina.projects.internal.model.BalToolDescriptor;
import io.ballerina.projects.internal.model.CompilerPluginDescriptor;
import org.wso2.ballerinalang.compiler.util.Names;

import io.ballerina.fs.Path;

import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;

/**
 * This class knows how to create a bala containing jballerina platform libs.
 *
 * @since 2.0.0
 */
public class JBallerinaBalaWriter extends BalaWriter {

    public static final String TOOL = "tool";
    public static final String COMPILER_PLUGIN = "compiler-plugin";
    private final JBallerinaBackend backend;

    public JBallerinaBalaWriter(JBallerinaBackend backend) {
        this.backend = backend;
        this.packageContext = backend.packageContext();
        this.compilerPluginToml = readCompilerPluginToml();
        this.balToolToml = readBalToolToml();
        this.target = getTargetPlatform(packageContext.getResolution()).code();
    }

    /**
     * Mark target platform as `java21` if one of the following condition fulfils.
     * 1) Direct dependencies of imports in the package have any `ballerina/java` dependency.
     * 2) Package has defined any platform dependency.
     *
     * @param pkgResolution package resolution
     * @return target platform
     */
    private CompilerBackend.TargetPlatform getTargetPlatform(PackageResolution pkgResolution) {
        ResolvedPackageDependency resolvedPackageDependency = new ResolvedPackageDependency(
                this.packageContext.project().currentPackage(), PackageDependencyScope.DEFAULT);
        Collection<ResolvedPackageDependency> resolvedPackageDependencies = pkgResolution.dependencyGraph()
                .getDirectDependencies(resolvedPackageDependency);

        // 1) Check direct dependencies of imports in the package have any `ballerina/java` dependency
        for (ResolvedPackageDependency dependency : resolvedPackageDependencies) {
            if (dependency.packageInstance().packageOrg().value().equals(Names.BALLERINA_ORG.value) &&
                    dependency.packageInstance().packageName().value().equals(Names.JAVA.value) &&
                    !dependency.scope().equals(PackageDependencyScope.TEST_ONLY)) {
                return this.backend.targetPlatform();
            }
        }

        // 2) Check package has defined any platform dependency
        PackageManifest manifest = this.packageContext.project().currentPackage().manifest();
        if (hasPlatformDependencies(manifest.platforms())) {
            return this.backend.targetPlatform();
        }

        // 3) Check if the package has a BalTool.toml or a CompilerPlugin.toml
        if (this.balToolToml.isPresent() || this.compilerPluginToml.isPresent()) {
            return this.backend.targetPlatform();
        }
        return AnyTarget.ANY;
    }

    private boolean hasPlatformDependencies(Map<String, PackageManifest.Platform> platforms) {
        for (PackageManifest.Platform value: platforms.values()) {
            if (!value.dependencies().isEmpty() && !isPlatformDependenciesTestOnly(value.dependencies())) {
                return true;
            }
        }
        return false;
    }

    private Optional<CompilerPluginDescriptor> readCompilerPluginToml() {
        Optional<CompilerPluginToml> compilerPluginToml = backend.packageContext().project()
                .currentPackage().compilerPluginToml();

        if (compilerPluginToml.isPresent()) {
            TomlDocument tomlDocument = compilerPluginToml.get().compilerPluginTomlContext().tomlDocument();
            return Optional.of(CompilerPluginDescriptor.from(tomlDocument));
        }
        return Optional.empty();
    }

    private Optional<BalToolDescriptor> readBalToolToml() {
        Optional<BalToolToml> balToolToml = backend.packageContext().project()
                .currentPackage().balToolToml();
        if (balToolToml.isPresent()) {
            TomlDocument tomlDocument = balToolToml.get().balToolTomlContext().tomlDocument();
            Path sourceRoot = packageContext.project().sourceRoot();
            return Optional.of(BalToolDescriptor.from(tomlDocument, sourceRoot));
        }
        return Optional.empty();
    }

    private boolean isPlatformDependenciesTestOnly(List<Map<String, Object>> dependencies) {
        for (Map<String, Object> dependency : dependencies) {
            if (!Objects.equals(PlatformLibraryScope.TEST_ONLY.getStringValue(), dependency.get("scope"))) {
                return false;
            }
        }
        return true;
    }
}
