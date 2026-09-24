public type ErrorA distinct error;
public type ErrorB distinct error;

public function testSendFailureType1(boolean b, boolean c) {
    worker w1 returns boolean|ErrorA|ErrorB {
        int i = 2;
        i -> w2;
        if 0 > 1 { return true; }
        i = i + 1;
        i -> w2;
        if b { return error ErrorA("error A"); }
        44 -> w2;
        if c { return error ErrorB("error B"); }
        "xxx" -> w2;
        "yyy" -> w2;
        "zzz" -> w2;
        return true;
    }
    worker w2 {
        int _ = <- w1;
        int _ = <- w1; // @error
        int _ = <- w1; // @error
        int _ = <- w1; // @error
        string|ErrorA|ErrorB|error:NoMessage m = <- w1;
        string|error n = <- w1;
        println(m);
        println(n);
    }
}

public function testSendFailureType2(boolean b) {
    worker w1 returns boolean|ErrorA|ErrorB {
        ErrorA|ErrorB e = error ErrorA("error A");
        if b { return e; }
        11 -> w2;
        return true;
    }
    worker w2 {
        int _ = <- w1; // @error
    }
}

public function testSendFailureType3(boolean b) {
    worker w1 returns boolean|ErrorA|ErrorB {
        ErrorA|ErrorB|boolean e = error ErrorA("error A");
        if b { return e; }
        22 -> w2;
        return true;
    }
    worker w2 {
        int _ = <- w1; // @error
    }
}

public function testReceiveFailureType(boolean b, boolean c) {
    worker w1 returns boolean|ErrorA|ErrorB {
        int i = 2;
        _ = <- w2;
        if 0 > 1 { return true; }
        i = i + 1;
        _ = <- w2; // @error
        if b { return error ErrorA("error A"); }
        _ = <- w2; // @error
        if c { return error ErrorB("error B"); }
        _ = <- w2; // @error
        _ = <- w2; // @error
        _ = <- w2; // @error
        return true;
    }
    worker w2 {
        () _ = 1 ->> w1;
        () _ = 2 ->> w1;
        () p = 3 ->> w1; // @error
        () q = 4 ->> w1; // @error
        ErrorA|ErrorB? r = 5 ->> w1;
        error? s = 6 ->> w1;
        println(p);
        println(q);
        println(r);
        println(s);
    }
}

public function println(any|error value) {
}
