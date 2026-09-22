import ballerina/io;

public enum Status {
    OPEN,
    CLOSED,
    HOLD
}

public type LiftRecord record {|
    readonly string id;
    string name;
    Status status;
    int capacity;
    boolean night;
    int elevationgain;
|};

public table<LiftRecord> key(id) liftTable = table [
    {id: "astra-express", name: "Astra Express", status: OPEN, capacity: 10, night: false, elevationgain: 20},
    {id: "jazz-cat", name: "Jazz Cat", status: CLOSED, capacity: 5, night: true, elevationgain: 30},
    {id: "jolly-roger", name: "Jolly Roger", status: CLOSED, capacity: 8, night: true, elevationgain: 10}
];

public function main() returns error? {
    testQueryExprWithinTypeGuard();
    testQueryExprWithinNegatedTypeGuard();
    testTernaryWithinQueryExpression();
    check testTypeNarrowing();
}

public function testQueryExprWithinTypeGuard() {
    Status? status = OPEN;
    LiftRecord[] lifts = [];
    if status is Status {
        lifts = from var lift in liftTable where lift.status == status select lift;
    }
    assertEquality(1, lifts.length());
    io:println(lifts.length()); // @output 1
    assertEquality(lifts[0].id, "astra-express");
    io:println(lifts[0].id); // @output astra-express
}

function testQueryExprWithinNegatedTypeGuard() {
    assertEquality("hellllo", merge(["h", "e", "l", "l", "o"]));
    io:println(merge(["h", "e", "l", "l", "o"])); // @output hellllo
}

function merge(string[]? tokens) returns string {
    if !(tokens is ()) {
        string s = from var t in tokens
            join var t1 in tokens
            on t equals t1 select t;
        return s;
    }
    return "";
}

type Label record {
    string name;
};

type Data record {
    Label[]? labels;
};

function testTernaryWithinQueryExpression() {
    Label label1 = {name: "A"};
    Label[] labelList = [label1, {name: "B"}];
    Data[] data1 = [{labels: ()}];
    Data[] data2 = [{labels: labelList}];
    Data data3 = {labels: [{name: "John Doe"}]};

    Label[] res1 = getFirstOrDefaultLabel(data2);
    Data[] res2 = filterNonEmtyData(data1);
    Data[] res3 = filterNonEmtyData(data2);
    Data[] res4 = filterCommonLabels(data2);

    assertEquality(label1, res1[0]);
    io:println(res1[0]); // @output {"name":"A"}
    assertEquality(data3, res2[0]);
    io:println(res2[0]); // @output {"labels":[{"name":"John Doe"}]}
    assertEquality(data2, res3);
    io:println(res3); // @output [{"labels":[{"name":"A"},{"name":"B"}]}]
    assertEquality(data2, res4);
    io:println(res4); // @output [{"labels":[{"name":"A"},{"name":"B"}]}]
}

function getFirstOrDefaultLabel(Data[] data) returns Label[] {
    Label[] labelList = from Data d in data
        let Label[]? l = d.labels
        select (l != () ? l[0] : {name: "John Doe"});
    return labelList;
}

function filterNonEmtyData(Data[] dataList) returns Data[] {
    Data[] newData = from Data d in dataList
        select {
            labels: let Label[]? l = d.labels
                in (l != () ? from Label nl in l
                    select {name: nl.name} : [{name: "John Doe"}])
        };
    return newData;
}

function filterCommonLabels(Data[] dataList) returns Data[] {
    string[] strArr = ["A", "B", "C"];
    Data[] newData = from Data d in dataList
        select {
            labels: let Label[]? l = d.labels
                in (l != () ? from string str in strArr
                    join Label nl in l on str equals nl.name
                    select {name: nl.name} : [{name: "John Doe"}])
        };
    return newData;
}

type IntOrStr int|string;

function testTypeNarrowing() returns error? {
    IntOrStr[] data1 = [1, 2, 3, 4, "5"];

    int[] res1 = from IntOrStr i in data1
        where i is int
        select i * 2;
    int[] expectedRes1 = [2, 4, 6, 8];
    assertEquality(expectedRes1, res1);
    io:println(res1); // @output [2,4,6,8]

    string[] res2 = from IntOrStr i in data1
        where i !is int
        select i;
    string[] expectedRes2 = ["5"];
    assertEquality(expectedRes2, res2);
    io:println(res2); // @output ["5"]

    int[] res3 = [];
    int[] expectedRes3 = [1, 2, 3, 4];
    from IntOrStr i in data1
    where i is int
    do {
        res3.push(i);
    };
    assertEquality(expectedRes3, res3);
    io:println(res3); // @output [1,2,3,4]

    string[] res4 = [];
    string[] expectedRes4 = ["5"];
    from IntOrStr i in data1
    where i !is int
    do {
        res4.push(i);
    };
    assertEquality(expectedRes4, res4);
    io:println(res4); // @output ["5"]

    (int|string)[] arr = [1, 2, 3, 4];
    int[] evenNums = [];
    from int|string item in arr
    where item is int && item % 2 == 0
    let int evenNum = item
    do {
        evenNums.push(evenNum);
    };
    int[] expectedEvenNums = [2, 4];
    assertEquality(expectedEvenNums, evenNums);
    io:println(evenNums); // @output [2,4]
}

const ASSERTION_ERROR_REASON = "AssertionError";

function assertEquality(any|error expected, any|error actual) {
    if expected is anydata && actual is anydata && expected == actual {
        return;
    }

    if expected === actual {
        return;
    }

    string expectedValAsString = expected is error ? expected.toString() : expected.toString();
    string actualValAsString = actual is error ? actual.toString() : actual.toString();
    panic error(ASSERTION_ERROR_REASON,
        message = "expected '" + expectedValAsString + "', found '" + actualValAsString + "'");
}
