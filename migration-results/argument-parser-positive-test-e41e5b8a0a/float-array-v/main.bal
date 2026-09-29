import ballerina/io;

public function main(float[] floatArr) {
    io:println("float: " + floatArr.toString()); // @output float: [1.0,200.0,3.0,1.0,20.4,30.3]
}

// @args ["1", "200", "3", "1.0", "20.4", "30.3"]
