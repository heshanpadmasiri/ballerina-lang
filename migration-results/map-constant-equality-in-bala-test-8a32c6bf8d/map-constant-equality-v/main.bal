import ballerina/io;
import testorg/foo;

// boolean ---------------------------------------------------

function testSimpleBooleanMapValueEqualityUsingSameReference() returns boolean {
    return foo:bm1 == foo:bm1; // true
}

function testSimpleBooleanMapValueEqualityUsingDifferentReference() returns boolean {
    return foo:bm1 == foo:bm1_new; // true
}

function testSimpleBooleanMapReferenceEqualityUsingSameReference() returns boolean {
    return foo:bm1 === foo:bm1; // true
}

function testSimpleBooleanMapReferenceEqualityUsingDifferentReference() returns boolean {
    return foo:bm1 === foo:bm1_new; // false
}

// -----------------------------------------------------------

function testComplexBooleanMapValueEqualityUsingSameReference() returns boolean {
    return foo:bm3 == foo:bm3; // true
}

function testComplexBooleanMapValueEqualityUsingDifferentReference() returns boolean {
    return foo:bm3 == foo:bm3_new; // true
}

function testComplexBooleanMapReferenceEqualityUsingSameReference() returns boolean {
    return foo:bm3 === foo:bm3; // true
}

function testComplexBooleanMapReferenceEqualityUsingDifferentReference() returns boolean {
    return foo:bm3 === foo:bm3_new; // false
}

// -----------------------------------------------------------

function testComplexBooleanMapValueEqualityUsingMapAccessSameReference() returns boolean {
    return foo:bm3["key5"] == foo:bm3["key5"]; // true
}

function testComplexBooleanMapValueEqualityUsingMapAccessDifferentReference() returns boolean {
    return foo:bm3["key5"] == foo:bm3_new["key5"]; // true
}

function testComplexBooleanMapReferenceEqualityUsingMapAccessSameReference() returns boolean {
    return foo:bm1 === foo:bm3["key5"]; // true
}

function testComplexBooleanMapReferenceEqualityUsingMapAccessDifferentReference() returns boolean {
    return foo:bm3["key5"] === foo:bm3_new["key5"]; // false
}

// -----------------------------------------------------------

function testSimpleBooleanMapValueEqualityUsingSameReferenceInMap() returns boolean {
    return foo:bm7["key5"] == foo:bm7["key5"]; // true
}

function testSimpleBooleanMapValueEqualityUsingDifferentReferenceInMap() returns boolean {
    return foo:bm7["key5"] == foo:bm1; // true
}

function testSimpleBooleanMapReferenceEqualityUsingSameReferenceInMap() returns boolean {
    return foo:bm7["key5"] === foo:bm7["key5"]; // true
}

function testSimpleBooleanMapReferenceEqualityUsingDifferentReferenceInMap() returns boolean {
    return foo:bm7["key5"] === foo:bm1; // false
}

// -----------------------------------------------------------

function testComplexBooleanMapValueEquality() returns boolean {
    return foo:bm7 == foo:bm8; // true
}

function testComplexBooleanMapReferenceEquality() returns boolean {
    return foo:bm7 === foo:bm8; // false
}

function testSimpleBooleanMapValueEqualityInDifferentMap() returns boolean {
    return foo:bm7["key5"] == foo:bm8["key5"]; // true
}

function testSimpleBooleanMapReferenceEqualityInDifferentMap() returns boolean {
    return foo:bm7["key5"] === foo:bm8["key5"]; // false
}

// int -------------------------------------------------------

function testSimpleIntMapValueEqualityUsingSameReference() returns boolean {
    return foo:im1 == foo:im1; // true
}

function testSimpleIntMapValueEqualityUsingDifferentReference() returns boolean {
    return foo:im1 == foo:im1_new; // true
}

function testSimpleIntMapReferenceEqualityUsingSameReference() returns boolean {
    return foo:im1 === foo:im1; // true
}

function testSimpleIntMapReferenceEqualityUsingDifferentReference() returns boolean {
    return foo:im1 === foo:im1_new; // false
}

// -----------------------------------------------------------

function testComplexIntMapValueEqualityUsingSameReference() returns boolean {
    return foo:im3 == foo:im3; // true
}

function testComplexIntMapValueEqualityUsingDifferentReference() returns boolean {
    return foo:im3 == foo:im3_new; // true
}

function testComplexIntMapReferenceEqualityUsingSameReference() returns boolean {
    return foo:im3 === foo:im3; // true
}

