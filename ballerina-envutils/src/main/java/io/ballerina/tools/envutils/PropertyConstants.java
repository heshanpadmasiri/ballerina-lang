package io.ballerina.tools.envutils;

import java.util.HashMap;
import java.util.Map;

/**
 * System property constants for web-compiler.
 * This class provides hardcoded system property values to replace System.getProperty calls.
 */
public class PropertyConstants {

    // Hardcoded system property values (captured from runtime)
    private static final String BALLERINA_HOME = "/virtual/.ballerina";
    private static final String BALLERINA_VERSION = "2201.13.0-m3";
    private static final String BALLERINA_SHORT_VERSION = null;
    private static final String SPEC_VERSION = "2024R1";
    private static final String OS_NAME = "Mac OS X";
    private static final String USER_HOME = "/Users/heshanp";
    private static final String DISTRIBUTED_TRANSACTIONS = null;
    private static final String BOOTSTRAP_LANG_LIB = null;
    private static final String BALLERINA_DEV_COMPILE_BALLERINA_ORG = null;
    private static final String BALLERINA_DEV_LOAD_BUILTIN_FROM_SOURCE = null;

    // Hardcoded tool.properties values
    private static final String BALLERINA_CHANNEL = "Swan Lake";
    private static final String BALLERINA_PACK_VERSION = "2201.13.0-m3";
    private static final String API_DOCS_VERSION = "1.0.0";

    /**
     * Get system property value by key.
     *
     * @param key the system property key
     * @return the hardcoded value for the key, or null if not found
     */
    public static String getProperty(String key) {
        if (key == null) {
            return null;
        }

        switch (key) {
            case "ballerina.home":
                return BALLERINA_HOME;
            case "ballerina.version":
                return BALLERINA_VERSION;
            case "ballerina.short.version":
                return BALLERINA_SHORT_VERSION;
            case "spec.version":
                return SPEC_VERSION;
            case "os.name":
                return OS_NAME;
            case "user.home":
                return USER_HOME;
            case "DISTRIBUTED_TRANSACTIONS":
                return DISTRIBUTED_TRANSACTIONS;
            case "BOOTSTRAP_LANG_LIB":
                return BOOTSTRAP_LANG_LIB;
            case "BALLERINA_DEV_COMPILE_BALLERINA_ORG":
                return BALLERINA_DEV_COMPILE_BALLERINA_ORG;
            case "BALLERINA_DEV_LOAD_BUILTIN_FROM_SOURCE":
                return BALLERINA_DEV_LOAD_BUILTIN_FROM_SOURCE;
            case "ballerina.channel":
                return BALLERINA_CHANNEL;
            case "ballerina.packVersion":
                return BALLERINA_PACK_VERSION;
            case "apiDocs.version":
                return API_DOCS_VERSION;
            default:
                return null;
        }
    }

    /**
     * Get a property value from the hardcoded tool.properties.
     * This replaces Properties.load() calls that read from /META-INF/tool.properties.
     *
     * @param key the property key
     * @return the hardcoded value for the key, or null if not found
     */
    public static String getToolProperty(String key) {
        if (key == null) {
            return null;
        }

        switch (key) {
            case "ballerina.channel":
                return BALLERINA_CHANNEL;
            case "ballerina.version":
                return BALLERINA_VERSION;
            case "ballerina.packVersion":
                return BALLERINA_PACK_VERSION;
            case "spec.version":
                return SPEC_VERSION;
            case "apiDocs.version":
                return API_DOCS_VERSION;
            default:
                return null;
        }
    }

    /**
     * Get all tool.properties as a map.
     * This replaces Properties.load() calls that read from /META-INF/tool.properties.
     *
     * @return a map containing the hardcoded tool.properties
     */
    public static Map<String, String> getToolPropertyMap() {
        Map<String, String> propMap = new HashMap<>();
        propMap.put("ballerina.channel", BALLERINA_CHANNEL);
        propMap.put("ballerina.version", BALLERINA_VERSION);
        propMap.put("ballerina.packVersion", BALLERINA_PACK_VERSION);
        propMap.put("spec.version", SPEC_VERSION);
        propMap.put("apiDocs.version", API_DOCS_VERSION);
        return propMap;
    }

    /**
     * Get system property value by key with a default value.
     *
     * @param key the system property key
     * @param defaultValue the default value to return if key is not found
     * @return the hardcoded value for the key, or defaultValue if not found
     */
    public static String getProperty(String key, String defaultValue) {
        String value = getProperty(key);
        return value != null ? value : defaultValue;
    }

    /**
     * Get all system properties as a map.
     * This replaces System.getProperties() calls that retrieve all properties.
     *
     * @return a map containing only the hardcoded system properties
     */
    public static Map<String, String> getPropertyMap() {
        Map<String, String> propMap = new HashMap<>();

        if (BALLERINA_HOME != null) {
            propMap.put("ballerina.home", BALLERINA_HOME);
        }
        if (BALLERINA_VERSION != null) {
            propMap.put("ballerina.version", BALLERINA_VERSION);
        }
        if (BALLERINA_SHORT_VERSION != null) {
            propMap.put("ballerina.short.version", BALLERINA_SHORT_VERSION);
        }
        if (SPEC_VERSION != null) {
            propMap.put("spec.version", SPEC_VERSION);
        }
        if (OS_NAME != null) {
            propMap.put("os.name", OS_NAME);
        }
        if (USER_HOME != null) {
            propMap.put("user.home", USER_HOME);
        }
        if (DISTRIBUTED_TRANSACTIONS != null) {
            propMap.put("DISTRIBUTED_TRANSACTIONS", DISTRIBUTED_TRANSACTIONS);
        }
        if (BOOTSTRAP_LANG_LIB != null) {
            propMap.put("BOOTSTRAP_LANG_LIB", BOOTSTRAP_LANG_LIB);
        }
        if (BALLERINA_DEV_COMPILE_BALLERINA_ORG != null) {
            propMap.put("BALLERINA_DEV_COMPILE_BALLERINA_ORG", BALLERINA_DEV_COMPILE_BALLERINA_ORG);
        }
        if (BALLERINA_DEV_LOAD_BUILTIN_FROM_SOURCE != null) {
            propMap.put("BALLERINA_DEV_LOAD_BUILTIN_FROM_SOURCE", BALLERINA_DEV_LOAD_BUILTIN_FROM_SOURCE);
        }

        return propMap;
    }
}
