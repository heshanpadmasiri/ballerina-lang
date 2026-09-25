type firstRec record {
    int id = 1;
    string name = "default";
};

type secondRec record {
    int f1 = 1;
    string f2 = "default";
};

type thirdRec record {
    int f1;
    string f2;
    int f4?;
};

type Person record {
    int age = 1;
    string name = "default";
};

function workerActionFirstTest() {
    worker w1 {
        Person p1 = {};
        p1 -> w2;
        var result = p1 ->> w2;
        any|error val = result; // @error
    }
    worker w2 returns error? {
        if(0 > 1){
             error err = error("err", message = "err msg");
             return err;
        }
        Person _ = <- w1;
        Person p3 = {}; // @error
        p3 = <- w1;
        return;
    }
    worker w3 {
        var x = flush w1; // @error
        any|error val = x; // @error
    }
}

function workerActionSecTest() {
    worker w1 {
        int i =10;
        i -> w2;

        string msg = "hello";
        msg -> w2;
    }

    worker w2 {
        print("w1");
        string msg = "default"; // @error
        if (true) {
            msg = <- w1; // @error
        }
    }
}

function workerActionThirdTest() {
    worker w1 {
        int i = 5;
        error? x1 = i ->> w2; // @error
        error? x2 = i ->> w2; // @error
        error? result = flush w2; // @error // @error
    }
    worker w2 returns error?{
        if(0 > 1){
             error err = error("err", message = "err msg");
             return err;
        }
        int j =0 ; // @error
        j = <- w1;
        j = <- w1;
        return;
    }
}

function invalidReceiveUsage() {
    fork {
        worker w1 {
            int a = 5;
            a -> w2;
        }
        worker w2 {
            int _ = <- w1;
        }
    }
}

function print(string str) {
    string _ = str.toUpperAscii();
}

function getId() returns int {
    return 10;
}

function getName() returns string {
    return "Natasha";
}

function getStatus() returns boolean {
    return true;
}

function getStdId() returns future<int> {
    future <int> id = start getId();
    return id;
}

public function workerAsAFutureTest() returns int {
    worker wx returns int {
        any _ = <- wy;
        "h" -> wy;
        future<int> fi = wy; // @error
        return checkpanic wait fi;
    }

    worker wy returns int {
        "a" -> wx;
        string _ = <- wx;

        fork {
            worker wix returns int {
                int _ = <- wiy;
                var _ = wiy;

                return 0;
            }
            worker wiy {
                0 -> wix;
                _ = wait wix; // @error
                _ = wait wx; // @error
            }
        }

        future<int> _ = wix; // @error
        int _ = wait wix; // @error
        future<int> _ = wx; // @error
        return wait wx; // @error
    }

    function () returns int lambda0 = function () returns int {
        worker lw0 {
            _ = wait lw1;
        }

        worker lw1 {

        }
        return 1+2;
    };

    future<int> fLambda0 = start lambda0();

    function () returns int|error lambda1 = function () returns int|error {
        return wait fLambda0;
    };
    future<int|error> _ = start lambda1();

    return wait wy; // @error
}

class ObjFuncUsingWorkersAsFutureValues {
    function foo() returns int {
        worker wx returns int {
            any _ = <- wy;
            "h" -> wy;
            future<int> fi = wy; // @error
            var _ = function () {
                _ = wait wy; // @error
            };
            return checkpanic wait fi;
        }

        worker wy returns int {
            "a" -> wx;
            string _ = <- wx;

            fork {
                worker wix returns int {
                    int _ = <- wiy;
                    var _ = wiy;

                    return 0;
                }
                worker wiy {
                    0 -> wix;
                    _ = wait wix; // @error
                    _ = wait wx; // @error
                    function (future<int>) returns future<int> f = (a) => wx; // @error
                    future<int> p = start bar();
                    future<int> _ = f(p);
                }
            }

            future<int> _ = wix; // @error
            int _ = wait wix; // @error
            future<int> _ = wx; // @error
            return wait wx; // @error
        }
        return wait wy; // @error
    }

}

function bar() returns int {
    return  1;
}

function testUnsupportedWorkerPosition() {
    worker w {
        if 1 / 2 == 0 {
            0 -> function;
            if true {
                1 -> function;
            }
        }

        int i = 6;
        foreach var index in 0 ..< i {
            index -> function; // @error
            index -> w1; // @error
        }

        while (true) {
            i -> function; // @error
            i -> w1; // @error
        }

        match i { // @error
            1 => {
                i -> function; // @error
            }
            2 => {
                i -> w1; // @error
            }
        }

        function _ = function() {
                         i -> w1; // @error
                     };
    }

    worker w1 {
        int i = 6;
        foreach var index in 0 ..< i {
            int _ = <- w; // @error
        }
    }

    if (2 / 2 == 1) {
        int _ = <- w; // @error
    }
}

function f = function() {
                 worker w {
                     if 1 / 2 == 0 {
                         0 -> function;
                         if true {
                             1 -> function;
                         }
                     }

                     int i = 6;
                     foreach var index in 0 ..< i {
                         index -> function; // @error
                         index -> w1; // @error
                     }

                     while (true) {
                         i -> function; // @error
                         i -> w1; // @error
                     }

                     match i { // @error
                         1 => {
                             i -> function; // @error
                         }
                         2 => {
                             i -> w1; // @error
                         }
                     }

                     function _ = function() {
                                      i -> w1; // @error
                                  };
                 }

                 worker w1 {
                     int i = 6;
                     foreach var index in 0 ..< i {
                         int _ = <- w; // @error
                     }
                 }

                 if (2 / 2 == 1) {
                     int _ = <- w; // @error
                 }
             };
