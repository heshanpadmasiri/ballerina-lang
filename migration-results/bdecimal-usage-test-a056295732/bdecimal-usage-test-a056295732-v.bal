import ballerina/io;
import ballerina/test;

// Decimal array.
function testDecimalArray() returns [decimal[], int, decimal, decimal] {
    decimal[] dArr = [12.3, 23.2, 34.534, 5.4];
    int length = dArr.length();
    decimal element0 = dArr[0];
    decimal element1 = dArr[1];
    return [dArr, length, element0, element1];
}

// Decimal map.
function testDecimalMap() returns [map<decimal>, int, string[], decimal] {
    map<decimal> dMap = {element0: 12.45, element1: 34.3, element2: 2314.31};
    int length = dMap.length();
    string[] keys = dMap.keys();
    decimal element0 = dMap.get("element0");
    return [dMap, length, keys, element0];
}

// Test record with decimal fields.
function testDecimalRecord() returns [decimal, decimal] {
    Animal a = {weight: 23.45, height: 120.43};
    return [a.weight, a.height];
}

// Test object with decimal fields.
function testDecimalObject() returns [string, int, decimal, decimal] {
    Student s = new (57.25, 168.67);
    return [s.name, s.age, s.weight, s.height];
}

// Record with decimal fields.
type Animal record {
    decimal weight = 0.0;
    decimal height = 0.0;
};

// Object with decimal fields.
class Student {
    string name = "";
    int age = 0;
    decimal weight = 65.65;
    decimal height = 0.0;

    function init(decimal weight, decimal height, string name = "Bob", int age = 25) {
        self.name = name;
        self.age = age;
        self.weight = weight;
        self.height = height;
    }
}

// Decimal defaultable parameters.
function testDecimalDefaultable() {
    decimal price = decimalDefaultable(540.5, discountRate = 0.1);
    decimal expected = 496.73;
    test:assertEquals(price, expected);
}

function decimalDefaultable(decimal fixedPrice, decimal tax = 10.28,
        decimal discountRate = 0.05) returns decimal {
    decimal discount = fixedPrice * discountRate;
    decimal price = fixedPrice + tax - discount;
    return price;
}

public function main() {
    [decimal[], int, decimal, decimal] decimalArrayResult = testDecimalArray();
    io:println(decimalArrayResult[0]); // @output [12.3,23.2,34.534,5.4]
    io:println(decimalArrayResult[1]); // @output 4
    io:println(decimalArrayResult[2]); // @output 12.3
    io:println(decimalArrayResult[3]); // @output 23.2

    [map<decimal>, int, string[], decimal] decimalMapResult = testDecimalMap();
    io:println(decimalMapResult[0]); // @output {"element0":12.45,"element1":34.3,"element2":2314.31}
    io:println(decimalMapResult[1]); // @output 3
    io:println(decimalMapResult[2]); // @output ["element0","element1","element2"]
    io:println(decimalMapResult[3]); // @output 12.45

    [decimal, decimal] decimalRecordResult = testDecimalRecord();
    io:println(decimalRecordResult[0]); // @output 23.45
    io:println(decimalRecordResult[1]); // @output 120.43

    [string, int, decimal, decimal] decimalObjectResult = testDecimalObject();
    io:println(decimalObjectResult[0]); // @output Bob
    io:println(decimalObjectResult[1]); // @output 25
    io:println(decimalObjectResult[2]); // @output 57.25
    io:println(decimalObjectResult[3]); // @output 168.67

    testDecimalDefaultable();
}
