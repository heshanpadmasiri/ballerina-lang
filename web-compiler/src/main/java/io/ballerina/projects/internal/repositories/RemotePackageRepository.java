package io.ballerina.projects.internal.repositories;

import io.ballerina.fs.Path;
import io.ballerina.projects.Package;
import io.ballerina.projects.PackageVersion;
import io.ballerina.projects.ProjectException;
import io.ballerina.projects.Settings;
import io.ballerina.projects.environment.Environment;
import io.ballerina.projects.environment.PackageMetadataResponse;
import io.ballerina.projects.environment.PackageRepository;
import io.ballerina.projects.environment.ResolutionOptions;
import io.ballerina.projects.environment.ResolutionRequest;
import io.ballerina.projects.internal.ImportModuleRequest;
import io.ballerina.projects.internal.ImportModuleResponse;
import org.wso2.ballerinalang.util.RepoUtils;

import java.net.Proxy;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static io.ballerina.projects.DependencyGraph.DependencyGraphBuilder.getBuilder;
import static io.ballerina.projects.util.ProjectUtils.initializeProxy;

/**
 * This class represents the remote package repository.
 *
 * @since 2.0.0
 */
public class RemotePackageRepository implements PackageRepository {

    private final FileSystemRepository fileSystemRepo;

    public RemotePackageRepository(FileSystemRepository fileSystemRepo) {
        this.fileSystemRepo = fileSystemRepo;
    }

    public static RemotePackageRepository from(Environment environment, Path cacheDirectory, String repoUrl,
                                               Settings settings) {
//        if (cacheDirectory.notExists()) {
//            throw new ProjectException("cache directory does not exists: " + cacheDirectory);
//        }
        String ballerinaShortVersion = RepoUtils.getBallerinaShortVersion();
        FileSystemRepository fileSystemRepository = new FileSystemRepository(
                environment, cacheDirectory, ballerinaShortVersion);
        Proxy proxy = initializeProxy(settings.getProxy());
//        CentralAPIClient client = new CentralAPIClient(repoUrl, proxy, settings.getProxy().username(),
//                settings.getProxy().password(), getAccessTokenOfCLI(settings),
//                settings.getCentral().getConnectTimeout(),
//                settings.getCentral().getReadTimeout(), settings.getCentral().getWriteTimeout(),
//                settings.getCentral().getCallTimeout(), settings.getCentral().getMaxRetries());
        return new RemotePackageRepository(fileSystemRepository);
    }

    public static RemotePackageRepository from(Environment environment, Path cacheDirectory, Settings settings) {
        String repoUrl = RepoUtils.getRemoteRepoURL();
        if ("".equals(repoUrl)) {
            throw new ProjectException("remote repo url is empty");
        }

        return from(environment, cacheDirectory, repoUrl, settings);
    }

    @Override
    public Optional<Package> getPackage(ResolutionRequest request, ResolutionOptions options) {
        throw new RuntimeException();
    }

    @Override
    public Collection<PackageVersion> getPackageVersions(ResolutionRequest request, ResolutionOptions options) {
        throw new RuntimeException();
    }

    @Override
    public Map<String, List<String>> getPackages() {
        // We only return locally cached packages
        return fileSystemRepo.getPackages();
    }

    @Override
    public Collection<ImportModuleResponse> getPackageNames(Collection<ImportModuleRequest> requests,
                                                            ResolutionOptions options) {
        throw new RuntimeException();
    }

    @Override
    public Collection<PackageMetadataResponse> getPackageMetadata(Collection<ResolutionRequest> requests,
                                                                  ResolutionOptions options) {
        throw new RuntimeException();
    }

}
