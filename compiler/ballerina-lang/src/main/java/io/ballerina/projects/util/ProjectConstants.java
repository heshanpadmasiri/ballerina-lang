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
package io.ballerina.projects.util;

/**
 * Defines constants related to the project directory.
 *
 * @since 2.0.0
 */
public final class ProjectConstants {

    public static final String README_MD_FILE_NAME = "README.md";
    public static final String README_EXTENSION = "md";

    private ProjectConstants() {}

    public static final String BLANG_SOURCE_EXT = ".bal";
    public static final String BALA_EXTENSION = ".bala";
    public static final String PLATFORM = "platform";
    public static final String TOML_EXTENSION = ".toml";

    public static final String BALLERINA_TOML = "Ballerina.toml";
    public static final String DEPENDENCIES_TOML = "Dependencies.toml";
    public static final String COMPILER_PLUGIN_TOML = "CompilerPlugin.toml";
    public static final String BAL_TOOL_TOML = "BalTool.toml";
    public static final String SETTINGS_TOML = "Settings.toml";
    public static final String BAL_TOOLS_TOML = "bal-tools.toml";
    public static final String CLOUD_TOML = "Cloud.toml";
    public static final String CONFIGURATION_TOML = "Config.toml";
    public static final String SETTINGS_FILE_NAME = "Settings.toml";
    public static final String GITIGNORE_FILE_NAME = ".gitignore";
    public static final String DEVCONTAINER = ".devcontainer.json";
    public static final String MODULE_MD_FILE_NAME = "Module.md";
    public static final String PACKAGE_MD_FILE_NAME = "Package.md";
    public static final String PACKAGE_JSON = "package.json";
    public static final String BALA_JSON = "bala.json";
    public static final String COMPILER_PLUGIN_JSON = "compiler-plugin.json";
    public static final String BAL_TOOL_JSON = "bal-tool.json";
    public static final String DEPENDENCY_GRAPH_JSON = "dependency-graph.json";
    public static final String DEPRECATED_META_FILE_NAME = "deprecated.txt";
    public static final String BUILD_FILE = "build";
    public static final String JAVA_CLASS_EXT = ".class";

    public static final String SOURCE_DIR_NAME = "src";
    public static final String BIN_DIR_NAME = "bin";
    public static final String TARGET_DIR_NAME = "target";
    public static final String TARGET_API_DOC_DIRECTORY = "apidocs";

    public static final String NATIVE_DIR_NAME = "native";
    public static final String NATIVE_CONFIG_DIR_NAME = "native-config";

    public static final String CACHES_DIR_NAME = "cache";

    public static final String HOME_REPO_ENV_KEY = "BALLERINA_HOME_DIR";
    public static final String HOME_REPO_DEFAULT_DIRNAME = ".ballerina";
    public static final String BALLERINA_CENTRAL_ACCESS_TOKEN = "BALLERINA_CENTRAL_ACCESS_TOKEN";

    public static final String USER_DIR = "user.dir";
    public static final String USER_NAME = "user.name";
    public static final String IMPORT_PREFIX = "import ";
    public static final String EMPTY_STRING = "";

    // Bala specific constants
    public static final String MODULES_ROOT = "modules";
    public static final String GENERATED_MODULES_ROOT = "generated";
    public static final String LIB_DIR = "lib";
    public static final String COMPILER_PLUGIN_DIR = "compiler-plugin";
    public static final String TOOL_DIR = "tool";

    public static final String BALA_DIR_NAME = "bala";
    public static final String BALA_CACHE_DIR_NAME = "bala_cache";
    public static final String BIR_CACHE_DIR_NAME = "bir_cache";
    public static final String JAR_CACHE_DIR_NAME = "jar_cache";
    public static final String JSON_CACHE_DIR_NAME = "json_cache";
    public static final String TESTS_CACHE_DIR_NAME = "tests_cache";
    public static final String TEST_DIR_NAME = "tests";
    public static final String USER_DIR_PROPERTY = "user.dir";