function testComplexIntMapReferenceEqualityUsingDifferentReference() returns boolean {
    return foo:im3 === foo:im3_new; // false
}

// -----------------------------------------------------------

function testComplexIntMapValueEqualityUsingMapAccessSameReference() returns boolean {
    return foo:im3["key5"] == foo:im3["key5"]; // true
}

function testComplexIntMapValueEqualityUsingMapAccessDifferentReference() returns boolean {
    return foo:im3["key5"] == foo:im3_new["key5"]; // true
}

function testComplexIntMapReferenceEqualityUsingMapAccessSameReference() returns boolean {
    return foo:im1 === foo:im3["key5"]; // true
}

function testComplexIntMapReferenceEqualityUsingMapAccessDifferentReference() returns boolean {
    return foo:im3["key5"] === foo:im3_new["key5"]; // false
}

// -----------------------------------------------------------

function testSimpleIntMapValueEqualityUsingSameReferenceInMap() returns boolean {
    return foo:im7["key5"] == foo:im7["key5"]; // true
}

function testSimpleIntMapValueEqualityUsingDifferentReferenceInMap() returns boolean {
    return foo:im7["key5"] == foo:im1; // true
}

function testSimpleIntMapReferenceEqualityUsingSameReferenceInMap() returns boolean {
    return foo:im7["key5"] === foo:im7["key5"]; // true
}

function testSimpleIntMapReferenceEqualityUsingDifferentReferenceInMap() returns boolean {
    return foo:im7["key5"] === foo:im1; // false
}

// -----------------------------------------------------------

function testComplexIntMapValueEquality() returns boolean {
    return foo:im7 == foo:im8; // true
}

function testComplexIntMapReferenceEquality() returns boolean {
    return foo:im7 === foo:im8; // false
}

function testSimpleIntMapValueEqualityInDifferentMap() returns boolean {
    return foo:im7["key5"] == foo:im8["key5"]; // true
}

function testSimpleIntMapReferenceEqualityInDifferentMap() returns boolean {
    return foo:im7["key5"] === foo:im8["key5"]; // false
}

// byte ------------------------------------------------------

function testSimpleByteMapValueEqualityUsingSameReference() returns boolean {
    return foo:bytem1 == foo:bytem1; // true
}

function testSimpleByteMapValueEqualityUsingDifferentReference() returns boolean {
    return foo:bytem1 == foo:bytem1_new; // true
}

function testSimpleByteMapReferenceEqualityUsingSameReference() returns boolean {
    return foo:bytem1 === foo:bytem1; // true
}

function testSimpleByteMapReferenceEqualityUsingDifferentReference() returns boolean {
    return foo:bytem1 === foo:bytem1_new; // false
}

// -----------------------------------------------------------

function testComplexByteMapValueEqualityUsingSameReference() returns boolean {
    return foo:bytem3 == foo:bytem3; // true
}

function testComplexByteMapValueEqualityUsingDifferentReference() returns boolean {
    return foo:bytem3 == foo:bytem3_new; // true
}

function testComplexByteMapReferenceEqualityUsingSameReference() returns boolean {
    return foo:bytem3 === foo:bytem3; // true
}

function testComplexByteMapReferenceEqualityUsingDifferentReference() returns boolean {
    return foo:bytem3 === foo:bytem3_new; // false
}

// -----------------------------------------------------------

function testComplexByteMapValueEqualityUsingMapAccessSameReference() returns boolean {
    return foo:bytem3["key5"] == foo:bytem3["key5"]; // true
}

function testComplexByteMapValueEqualityUsingMapAccessDifferentReference() returns boolean {
    return foo:bytem3["key5"] == foo:bytem3_new["key5"]; // true
}

function testComplexByteMapReferenceEqualityUsingMapAccessSameReference() returns boolean {
    return foo:bytem1 === foo:bytem3["key5"]; // true
}

function testComplexByteMapReferenceEqualityUsingMapAccessDifferentReference() returns boolean {
    return foo:bytem3["key5"] === foo:bytem3_new["key5"]; // false
}

// -----------------------------------------------------------

function testSimpleByteMapValueEqualityUsingSameReferenceInMap() returns boolean {
    return foo:bytem7["key5"] == foo:bytem7["key5"]; // true
}

function testSimpleByteMapValueEqualityUsingDifferentReferenceInMap() returns boolean {
    return foo:bytem7["key5"] == foo:bytem1; // true
}

