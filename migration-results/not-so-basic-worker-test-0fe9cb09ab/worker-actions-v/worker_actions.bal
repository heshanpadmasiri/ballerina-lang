import ballerina/io;
import ballerina/lang.runtime;

function sleep(int millis) {
    runtime:sleep(<decimal>millis / 1000.0);
}

function chainedWorkerSendReceive() returns map<any> {
    map<any> m = {};
    fork {
        @strand{thread:"any"}
        worker w1 {
            int a = 3;
            int b = 0;
            a -> w2;
            b = <- w3;
            m["x"] = b;
        }
        @strand{thread:"any"}
        worker w2 {
            int a = 0;
            int b = 15;
            a = <- w1;
            a * 2 -> w3;
        }
        @strand{thread:"any"}
        worker w3 {
            int a = 0;
            int b = 0;
            a = <- w2;
            b = a * 2;
            b -> w1;
        }
    }
    map<any> results = wait {w1, w2, w3};
    return m;
}

function forkWithWaitOnSomeSelectedWorkers1() returns int|error {
    map<any> m = {};
    m["x"] = 0;
    m["y"] = 0;
    fork {
        @strand{thread:"any"}
        worker w1 {
            int a = 55;
            int b = 5;
            m["x"] = a;
            m["y"] = b;
        }
        @strand{thread:"any"}
        worker w2 {
            int a = 5;
            int b = 15;
            sleep(2000);
            m["x"] = a;
        }
        @strand{thread:"any"}
        worker w3 {
            int a = 0;
            int b = 15;
            sleep(1000);
            m["x"] = b;
        }
    }
    () results = wait w2 | w3;
    int j = <int>m["x"];
    int k = <int>m["y"];
    return j * k;
}

function forkWithWaitOnSomeSelectedWorkers2() returns map<any> {
    map<any> m = {};
    m["x"] = 0;
    fork {
        @strand{thread:"any"}
        worker w1 {
            int x = 80;
            x -> w2;
            x = <- w3;
            m["x"] = x;
            10 -> w2;
        }
        @strand{thread:"any"}
        worker w2 {
            int a = 0;
            a = <- w1;
            (a * 2) -> w3;
            a = <- w1;
            10 -> w3;
        }
        @strand{thread:"any"}
        worker w3 {
            int a = 0;
            a = <- w2;
            (a * 2) -> w1;
            a = <- w2;
        }
    }
    () results = wait w1| w2 | w3;
    return m;
}

function forkWithWaitOnSomeSelectedWorkers3() returns map<any> {
    map<any> m = {};
    m["x"] = 0;
    fork {
        @strand{thread:"any"}
        worker w1 {
            int x = 10;
            x -> w2;
            int a = 0;
            a = <- w3;
            (a * 2) -> w2;
        }
        @strand{thread:"any"}
        worker w2 {
            int a = 0;
            a = <- w1;
            (a * 2) -> w3;
            a = <- w1;
            m["x"] = a;
            (a * 2) -> w3;
            sleep(1000);
        }
        @strand{thread:"any"}
        worker w3 {
            int a = 0;
            a = <- w2;
            (a * 2) -> w1;
            m["x"] = <- w2;
        }
    }
    () results = wait w2 | w3;
    return m;
}

function forkWithWaitOnAllSelectedWorkers1() returns map<any> {
    map<any> m = {};
    m["x"] = 0;
    fork {
        @strand{thread:"any"}
        worker w1 {
            int x = 10;
            x -> w2;
            int a = 0;
            a = <- w3;
            (a * 2) -> w2;
        }
        @strand{thread:"any"}
        worker w2 {
            int a = 0;
            a = <- w1;
            (a * 2) -> w3;
            a = <- w1;
            m["x"] = a;
            (a * 2) -> w3;
            sleep(1000);
            m["x"] = 33;
        }
        @strand{thread:"any"}
        worker w3 {
            int a = 0;
            a = <- w2;
            (a * 2) -> w1;
            m["x"] = <- w2;
        }
    }
    map<any> results = wait {w2, w3};
    return m;
}

function timeoutFunction2(int milliSeconds) returns int {
    sleep(milliSeconds);
    return 777;
}

function forkWithWaitOnAllSelectedWorkers2() returns int {
    int result = 0;
    fork {
        @strand{thread:"any"}
        worker w1 {
            int x = 10;
            x -> w2;
            int a = 0;
            a = <- w3;
            (a * 2) -> w2;
        }
        @strand{thread:"any"}
        worker w2 {
            int a = 0;
            a = <- w1;
            (a * 2) -> w3;
            a = <- w1;
            result = a;
            (a * 2) -> w3;
            sleep(2000);
            result = 33;
        }
        @strand{thread:"any"}
        worker w3 {
            int a = 0;
            a = <- w2;
            (a * 2) -> w1;
            result = <- w2;
        }
    }
    @strand{thread:"any"}
    worker w4 returns int {
        map<any> results = wait {w2, w3};
        return result;
    }
    future<int> f = @strand{thread:"any"} start timeoutFunction2(1000);
    return checkpanic (wait w4 | f);
}

function forkWithMessagePassing() returns map<any>|error {
    map<any> m = {};
    fork {
        @strand{thread:"any"}
        worker w1 returns int {
            int a = 5;
            a -> w2;
            int b = 0;
            b = <- w2;
            return b;
        }
        @strand{thread:"any"}
        worker w2 returns int {
            int a = 0;
            a = <- w1;
            int b = 15;
            b -> w1;
            return a;
        }
    }
    map<any> results = wait {w1, w2};
    int b = <int>results["w1"];
    int a = <int>results["w2"];
    m["x"] = (a + 1) * b;
    return m;
}

