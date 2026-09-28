public type Student record {|
    decimal val;
|};

// @args ["--val=99999999.9e9999999999"]
public function main(*Student student) { // @panic
}
