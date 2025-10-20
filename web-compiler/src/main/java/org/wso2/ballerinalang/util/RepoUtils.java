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
package org.wso2.ballerinalang.util;

import java.io.InputStream;
import java.util.Map;
import java.util.Properties;

import io.ballerina.fs.Path;
import org.ballerinalang.compiler.BLangCompilerException;
import org.ballerinalang.toml.model.Manifest;
import org.wso2.ballerinalang.compiler.util.ProjectDirConstants;
import org.wso2.ballerinalang.compiler.util.ProjectDirs;

/**
 * Home repository util methods.
 */
public final class RepoUtils {

    public static final String BALLERINA_INSTALL_DIR_PROP = "ballerina.home";
    public static final String COMPILE_BALLERINA_ORG_PROP = "BALLERINA_DEV_COMPILE_BALLERINA_ORG";
    public static final String LOAD_BUILTIN_FROM_SOURCE_PROP = "BALLERINA_DEV_LOAD_BUILTIN_FROM_SOURCE";
    public static final boolean COMPILE_BALLERINA_ORG = getBooleanProp(COMPILE_BALLERINA_ORG_PROP);
    public static final boolean LOAD_BUILTIN_FROM_SOURCE = getBooleanProp(LOAD_BUILTIN_FROM_SOURCE_PROP);

    private static final String USER_HOME = "user.home";
    private static final String DEFAULT_TERMINAL_SIZE = "80";
    private static final String BALLERINA_CLI_WIDTH = "BALLERINA_CLI_WIDTH";
    private static final String PRODUCTION_URL = "https://api.central.ballerina.io/2.0/registry";
    private static final String STAGING_URL = "https://api.staging-central.ballerina.io/2.0/registry";
    private static final String DEV_URL = "https://api.dev-central.ballerina.io/2.0/registry";
    private static final String PRODUCTION_GRAPHQL_URL = "https://api.central.ballerina.io/2.0/graphql";
    private static final String STAGING_GRAPHQL_URL = "https://api.staging-central.ballerina.io/2.0/graphql";
    private static final String DEV_GRAPHQL_URL = "https://api.dev-central.ballerina.io/2.0/graphql";

    private static final String BALLERINA_ORG = "ballerina";

    public static final String BALLERINA_STAGE_CENTRAL = "BALLERINA_STAGE_CENTRAL";
    public static final String BALLERINA_DEV_CENTRAL = "BALLERINA_DEV_CENTRAL";
    public static final boolean SET_BALLERINA_STAGE_CENTRAL = Boolean.parseBoolean(
            System.getenv(BALLERINA_STAGE_CENTRAL));
    public static final boolean SET_BALLERINA_DEV_CENTRAL = Boolean.parseBoolean(
            System.getenv(BALLERINA_DEV_CENTRAL));

    private static final String UNKNOWN = "unknown";

    private RepoUtils() {
    }

    /**
     * Create and get the home repository path.
     *
     * @return home repository path
     */
    public static Path createAndGetHomeReposPath() {
        Path homeRepoPath;
        String homeRepoDir = System.getenv(ProjectDirConstants.HOME_REPO_ENV_KEY);
        if (homeRepoDir == null || homeRepoDir.isEmpty()) {
            String userHomeDir = System.getProperty(USER_HOME);
            if (userHomeDir == null || userHomeDir.isEmpty()) {
                throw new BLangCompilerException("Error creating home repository: unable to get user home directory");
            }
            homeRepoPath = Path.of(userHomeDir, ProjectDirConstants.HOME_REPO_DEFAULT_DIRNAME);
        } else {
            // User has specified the home repo path with env variable.
            homeRepoPath = Path.of(homeRepoDir);
        }

        homeRepoPath = homeRepoPath.toAbsolutePath();
        if (homeRepoPath.exists() && !homeRepoPath.isDirectory()) {
            throw new BLangCompilerException("Home repository is not a directory: " + homeRepoPath);
        }
        return homeRepoPath;
    }

    /**
     * Checks if the path is a project.
     *
     * @param sourceRoot source root of the project.
     * @return true if the directory is a project repo, false if its the home repo
     */
    public static boolean isBallerinaProject(Path sourceRoot) {
        Path manifest = sourceRoot.resolve(ProjectDirConstants.MANIFEST_FILE_NAME);
        return sourceRoot.isDirectory() && manifest.exists() && manifest.isRegularFile();
    }

