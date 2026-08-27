function testCodeAnalyzerRunningOnAnonymousRecordsForDeprecatedFunctionAnnotation() {
    record {
        int b = Test(// @error
        );
    } _ = {};
}

@deprecated
isolated function Test() returns int {
    return 0;
}
