/*
 * Copyright (c) 2019, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package org.wso2.ballerinalang.compiler.packaging.converters;

import org.ballerinalang.model.elements.PackageID;
import org.wso2.ballerinalang.compiler.util.Name;
import org.wso2.ballerinalang.compiler.util.Names;
import org.wso2.ballerinalang.compiler.util.ProjectDirConstants;
import org.wso2.ballerinalang.util.RepoUtils;

import java.io.IOException;
import java.nio.file.Files;
import io.ballerina.fs.Path;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.stream.Stream;

/**
 * Provide functions to convert a patten to a stream of zip paths.
 */
public class ZipConverter extends PathConverter {

    public ZipConverter(Path archivePath) {
        super(resolveIntoArchive(archivePath));
    }

    @Override
    public Path combine(Path path, String pathPart) {
        return resolveIntoArchive(path.resolve(pathPart));
    }

    private static Path resolveIntoArchive(Path newPath) {
        throw new RuntimeException();
    }

    @Override
    public Stream<Path> getLatestVersion(Path path, PackageID packageID) {
        throw new RuntimeException();
    }
    
    /**
     * Check if the module in caches in invalid.
     *
     * @param balaPath Path to the parent folder of the bala file.
     * @return if the module cached is invalid or not.
     */
    private boolean checkForCacheInvalidity(Path balaPath) {
        Path nightlyFilePath = balaPath.resolve(ProjectDirConstants.NIGHTLY_BUILD);
        // Check if the cached module was pulled from a nightly, if not return false
        if (!nightlyFilePath.exists()) {
            return false;
        }
        
        // Get modified of the module zip file.
        Date modifiedDate = new Date(nightlyFilePath.toFile().lastModified());
        // Set the cache invalidation time as the midnight of today
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.HOUR_OF_DAY, 0);
        cal.set(Calendar.MINUTE, 0);
        cal.set(Calendar.SECOND, 0);
        Date midnightDate = cal.getTime();

        // If the module was not pulled before the cache invalidation time and if it was pulled on the same day, return
        // false
        if (!modifiedDate.before(midnightDate)) {
            return false;
        }
        // The module cached has been invalidated so clean the directory and pull again.
        try {
            //Delete the metadata file
            deleteFiles(balaPath);
            // Delete all the empty directories
            deleteEmptyParentDirs(balaPath, this.getRoot());
        } catch (IOException ignore) {
            // An I/O exception occurs when deleting the files inside the downloaded mod. Since
            // this is done during dependency resolution, we don't throw an exception to the user so instead we
            // return an empty stream.
        }
        return true;
    }
    
    /**
     * Delete files inside directories.
     *
     * @param dirPath directory path
     * @throws IOException throw an exception if an issue occurs
     */
    public static void deleteFiles(Path dirPath) throws IOException {
        throw new RuntimeException();
    }

    /**
     * Delete empty parent directories.
     * After deleting the module.zip from the home repository we should delete the empty directories as well. We need
     * to delete all folders from the module path to the home directory only if they are empty (going backwards).
     * If the directory path is empty i.e. does not contain any files we simply delete the folder else we don't delete.
     *
     * @param modulePath package directory path
     * @param repoPath   home repository path
     * @throws IOException throw an exception if an error occurs
     */
    private static void deleteEmptyParentDirs(Path modulePath, Path repoPath) throws IOException {
        throw new RuntimeException();
    }
}
