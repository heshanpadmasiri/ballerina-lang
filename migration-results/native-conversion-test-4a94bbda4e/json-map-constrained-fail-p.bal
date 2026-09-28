type T1 record {|
    int x = 0;
    int y = 0;
|};
type T1Map map<T1>;

function trigger() {
    json j = {a: {x: 5, y: "non-convertible"}};
    var result = j.cloneWithType(T1Map); // @panic
    if (result is map<T1>) {
        return;
    }
    panic result;
}

public function main() {
    trigger();
}
