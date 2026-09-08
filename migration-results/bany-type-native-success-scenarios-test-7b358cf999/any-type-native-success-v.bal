import ballerina/jballerina.java;

public function main() {
    println(successfulXmlCasting()); // @output Value
    printlnAnyVal(); // @output {"PropertyName":"Value"}
    printAnyVal();
    println(); // @output {"PropertyName":"Value"}
    findBestNativeFunctionPrintln(); // @output 8
    findBestNativeFunctionPrint();
    println(); // @output 7
}

function successfulXmlCasting() returns string {
    json value = jsonReturnFunction();
    return extractFieldValue(checkpanic value.PropertyName);
}

function extractFieldValue(json fieldValue) returns string {
    any value = fieldValue;
    if value is string {
        return value;
    }
    if value is json {
        return "Error";
    }
    return "";
}

function jsonReturnFunction() returns json {
    return {PropertyName: "Value"};
}

function printlnAnyVal() {
    any value = jsonReturnFunction();
    println(value);
}

function printAnyVal() {
    any value = jsonReturnFunction();
    print(value);
}

function findBestNativeFunctionPrintln() {
    int value = 8;
    println(value);
}

function findBestNativeFunctionPrint() {
    int value = 7;
    print(value);
}

public function print(any|error... values) = @java:Method {
    'class: "org.ballerinalang.test.utils.interop.Utils"
} external;

public function println(any|error... values) = @java:Method {
    'class: "org.ballerinalang.test.utils.interop.Utils"
} external;
