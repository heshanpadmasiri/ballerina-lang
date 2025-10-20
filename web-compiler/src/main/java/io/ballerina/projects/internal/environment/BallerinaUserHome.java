package io.ballerina.projects.internal.environment;

import io.ballerina.fs.Path;
import io.ballerina.projects.ProjectException;
import io.ballerina.projects.Settings;
import io.ballerina.projects.TomlDocument;
import io.ballerina.projects.environment.Environment;
import io.ballerina.projects.internal.SettingsBuilder;
import io.ballerina.projects.internal.model.Repository;
import io.ballerina.projects.internal.repositories.CustomPkgRepositoryContainer;
import io.ballerina.projects.internal.repositories.LocalPackageRepository;
import io.ballerina.projects.internal.repositories.MavenPackageRepository;
import io.ballerina.projects.internal.repositories.RemotePackageRepository;
import io.ballerina.projects.util.ProjectConstants;
import org.wso2.ballerinalang.util.RepoUtils;

import java.util.HashMap;
import java.util.Map;

/**
 * Represents the Ballerina user home and responsible for resolving cached packages.
 *
 * @since 2.0.0
 */
public final class BallerinaUserHome {

    private final Path ballerinaUserHomeDirPath;
    private final RemotePackageRepository remotePackageRepository;
    private final LocalPackageRepository localPackageRepository;
    private final Map<String, MavenPackageRepository> mavenCustomRepositories;

    private BallerinaUserHome(Environment environment, Path ballerinaUserHomeDirPath) {
        this.ballerinaUserHomeDirPath = ballerinaUserHomeDirPath;
        Path repositoryPath = ballerinaUserHomeDirPath.resolve(ProjectConstants.REPOSITORIES_DIR);
        Path remotePackageRepositoryPath = ballerinaUserHomeDirPath.resolve(ProjectConstants.REPOSITORIES_DIR)
                .resolve(ProjectConstants.CENTRAL_REPOSITORY_CACHE_NAME);
//        remotePackageRepositoryPath.createDirectories();

        this.remotePackageRepository = RemotePackageRepository
                .from(environment, remotePackageRepositoryPath, readSettings());
        this.localPackageRepository = createLocalRepository(environment);
        this.mavenCustomRepositories = createMavenCustomRepositories(environment);
    }

    private Map<String, MavenPackageRepository> createMavenCustomRepositories(Environment environment) {
        Map<String, MavenPackageRepository> customRepositories = new HashMap<>();
        Repository[] repositories = readSettings().getRepositories();
        for (Repository repository : repositories) {
            Path repositoryPath = ballerinaUserHomeDirPath.resolve(ProjectConstants.REPOSITORIES_DIR)
                    .resolve(repository.id());
            repositoryPath.createDirectories();

            if (!customRepositories.containsKey(repository.id())) {
                customRepositories.put(repository.id(), MavenPackageRepository.from(environment, repositoryPath,
                        repository));
            }
        }
        return customRepositories;
    }

    public static BallerinaUserHome from(Environment environment, Path ballerinaUserHomeDirPath) {
        validateBallerinaUserHomeDir(ballerinaUserHomeDirPath);
        return new BallerinaUserHome(environment, ballerinaUserHomeDirPath);
    }

    public static BallerinaUserHome from(Environment environment) {
        String userHomeDir = System.getProperty("user.home");
        if (userHomeDir == null || userHomeDir.isEmpty()) {
            throw new ProjectException("unable to get user home directory");
        }

        Path homeRepoPath = Path.of(userHomeDir, ProjectConstants.HOME_REPO_DEFAULT_DIRNAME);
        return from(environment, homeRepoPath);
    }

    public RemotePackageRepository remotePackageRepository() {
        return this.remotePackageRepository;
    }

    public Map<String, MavenPackageRepository> customRepositories() {
        return this.mavenCustomRepositories;
    }

    public CustomPkgRepositoryContainer customPkgRepositoryContainer() {
        return new CustomPkgRepositoryContainer(mavenCustomRepositories);
    }

    public LocalPackageRepository localPackageRepository() {
        return localPackageRepository;
    }

    /**
     * Read Settings.toml to populate the configurations.
     *
     * @return {@link Settings} settings object
     */
    private Settings readSettings() {
        Path settingsFilePath = this.ballerinaUserHomeDirPath.resolve(ProjectConstants.SETTINGS_FILE_NAME);
        String settings = """
                """;
//        if (settingsFilePath.notExists()) {
//            settingsFilePath.createFile();
//        }
        TomlDocument settingsTomlDocument = TomlDocument
                .from(String.valueOf(settingsFilePath.getFileName()), settings);
        SettingsBuilder settingsBuilder = SettingsBuilder.from(settingsTomlDocument);
        return settingsBuilder.settings();
    }

    private static void validateBallerinaUserHomeDir(Path ballerinaUserHomeDirPath) {
        // If directory does not exists, create it
//        if (ballerinaUserHomeDirPath.notExists() || !ballerinaUserHomeDirPath.isDirectory()) {
//            ballerinaUserHomeDirPath.createDirectories();
//        }
    }

    private LocalPackageRepository createLocalRepository(Environment environment) {
        Path repositoryPath = ballerinaUserHomeDirPath.resolve(ProjectConstants.REPOSITORIES_DIR)
                .resolve(ProjectConstants.LOCAL_REPOSITORY_NAME);
//        repositoryPath.createDirectories();
        String ballerinaShortVersion = RepoUtils.getBallerinaShortVersion();
        return new LocalPackageRepository(environment, repositoryPath, ballerinaShortVersion);
    }
}
