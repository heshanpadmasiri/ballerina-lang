public type Student record {|
    boolean[] array;
|};

// @args ["--array=false"]
public function main(*Student student) { // @panic
}
