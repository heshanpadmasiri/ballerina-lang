// Test invalid decimal value scenarios.
function testInvlaidDecimalValue() {
    decimal a = 12.3f; // @error
    decimal b = 0x4fp1; // @error
    decimal c = 0x12bc;
    decimal d = -0x12b;
    decimal e = 0X1abc;
    decimal f = -0X1ab;
    decimal[] ds1 = [12.3f, 22.4]; // @error
    decimal[] ds2 = [0x3ap-1, 0x4bp3]; // @error @error
    int|decimal md1 = 0x33p0; // @error
    int|decimal md2 = 22.22;
}

// Test invalid decimal inference.
function testInvalidDecimalInference() {
    decimal a = 1.0 / 2.0f; // @error
    decimal b = 1.0 + 2.0f; // @error
    decimal c = 1.0d + 2.0f; // @error
    decimal d = 1.0 * 2.0f; // @error
    decimal e = 1.0f + 2.0; // @error
    decimal f = 1.0f - 2.0; // @error
    float k = 2.0;
    decimal g = 1.0 * 2.0 + 0.002 / k; // @error
}

function testOverflow() {
    decimal _ = 9.999999999999999999999999999999999e6144;
    decimal _ = 9.999999999999999999999999999999999e6144d;
    decimal _ = 9.999999999999999999999999999999998e6144d;
    decimal _ = 9.9999999999999999999999999999999999e6144d; // @error
    decimal _ = 9.999999999999999999999999999999999e6145d; // @error
    decimal _ = 9.999999999999999999999999999999999e6143d;
    decimal _ = -9.999999999999999999999999999999999e6144d;
    decimal _ = -9.9999999999999999999999999999999999e6144d; // @error
}
