import ballerina/io;
import ballerina/jballerina.java;

function newInstanceMethods() returns handle = @java:Constructor {
    'class: "org.ballerinalang.nativeimpl.jvm.tests.InstanceMethods"
} external;

function newInteger(int value) returns handle = @java:Constructor {
    'class: "java.lang.Integer",
    paramTypes: ["int"]
} external;

function testAcceptNothingAndReturnNothing(handle receiver) {
    increaseCounterByOne(receiver);
}

function testAcceptNothingAndReturnVoidThrows(handle receiver) returns error? {
    return testThrowsWithVoid(receiver);
}

function testAcceptNothingAndReturnVoidThrowsReturn(handle receiver) returns error? {
    return testThrowsWithVoidReturn(receiver);
}

function testHandleOrErrorReturn(handle receiver) returns handle|error {
    return handleOrErrorReturn(receiver);
}

function testHandleOrErrorReturnThrows(handle receiver) returns handle|error {
    return handleOrErrorReturnThrows(receiver);
}

function testInteropFunctionWithDifferentName(handle receiver) {
    interopFunctionWithDifferentName(receiver);
}

function testAcceptNothingButReturnSomething(handle receiver) returns handle {
    return getCounter(receiver);
}

function testAcceptSomethingButReturnNothing(handle receiver, handle h) {
    setCounterValue(receiver, h);
}

function testAcceptSomethingAndReturnSomething(handle receiver, handle h) returns handle {
    return setAndGetCounterValue(receiver, h);
}

function testAcceptTwoParamsAndReturnSomething(handle receiver, handle h1, handle h2) returns handle {
    return setTwiceAndGetCounterValue(receiver, h1, h2);
}

function testHandleOrErrorWithObjectReturn(handle receiver) returns error|handle {
    return handleOrErrorWithObjectReturn(receiver);
}

function testPrimitiveOrErrorReturn(handle receiver) returns error|float {
    return primitiveOrErrorReturn(receiver);
}

function testPrimitiveOrErrorReturnThrows(handle receiver) returns error|float {
    return primitiveOrErrorReturnThrows(receiver);
}

function testUnionWithErrorReturnByte(handle receiver) returns error|int|boolean|byte|handle {
    return unionWithErrorReturnByte(receiver);
}

function testUnionWithErrorReturnThrows(handle receiver) returns error|int|boolean|byte|handle {
    return unionWithErrorReturnThrows(receiver);
}

function testUnionWithErrorReturnHandle(handle receiver) returns error|int|boolean|byte|handle {
    return unionWithErrorReturnHandle(receiver);
}

function testUnionWithErrorReturnByteArray(handle receiver) {
    handle|error result = unionWithErrorReturnByteArray(receiver);
    ensure(result is handle);
}

function testAnyOrErrorReturnStringArray(handle receiver) {
    any|error result = anyOrErrorReturnStringArray(receiver);
    ensure(result is any);
}

function testInstanceResolve() {
    int value = hashCode(newByte(2));
    ensure(value == 2);
}

public function testGetCurrentModule(handle receiver) {
    string moduleString = getCurrentModule(receiver, 4);
    ensure(moduleString == "migration#instance_method_v#0#4");
    moduleString = getCurrentModuleAndOverloadParams(receiver, 4);
    ensure(moduleString == "migration#instance_method_v#0#8");
    moduleString = getCurrentModuleAndOverloadParamsWithReceiver(receiver, receiver, 4);
    ensure(moduleString == "migration#instance_method_v#0#16");
}

public function testBalEnvAcceptingMethodRetType(handle receiver) {
    ensure(getStringFromFutureResult(receiver) == "Hello World!");
    anydata stringResult = getStringFromFutureResult(receiver);
    ensure(stringResult == "Hello World!");
    anydata intResult = getIntFromFutureResult(receiver);
    ensure(intResult == 7);
    map<any> mapResult = getMapFromFutureResult(receiver);
    ensure(mapResult == {"a": 10, "b": 12.5});
}

public function testInteropCallToAbstractClassMethod() {
    handle receiver = getConstructor();
    ensure(getMessage(receiver) == "Hello from Java!");
}

