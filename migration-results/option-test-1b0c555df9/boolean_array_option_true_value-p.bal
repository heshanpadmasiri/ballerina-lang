public type Student record {|
    boolean[] array;
|};

// @args ["--array=true"]
public function main(*Student student) { // @panic
}
