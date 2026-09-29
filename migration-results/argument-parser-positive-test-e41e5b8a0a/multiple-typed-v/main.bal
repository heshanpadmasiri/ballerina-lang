import ballerina/io;

public function main(int i, float f, string s, string... args) {
    string restArgs = "";
    foreach string str in args {
        restArgs += str + " ";
    }
    io:println("integer: " + i.toHexString() + ", float: " + f.toString() + ", string: " + s +
        ", string rest args: " + restArgs); // @output integer: 3e8, float: 1.0, string: Hello Ballerina, string rest args: 255 true <book>Harry Potter</book> just the rest 
}

// @args ["1000", "1.0", "Hello Ballerina", "255", "true", "<book>Harry Potter</book>", "just", "the", "rest"]