function testSimpleByteMapReferenceEqualityUsingSameReferenceInMap() returns boolean {
    return foo:bytem7["key5"] === foo:bytem7["key5"]; // true
}

function testSimpleByteMapReferenceEqualityUsingDifferentReferenceInMap() returns boolean {
    return foo:bytem7["key5"] === foo:bytem1; // false
}

// -----------------------------------------------------------

function testComplexByteMapValueEquality() returns boolean {
    return foo:bytem7 == foo:bytem8; // true
}

function testComplexByteMapReferenceEquality() returns boolean {
    return foo:bytem7 === foo:bytem8; // false
}

function testSimpleByteMapValueEqualityInDifferentMap() returns boolean {
    return foo:bytem7["key5"] == foo:bytem8["key5"]; // true
}

function testSimpleByteMapReferenceEqualityInDifferentMap() returns boolean {
    return foo:bytem7["key5"] === foo:bytem8["key5"]; // false
}

// float -----------------------------------------------------

function testSimpleFloatMapValueEqualityUsingSameReference() returns boolean {
    return foo:fm1 == foo:fm1; // true
}

function testSimpleFloatMapValueEqualityUsingDifferentReference() returns boolean {
    return foo:fm1 == foo:fm1_new; // true
}

function testSimpleFloatMapReferenceEqualityUsingSameReference() returns boolean {
    return foo:fm1 === foo:fm1; // true
}

function testSimpleFloatMapReferenceEqualityUsingDifferentReference() returns boolean {
    return foo:fm1 === foo:fm1_new; // false
}

// -----------------------------------------------------------

function testComplexFloatMapValueEqualityUsingSameReference() returns boolean {
    return foo:fm3 == foo:fm3; // true
}

function testComplexFloatMapValueEqualityUsingDifferentReference() returns boolean {
    return foo:fm3 == foo:fm3_new; // true
}

function testComplexFloatMapReferenceEqualityUsingSameReference() returns boolean {
    return foo:fm3 === foo:fm3; // true
}

function testComplexFloatMapReferenceEqualityUsingDifferentReference() returns boolean {
    return foo:fm3 === foo:fm3_new; // false
}

// -----------------------------------------------------------

function testComplexFloatMapValueEqualityUsingMapAccessSameReference() returns boolean {
    return foo:fm3["key5"] == foo:fm3["key5"]; // true
}

function testComplexFloatMapValueEqualityUsingMapAccessDifferentReference() returns boolean {
    return foo:fm3["key5"] == foo:fm3_new["key5"]; // true
}

function testComplexFloatMapReferenceEqualityUsingMapAccessSameReference() returns boolean {
    return foo:fm1 === foo:fm3["key5"]; // true
}

function testComplexFloatMapReferenceEqualityUsingMapAccessDifferentReference() returns boolean {
    return foo:fm3["key5"] === foo:fm3_new["key5"]; // false
}

// -----------------------------------------------------------

function testSimpleFloatMapValueEqualityUsingSameReferenceInMap() returns boolean {
    return foo:fm7["key5"] == foo:fm7["key5"]; // true
}

function testSimpleFloatMapValueEqualityUsingDifferentReferenceInMap() returns boolean {
    return foo:fm7["key5"] == foo:fm1; // true
}

function testSimpleFloatMapReferenceEqualityUsingSameReferenceInMap() returns boolean {
    return foo:fm7["key5"] === foo:fm7["key5"]; // true
}

function testSimpleFloatMapReferenceEqualityUsingDifferentReferenceInMap() returns boolean {
    return foo:fm7["key5"] === foo:fm1; // false
}

// -----------------------------------------------------------

function testComplexFloatMapValueEquality() returns boolean {
    return foo:fm7 == foo:fm8; // true
}

function testComplexFloatMapReferenceEquality() returns boolean {
    return foo:fm7 === foo:fm8; // false
}

function testSimpleFloatMapValueEqualityInDifferentMap() returns boolean {
    return foo:fm7["key5"] == foo:fm8["key5"]; // true
}

function testSimpleFloatMapReferenceEqualityInDifferentMap() returns boolean {
    return foo:fm7["key5"] === foo:fm8["key5"]; // false
}

// decimal ---------------------------------------------------

function testSimpleDecimalMapValueEqualityUsingSameReference() returns boolean {
    return foo:dm1 == foo:dm1; // true
}

function testSimpleDecimalMapValueEqualityUsingDifferentReference() returns boolean {
    return foo:dm1 == foo:dm1_new; // true
}

