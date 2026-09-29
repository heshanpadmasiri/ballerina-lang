import ballerina/io;

public function main(string? s) {
    string stringToPrint = "string value: ";
    if s is string {
        stringToPrint += s;
    } else {
        stringToPrint += "s is nil";
    }
    io:println(stringToPrint); // @output string value: hello world
}

// @args ["hello world"]
