public function testSendAllowedLocations(boolean b) returns error? {
    worker w1 {
        foreach var i in [1, 2, 3] {
            i -> function; // @error
        }
        while b {
            119 -> function; // @error
        }
        lock {
            120 -> function; // @error
        }
        1 -> function;
        if b {
            2 -> function;
            if b {
                3 -> function;
            }
        }
        () _ = 4 -> function;
        () _ = (4 -> function);
        do {
            5 -> function;
        }
        {
            5 -> function;
        }
    } on fail {
        6 -> function;
    }
    _ = <- w1;
    _ = check <- w1;
    _ = check <- w1;
    _ = <- w1;
    _ = <- w1;
    _ = <- w1;
    _ = <- w1;
    _ = <- w1;
    _ = <- w1;
    _ = <- w1;
    _ = <- w1;
}

public function testReceiveAllowedLocations(boolean b) returns error? {
    worker w1 {
        foreach int _ in [1, 2, 3] {
            _ = <- function; // @error
        }
        while b {
            _ = <- function; // @error
        }
        lock {
            _ = <- function; // @error
        }
        _ = <- function;
        if b {
            _ = <- function; // @error
            if b {
                _ = <- function; // @error
            }
        }
        _ = <- function;
        _ = (<- function);
        do {
            _ = <- function;
        }
        {
            _ = <- function;
        }
    } on fail {
        _ = <- function; // @error
        _ = <- w2|function; // @error @error
    }
    worker w2 {
        1 -> w1;
    }
    1 -> w1;
    1 -> w1;
    1 -> w1;
    1 -> w1;
    1 -> w1;
    1 -> w1;
    1 -> w1;
    1 -> w1;
    1 -> w1;
    1 -> w1;
    1 -> w1;
}
