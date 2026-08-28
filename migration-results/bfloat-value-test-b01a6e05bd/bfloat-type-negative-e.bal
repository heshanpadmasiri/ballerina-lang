function testInvalidHexaDecimalWithFloatType() {
    float a = 0xFFFFFFFFFFFFFFFF; // @error

    a = 0xabc435de769FEAB0; // @error

    a = 0xaaaaaaaaaaaaaaa0; // @error

    a = 0xAAAAAAAAAAAAAAA0; // @error

    float|decimal b = 0xFFFFFFFFFFFFFFFF; // @error

    b = 0xabc435de769FEAB0; // @error

    b = 0xaaaaaaaaaaaaaaa0; // @error

    b = 0xAAAAAAAAAAAAAAA0; // @error
}

float x1 = 0xFFFFFFFFFFFFFFFF; // @error

float x2 = 0xabc435de769FEAB0; // @error

float x3 = 0xaaaaaaaaaaaaaaa0; // @error

float x4 = 0xAAAAAAAAAAAAAAA0; // @error

float|decimal y1 = 0xFFFFFFFFFFFFFFFF; // @error

float|decimal y2 = 0xabc435de769FEAB0; // @error

float|decimal y3 = 0xaaaaaaaaaaaaaaa0; // @error

float|decimal y4 = 0xAAAAAAAAAAAAAAA0; // @error

type FloatType float;

FloatType u1 = 0xFFFFFFFFFFFFFFFF; // @error

type FloatType2 float|decimal;

FloatType2 u2 = 0xFFFFFFFFFFFFFFFF; // @error

function testInvalidHexaDecimalWithFloatType2() {
    FloatType u3 = 0xFFFFFFFFFFFFFFFF; // @error
    FloatType u4 = 0Xffffffffffffffff; // @error
    FloatType2 u5 = 0XFFFFFFFFFFFFFFFF; // @error

    float u6 = 0x; // @error // @error
    u6 = 0X; // @error // @error

    FloatType u7 = 0x; // @error // @error

    float|decimal u8 = 0x; // @error // @error
    u8 = 0X; // @error // @error

    FloatType2 u9 = 0x; // @error // @error
}
