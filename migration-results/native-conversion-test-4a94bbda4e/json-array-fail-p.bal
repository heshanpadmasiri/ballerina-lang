type IntArrayType int[];

function trigger() {
    json j = {x: 1, y: 1.5};
    var result = j.cloneWithType(IntArrayType); // @panic
    if (result is int[]) {
        return;
    }
    panic result;
}

public function main() {
    trigger();
}
