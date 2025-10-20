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
import org.ballerinalang.central.client.exceptions.ConnectionErrorException;
import org.ballerinalang.central.client.exceptions.NoPackageException;
import org.ballerinalang.central.client.exceptions.PackageAlreadyExistsException;
import org.ballerinalang.central.client.model.ConnectorInfo;
import org.ballerinalang.central.client.model.Package;
import org.ballerinalang.central.client.model.PackageNameResolutionRequest;
import org.ballerinalang.central.client.model.PackageNameResolutionResponse;
import org.ballerinalang.central.client.model.PackageResolutionRequest;
import org.ballerinalang.central.client.model.PackageResolutionResponse;
import org.ballerinalang.central.client.model.PackageSearchResult;
import org.ballerinalang.central.client.model.ToolResolutionCentralRequest;
import org.ballerinalang.central.client.model.ToolResolutionCentralResponse;
import org.ballerinalang.central.client.model.ToolSearchResult;

import java.io.PrintStream;
import java.util.List;

/**
 * J2CL-compatible stub implementation of CentralAPIClient.
 * This class provides minimal functionality for web compiler context.
 */
public class CentralAPIClient {

    private final String baseUrl;
    private final String accessToken;

    public CentralAPIClient(String baseUrl, String accessToken) {
        this.baseUrl = baseUrl;
        this.accessToken = accessToken;
    }

    public CentralAPIClient(String baseUrl) {
        this(baseUrl, null);
    }

    /**
     * Stub implementation for web compiler context.
     * Throws UnsupportedOperationException as this functionality is not available in web context.
     */
    public PackageResolutionResponse resolvePackage(PackageResolutionRequest request) throws CentralClientException {
        throw new UnsupportedOperationException("Package resolution is not supported in web compiler context");
    }

    /**
     * Stub implementation for web compiler context.
     * Throws UnsupportedOperationException as this functionality is not available in web context.
     */
    public PackageNameResolutionResponse resolvePackageNames(PackageNameResolutionRequest request) throws CentralClientException {
        throw new UnsupportedOperationException("Package name resolution is not supported in web compiler context");
    }

    /**
     * Stub implementation for web compiler context.
     * Throws UnsupportedOperationException as this functionality is not available in web context.
     */
    public PackageSearchResult searchPackages(String query, int offset, int limit) throws CentralClientException {
        throw new UnsupportedOperationException("Package search is not supported in web compiler context");
    }

    /**
     * Stub implementation for web compiler context.
     * Throws UnsupportedOperationException as this functionality is not available in web context.
     */
    public Package getPackage(String orgName, String packageName, String version) throws CentralClientException, NoPackageException {
        throw new UnsupportedOperationException("Package retrieval is not supported in web compiler context");
    }

    /**
     * Stub implementation for web compiler context.
     * Throws UnsupportedOperationException as this functionality is not available in web context.
     */
    public void pushPackage(String balaFilePath, PrintStream out) throws CentralClientException, PackageAlreadyExistsException {
        throw new UnsupportedOperationException("Package push is not supported in web compiler context");
    }

    /**
     * Stub implementation for web compiler context.
     * Throws UnsupportedOperationException as this functionality is not available in web context.
     */
    public void pullPackage(String orgName, String packageName, String version, String outputDir, PrintStream out) throws CentralClientException, NoPackageException {
        throw new UnsupportedOperationException("Package pull is not supported in web compiler context");
    }

    /**
     * Stub implementation for web compiler context.
     * Throws UnsupportedOperationException as this functionality is not available in web context.
     */
    public List<ConnectorInfo> getConnectors(String query, int offset, int limit) throws CentralClientException {
        throw new UnsupportedOperationException("Connector retrieval is not supported in web compiler context");
    }

    /**
     * Stub implementation for web compiler context.
     * Throws UnsupportedOperationException as this functionality is not available in web context.
     */
    public ToolResolutionCentralResponse resolveTool(ToolResolutionCentralRequest request) throws CentralClientException {
        throw new UnsupportedOperationException("Tool resolution is not supported in web compiler context");
    }

    /**
     * Stub implementation for web compiler context.
     * Throws UnsupportedOperationException as this functionality is not available in web context.
     */
    public ToolSearchResult searchTools(String query, int offset, int limit) throws CentralClientException {
        throw new UnsupportedOperationException("Tool search is not supported in web compiler context");
    }

    /**
     * Stub implementation for web compiler context.
     * Returns false as this functionality is not available in web context.
     */
    public boolean isPackageAvailable(String orgName, String packageName, String version) {
        return false;
    }

    /**
     * Stub implementation for web compiler context.
     * Throws UnsupportedOperationException as this functionality is not available in web context.
     */
    public void setAccessToken(String accessToken) {
        throw new UnsupportedOperationException("Access token setting is not supported in web compiler context");
    }

    /**
     * Stub implementation for web compiler context.
     * Throws UnsupportedOperationException as this functionality is not available in web context.
     */
    public void setProxy(String host, int port) {
        throw new UnsupportedOperationException("Proxy setting is not supported in web compiler context");
    }

    /**
     * Stub implementation for web compiler context.
     * Throws UnsupportedOperationException as this functionality is not available in web context.
     */
    public void setConnectionTimeout(int timeout) {
        throw new UnsupportedOperationException("Connection timeout setting is not supported in web compiler context");
    }

    /**
     * Stub implementation for web compiler context.
     * Throws UnsupportedOperationException as this functionality is not available in web context.
     */
    public void setReadTimeout(int timeout) {
        throw new UnsupportedOperationException("Read timeout setting is not supported in web compiler context");
    }
}