function testSimpleDecimalMapReferenceEqualityUsingSameReference() returns boolean {
    return foo:dm1 === foo:dm1; // true
}

function testSimpleDecimalMapReferenceEqualityUsingDifferentReference() returns boolean {
    return foo:dm1 === foo:dm1_new; // false
}

// -----------------------------------------------------------

function testComplexDecimalMapValueEqualityUsingSameReference() returns boolean {
    return foo:dm3 == foo:dm3; // true
}

function testComplexDecimalMapValueEqualityUsingDifferentReference() returns boolean {
    return foo:dm3 == foo:dm3_new; // true
}

function testComplexDecimalMapReferenceEqualityUsingSameReference() returns boolean {
    return foo:dm3 === foo:dm3; // true
}

function testComplexDecimalMapReferenceEqualityUsingDifferentReference() returns boolean {
    return foo:dm3 === foo:dm3_new; // false
}

// -----------------------------------------------------------

function testComplexDecimalMapValueEqualityUsingMapAccessSameReference() returns boolean {
    return foo:dm3["key5"] == foo:dm3["key5"]; // true
}

function testComplexDecimalMapValueEqualityUsingMapAccessDifferentReference() returns boolean {
    return foo:dm3["key5"] == foo:dm3_new["key5"]; // true
}

function testComplexDecimalMapReferenceEqualityUsingMapAccessSameReference() returns boolean {
    return foo:dm1 === foo:dm3["key5"]; // true
}

function testComplexDecimalMapReferenceEqualityUsingMapAccessDifferentReference() returns boolean {
    return foo:dm3["key5"] === foo:dm3_new["key5"]; // false
}

// -----------------------------------------------------------

function testSimpleDecimalMapValueEqualityUsingSameReferenceInMap() returns boolean {
    return foo:dm7["key5"] == foo:dm7["key5"]; // true
}

function testSimpleDecimalMapValueEqualityUsingDifferentReferenceInMap() returns boolean {
    return foo:dm7["key5"] == foo:dm1; // true
}

function testSimpleDecimalMapReferenceEqualityUsingSameReferenceInMap() returns boolean {
    return foo:dm7["key5"] === foo:dm7["key5"]; // true
}

function testSimpleDecimalMapReferenceEqualityUsingDifferentReferenceInMap() returns boolean {
    return foo:dm7["key5"] === foo:dm1; // false
}

// -----------------------------------------------------------

function testComplexDecimalMapValueEquality() returns boolean {
    return foo:dm7 == foo:dm8; // true
}

function testComplexDecimalMapReferenceEquality() returns boolean {
    return foo:dm7 === foo:dm8; // false
}

function testSimpleDecimalMapValueEqualityInDifferentMap() returns boolean {
    return foo:dm7["key5"] == foo:dm8["key5"]; // true
}

function testSimpleDecimalMapReferenceEqualityInDifferentMap() returns boolean {
    return foo:dm7["key5"] === foo:dm8["key5"]; // false
}

// string ----------------------------------------------------

function testSimpleStringMapValueEqualityUsingSameReference() returns boolean {
    return foo:sm1 == foo:sm1; // true
}

function testSimpleStringMapValueEqualityUsingDifferentReference() returns boolean {
    return foo:sm1 == foo:sm1_new; // true
}

function testSimpleStringMapReferenceEqualityUsingSameReference() returns boolean {
    return foo:sm1 === foo:sm1; // true
}

function testSimpleStringMapReferenceEqualityUsingDifferentReference() returns boolean {
    return foo:sm1 === foo:sm1_new; // false
}

// -----------------------------------------------------------

function testComplexStringMapValueEqualityUsingSameReference() returns boolean {
    return foo:sm3 == foo:sm3; // true
}

function testComplexStringMapValueEqualityUsingDifferentReference() returns boolean {
    return foo:sm3 == foo:sm3_new; // true
}

function testComplexStringMapReferenceEqualityUsingSameReference() returns boolean {
    return foo:sm3 === foo:sm3; // true
}

function testComplexStringMapReferenceEqualityUsingDifferentReference() returns boolean {
    return foo:sm3 === foo:sm3_new; // false
}

// -----------------------------------------------------------

function testComplexStringMapValueEqualityUsingMapAccessSameReference() returns boolean {
    return foo:sm3["key5"] == foo:sm3["key5"]; // true
}

function testComplexStringMapValueEqualityUsingMapAccessDifferentReference() returns boolean {
    return foo:sm3["key5"] == foo:sm3_new["key5"]; // true
}

