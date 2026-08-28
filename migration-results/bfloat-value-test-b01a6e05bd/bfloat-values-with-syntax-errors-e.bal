function testFloatValuesWithSyntaxErrors() {
    float|decimal a = 0x 3eA3 .4Eb2 p45; // @error // @error // @error // @error // @error // @error // @error // @error // @error
    a = 0x 3eA3.4Eb2p+45; // @error // @error // @error // @error // @error // @error // @error // @error // @error // @error
    a = 0x:4Eb2P-45; // @error // @error // @error // @error // @error // @error // @error
    a = 0x,4Eb2P-45; // @error // @error // @error // @error // @error // @error // @error
}
