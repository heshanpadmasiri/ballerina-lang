/*
 * Copyright (c) 2025, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

package org.wso2.ballerinalang.compiler.util;

/**
 * XML-related constants used in the Ballerina compiler.
 * These constants are defined according to the XML specification.
 *
 * This class replaces the dependency on javax.xml.XMLConstants.
 *
 * @since 2.0.0
 */
public final class XMLConstants {

    /**
     * The default namespace prefix.
     *
     * This is an empty string, representing a namespace declaration without a prefix.
     * According to the XML Namespaces specification, this represents the default namespace.
     */
    public static final String DEFAULT_NS_PREFIX = "";

    /**
     * The official XML attribute name for namespace declarations.
     *
     * Value: "xmlns"
     *
     * According to the XML Namespaces specification, this is the reserved attribute
     * name used for declaring XML namespaces.
     */
    public static final String XMLNS_ATTRIBUTE = "xmlns";

    /**
     * Private constructor to prevent instantiation.
     */
    private XMLConstants() {
        throw new AssertionError("Utility class should not be instantiated");
    }
}
