import ballerina/io;

@Greeting {
    salutation: "Hey🧑🏿‍✈️"
}
type MyRecord record {

};

public function testAnnotation() returns int {
    MyRecord rec = {};
    typedesc<any> t = typeof rec;
    return t.@Greeting?.salutation.toString().length();
}

public type HelloConfiguration record {|
    string salutation = "Hello!";
|};

public annotation HelloConfiguration Greeting on type;

public function main() {
    io:println(testAnnotation()); // @output 8
}