public function main() {
    handle receiver = newInstanceMethods();
    io:println(testAcceptNothingAndReturnNothing(receiver)); // @output
    io:println(integerValue(getCounter(receiver))); // @output 1

    receiver = newInstanceMethods();
    error? voidError = testAcceptNothingAndReturnVoidThrows(receiver);
    if voidError is error {
        io:println(voidError.message()); // @output java.lang.InterruptedException
    }
    io:println(testAcceptNothingAndReturnVoidThrowsReturn(receiver)); // @output

    receiver = newInstanceMethods();
    handle|error handleResult = testHandleOrErrorReturn(receiver);
    if handleResult is handle {
        io:println(integerValue(handleResult)); // @output 70
    } else {
        panic error("expected handle result");
    }
    handle|error handleError = testHandleOrErrorReturnThrows(receiver);
    if handleError is error {
        io:println(handleError.message()); // @output java.lang.InterruptedException
    }

    receiver = newInstanceMethods();
    handle|error objectResult = testHandleOrErrorWithObjectReturn(receiver);
    if objectResult is handle {
        io:println(integerValue(objectResult)); // @output 70
    } else {
        panic error("expected handle result");
    }
    handle|error objectError = handleOrErrorWithObjectReturnThrows(receiver);
    if objectError is error {
        io:println(objectError.message()); // @output java.lang.InterruptedException
    }

    receiver = newInstanceMethods();
    io:println(testPrimitiveOrErrorReturn(receiver)); // @output 55.0
    float|error primitiveError = testPrimitiveOrErrorReturnThrows(receiver);
    if primitiveError is error {
        io:println(primitiveError.message()); // @output java.lang.InterruptedException
    }

    receiver = newInstanceMethods();
    error|int|boolean|byte|handle byteResult = testUnionWithErrorReturnByte(receiver);
    if byteResult is byte {
        io:println(byteResult); // @output 53
    } else {
        panic error("expected byte result");
    }
    error|int|boolean|byte|handle unionError = testUnionWithErrorReturnThrows(receiver);
    if unionError is error {
        io:println(unionError.message()); // @output java.lang.InterruptedException
    }
    error|int|boolean|byte|handle unionHandle = testUnionWithErrorReturnHandle(receiver);
    if unionHandle is handle {
        string stringResult = "";
        foreach int index in 0 ..< stringLength(unionHandle) {
            string:Char|error character = string:fromCodePointInt(stringCodePointAt(unionHandle, index));
            if character is string:Char {
                stringResult += character.toString();
            } else {
                panic character;
            }
        }
        io:println(stringResult); // @output handle ret
    } else {
        panic error("expected handle result");
    }

    receiver = newInstanceMethods();
    io:println(testInteropFunctionWithDifferentName(receiver)); // @output
    io:println(integerValue(getCounter(receiver))); // @output 1

    receiver = newInstanceMethods();
    setCounterValue(receiver, newInteger(21));
    io:println(integerValue(testAcceptNothingButReturnSomething(receiver))); // @output 21

    receiver = newInstanceMethods();
    io:println(testAcceptSomethingButReturnNothing(receiver, newInteger(22))); // @output
    io:println(integerValue(getCounter(receiver))); // @output 22

    receiver = newInstanceMethods();
    io:println(integerValue(testAcceptSomethingAndReturnSomething(receiver, newInteger(25)))); // @output 25

    receiver = newInstanceMethods();
    io:println(integerValue(testAcceptTwoParamsAndReturnSomething(receiver, newInteger(20), newInteger(30)))); // @output 50

    receiver = newInstanceMethods();
    error? detailError = errorDetail(receiver);
    if detailError is error {
        io:println(detailError.message()); // @output org.ballerinalang.nativeimpl.jvm.tests.JavaInteropTestCheckedException
        var detail = detailError.detail();
        io:println(detail["message"]); // @output Custom error
        var causeValue = detail["cause"];
        if causeValue is error {
            io:println(causeValue.message()); // @output java.lang.Throwable
            var causeDetail = causeValue.detail();
            io:println(causeDetail["message"]); // @output Interop Throwable
        }
    }

    testInstanceResolve();
    receiver = newInstanceMethods();
    testGetCurrentModule(receiver);
    receiver = newInstanceMethods();
    testBalEnvAcceptingMethodRetType(receiver);
    receiver = newInstanceMethods();
    testUnionWithErrorReturnByteArray(receiver);
    receiver = newInstanceMethods();
    testAnyOrErrorReturnStringArray(receiver);
    testInteropCallToAbstractClassMethod();
}

function ensure(boolean value) {
    if !value {
        panic error("assertion failed");
    }
}

function increaseCounterByOne(handle receiver) = @java:Method {
    'class: "org.ballerinalang.nativeimpl.jvm.tests.InstanceMethods"
} external;

function interopFunctionWithDifferentName(handle receiver) = @java:Method {
    'class: "org.ballerinalang.nativeimpl.jvm.tests.InstanceMethods",
    name: "increaseCounterByOne"
} external;

function getCounter(handle receiver) returns handle = @java:Method {
    'class: "org.ballerinalang.nativeimpl.jvm.tests.InstanceMethods"
} external;

function integerValue(handle receiver) returns int = @java:Method {
    name: "intValue",
    'class: "java.lang.Integer"
} external;

function stringLength(handle receiver) returns int = @java:Method {
    name: "length",
    'class: "java.lang.String"
} external;

function stringCodePointAt(handle receiver, int index) returns int = @java:Method {
    name: "codePointAt",
    'class: "java.lang.String",
    paramTypes: ["int"]
} external;

function setCounterValue(handle receiver, handle value) = @java:Method {
    'class: "org.ballerinalang.nativeimpl.jvm.tests.InstanceMethods"
} external;

function setAndGetCounterValue(handle receiver, handle value) returns handle = @java:Method {
    'class: "org.ballerinalang.nativeimpl.jvm.tests.InstanceMethods"
} external;

