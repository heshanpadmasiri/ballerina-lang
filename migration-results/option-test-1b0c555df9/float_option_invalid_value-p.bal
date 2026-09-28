public type Student record {|
    float val;
|};

// @args ["--val=name"]
public function main(*Student student) { // @panic
}
