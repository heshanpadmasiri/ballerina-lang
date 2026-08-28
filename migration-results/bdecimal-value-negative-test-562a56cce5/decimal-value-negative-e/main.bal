// Test invalid decimal value scenarios.
function testInvlaidDecimalValue() {
    // This is to test a syntax issue.
    decimal a = 12.3
    // @error
    // This is to test invalid literal assignment.
    decimal b = 12.3g; // @error @error

    // This is to test non-supported decimal value assignment that starts with 0.
    decimal d = 023.04; // @error

    // This is to test invalid hexadecimal literal assignment.
    decimal e = -0xX1231.12P1; // @error @error @error @error @error

    // This is to test hexadecimal literal assignment with invalid extra space.
    decimal f = -0 X1231.12P2; // @error @error @error @error

    // This is to test invalid syntax for missing digit after the dot.
    decimal _ = 2.; // @error
    decimal _ = 2.e12; // @error

    // This is to test invalid syntax for missing hex number after the hex indicator
    decimal _ = 0x; // @error
    decimal _ = 0X; // @error
}

function testOutOfRangeFloatWithDecimal() {
    decimal _ = 9.99E+6111f; // @error
    decimal _ = <decimal>9.99E+6111f; // @error
}
