public type Student record {|
    boolean bool;
|};

// @args ["--bool=false"]
public function main(*Student student) { // @panic
}