    /**
     * Checks if the path is a standalone file.
     *
     * @param file path to bal file
     * @return true if the file is a standalone bal file
     */
    public static boolean isBallerinaStandaloneFile(Path file) {
        // Check if the file is a regular file
        if (!file.isRegularFile()) {
            return false;
        }
        // Check if it is a file with bal extention.
        if (!file.toString().endsWith(ProjectDirConstants.BLANG_SOURCE_EXT)) {
            return false;
        }
        // Check if it is inside a project
        Path projectRoot = ProjectDirs.findProjectRoot(file.getParent());
        if (null != projectRoot) {
            // Check if it is inside a module
            Path src = projectRoot.resolve(ProjectDirConstants.SOURCE_DIR_NAME);
            Path parent = file.getParent();
            while (parent != null) {
                if (src.equals(parent)) {
                    return false;
                }
                parent = parent.getParent();
            }
            return true;
        } else {
            return true;
        }
    }


    /**
     * Get the remote repo URL.
     *
     * @return URL of the remote repository
     */
    public static String getRemoteRepoURL() {
        if (SET_BALLERINA_STAGE_CENTRAL) {
            return STAGING_URL;
        } else if (SET_BALLERINA_DEV_CENTRAL) {
            return DEV_URL;
        }
        return PRODUCTION_URL;
    }

    /**
     * Get the graphQL remote repo URL.
     *
     * @return URL of the remote repository
     */
    public static String getRemoteRepoGraphQLURL() {
        if (SET_BALLERINA_STAGE_CENTRAL) {
            return STAGING_GRAPHQL_URL;
        } else if (SET_BALLERINA_DEV_CENTRAL) {
            return DEV_GRAPHQL_URL;
        }
        return PRODUCTION_GRAPHQL_URL;
    }

    /**
     * Get the staging URL.
     *
     * @return URL of the remote repository
     */
    public static String getStagingURL() {
            return STAGING_URL;
    }

    public static Path getLibDir() {
        return Path.of(System.getProperty(BALLERINA_INSTALL_DIR_PROP, ".")).resolve("lib");
    }

    /**
     * Get the terminal width.
     *
     * @return terminal width as a string
     */
    public static String getTerminalWidth() {
        Map<String, String> envVariableMap = System.getenv();
        if (envVariableMap.containsKey(BALLERINA_CLI_WIDTH)) {
            return envVariableMap.get(BALLERINA_CLI_WIDTH);
        }
        return DEFAULT_TERMINAL_SIZE;
    }

    public static Path createAndGetLibsRepoPath() {
        String ballerinaHome = System.getProperty(ProjectDirConstants.BALLERINA_HOME);
        if (ballerinaHome == null || ballerinaHome.isEmpty()) {
            return null;
        }

        return Path.of(ballerinaHome).resolve(ProjectDirConstants.BALLERINA_HOME_LIB);
    }

    private static boolean getBooleanProp(String key) {
        return Boolean.parseBoolean(System.getProperty(key));
    }


    /**
     * Get the ballerina version the package is built with.
     *
     * @return ballerina version
     */
    public static String getBallerinaVersion() {
        try (InputStream inputStream = RepoUtils.class.getResourceAsStream(ProjectDirConstants.PROPERTIES_FILE)) {
            Properties properties = new Properties();
            properties.load(inputStream);
            return properties.getProperty(ProjectDirConstants.BALLERINA_VERSION);
        } catch (Throwable ignore) {
        }
        return UNKNOWN;
    }

    public static String getBallerinaShortVersion() {
        try (InputStream inputStream = RepoUtils.class.getResourceAsStream(ProjectDirConstants.PROPERTIES_FILE)) {
            Properties properties = new Properties();
            properties.load(inputStream);
            return properties.getProperty(ProjectDirConstants.BALLERINA_SHORT_VERSION);
        } catch (Throwable ignore) {
        }
        return UNKNOWN;
    }

    public static String getBallerinaSpecVersion() {
        try (InputStream inputStream = RepoUtils.class.getResourceAsStream(ProjectDirConstants.PROPERTIES_FILE)) {
            Properties properties = new Properties();
            properties.load(inputStream);
            return properties.getProperty(ProjectDirConstants.BALLERINA_SPEC_VERSION);
        } catch (Throwable ignore) {
        }
        return UNKNOWN;
    }

    /**
     * Get the Ballerina.toml from a bala file.
     *
     * @param balaPath The path to bala file.
     * @return Ballerina.toml contents.
     */
    public static Manifest getManifestFromBala(Path balaPath) {
        throw new RuntimeException();
    }

}
