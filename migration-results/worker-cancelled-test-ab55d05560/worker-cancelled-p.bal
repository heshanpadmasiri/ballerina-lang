import ballerina/lang.runtime;

public function main() {
    workerCancelledBeforeSend();
}

// A send to a worker cancelled while it was waiting to receive must panic.
function workerCancelledBeforeSend() {
    worker wy {
        string _ = <- function;
        "message" -> function;
    }
    wy.cancel();
    runtime:sleep(0.005);
    "message" -> wy; // @panic
    string|error result = <- wy;
    if result is string {
        return;
    }
}
