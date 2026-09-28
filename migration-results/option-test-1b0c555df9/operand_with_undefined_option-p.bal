public type Student record {|
    string name;
|};

// @args ["--na", "Riyafa", "--", "--Sri Lanka"]
public function main(string birth, *Student student) { // @panic
}
