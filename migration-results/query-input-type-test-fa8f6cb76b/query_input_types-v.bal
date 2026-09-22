// Copyright (c) 2025 WSO2 LLC. (http://www.wso2.org)
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.

import ballerina/io;

public type MyRecord record {
    int id;
    string name;
};

public function testArrayQuery() {
    int[] arr = [1, 2, 3];
    int[] result = from var item in arr
                   select item;

    io:println(result.length()); // @output 3
    io:println(result[0]); // @output 1
    io:println(result[1]); // @output 2
    io:println(result[2]); // @output 3
}

public function testMapQuery() {
    map<int> m = {"key1": 1, "key2": 2, "key3": 3};
    int[] result = from int i in m
                   select i;

    io:println(result.length()); // @output 3
    io:println(result[0] == 1); // @output true
    io:println(result[1] == 2); // @output true
    io:println(result[2] == 3); // @output true
}

public function testRecordQuery() {
    MyRecord[] records = [
        {id: 1, name: "record1"},
        {id: 2, name: "record2"}
    ];
    MyRecord[] result = from var rec in records
                        select rec;

    io:println(result.length()); // @output 2
    io:println(result[0].id); // @output 1
    io:println(result[0].name); // @output record1
    io:println(result[1].id); // @output 2
    io:println(result[1].name); // @output record2
}

public function testStringQuery() {
    string str = "Ballerina";
    string[] result = from var ch in str
                      select ch.toString();

    io:println(result.length()); // @output 9
    io:println(result[0]); // @output B
    io:println(result[1]); // @output a
    io:println(result[8]); // @output a
}

public function main() {
    testArrayQuery();
    testMapQuery();
    testRecordQuery();
    testStringQuery();
}