    public static final String BLANG_COMPILED_PKG_BINARY_EXT = ".bala";
    public static final String BLANG_COMPILED_PKG_BIR_EXT = ".bir";
    public static final String BLANG_COMPILED_JAR_EXT = ".jar";
    public static final String RESOURCE_DIR_NAME = "resources";

    public static final String TARGET_BALA_DIR_NAME = "bala";
    public static final String BALLERINA_HOME = "ballerina.home";
    public static final String DIST_CACHE_DIRECTORY = "repo";
    public static final String BALLERINA_HOME_BRE = "bre";

    public static final String ANON_ORG = "$anon";
    public static final String DOT = ".";
    public static final String EQUAL = "=";
    public static final String DEFAULT_VERSION = "0.0.0";
    public static final String INTERNAL_VERSION = "0.1.0";
    public static final String MODULE_NAME_SEPARATOR = DOT;
    public static final String BUILTIN_PACKAGE_VERSION_STR = "0.0.0";

    // Constants related to file system repo
    public static final String REPO_BALA_DIR_NAME = TARGET_BALA_DIR_NAME;
    public static final String REPO_CACHE_DIR_NAME = "cache";
    public static final String REPO_BIR_CACHE_NAME = "bir";

    // Test framework related constants
    public static final String TEST_RUNTIME_JAR_PREFIX = "testerina-runtime-";
    public static final String TEST_CORE_JAR_PREFIX = "testerina-core-";
    public static final String TEST_UBER_JAR_SUFFIX = "-testable";
    public static final String DIR_PATH_SEPARATOR = "/";
    public static final String TEST_RUNTIME_MAIN_ARGS_FILE = "mainArgs.txt";
    public static final String EXCLUDED_CLASSES_FILE = "excludedClasses.txt";

    public static final String TEST_SUITE = "test_suite";
    public static final String TEST_SUITE_JSON = "test_suit.json";

    public static final String JACOCO_CORE_JAR = "org.jacoco.core-0.8.12.jar";
    public static final String JACOCO_REPORT_JAR = "org.jacoco.report-0.8.12.jar";
    public static final String ASM_JAR = "asm-9.7.jar";
    public static final String ASM_TREE_JAR = "asm-tree-9.7.jar";
    public static final String ASM_COMMONS_JAR = "asm-commons-9.7.jar";
    public static final String DIFF_UTILS_JAR = "java-diff-utils-4.5.jar";
    public static final String REPORT_DIR_NAME = "report";

    public static final String BALA_DOCS_DIR = "docs";
    public static final String REPOSITORIES_DIR = "repositories";
    public static final String LOCAL_REPOSITORY_NAME = "local";
    public static final String DISTRIBUTION_REPOSITORY_NAME = "distribution";
    public static final String CENTRAL_REPOSITORY_CACHE_NAME = "central.ballerina.io";
    public static final String MAVEN_REPOSITORY_CACHE_NAME = "maven";
    public static final String DEPENDENCIES_TOML_VERSION = "2";
    public static final String BALLERINA_ORG = "ballerina";
    public static final String EXISTING_PACKAGE_FILES_DIR = "directories-with-existing-package-files-for-bal-new";
    public static final String CONFIG_ARGS_PATTERN = "-C[\\w\\W]+=([\\w\\W]+)";
    public static final String CONFIG_DIR = ".config";
    public static final String PROFILER_DIR_NAME = "profiler";
    public static final String TOOL_CACHE_DIR = "tool-cache";
    public static final String TOOL_DIAGNOSTIC_CODE_PREFIX = "BCE53";
    public static final String ORG = "org";
    public static final String PACKAGE_NAME = "name";
    public static final String LOCAL_TOOLS_JSON = "local-tools.json";
    public static final String STICKY_FLAG = "--sticky";
    public static final String OFFLINE_FLAG = "--offline";
    public static final String REPOSITORY_FLAG = "--repository";
    public static final String WILD_CARD = "*";
}
