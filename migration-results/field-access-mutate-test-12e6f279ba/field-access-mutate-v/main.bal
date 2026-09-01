import ballerina/io;
import ballerina/jballerina.java;
import ballerina/lang.runtime;

type Bool true|false|5;

function testStaticFieldAccess() returns handle {
    return getContractId();
}

function testStaticFieldMutate(string value) {
    setContractId(value);
}

function testStaticPrimitiveFieldAccess() returns int {
    return getAge();
}

function testStaticPrimitiveFieldMutate(int shortValue) {
    setShortValue(shortValue);
}

function testStaticBooleanFieldMutate() {
    setBoolean(true);
    ensureBoolean(getBoolean(), true);
}

function testBFiniteToJBooleanCast() {
    Bool arg = true;
    setFiniteToBoolean(arg);
    ensureBoolean(getBoolean(), true);
}

function testInstanceFieldAccess(handle receiver) returns handle {
    return getCreatedAt(receiver);
}

function testInstanceFieldMutate(handle receiver, handle value) {
    setUUID(receiver, value);
}

function testInstancePrimitiveFieldAccess(handle receiver) returns boolean {
    return isEmpty(receiver);
}

function testInstancePrimitiveFieldMutate(handle receiver, float value) {
    setLKR(receiver, value);
}

function testFieldSetAndGetWithDefaultValues() {
    setAgeWithDefaultParameters(789);
    ensureInt(getAge(), 789);
    setAgeWithDefaultParameters();
    ensureInt(getAge(), 19);

    setContractIdWithDefaultParameters("789");
    ensureString(getStaticStringContractId(), "789");
    setContractIdWithDefaultParameters();
    ensureString(getStaticStringContractId(), "12bacb");

    handle jObject = newJavaFieldAccessMutate();

    setCountWithDefaultParameters(jObject, 789);
    ensureInt(getCount(jObject), 789);
    setCountWithDefaultParameters(jObject);
    ensureInt(getCount(jObject), 19);

    setBalStringWithDefaultParameters(jObject, "789");
    ensureString(getBalString(jObject), "789");
    setBalStringWithDefaultParameters(jObject);
    ensureString(getBalString(jObject), "12bacb");

    setCountWithDefaultParameters();
    setBalStringWithDefaultParameters();
    ensureInt(getCount(), 101);
    ensureString(getBalString(), "String value");
}

function getInt1() returns int {
    worker w1 returns int {
        runtime:sleep(0.01);
        return 3;
    }

    future<int> futureIntVal1 = start getInt2();
    int intVal1 = checkpanic wait futureIntVal1;
    int intVal2 = wait w1;
    return intVal1 + intVal2 + 5;
}

function getInt2() returns int => 4;

function getStr1() returns string {
    worker w1 returns string {
        runtime:sleep(0.01);
        return "a";
    }

    future<string> futureStringVal1 = start getStr2();
    string stringVal1 = checkpanic wait futureStringVal1;
    string stringVal2 = wait w1;
    return stringVal1 + stringVal2 + "c";
}

function getStr2() returns string => "b";

function setAgeWithDefaultParameters(int age = (1 + 2 + getInt1() + getInt2())) = @java:FieldSet {
    name: "age",
    'class: "org/ballerinalang/nativeimpl/jvm/tests/JavaFieldAccessMutate"
} external;

function setContractIdWithDefaultParameters(string contractId = ("1" + "2" + getStr1() + getStr2())) =
    @java:FieldSet {
        name: "contractId",
        'class: "org/ballerinalang/nativeimpl/jvm/tests/JavaFieldAccessMutate"
    } external;

function getStaticStringContractId() returns string = @java:FieldGet {
    name: "contractId",
    'class: "org/ballerinalang/nativeimpl/jvm/tests/JavaFieldAccessMutate"
} external;

function getContractId() returns handle = @java:FieldGet {
    name: "contractId",
    'class: "org/ballerinalang/nativeimpl/jvm/tests/JavaFieldAccessMutate"
} external;

function setContractId(string contractId) = @java:FieldSet {
    name: "contractId",
    'class: "org/ballerinalang/nativeimpl/jvm/tests/JavaFieldAccessMutate"
} external;

function getAge() returns int = @java:FieldGet {
    name: "age",
    'class: "org/ballerinalang/nativeimpl/jvm/tests/JavaFieldAccessMutate"
} external;

function setShortValue(int shortValue) = @java:FieldSet {
    name: "aShort",
    'class: "org/ballerinalang/nativeimpl/jvm/tests/JavaFieldAccessMutate"
} external;

function getShortValue() returns int = @java:FieldGet {
    name: "aShort",
    'class: "org/ballerinalang/nativeimpl/jvm/tests/JavaFieldAccessMutate"
} external;

function setBoolean(boolean bool) = @java:FieldSet {
    name: "isAvailable",
    'class: "org/ballerinalang/nativeimpl/jvm/tests/JavaFieldAccessMutate"
} external;

function getBoolean() returns boolean = @java:FieldGet {
    name: "isAvailable",
    'class: "org/ballerinalang/nativeimpl/jvm/tests/JavaFieldAccessMutate"
} external;

function setFiniteToBoolean(Bool arg) = @java:FieldSet {
    name: "isAvailable",
    'class: "org/ballerinalang/nativeimpl/jvm/tests/JavaFieldAccessMutate"
} external;

function setCountWithDefaultParameters(handle receiver = newJavaFieldAccessMutate(),
    int age = (1 + 2 + getInt1() + getInt2())) = @java:FieldSet {
    name: "count",
    'class: "org/ballerinalang/nativeimpl/jvm/tests/JavaFieldAccessMutate"
} external;

