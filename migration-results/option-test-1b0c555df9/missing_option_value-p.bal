public type Student record {|
    string val;
|};

// @args ["--val"]
public function main(*Student student) { // @panic
}
