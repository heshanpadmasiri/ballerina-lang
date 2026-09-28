import ballerina/os;

public function main() returns error? {
    os:Command command = {
        value: "/Library/Ballerina/bin/bal",
        arguments: ["test", "--list-groups", "visibility-v"]
    };
    os:Process process = check os:exec(command);
    int exitCode = check process.waitForExit();
    if exitCode != 0 {
        return error("visibility test-source compilation failed");
    }
}