function testComplexStringMapReferenceEqualityUsingMapAccessSameReference() returns boolean {
    return foo:sm1 === foo:sm3["key5"]; // true
}

function testComplexStringMapReferenceEqualityUsingMapAccessDifferentReference() returns boolean {
    return foo:sm3["key5"] === foo:sm3_new["key5"]; // false
}

// -----------------------------------------------------------

function testSimpleStringMapValueEqualityUsingSameReferenceInMap() returns boolean {
    return foo:sm7["key5"] == foo:sm7["key5"]; // true
}

function testSimpleStringMapValueEqualityUsingDifferentReferenceInMap() returns boolean {
    return foo:sm7["key5"] == foo:sm1; // true
}

function testSimpleStringMapReferenceEqualityUsingSameReferenceInMap() returns boolean {
    return foo:sm7["key5"] === foo:sm7["key5"]; // true
}

function testSimpleStringMapReferenceEqualityUsingDifferentReferenceInMap() returns boolean {
    return foo:sm7["key5"] === foo:sm1; // false
}

// -----------------------------------------------------------

function testComplexStringMapValueEquality() returns boolean {
    return foo:sm7 == foo:sm8; // true
}

function testComplexStringMapReferenceEquality() returns boolean {
    return foo:sm7 === foo:sm8; // false
}

function testSimpleStringMapValueEqualityInDifferentMap() returns boolean {
    return foo:sm7["key5"] == foo:sm8["key5"]; // true
}

function testSimpleStringMapReferenceEqualityInDifferentMap() returns boolean {
    return foo:sm7["key5"] === foo:sm8["key5"]; // false
}

// nil -------------------------------------------------------

function testSimpleNilMapValueEqualityUsingSameReference() returns boolean {
    return foo:nm1 == foo:nm1; // true
}

function testSimpleNilMapValueEqualityUsingDifferentReference() returns boolean {
    return foo:nm1 == foo:nm1_new; // true
}

function testSimpleNilMapReferenceEqualityUsingSameReference() returns boolean {
    return foo:nm1 === foo:nm1; // true
}

function testSimpleNilMapReferenceEqualityUsingDifferentReference() returns boolean {
    return foo:nm1 === foo:nm1_new; // false
}

// -----------------------------------------------------------

function testComplexNilMapValueEqualityUsingSameReference() returns boolean {
    return foo:nm3 == foo:nm3; // true
}

function testComplexNilMapValueEqualityUsingDifferentReference() returns boolean {
    return foo:nm3 == foo:nm3_new; // true
}

function testComplexNilMapReferenceEqualityUsingSameReference() returns boolean {
    return foo:nm3 === foo:nm3; // true
}

function testComplexNilMapReferenceEqualityUsingDifferentReference() returns boolean {
    return foo:nm3 === foo:nm3_new; // false
}

// -----------------------------------------------------------

function testComplexNilMapValueEqualityUsingMapAccessSameReference() returns boolean {
    return foo:nm3["key5"] == foo:nm3["key5"]; // true
}

function testComplexNilMapValueEqualityUsingMapAccessDifferentReference() returns boolean {
    return foo:nm3["key5"] == foo:nm3_new["key5"]; // true
}

function testComplexNilMapReferenceEqualityUsingMapAccessSameReference() returns boolean {
    return foo:nm1 === foo:nm3["key5"]; // true
}

function testComplexNilMapReferenceEqualityUsingMapAccessDifferentReference() returns boolean {
    return foo:nm3["key5"] === foo:nm3_new["key5"]; // false
}

// -----------------------------------------------------------

function testSimpleNilMapValueEqualityUsingSameReferenceInMap() returns boolean {
    return foo:nm7["key5"] == foo:nm7["key5"]; // true
}

function testSimpleNilMapValueEqualityUsingDifferentReferenceInMap() returns boolean {
    return foo:nm7["key5"] == foo:nm1; // true
}

function testSimpleNilMapReferenceEqualityUsingSameReferenceInMap() returns boolean {
    return foo:nm7["key5"] === foo:nm7["key5"]; // true
}

function testSimpleNilMapReferenceEqualityUsingDifferentReferenceInMap() returns boolean {
    return foo:nm7["key5"] === foo:nm1; // false
}

// -----------------------------------------------------------

function testComplexNilMapValueEquality() returns boolean {
    return foo:nm7 == foo:nm8; // true
}

function testComplexNilMapReferenceEquality() returns boolean {
    return foo:nm7 === foo:nm8; // false
}

