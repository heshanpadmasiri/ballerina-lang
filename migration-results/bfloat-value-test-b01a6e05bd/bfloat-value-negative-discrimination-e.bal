function testInvlaidFloatValue() returns float {
    float b = 2.3d; // @error
    return b;
}
