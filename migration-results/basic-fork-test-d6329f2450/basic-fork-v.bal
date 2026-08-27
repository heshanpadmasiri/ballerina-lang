import ballerina/io;

public function main() {
    sendToFork();
    forkInWorker();
}

function sendToFork() {
    fork {
        @strand {thread: "any"}
        worker w1 {
            int i = 23;
            i -> w2;
        }
        @strand {thread: "any"}
        worker w2 {
            int j = <-w1;
            io:println(j + 1); // @output 24
        }
    }
    wait w2;
}

function forkInWorker() {
    worker wx {
        fork {
            @strand {thread: "any"}
            worker w1 {
                int i = 86;
                i -> w2;
            }
            @strand {thread: "any"}
            worker w2 {
                int j = <-w1;
                io:println(j + 1); // @output 87
            }
        }
        wait w2;
    }
    wait wx;
}
