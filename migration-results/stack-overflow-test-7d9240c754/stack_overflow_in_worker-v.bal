function stackOverflowInWorker() {
    @strand{thread:"any"}
    worker w1 returns int {
        return getInt();
    }

    @strand{thread:"any"}
    worker w2 returns int {
        return 10;
    }
}

function getInt() returns int {
    return getInt();
}

public function main() {
    stackOverflowInWorker();
}