function setTwiceAndGetCounterValue(handle receiver, handle first, handle second) returns handle = @java:Method {
    'class: "org.ballerinalang.nativeimpl.jvm.tests.InstanceMethods"
} external;

function testThrowsWithVoid(handle receiver) returns error? = @java:Method {
    'class: "org.ballerinalang.nativeimpl.jvm.tests.InstanceMethods"
} external;

function testThrowsWithVoidReturn(handle receiver) returns error? = @java:Method {
    'class: "org.ballerinalang.nativeimpl.jvm.tests.InstanceMethods"
} external;

function handleOrErrorReturn(handle receiver) returns handle|error = @java:Method {
    'class: "org.ballerinalang.nativeimpl.jvm.tests.InstanceMethods"
} external;

function handleOrErrorReturnThrows(handle receiver) returns handle|error = @java:Method {
    'class: "org.ballerinalang.nativeimpl.jvm.tests.InstanceMethods"
} external;

function handleOrErrorWithObjectReturn(handle receiver) returns handle|error = @java:Method {
    'class: "org.ballerinalang.nativeimpl.jvm.tests.InstanceMethods"
} external;

function handleOrErrorWithObjectReturnThrows(handle receiver) returns handle|error = @java:Method {
    'class: "org.ballerinalang.nativeimpl.jvm.tests.InstanceMethods"
} external;

function primitiveOrErrorReturn(handle receiver) returns float|error = @java:Method {
    'class: "org.ballerinalang.nativeimpl.jvm.tests.InstanceMethods"
} external;

function primitiveOrErrorReturnThrows(handle receiver) returns float|error = @java:Method {
    'class: "org.ballerinalang.nativeimpl.jvm.tests.InstanceMethods"
} external;

function unionWithErrorReturnByte(handle receiver) returns error|int|boolean|byte|handle = @java:Method {
    'class: "org.ballerinalang.nativeimpl.jvm.tests.InstanceMethods"
} external;

function unionWithErrorReturnThrows(handle receiver) returns error|int|boolean|byte|handle = @java:Method {
    'class: "org.ballerinalang.nativeimpl.jvm.tests.InstanceMethods"
} external;

function unionWithErrorReturnHandle(handle receiver) returns error|int|boolean|byte|handle = @java:Method {
    'class: "org.ballerinalang.nativeimpl.jvm.tests.InstanceMethods"
} external;

function unionWithErrorReturnByteArray(handle receiver) returns handle|error = @java:Method {
    'class: "org.ballerinalang.nativeimpl.jvm.tests.InstanceMethods"
} external;

function anyOrErrorReturnStringArray(handle receiver) returns any|error = @java:Method {
    'class: "org.ballerinalang.nativeimpl.jvm.tests.InstanceMethods"
} external;

function errorDetail(handle receiver) returns error? = @java:Method {
    'class: "org.ballerinalang.nativeimpl.jvm.tests.InstanceMethods"
} external;

function getCurrentModule(handle receiver, int value) returns string = @java:Method {
    'class: "org.ballerinalang.nativeimpl.jvm.tests.InstanceMethods",
    paramTypes: ["io.ballerina.runtime.api.Environment", "long"]
} external;

function getCurrentModuleAndOverloadParams(handle receiver, int value) returns string = @java:Method {
    'class: "org.ballerinalang.nativeimpl.jvm.tests.InstanceMethods",
    paramTypes: ["io.ballerina.runtime.api.Environment", "long"]
} external;

function getCurrentModuleAndOverloadParamsWithReceiver(handle receiver, handle receiverParam, int value) returns string = @java:Method {
    name: "getCurrentModuleAndOverloadParams",
    'class: "org.ballerinalang.nativeimpl.jvm.tests.InstanceMethods",
    paramTypes: ["io.ballerina.runtime.api.Environment", "org.ballerinalang.nativeimpl.jvm.tests.InstanceMethods", "long"]
} external;

function hashCode(handle receiver) returns int = @java:Method {
    name: "hashCode",
    'class: "java.lang.Byte",
    paramTypes: []
} external;

function newByte(int value) returns handle = @java:Constructor {
    'class: "java.lang.Byte",
    paramTypes: ["byte"]
} external;

function getStringFromFutureResult(handle receiver) returns string = @java:Method {
    name: "getStringWithBalEnv",
    'class: "org.ballerinalang.nativeimpl.jvm.tests.InstanceMethods"
} external;

function getIntFromFutureResult(handle receiver) returns int = @java:Method {
    name: "getIntWithBalEnv",
    'class: "org.ballerinalang.nativeimpl.jvm.tests.InstanceMethods"
} external;

function getMapFromFutureResult(handle receiver) returns map<any> = @java:Method {
    name: "getMapValueWithBalEnv",
    'class: "org.ballerinalang.nativeimpl.jvm.tests.InstanceMethods"
} external;

function getMessage(handle receiver) returns string = @java:Method {
    name: "getMessage",
    'class: "org.ballerinalang.nativeimpl.jvm.tests.AbstractClass"
} external;

function getConstructor() returns handle = @java:Constructor {
    'class: "org.ballerinalang.nativeimpl.jvm.tests.ClassWithDefaultConstructor"
} external;
