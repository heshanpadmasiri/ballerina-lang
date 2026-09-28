public type Student record {|
    int[] array;
|};

// @args ["--array", "10", "--array", "arr-val"]
public function main(*Student student) { // @panic
}
