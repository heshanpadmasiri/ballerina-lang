import ballerina/io;

public function main(int val, string s = "default", int i = 1, float j = 2.0, decimal k = 1e100, byte l = 34) {
    string result = "value : " + val.toString() + ", string arg : " + s + ", int arg : " + i.toString() +
        ", float arg : " + j.toString() + ", decimal arg : " + k.toString() + ", byte arg : " + l.toString();
    io:println(result); // @output value : 1, string arg : default, int arg : 1, float arg : 2.0, decimal arg : 1E+100, byte arg : 34
}

// @args ["1"]
