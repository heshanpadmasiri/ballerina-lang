public type InMemoryModeConfig record {|
    string name = "";
    string username = "";
    string password = "";
    map<any> dbOptions = {};
|};
public type ServerModeConfig record {|
    string host = "localhost";
    int port = 9090;
    *InMemoryModeConfig;
|};
public type EmbeddedModeConfig record {|
    string path = "";
    *InMemoryModeConfig;
|};
function testAmbiguityResolution() returns [string, string, string] {
    string s1 = _init_({}); // @error
    string s2 = _init_({host: "localhost", port: 9090});
    string s3 = _init_({path: "localhost:9090"});
    return [s1, s2, s3];
}
function _init_(InMemoryModeConfig|ServerModeConfig|EmbeddedModeConfig rec) returns string {
    if rec is ServerModeConfig { return "Server mode configuration"; }
    if rec is EmbeddedModeConfig { return "Embedded mode configuration"; }
    return "In-memory mode configuration";
}
