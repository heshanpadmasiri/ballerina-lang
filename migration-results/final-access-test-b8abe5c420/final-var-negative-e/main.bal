final int globalFinalInt = 10;

public function testFinalGlobalVariable() {
    int v1 = globalFinalInt; // @error
    globalFinalInt = 20; // @error
}

function testLocalFinalValueWithType() {
    final string name = "Ballerina"; // @error
    name = "ABC"; // @error
}

function testLocalFinalValueWithoutType() {
    final var name = "Ballerina"; // @error
    name = "ABC"; // @error
}

function testLocalFinalValueWithTypeInitializedFromFunction() {
    final string name = getName(); // @error
    name = "ABC"; // @error
}

function testLocalFinalValueWithoutTypeInitializedFromFunction() {
    final var name = getName(); // @error
    name = "ABC"; // @error
}

function getName() returns string {
    return "Ballerina";
}

function testAssignmentToSubsequentlyInitializedFinalNoInitVar(boolean b) {
    final int i;
    i = 12;

    i = 13; // @error

    final string s; // @error

    if b {
        s = "true";
    } else if i == 2 {
        s = "i is 2";
    } else {
        s = "else";
    }
    s = "after if-else"; // @error
}

function testAssignmentToSubsequentlyPotentiallyInitializedFinalNoInitVar() {
    final int i; // @error
    boolean b = false;

    if b {
        i = 10;
    } else {
        b = true;
    }
    i = 12; // @error

    final string s; // @error

    while b {
        s = "initialized";
    }
    s = "after while"; // @error
}

function testAccessOfSubsequentlyPotentiallyInitializedFinalNoInitVar() {
    final int i;
    boolean b = false;

    if b {
        i = 10;
    } else {
        b = true;
    }
    int _ = i; // @error

    final string s;

    while b {
        s = "initialized";
    }
    string t = s; // @error // @error
}
