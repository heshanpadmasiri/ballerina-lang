public type Student record {|
    boolean booleanVal;
|};

// @args ["--booleanVal", "--booleanVal"]
public function main(*Student student) { // @panic
}
