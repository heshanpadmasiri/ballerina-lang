/*
 * Copyright (c) 2024, WSO2 LLC. (https://www.wso2.com).
 *
 * WSO2 LLC. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package io.ballerina.cli.cmd;

import io.ballerina.cli.launcher.BLauncherException;
import io.ballerina.cli.task.RunBuildToolsTask;
import io.ballerina.projects.BuildOptions;
import io.ballerina.projects.JvmTarget;
import io.ballerina.projects.Project;
import io.ballerina.projects.directory.BuildProject;
import io.ballerina.projects.util.ProjectConstants;
import org.ballerinalang.test.BCompileUtil;
import org.testng.Assert;
import org.testng.annotations.AfterClass;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.DataProvider;
import org.testng.annotations.Test;
import org.wso2.ballerinalang.util.RepoUtils;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Objects;
import java.util.concurrent.atomic.AtomicBoolean;

import static io.ballerina.cli.cmd.CommandOutputUtils.getOutput;

/**
 * Test cases for the RunBuildToolsTask.
 *
 * @since 2201.9.0
 */
public class RunBuildToolsTaskTest extends BaseCommandTest {
    private Path buildToolResources;

    private static final long TWO_DAYS = 2 * 24 * 60 * 60 * 1000;
    private static final long HALF_DAY = 12 * 60 * 60 * 1000;

    private static final Path LOG_FILE = Path.of("build/logs/log_creator_combined_plugin/compiler-plugin.txt")
            .toAbsolutePath();

    @Override
    @BeforeClass
    public void setup() throws IOException {
        super.setup();
        Files.createDirectories(LOG_FILE.getParent());
        Files.writeString(LOG_FILE, "");

        // copy all test resources
        try {
            Path testResources = super.tmpDir.resolve("build-tool-test-resources");
            this.buildToolResources = testResources.resolve("buildToolResources");
            Path testResourcesPath = Path.of(
                    Objects.requireNonNull(getClass().getClassLoader().getResource("test-resources")).toURI());
            Files.walkFileTree(testResourcesPath, new BuildCommandTest.Copy(testResourcesPath, testResources));

            // copy the sample-build-tool jar to the test tool projects
            String sampleBuildToolJar = "sample-build-tool-1.0.0.jar";
            Path sampleBuildToolJarPath = Paths.get("build/tool-libs").resolve(sampleBuildToolJar);
            Path destPath = testResources.resolve("buildToolResources/tools/sample-build-tool-pkg")
                    .resolve("lib").resolve(sampleBuildToolJar);
            Files.createDirectories(destPath.getParent());
            Files.copy(sampleBuildToolJarPath, destPath);

            destPath = testResources.resolve("buildToolResources/tools/dummy-tool-pkg-higher-dist")
                    .resolve("lib").resolve(sampleBuildToolJar);
            Files.createDirectories(destPath.getParent());
            Files.copy(sampleBuildToolJarPath, destPath);
        } catch (Exception e) {
            Assert.fail("error loading resources");
        }

        // compile and cache tools
        BCompileUtil.compileAndCacheBala(buildToolResources.resolve("tools")
                .resolve("dummy-tool-pkg").toString(), testCentralRepoCache);
        BCompileUtil.compileAndCacheBala(buildToolResources.resolve("tools")
                        .resolve("invalid-name-tool-pkg").toString(), testCentralRepoCache);
        BCompileUtil.compileAndCacheBala(buildToolResources.resolve("tools")
                        .resolve("ballerina-generate-file").toString(), testCentralRepoCache);
        BCompileUtil.compileAndCacheBala(buildToolResources.resolve("tools")
                .resolve("hidden-cmd-tool-pkg").toString(), testCentralRepoCache);
        BCompileUtil.compileAndCacheBala(buildToolResources.resolve("tools")
                .resolve("missing-interface-tool-pkg").toString(), testCentralRepoCache);
        BCompileUtil.compileAndCacheBala(buildToolResources.resolve("tools")
                .resolve("no-options-tool-pkg").toString(), testCentralRepoCache);
        BCompileUtil.compileAndCacheBala(buildToolResources.resolve("tools")
                .resolve("dummy-tool-pkg-higher-dist").toString(), testCentralRepoCache);

        Path balaPath = testCentralRepoCache.resolve("bala").resolve("foo")
                .resolve("dummypkghigherdist").resolve("1.4.0").resolve(JvmTarget.JAVA_21.code());
        replacePkgDistVersion(balaPath);
        // add build.json files
        addBuildJsonToProjects("project-lt-24h-with-build-tool", System.currentTimeMillis() - HALF_DAY);
        addBuildJsonToProjects("project-gt-24h-with-build-tool", System.currentTimeMillis() - TWO_DAYS);
    }

