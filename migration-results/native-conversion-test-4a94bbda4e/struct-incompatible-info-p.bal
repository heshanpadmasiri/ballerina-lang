type Info record {|
    map<anydata> foo;
|};

function trigger() {
    xml xml1 = xml `ballerina`;
    xml[] x = [xml1];
    map<anydata> m = {bar: x};
    Info info = {foo: m};
    var j = info.cloneWithType(json); // @panic
    if (j is json) {
        return;
    }
    panic j;
}

public function main() {
    trigger();
}