function testSimpleNilMapValueEqualityInDifferentMap() returns boolean {
    return foo:nm7["key5"] == foo:nm8["key5"]; // true
}

function testSimpleNilMapReferenceEqualityInDifferentMap() returns boolean {
    return foo:nm7["key5"] === foo:nm8["key5"]; // false
}

public function main() {
    io:println(testSimpleBooleanMapValueEqualityUsingSameReference()); // @output true
    io:println(testSimpleBooleanMapValueEqualityUsingDifferentReference()); // @output true
    io:println(testSimpleBooleanMapReferenceEqualityUsingSameReference()); // @output true
    io:println(testSimpleBooleanMapReferenceEqualityUsingDifferentReference()); // @output false
    io:println(testComplexBooleanMapValueEqualityUsingSameReference()); // @output true
    io:println(testComplexBooleanMapValueEqualityUsingDifferentReference()); // @output true
    io:println(testComplexBooleanMapReferenceEqualityUsingSameReference()); // @output true
    io:println(testComplexBooleanMapReferenceEqualityUsingDifferentReference()); // @output false
    io:println(testComplexBooleanMapValueEqualityUsingMapAccessSameReference()); // @output true
    io:println(testComplexBooleanMapValueEqualityUsingMapAccessDifferentReference()); // @output true
    io:println(testComplexBooleanMapReferenceEqualityUsingMapAccessSameReference()); // @output true
    io:println(testComplexBooleanMapReferenceEqualityUsingMapAccessDifferentReference()); // @output false
    io:println(testSimpleBooleanMapValueEqualityUsingSameReferenceInMap()); // @output true
    io:println(testSimpleBooleanMapValueEqualityUsingDifferentReferenceInMap()); // @output true
    io:println(testSimpleBooleanMapReferenceEqualityUsingSameReferenceInMap()); // @output true
    io:println(testSimpleBooleanMapReferenceEqualityUsingDifferentReferenceInMap()); // @output false
    io:println(testComplexBooleanMapValueEquality()); // @output true
    io:println(testComplexBooleanMapReferenceEquality()); // @output false
    io:println(testSimpleBooleanMapValueEqualityInDifferentMap()); // @output true
    io:println(testSimpleBooleanMapReferenceEqualityInDifferentMap()); // @output false
    io:println(testSimpleIntMapValueEqualityUsingSameReference()); // @output true
    io:println(testSimpleIntMapValueEqualityUsingDifferentReference()); // @output true
    io:println(testSimpleIntMapReferenceEqualityUsingSameReference()); // @output true
    io:println(testSimpleIntMapReferenceEqualityUsingDifferentReference()); // @output false
    io:println(testComplexIntMapValueEqualityUsingSameReference()); // @output true
    io:println(testComplexIntMapValueEqualityUsingDifferentReference()); // @output true
    io:println(testComplexIntMapReferenceEqualityUsingSameReference()); // @output true
    io:println(testComplexIntMapReferenceEqualityUsingDifferentReference()); // @output false
    io:println(testComplexIntMapValueEqualityUsingMapAccessSameReference()); // @output true
    io:println(testComplexIntMapValueEqualityUsingMapAccessDifferentReference()); // @output true
    io:println(testComplexIntMapReferenceEqualityUsingMapAccessSameReference()); // @output true
    io:println(testComplexIntMapReferenceEqualityUsingMapAccessDifferentReference()); // @output false
    io:println(testSimpleIntMapValueEqualityUsingSameReferenceInMap()); // @output true
    io:println(testSimpleIntMapValueEqualityUsingDifferentReferenceInMap()); // @output true
    io:println(testSimpleIntMapReferenceEqualityUsingSameReferenceInMap()); // @output true
    io:println(testSimpleIntMapReferenceEqualityUsingDifferentReferenceInMap()); // @output false
    io:println(testComplexIntMapValueEquality()); // @output true
    io:println(testComplexIntMapReferenceEquality()); // @output false
    io:println(testSimpleIntMapValueEqualityInDifferentMap()); // @output true
    io:println(testSimpleIntMapReferenceEqualityInDifferentMap()); // @output false
    io:println(testSimpleByteMapValueEqualityUsingSameReference()); // @output true
    io:println(testSimpleByteMapValueEqualityUsingDifferentReference()); // @output true
    io:println(testSimpleByteMapReferenceEqualityUsingSameReference()); // @output true
    io:println(testSimpleByteMapReferenceEqualityUsingDifferentReference()); // @output false
    io:println(testComplexByteMapValueEqualityUsingSameReference()); // @output true
    io:println(testComplexByteMapValueEqualityUsingDifferentReference()); // @output true
    io:println(testComplexByteMapReferenceEqualityUsingSameReference()); // @output true
    io:println(testComplexByteMapReferenceEqualityUsingDifferentReference()); // @output false
    io:println(testComplexByteMapValueEqualityUsingMapAccessSameReference()); // @output true
    io:println(testComplexByteMapValueEqualityUsingMapAccessDifferentReference()); // @output true
    io:println(testComplexByteMapReferenceEqualityUsingMapAccessSameReference()); // @output true
    io:println(testComplexByteMapReferenceEqualityUsingMapAccessDifferentReference()); // @output false
    io:println(testSimpleByteMapValueEqualityUsingSameReferenceInMap()); // @output true
    io:println(testSimpleByteMapValueEqualityUsingDifferentReferenceInMap()); // @output true
    io:println(testSimpleByteMapReferenceEqualityUsingSameReferenceInMap()); // @output true
    io:println(testSimpleByteMapReferenceEqualityUsingDifferentReferenceInMap()); // @output false
    io:println(testComplexByteMapValueEquality()); // @output true
    io:println(testComplexByteMapReferenceEquality()); // @output false
    io:println(testSimpleByteMapValueEqualityInDifferentMap()); // @output true
    io:println(testSimpleByteMapReferenceEqualityInDifferentMap()); // @output false
    io:println(testSimpleFloatMapValueEqualityUsingSameReference()); // @output true
    io:println(testSimpleFloatMapValueEqualityUsingDifferentReference()); // @output true
    io:println(testSimpleFloatMapReferenceEqualityUsingSameReference()); // @output true
    io:println(testSimpleFloatMapReferenceEqualityUsingDifferentReference()); // @output false
    io:println(testComplexFloatMapValueEqualityUsingSameReference()); // @output true
    io:println(testComplexFloatMapValueEqualityUsingDifferentReference()); // @output true
    io:println(testComplexFloatMapReferenceEqualityUsingSameReference()); // @output true
    io:println(testComplexFloatMapReferenceEqualityUsingDifferentReference()); // @output false
    io:println(testComplexFloatMapValueEqualityUsingMapAccessSameReference()); // @output true
    io:println(testComplexFloatMapValueEqualityUsingMapAccessDifferentReference()); // @output true
    io:println(testComplexFloatMapReferenceEqualityUsingMapAccessSameReference()); // @output true
    io:println(testComplexFloatMapReferenceEqualityUsingMapAccessDifferentReference()); // @output false
    io:println(testSimpleFloatMapValueEqualityUsingSameReferenceInMap()); // @output true
    io:println(testSimpleFloatMapValueEqualityUsingDifferentReferenceInMap()); // @output true
    io:println(testSimpleFloatMapReferenceEqualityUsingSameReferenceInMap()); // @output true
    io:println(testSimpleFloatMapReferenceEqualityUsingDifferentReferenceInMap()); // @output false
    io:println(testComplexFloatMapValueEquality()); // @output true
    io:println(testComplexFloatMapReferenceEquality()); // @output false
    io:println(testSimpleFloatMapValueEqualityInDifferentMap()); // @output true
    io:println(testSimpleFloatMapReferenceEqualityInDifferentMap()); // @output false
    io:println(testSimpleDecimalMapValueEqualityUsingSameReference()); // @output true
    io:println(testSimpleDecimalMapValueEqualityUsingDifferentReference()); // @output true
    io:println(testSimpleDecimalMapReferenceEqualityUsingSameReference()); // @output true
    io:println(testSimpleDecimalMapReferenceEqualityUsingDifferentReference()); // @output false
    io:println(testComplexDecimalMapValueEqualityUsingSameReference()); // @output true
    io:println(testComplexDecimalMapValueEqualityUsingDifferentReference()); // @output true
    io:println(testComplexDecimalMapReferenceEqualityUsingSameReference()); // @output true
    io:println(testComplexDecimalMapReferenceEqualityUsingDifferentReference()); // @output false
    io:println(testComplexDecimalMapValueEqualityUsingMapAccessSameReference()); // @output true
    io:println(testComplexDecimalMapValueEqualityUsingMapAccessDifferentReference()); // @output true
    io:println(testComplexDecimalMapReferenceEqualityUsingMapAccessSameReference()); // @output true
    io:println(testComplexDecimalMapReferenceEqualityUsingMapAccessDifferentReference()); // @output false
    io:println(testSimpleDecimalMapValueEqualityUsingSameReferenceInMap()); // @output true
    io:println(testSimpleDecimalMapValueEqualityUsingDifferentReferenceInMap()); // @output true
    io:println(testSimpleDecimalMapReferenceEqualityUsingSameReferenceInMap()); // @output true
    io:println(testSimpleDecimalMapReferenceEqualityUsingDifferentReferenceInMap()); // @output false
    io:println(testComplexDecimalMapValueEquality()); // @output true
    io:println(testComplexDecimalMapReferenceEquality()); // @output false
    io:println(testSimpleDecimalMapValueEqualityInDifferentMap()); // @output true
    io:println(testSimpleDecimalMapReferenceEqualityInDifferentMap()); // @output false
    io:println(testSimpleStringMapValueEqualityUsingSameReference()); // @output true
    io:println(testSimpleStringMapValueEqualityUsingDifferentReference()); // @output true
    io:println(testSimpleStringMapReferenceEqualityUsingSameReference()); // @output true
    io:println(testSimpleStringMapReferenceEqualityUsingDifferentReference()); // @output false
    io:println(testComplexStringMapValueEqualityUsingSameReference()); // @output true
    io:println(testComplexStringMapValueEqualityUsingDifferentReference()); // @output true
    io:println(testComplexStringMapReferenceEqualityUsingSameReference()); // @output true
    io:println(testComplexStringMapReferenceEqualityUsingDifferentReference()); // @output false
    io:println(testComplexStringMapValueEqualityUsingMapAccessSameReference()); // @output true
    io:println(testComplexStringMapValueEqualityUsingMapAccessDifferentReference()); // @output true
    io:println(testComplexStringMapReferenceEqualityUsingMapAccessSameReference()); // @output true
    io:println(testComplexStringMapReferenceEqualityUsingMapAccessDifferentReference()); // @output false
    io:println(testSimpleStringMapValueEqualityUsingSameReferenceInMap()); // @output true
    io:println(testSimpleStringMapValueEqualityUsingDifferentReferenceInMap()); // @output true
    io:println(testSimpleStringMapReferenceEqualityUsingSameReferenceInMap()); // @output true
    io:println(testSimpleStringMapReferenceEqualityUsingDifferentReferenceInMap()); // @output false
    io:println(testComplexStringMapValueEquality()); // @output true
    io:println(testComplexStringMapReferenceEquality()); // @output false
    io:println(testSimpleStringMapValueEqualityInDifferentMap()); // @output true
    io:println(testSimpleStringMapReferenceEqualityInDifferentMap()); // @output false
    io:println(testSimpleNilMapValueEqualityUsingSameReference()); // @output true
    io:println(testSimpleNilMapValueEqualityUsingDifferentReference()); // @output true
    io:println(testSimpleNilMapReferenceEqualityUsingSameReference()); // @output true
    io:println(testSimpleNilMapReferenceEqualityUsingDifferentReference()); // @output false
    io:println(testComplexNilMapValueEqualityUsingSameReference()); // @output true
    io:println(testComplexNilMapValueEqualityUsingDifferentReference()); // @output true
    io:println(testComplexNilMapReferenceEqualityUsingSameReference()); // @output true
    io:println(testComplexNilMapReferenceEqualityUsingDifferentReference()); // @output false
    io:println(testComplexNilMapValueEqualityUsingMapAccessSameReference()); // @output true
    io:println(testComplexNilMapValueEqualityUsingMapAccessDifferentReference()); // @output true
    io:println(testComplexNilMapReferenceEqualityUsingMapAccessSameReference()); // @output true
    io:println(testComplexNilMapReferenceEqualityUsingMapAccessDifferentReference()); // @output false
    io:println(testSimpleNilMapValueEqualityUsingSameReferenceInMap()); // @output true
    io:println(testSimpleNilMapValueEqualityUsingDifferentReferenceInMap()); // @output true
    io:println(testSimpleNilMapReferenceEqualityUsingSameReferenceInMap()); // @output true
    io:println(testSimpleNilMapReferenceEqualityUsingDifferentReferenceInMap()); // @output false
    io:println(testComplexNilMapValueEquality()); // @output true
    io:println(testComplexNilMapReferenceEquality()); // @output false
    io:println(testSimpleNilMapValueEqualityInDifferentMap()); // @output true
    io:println(testSimpleNilMapReferenceEqualityInDifferentMap()); // @output false
}