function setBalStringWithDefaultParameters(handle receiver = newJavaFieldAccessMutate(),
    string contractId = ("1" + "2" + getStr1() + getStr2())) = @java:FieldSet {
    name: "balString",
    'class: "org/ballerinalang/nativeimpl/jvm/tests/JavaFieldAccessMutate"
} external;

function getCount(handle receiver = newJavaFieldAccessMutate()) returns int = @java:FieldGet {
    name: "count",
    'class: "org/ballerinalang/nativeimpl/jvm/tests/JavaFieldAccessMutate"
} external;

function getBalString(handle receiver = newJavaFieldAccessMutate()) returns string = @java:FieldGet {
    name: "balString",
    'class: "org/ballerinalang/nativeimpl/jvm/tests/JavaFieldAccessMutate"
} external;

function getCreatedAt(handle receiver) returns handle = @java:FieldGet {
    name: "createdAt",
    'class: "org/ballerinalang/nativeimpl/jvm/tests/JavaFieldAccessMutate"
} external;

function setUUID(handle receiver, handle uuid) = @java:FieldSet {
    name: "uuid",
    'class: "org/ballerinalang/nativeimpl/jvm/tests/JavaFieldAccessMutate"
} external;

function isEmpty(handle receiver) returns boolean = @java:FieldGet {
    name: "isEmpty",
    'class: "org/ballerinalang/nativeimpl/jvm/tests/JavaFieldAccessMutate"
} external;

function setLKR(handle receiver, float value) = @java:FieldSet {
    name: "lkr",
    'class: "org/ballerinalang/nativeimpl/jvm/tests/JavaFieldAccessMutate"
} external;

function getLKR(handle receiver) returns float = @java:FieldGet {
    name: "lkr",
    'class: "org/ballerinalang/nativeimpl/jvm/tests/JavaFieldAccessMutate"
} external;

function newJavaFieldAccessMutate() returns handle = @java:Constructor {
    'class: "org/ballerinalang/nativeimpl/jvm/tests/JavaFieldAccessMutate"
} external;

function newJavaFieldAccessMutateWithDate(handle createdAt) returns handle = @java:Constructor {
    'class: "org/ballerinalang/nativeimpl/jvm/tests/JavaFieldAccessMutate"
} external;

function newDate(int time) returns handle = @java:Constructor {
    'class: "java.util.Date",
    paramTypes: ["long"]
} external;

function newDeterministicUUID() returns handle = @java:Method {
    name: "deterministicUuid",
    'class: "org/ballerinalang/nativeimpl/jvm/tests/JavaFieldAccessMutate"
} external;

function uuidString(handle receiver) returns string = @java:Method {
    name: "uuidString",
    'class: "org/ballerinalang/nativeimpl/jvm/tests/JavaFieldAccessMutate"
} external;

function contractIdString(handle contractId) returns string = @java:Method {
    name: "contractIdString",
    'class: "org/ballerinalang/nativeimpl/jvm/tests/JavaFieldAccessMutate"
} external;

function dateTime(handle receiver) returns int = @java:Method {
    name: "dateTime",
    'class: "org/ballerinalang/nativeimpl/jvm/tests/JavaFieldAccessMutate"
} external;

function sameJavaObject(handle first, handle second) returns boolean = @java:Method {
    name: "sameObject",
    'class: "org/ballerinalang/nativeimpl/jvm/tests/JavaFieldAccessMutate"
} external;

function getUUID(handle receiver) returns handle = @java:FieldGet {
    name: "uuid",
    'class: "org/ballerinalang/nativeimpl/jvm/tests/JavaFieldAccessMutate"
} external;

function ensureInt(int actual, int expected) {
    if actual != expected {
        panic error("unexpected integer field value");
    }
}

function ensureString(string actual, string expected) {
    if actual != expected {
        panic error("unexpected string field value");
    }
}

function ensureBoolean(boolean actual, boolean expected) {
    if actual != expected {
        panic error("unexpected boolean field value");
    }
}

public function main() {
    handle staticContractId = testStaticFieldAccess();
    io:println(contractIdString(staticContractId)); // @output Ballerina

    testStaticFieldMutate("NewValue");
    io:println(getStaticStringContractId()); // @output NewValue

    io:println(testStaticPrimitiveFieldAccess()); // @output 10
    testStaticPrimitiveFieldMutate(345);
    io:println(getShortValue()); // @output 345

    testStaticBooleanFieldMutate();
    testBFiniteToJBooleanCast();

    handle createdAt = newDate(1700000000000);
    handle createdAtReceiver = newJavaFieldAccessMutateWithDate(createdAt);
    handle returnedCreatedAt = testInstanceFieldAccess(createdAtReceiver);
    ensureBoolean(sameJavaObject(createdAt, returnedCreatedAt), true);
    io:println(dateTime(returnedCreatedAt)); // @output 1700000000000

    handle uuidReceiver = newJavaFieldAccessMutate();
    handle uuid = newDeterministicUUID();
    testInstanceFieldMutate(uuidReceiver, uuid);
    handle receiverUuid = getUUID(uuidReceiver);
    ensureBoolean(sameJavaObject(uuid, receiverUuid), true);
    io:println(uuidString(receiverUuid)); // @output b4f5c1d5-09b1-4d5a-b647-9d7e1fd8fa18

    handle booleanReceiver = newJavaFieldAccessMutate();
    io:println(testInstancePrimitiveFieldAccess(booleanReceiver)); // @output false

    handle floatReceiver = newJavaFieldAccessMutate();
    testInstancePrimitiveFieldMutate(floatReceiver, 123.0);
    io:println(getLKR(floatReceiver)); // @output 123.0

    testFieldSetAndGetWithDefaultValues();
}
