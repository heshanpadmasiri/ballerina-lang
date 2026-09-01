function testClosedIntRangeForUnsupportedTypes() {
    string[] strArray = "aa" ... "bbb"; // @error
    json j1 = {"type":"Closed"};
    json j2 = {"value":"json"};
    json[] jsonArray = j1 ... j2; // @error
    float[] floatArray = 1.0 ... 1.2; // @error
    int[] intArrayTwo = 1 ... 1.2; // @error
}

function testHalfOpenIntRangeForUnsupportedTypes() {
    string[] strArray = "aa" ..< "bbb"; // @error
    json j1 = {"type":"Closed"};
    json j2 = {"value":"json"};
    json[] jsonArray = j1 ..< j2; // @error
    float[] floatArray = 1.0 ..< 1.2; // @error
    int[] intArrayTwo = 1 ..< 1.2; // @error
}
