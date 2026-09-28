public type Student record {|
    int val;
|};

// @args ["--val=name"]
public function main(*Student student) { // @panic
}
