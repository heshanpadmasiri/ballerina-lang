import ballerina/io;

public function main() {
    io:println(getEmployee().name); // @output Sumedha
    io:println(getfromFuncA().name); // @output Sumedha
}
