public type Student record {|
    string val;
|};

// @args ["--val", "--name"]
public function main(*Student student) { // @panic
}
