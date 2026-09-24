function testWorkerInsideLock() {
    lock {
        fork {
            worker w1 { // @error
                int _ = 5;
            }
        }
    }
}

function testStartInsideLock() {
    lock {
        _ = start testFunction(); // @error
    }
}

function testFunction() {
    int _ = 1;
}


function testWorkerInsideLockDepth3() {
    lock {
        fork {
            worker w1 { // @error
                fork {
                    worker w2 { // @error
                        int _ = 5;
                    }
                }
            }
        }
    }
}

function testWorkerInsideNestedLocks() {
    lock {
        lock {
            int _ = 10;
        }
        fork {
            worker w1 { // @error
                int _ = 15;
            }
        }
    }
}
