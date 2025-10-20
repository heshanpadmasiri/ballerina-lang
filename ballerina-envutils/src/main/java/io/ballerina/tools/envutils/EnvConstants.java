package io.ballerina.tools.envutils;

import java.util.HashMap;
import java.util.Map;

/**
 * Environment constants for web-compiler.
 * This class provides hardcoded environment variable values to replace System.getenv calls.
 */
public class EnvConstants {

    // Hardcoded environment variable values (captured from runtime)
    private static final String BALLERINA_HOME_DIR = null;
    private static final String BALLERINA_STAGE_CENTRAL = null;
    private static final String BALLERINA_DEV_CENTRAL = null;
    private static final String BALLERINA_CLI_WIDTH = null;

    /**
     * Get environment variable value by key.
     *
     * @param key the environment variable key
     * @return the hardcoded value for the key, or null if not found
     */
    public static String getEnv(String key) {
        if (key == null) {
            return null;
        }

        switch (key) {
            case "BALLERINA_HOME_DIR":
                return BALLERINA_HOME_DIR;
            case "BALLERINA_STAGE_CENTRAL":
                return BALLERINA_STAGE_CENTRAL;
            case "BALLERINA_DEV_CENTRAL":
                return BALLERINA_DEV_CENTRAL;
            case "BALLERINA_CLI_WIDTH":
                return BALLERINA_CLI_WIDTH;
            default:
                return null;
        }
    }

    /**
     * Get all environment variables as a map.
     * This replaces System.getenv() calls that retrieve all environment variables.
     *
     * @return a map containing only the hardcoded environment variables
     */
    public static Map<String, String> getEnvMap() {
        Map<String, String> envMap = new HashMap<>();

        if (BALLERINA_HOME_DIR != null) {
            envMap.put("BALLERINA_HOME_DIR", BALLERINA_HOME_DIR);
        }
        if (BALLERINA_STAGE_CENTRAL != null) {
            envMap.put("BALLERINA_STAGE_CENTRAL", BALLERINA_STAGE_CENTRAL);
        }
        if (BALLERINA_DEV_CENTRAL != null) {
            envMap.put("BALLERINA_DEV_CENTRAL", BALLERINA_DEV_CENTRAL);
        }
        if (BALLERINA_CLI_WIDTH != null) {
            envMap.put("BALLERINA_CLI_WIDTH", BALLERINA_CLI_WIDTH);
        }

        return envMap;
    }
}
