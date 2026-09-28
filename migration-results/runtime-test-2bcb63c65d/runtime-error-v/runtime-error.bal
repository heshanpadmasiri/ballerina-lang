import ballerina/lang.runtime; import ballerina/io; import ballerina/lang.regexp as regexutils;

function testGetCallStack () returns (runtime:StackFrame[]) {
    return level1Function();
}

function level1Function () returns (runtime:StackFrame[]) {
    return level2Function();
}

function level2Function () returns (runtime:StackFrame[]) {
    return runtime:getStackTrace();
}

function testErrorCallStack() returns error:StackFrame[]? {
    var e = trap level1Error(-10);
    if (e is error) {
        return e.stackTrace();
    } else {
        return ();
    }
}

function level1Error (int value) returns (int) {
    return level2Error(value);
}

function level2Error (int value) returns (int) {
    if (value < 0) {
        error e = error("less than zero");
        panic e;
    }
    return value;
}

function javaStackFrameProjection(runtime:StackFrame frame) returns string {
    string projection = frame.toString();
    projection = regexutils:replace(re `callableName: `, projection, "callableName:");
    projection = regexutils:replace(re ` moduleName: `, projection, ", moduleName:");
    projection = regexutils:replace(re ` fileName: `, projection, ", fileName:");
    projection = regexutils:replace(re ` lineNumber: `, projection, ", lineNumber:");
    projection = regexutils:replace(re `moduleName:migration.runtime_error_v.0`, projection, "moduleName:null");
    return "{" + projection + "}";
}

public function main() {
    runtime:StackFrame[] callStackWithMain = testGetCallStack();
    boolean onlyCliMainFrame = callStackWithMain.length() == 6 &&
        javaStackFrameProjection(callStackWithMain[5]).startsWith("{callableName:main,");
    io:println(onlyCliMainFrame); // @output true
    runtime:StackFrame[] callStack = callStackWithMain.slice(0, callStackWithMain.length() - 1);
    io:println(callStack.length()); // @output 5
    io:println(javaStackFrameProjection(callStack[0])); // @output {callableName:externGetStackTrace, moduleName:ballerina.lang.runtime.0, fileName:runtime.bal, lineNumber:121}
    io:println(javaStackFrameProjection(callStack[1])); // @output {callableName:getStackTrace, moduleName:ballerina.lang.runtime.0, fileName:runtime.bal, lineNumber:111}
    io:println(javaStackFrameProjection(callStack[2])); // @output {callableName:level2Function, moduleName:null, fileName:runtime-error.bal, lineNumber:12}
    io:println(javaStackFrameProjection(callStack[3])); // @output {callableName:level1Function, moduleName:null, fileName:runtime-error.bal, lineNumber:8}
    io:println(javaStackFrameProjection(callStack[4])); // @output {callableName:testGetCallStack, moduleName:null, fileName:runtime-error.bal, lineNumber:4}

    error:StackFrame[]? returnedErrorStack = testErrorCallStack();
    if returnedErrorStack is error:StackFrame[] {
        boolean onlyCliMainErrorFrame = returnedErrorStack.length() == 4 &&
            javaStackFrameProjection(returnedErrorStack[3]).startsWith("{callableName:main,");
        io:println(onlyCliMainErrorFrame); // @output true
        error:StackFrame[] errorStack = returnedErrorStack.slice(0, returnedErrorStack.length() - 1);
        io:println(errorStack.length()); // @output 3
        io:println(javaStackFrameProjection(errorStack[0])); // @output {callableName:level2Error, moduleName:null, fileName:runtime-error.bal, lineNumber:30}
        io:println(javaStackFrameProjection(errorStack[1])); // @output {callableName:level1Error, moduleName:null, fileName:runtime-error.bal, lineNumber:25}
        io:println(javaStackFrameProjection(errorStack[2])); // @output {callableName:testErrorCallStack, moduleName:null, fileName:runtime-error.bal, lineNumber:16}
    }
}