function forkWithinWorkers() returns int|error {
    @strand{thread:"any"}
    worker wx returns int|error {
        int x = 20;
        map<any> m = {};
        fork {
            @strand{thread:"any"}
            worker wx1 {
                m["a"] = 10;
            }
            @strand{thread:"any"}
            worker wx2 {
                m["b"] = 20;
            }
        }
        map<any> results = wait {wx1, wx2};
        int a = <int>m["a"];
        int b = <int>m["b"];
        x = a + b;
        return x;
    }
    return wait wx;
}

function largeForkCreationTest() returns int|error {
    int result = 0;
    map<any> m = {};
    int c = 1000;
    while (c > 0) {
        m["x"] = 10;
        fork {
            @strand{thread:"any"}
            worker w1 {
                int a = 2;
                int b = 0;
                a -> w2;
                b = <- w10;
                m["x"] = result + b;
            }
            @strand{thread:"any"}
            worker w2 {
                int a = 0;
                int b = 3;
                a = <- w1;
                (a + b) -> w3;
            }
            @strand{thread:"any"}
            worker w3 {
                int a = 0;
                int b = 4;
                a = <- w2;
                (a + b) -> w4;
            }
            @strand{thread:"any"}
            worker w4 {
                int a = 0;
                int b = 5;
                a = <- w3;
                (a + b) -> w5;
            }
            @strand{thread:"any"}
            worker w5 {
                int a = 0;
                int b = 6;
                a = <- w4;
                (a + b) -> w6;
            }
            @strand{thread:"any"}
            worker w6 {
                int a = 0;
                int b = 7;
                a = <- w5;
                (a + b) -> w7;
            }
            @strand{thread:"any"}
            worker w7 {
                int a = 0;
                int b = 8;
                a = <- w6;
                (a + b) -> w8;
            }
            @strand{thread:"any"}
            worker w8 {
                int a = 0;
                int b = 9;
                a = <- w7;
                (a + b) -> w9;
            }
            @strand{thread:"any"}
            worker w9 {
                int a = 0;
                int b = 10;
                a = <- w8;
                (a + b) -> w10;
            }
            @strand{thread:"any"}
            worker w10 {
                int a = 0;
                int b = 11;
                a = <- w9;
                (a + b) -> w1;
            }
        }
        map<any> results = wait {w1, w2, w3, w4, w5, w6, w7, w8, w9, w10};
        result = <int>m["x"];
        c = c - 1;
    }
    return result;
}

type Foo record {
    int x = 0;
    string y = "";
};

function forkWithStruct() returns string|error {
    string result = "";
    fork {
        @strand{thread:"any"}
        worker w1 returns Foo {
            Foo f = {x: 1, y: "w1"};
            return f;
        }
        @strand{thread:"any"}
        worker w2 returns float {
            float f = 10.344;
            return f;
        }
    }
    map<any> results = wait {w1, w2};
    Foo f = <Foo>results["w1"];
    result = "[block] sW1: " + f.y;
    float fW2 = <float>results["w2"];
    result = result + "[block] fW2: " + fW2.toString();
    return result;
}

function forkWithSameWorkerContent() returns string|error {
    string result = "";
    fork {
        @strand{thread:"any"}
        worker w1 returns any[] {
            any[] a = [];
            return a;
        }
        @strand{thread:"any"}
        worker w2 returns any[] {
            any[] b = [];
            return b;
        }
    }
    map<any> results1 = wait {w1, w2};
    fork {
        @strand{thread:"any"}
        worker w3 returns string[] {
            string[] a = ["data1"];
            return a;
        }
        @strand{thread:"any"}
        worker w4 returns string[] {
            string[] a = ["data2"];
            return a;
        }
    }
    map<string[]> results2 = wait {w3, w4};
    string[]? resW1 = results2["w3"];
    string s1 = "";
    if resW1 is string[] {
        s1 = resW1[0];
    }
    result = "W3: " + s1;
    string[]? resW2 = results2["w4"];
    string s2 = "";
    if resW2 is string[] {
        s2 = resW2[0];
    }
    return result + ", W4: " + s2;
}

public function main() {
    map<any> messagePassing = checkpanic forkWithMessagePassing();
    io:println(messagePassing["x"]); // @output 90
    map<any> chained = chainedWorkerSendReceive();
    io:println(chained["x"]); // @output 12
    io:println(checkpanic forkWithWaitOnSomeSelectedWorkers1()); // @output 75
    map<any> selected2 = forkWithWaitOnSomeSelectedWorkers2();
    io:println(selected2["x"]); // @output 320
    map<any> selected3 = forkWithWaitOnSomeSelectedWorkers3();
    io:println(selected3["x"]); // @output 160
    map<any> all1 = forkWithWaitOnAllSelectedWorkers1();
    io:println(all1["x"]); // @output 33
    io:println(forkWithWaitOnAllSelectedWorkers2()); // @output 777
    io:println(checkpanic forkWithinWorkers()); // @output 30
    io:println(checkpanic largeForkCreationTest()); // @output 65000
    io:println(checkpanic forkWithStruct()); // @output [block] sW1: w1[block] fW2: 10.344
    io:println(checkpanic forkWithSameWorkerContent()); // @output W3: data1, W4: data2
}
