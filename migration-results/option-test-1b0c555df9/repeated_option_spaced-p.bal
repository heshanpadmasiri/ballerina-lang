public type Student record {|
    string stringVal;
|};

// @args ["--stringVal", "val1", "--stringVal", "val2"]
public function main(*Student student) { // @panic
}
