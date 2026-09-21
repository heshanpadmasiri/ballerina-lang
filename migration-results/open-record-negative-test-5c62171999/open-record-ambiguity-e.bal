public type InMemoryModeConfig record {
    string name = "";
    string username = "";
    string password = "";
    map<any> dbOptions = {};
};

public type ServerModeConfig record {
    string host;
    int port;
    *InMemoryModeConfig;
};

public type EmbeddedModeConfig record {
    string path;
    *InMemoryModeConfig;
};

function testAmbiguityResolution() returns [string, string, string] {
    string s1 = _init_({});
    string s2 = _init_({host:"localhost", port:9090}); // @error
    string s3 = _init_({path:"localhost:9090"}); // @error
    return [s1, s2, s3];
}

function _init_(InMemoryModeConfig|ServerModeConfig|EmbeddedModeConfig rec) returns string {
    if (rec is ServerModeConfig) {
        return "Server mode configuration";
    } else if (rec is EmbeddedModeConfig) {
        return "Embedded mode configuration";
    } else {
        return "In-memory mode configuration";
    }
}

public type A record {
    string a;
    string b;
    string c;
};

public type B record {
    string f;
    int g?;
    *A;
};

public type C record {
    string i;
    *A;
};

function testAmbiguityResolution2() returns [string, string, string, string] {
    string s1 = resolve({a:"", b:"", c:""});
    string s2 = resolve({a:"", b:"", c:"", f:""}); // @error
    string s3 = resolve({a:"", b:"", c:"", f:"", g:0}); // @error
    string s4 = resolve({a:"", b:"", c:"", i:""}); // @error
    return [s1, s2, s3, s4];
}

function resolve(A|B|C rec) returns string {
    if (rec is A) {
        return "A";
    } else {
        return "B|C";
    }
}
