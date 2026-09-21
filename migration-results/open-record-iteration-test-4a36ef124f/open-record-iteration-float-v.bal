import ballerina/io;

type RestrictedBar record {| float x = 0.0; float y = 0.0; float z = 0.0; float...; |};

function testMapWithAllFloatOpenRecord(float a, float b, float c) returns map<float> {
    RestrictedBar bar = {x: a, y: b, z: c, "p": 9.9};
    return bar.'map(function (float value) returns float { return value + 10.0; });
}

function testFilterWithAllFloatOpenRecord(float a, float b, float c) returns map<float> {
    RestrictedBar bar = {x: a, y: b, z: c, "p": 9.9};
    return bar.filter(function (float value) returns boolean { return value > 6.0; });
}

// @args ["20.15", "7.89", "5.15"]
public function main(float a, float b, float c) {
    map<float> floatMap = testMapWithAllFloatOpenRecord(a, b, c);
    io:println(floatMap["x"]); // @output 30.15
    io:println(floatMap["y"]); // @output 17.89
    io:println(floatMap["z"]); // @output 15.15
    io:println(floatMap["p"]); // @output 19.9
    map<float> floatFilter = testFilterWithAllFloatOpenRecord(a, b, c);
    io:println(floatFilter["x"]); // @output 20.15
    io:println(floatFilter["y"]); // @output 7.89
    io:println(floatFilter.hasKey("z") ? floatFilter["z"] : ()); // @output
    io:println(floatFilter["p"]); // @output 9.9
}