    @Test(description = "Resolve a tool offline", dataProvider = "buildToolOfflineProvider")
    public void testOfflineToolResolution(String projectName, String outputFileName, boolean sticky, boolean isError)
            throws IOException {

        Path projectPath = buildToolResources.resolve(projectName);
        Project project = BuildProject.load(projectPath,
                BuildOptions.builder().setOffline(true).setSticky(sticky).build());
        RunBuildToolsTask runBuildToolsTask = new RunBuildToolsTask(printStream);
        try {
            runBuildToolsTask.execute(project);
        } catch (BLauncherException e) {
            if (!isError) {
                String errorMsg = "Error executing build tools task for project: " + projectName
                        + (sticky ? " with sticky." : " without sticky. ") + e.getMessage();
                Assert.fail(errorMsg);
            }
            List<String> messages = e.getMessages();
            Assert.assertEquals(messages.size(), 1);
            Assert.assertEquals(messages.get(0), "error: build tool execution contains errors");
        }

        String buildLog = readOutput(true);
        Assert.assertEquals(buildLog.replace("\r", ""), getOutput(outputFileName));
    }

    @Test(description = "Generate files using a project and find the generated file in project instance")
    public void testProjectForAddedGeneratedCode() throws IOException {
        Path projectPath = buildToolResources.resolve("project-with-generate-file-tool");
        Project project = BuildProject.load(projectPath, BuildOptions.builder().setOffline(true).build());
        RunBuildToolsTask runBuildToolsTask = new RunBuildToolsTask(printStream);
        runBuildToolsTask.execute(project);
        String buildLog = readOutput(true);
        Assert.assertEquals(buildLog.replace("\r", ""), getOutput("build-tool-generate-file.txt"));
        AtomicBoolean fileFound = new AtomicBoolean(false);
        project.currentPackage().modules().forEach(module -> {
            if (module.moduleName().toString().equals("winery.mod_generate")) {
                module.documentIds().forEach(documentId -> {
                    if (module.document(documentId).name().equals("client.bal")) {
                        fileFound.set(true);
                    }
                });
            }
        });
        Assert.assertTrue(fileFound.get(),
                "Generated file not found. Project instance hasn't been updated after build tools task");
    }

    @DataProvider(name = "buildToolOfflineProvider")
    public Object[][] buildToolOfflineProvider() {
        return new Object[][]{
            {
                "project-with-central-build-tool",
                "build-tool-offline.txt",
                false,
                false
            },
            {
                "project-with-non-existent-build-tool",
                "build-tool-offline-resolve-failed.txt",
                false,
                true
            },
            {
                "fresh-project-with-central-build-tool",
                "build-tool-offline-resolve-failed-wo-version.txt",
                false,
                true,
            },
            {
                "project-with-2.x-central-build-tool",
                "build-tool-offline-with-new-major-version-locked.txt",
                false,
                true
            },
            {
                "project-with-non-existent-subcommand",
                "build-tool-non-existent-subcommand.txt",
                false,
                false
            },
            {
                "project-with-invalid-name-build-tool",
                "build-tool-invalid-name.txt",
                false,
                false
            },
            {
                "project-with-multilevel-subcommands",
                "build-tool-multilevel-subcommands.txt",
                false,
                false
            },
            {
                "project-with-only-subcommands",
                "build-tool-only-subcommands.txt",
                false,
                false
            },
            {
                "project-with-hidden-commands",
                "build-tool-hidden-commands.txt",
                false,
                false
            },
            {
                "project-with-missing-interface-build-tool",
                "build-tool-missing-interface.txt",
                false,
                false
            },
            {
                "project-with-no-options-build-tool",
                "build-tool-no-options.txt",
                false,
                false
            },
            {
                "project-with-old-build-tool",
                "build-tool-without-sticky.txt",
                false,
                false
            },
            {
                "project-with-old-build-tool",
                "build-tool-with-sticky.txt",
                true,
                true
            },
            {
                "project-lt-24h-with-build-tool",
                "build-tool-lt-24-build-file.txt",
                false,
                true
            },
            {
                "project-gt-24h-with-build-tool",
                "build-tool-gt-24-build-file.txt",
                false,
                false
            },
            {
                "project-with-higher-dist-build-tool",
                "build-tool-higher-dist-resolve-failed.txt",
                false,
                true
            }
        };
    }

    private void addBuildJsonToProjects(String projectName, long time) {
        Path buildJsonPath = buildToolResources.resolve(projectName).resolve("target/build");
        String buildJsonContent = "{\n" +
                "  \"last_build_time\": 1710907945705,\n" +
                "  \"last_update_time\": " + time + ",\n" +
                "  \"distribution_version\": \"" + RepoUtils.getBallerinaShortVersion() + "\",\n" +
                "  \"last_modified_time\": {\n" +
                "    \"sample_build_tool_ballerina\": 1710907943604\n" +
                "  }\n" +
                "}";
        try {
            Files.createDirectories(buildJsonPath.getParent());
            Files.write(buildJsonPath, buildJsonContent.getBytes());
        } catch (IOException e) {
            Assert.fail("Error writing build.json file");
        }
    }
    
    @AfterClass
    public void cleanUp() throws IOException {
        Files.deleteIfExists(LOG_FILE);
        Files.deleteIfExists(LOG_FILE.getParent());
        Files.deleteIfExists(LOG_FILE.getParent().getParent());
    }

    private void replacePkgDistVersion(Path balaPath) {
        Path packageJson = balaPath.resolve(ProjectConstants.PACKAGE_JSON);
        try {
            String content = Files.readString(packageJson);
            content = content.replace(RepoUtils.getBallerinaShortVersion(), "2201.99.0");
            Files.writeString(packageJson, content);
        } catch (IOException e) {
            Assert.fail("Error replacing distribution version in bala");
        }
    }
}
