// Copyright (c) 2022 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

isolated function testNonIsolatedNamedWorkerInIsolatedFunc(string msg) {
    _ = f2();
    worker sampleWorker1 {
        f1(msg); // @error
    }
}

function f1(string m) {
}

isolated function f2() {
}

int intVal = 12;

isolated function testNonIsolatedNamedWorkerInIsolatedFunc2() {
    _ = f2();
    worker sampleWorker1 {
        int _ = intVal; // @error
    }
}

int[] arr = [];

isolated function testNonIsolatedNamedWorkerInIsolatedFunc3() {
    _ = f2();
    worker sampleWorker1 {
        arr = [0, 1]; // @error
    }
}

isolated function testNonIsolatedNamedWorkerInIsolatedFunc4() {
    _ = f2();
    int a = 12;
    worker sampleWorker1 {
        int _ = a; // @error
    }
}

isolated function testNonIsolatedNamedWorkerInIsolatedFunc5() {
    _ = f2();
    worker sampleWorker1 {
        fork {
            worker A returns int {
                return intVal; // @error
            }
        }
    }
}

isolated function testNonIsolatedNamedWorkerInIsolatedFunc6() {
    _ = f2();
    worker sampleWorker1 {
        future<()> _ = start f1(""); // @error
    }
}

isolated function testNonIsolatedNamedWorkerInIsolatedFunc7() {
    _ = f2();
    worker sampleWorker1 {
        future<()> _ = start f3(arr); // @error
    }
}

isolated function f3(int[] a) {
}

isolated function testNamedWorkerWithStrandAnnotInIsolatedFunc() {
    @strand{thread:"parent"} // @error
    worker sampleWorker1 {
    }
}

isolated function testNamedWorkerWithStrandAnnotInIsolatedFunc2() {
    fork {
        @strand {thread: "parent"} // @error
        worker sampleWorker1 {
        }

        @strand {thread: "any"} // @error
        worker sampleWorker2 {
        }
    }
}

int[] intArr = [];

function f4(int[] b) returns int {
    return b[0];
}

function testInvalidWorkersInIsolatedResourceFunctions() {
    var _ = service object {
        isolated resource function get foo() returns int[] {
            int[] a = [];
            future<int> _ = start f4(intArr); // @error

            worker A {
                future<int> _ = start f4(a); // @error
                int[] _ = intArr; // @error
            }

            future<int> _ = start f4(a); // @error

            fork {
                worker B {
                    future<int> _ = start f4(intArr); // @error
                    int[] _ = a; // @error
                }

                worker C {
                    future<int> _ = start f4(a); // @error
                    int[] _ = a; // @error
                }
            }

            return intArr; // @error
        }

        isolated remote function bar() returns int[] {
            int[] a = [];
            future<int> _ = start f4(intArr); // @error

            worker A {
                future<int> _ = start f4(a); // @error
                int[] _ = intArr; // @error
            }

            future<int> _ = start f4(a); // @error

            fork {
                worker B {
                    future<int> _ = start f4(intArr); // @error
                    int[] _ = a; // @error
                }

                worker C {
                    future<int> _ = start f4(a); // @error
                    int[] _ = a; // @error
                }
            }

            return intArr; // @error
        }

        isolated function bam() returns int[] {
            int[] a = [];
            future<int> _ = start f4(intArr); // @error

            worker A {
                future<int> _ = start f4(a); // @error
                int[] _ = intArr; // @error
            }

            future<int> _ = start f4(a); // @error

            fork {
                worker B {
                    future<int> _ = start f4(intArr); // @error
                    int[] _ = a; // @error
                }

                worker C {
                    future<int> _ = start f4(a); // @error
                    int[] _ = a; // @error
                }
            }

            return intArr; // @error
        }
    };
}

listener Listener ep = new ();

service /doSomething/here on ep {
    isolated resource function get foo() returns int[] {
        int[] a = [];
        future<int> _ = start f4(intArr); // @error

        worker A {
            future<int> _ = start f4(a); // @error
            int[] _ = intArr; // @error
        }

        future<int> _ = start f4(a); // @error

        fork {
            worker B {
                future<int> _ = start f4(intArr); // @error
                int[] _ = a; // @error
            }

            worker C {
                future<int> _ = start f4(a); // @error
                int[] _ = a; // @error
            }
        }

        return intArr; // @error
    }

    isolated remote function bar() returns int[] {
        int[] a = [];
        future<int> _ = start f4(intArr); // @error

        worker A {
            future<int> _ = start f4(a); // @error
            int[] _ = intArr; // @error
        }

        future<int> _ = start f4(a); // @error

        fork {
            worker B {
                future<int> _ = start f4(intArr); // @error
                int[] _ = a; // @error
            }

            worker C {
                future<int> _ = start f4(a); // @error
                int[] _ = a; // @error
            }
        }

        return intArr; // @error
    }

    isolated function bam() returns int[] {
        int[] a = [];
        future<int> _ = start f4(intArr); // @error

        worker A {
            future<int> _ = start f4(a); // @error
            int[] _ = intArr; // @error
        }

        future<int> _ = start f4(a); // @error

        fork {
            worker B {
                future<int> _ = start f4(intArr); // @error
                int[] _ = a; // @error
            }

            worker C {
                future<int> _ = start f4(a); // @error
                int[] _ = a; // @error
            }
        }

        return intArr; // @error
    }
}

class Listener {
    public function attach(service object {} s, string[]|string? name = ()) returns error? {
    }

    public function detach(service object {} s) returns error? {
    }

    public function 'start() returns error? {
    }

    public function gracefulStop() returns error? {
    }

    public function immediateStop() returns error? {
    }
}
