function getArray() returns int[] {
    return [];
}

function getMap() returns map<int> {
    return {};
}

function testInvalidLvexprInvocation() {
    getArray()[0] = 3; // @error
    getMap()["1"] = 1; // @error
}
