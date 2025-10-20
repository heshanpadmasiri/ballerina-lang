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

package org.ballerinalang.central.client;

import org.ballerinalang.central.client.exceptions.CentralClientException;
import org.ballerinalang.central.client.exceptions.PackageAlreadyExistsException;

import java.io.PrintStream;

/**
 * J2CL-compatible stub implementation of Utils.
 * This class provides minimal functionality for web compiler context.
 */
public class Utils {

    public static final String BALLERINA_CENTRAL_CLIENT_USER_AGENT = "ballerina-central-client";
    public static final String BALLERINA_CENTRAL_CLIENT_VERSION = "1.0.0";

    /**
     * Stub implementation for web compiler context.
     * Throws UnsupportedOperationException as this functionality is not available in web context.
     */
    public static void downloadFile(String url, String fileName, PrintStream out) throws CentralClientException {
        throw new UnsupportedOperationException("File download is not supported in web compiler context");
    }

    /**
     * Stub implementation for web compiler context.
     * Throws UnsupportedOperationException as this functionality is not available in web context.
     */
    public static void downloadFileWithProgress(String url, String fileName, PrintStream out) throws CentralClientException {
        throw new UnsupportedOperationException("File download with progress is not supported in web compiler context");
    }

    /**
     * Stub implementation for web compiler context.
     * Throws UnsupportedOperationException as this functionality is not available in web context.
     */
    public static void uploadFile(String url, String fileName, PrintStream out) throws CentralClientException, PackageAlreadyExistsException {
        throw new UnsupportedOperationException("File upload is not supported in web compiler context");
    }

    /**
     * Stub implementation for web compiler context.
     * Returns empty string as this functionality is not available in web context.
     */
    public static String getBallerinaVersion() {
        return "1.0.0";
    }

    /**
     * Stub implementation for web compiler context.
     * Returns false as this functionality is not available in web context.
     */
    public static boolean isBallerinaProject(String projectPath) {
        return false;
    }

    /**
     * Stub implementation for web compiler context.
     * Throws UnsupportedOperationException as this functionality is not available in web context.
     */
    public static void extractBala(String balaPath, String extractPath) throws CentralClientException {
        throw new UnsupportedOperationException("Bala extraction is not supported in web compiler context");
    }

    /**
     * Stub implementation for web compiler context.
     * Throws UnsupportedOperationException as this functionality is not available in web context.
     */
    public static void createBala(String projectPath, String balaPath) throws CentralClientException {
        throw new UnsupportedOperationException("Bala creation is not supported in web compiler context");
    }
}
