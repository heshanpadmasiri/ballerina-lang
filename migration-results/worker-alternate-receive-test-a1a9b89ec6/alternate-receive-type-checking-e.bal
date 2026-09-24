function testAltReceiveNoMessageErrorType(boolean b) {
    worker w1 {
        1 -> w2;
        2 -> w2;
        if b { 3 -> w2; 4 -> w2; }
        if b { 5 -> w2; }
        6 -> w2;
        7 -> w2;
        if b { 8 -> w2; }
        9 -> w2;
        10 -> w2;
        if b { 11 -> w2; }
        12 -> w2;
        13.3d -> w2;
        if b { "xx" -> w2; 14 -> w2; true -> w2; }
        if !b { 13.3d -> w2; }
        if b { "xx" -> w2; 14 -> w2; true -> w2; }
    }
    worker w2 {
        string _ = <- w1|w1; // @error
        string _ = <- w1|w1; // @error
        string _ = <- w1|w1; // @error
        string _ = <- w1|w1; // @error
        string _ = <- w1|w1|w1|w1; // @error
        string _ = <- w1|w1|w1|w1; // @error
        string _ = <- w1|w1|w1|w1; // @error
    }
    _ = wait {a: w1, b: w2};
}
