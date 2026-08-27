function testCodeAnalyzerRunningOnAnonymousObjectsForDeprecatedFunctionAnnotation() {
    object {
        int b;
    } obj = object { // @error
                int b = Test(); // @error
            };
}

@deprecated
isolated function Test() returns int {
    return 0;
}
