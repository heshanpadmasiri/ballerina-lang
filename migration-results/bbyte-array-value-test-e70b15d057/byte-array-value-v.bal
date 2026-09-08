import ballerina/io;

function base16ByteArrayLiteralWithWS() {
    byte[] byteArray = base16 `a
                        d`;
    assertEquality(byteArray, base16 `ad`);

    byte[] byteArray2 = base16 `a	d`;
    assertEquality(byteArray2, base16 `ad`);

    byte[3] byteArray3 = base16 `ab a       c a    d`;
    assertEquality(byteArray3, base16 `ab ac ad`);
}

function base64ByteArrayLiteralWithWS() {
    byte[] byteArray1 = base64 `aGVsbG8gYmFsbGVyaW5hICEhIQ==`;
    byte[] byteArray2 = base64 `aGVs	bG8g	YmFs	bGVy	aW5h	ICEh	IQ==`;
    byte[] byteArray3 = base64 `	aG	Vs	b	G	8g	Y	mFs	bGVy	aW5h	ICEh	IQ=		=	`;

    assertEquality(byteArray1, byteArray2);
    assertEquality(byteArray1, byteArray3);
}

function testByteArrayLiteralInherentType() {
    var byteArray1 = base16 `aa bb`;
    assertEquality(true, byteArray1 is byte[2]);

    var byteArray2 = base64 `aa bb`;
    assertEquality(true, byteArray2 is byte[3]);

    byte[*] byteArray3 = base16 `aa bb`;
    assertEquality(true, byteArray3 is byte[2]);

    byte[*] byteArray4 = base64 `aa bb`;
    assertEquality(true, byteArray4 is byte[3]);

    byte[*] byteArray5 = (base64 `aa bb`);
    assertEquality(true, byteArray5 is byte[3]);

    byte[*] byteArray6 = (((base16 `aa bb`)));
    assertEquality(true, byteArray6 is byte[2]);
}

type ByteArr byte[2];
type ByteArr2 byte[2] & readonly;

function testByteArrayLiteralWithReferenceType() {
    ByteArr byteArr1 = base16 `aa bb`;
    assertEquality(true, byteArr1 is byte[2]);
    assertEquality(true, byteArr1 is ByteArr);

    ByteArr2 byteArr2 = base16 `aa bb`;
    assertEquality(true, byteArr2.isReadOnly());
    assertEquality(true, byteArr2 is ByteArr2);
}

function testByteArrayLiteralAssignToIntArray() {
    int[*] arr1 = base16 `aa bb`;
    int[2] arr2 = arr1;
    assertTrue(arr2 is int[2]);
    assertEquality([170, 187], arr2);

    int[] arr3 = arr1;
    assertTrue(arr3 is int[2]);
    assertEquality([170, 187], arr3);

    int[3] arr4 = base64 `aa bb`;
    assertTrue(arr4 is int[3]);
    assertEquality([105, 166, 219], arr4);
}

function assertTrue(boolean actual) {
    assertEquality(true, actual);
}

function assertEquality(anydata expected, anydata actual) {
    if expected == actual {
        return;
    }

    panic error("AssertionError", message = "expected '" + expected.toString() + "', found '" + actual.toString() + "'");
}

public function main() {
    base16ByteArrayLiteralWithWS();
    base64ByteArrayLiteralWithWS();
    testByteArrayLiteralInherentType();
    testByteArrayLiteralWithReferenceType();
    testByteArrayLiteralAssignToIntArray();
}

function retainIoImport() {
    io:println();
}
