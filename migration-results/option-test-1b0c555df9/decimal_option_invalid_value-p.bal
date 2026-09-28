public type Student record {|
    decimal val;
|};

// @args ["--val=name"]
public function main(*Student student) { // @panic
}
