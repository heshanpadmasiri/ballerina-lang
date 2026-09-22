import ballerina/io;

type PersonQT record {|
    string firstName;
    string lastName;
    int age;
|};

type TeacherQT record {|
    string firstName;
    string lastName;
    int age;
    string teacherId;
|};

type EmployeeEntity record {
    int id;
    string fname;
    string lname;
    int age;
};

type EmployeeQT record {|
    string fname;
    string lname;
    int age;
|};

class NumberGenerator {
    int i = 0;

    public isolated function next() returns record {|int value;|}|error? {
        if self.i == 5 {
            return ();
        }
        self.i += 1;
        return {value: self.i};
    }
}

type ResultValue record {|
    PersonQT value;
|};

function getRecordValue((record {|PersonQT value;|}|error?)|(record {|PersonQT value;|}?) returnedVal) returns PersonQT? {
    if returnedVal is ResultValue {
        return returnedVal.value;
    }
    return ();
}

function testSimpleSelectQueryWithSimpleVariable() returns PersonQT[] {
    PersonQT[] personList = [
        {firstName: "Alex", lastName: "George", age: 23},
        {firstName: "Ranjan", lastName: "Fonseka", age: 30},
        {firstName: "John", lastName: "David", age: 33}
    ];
    PersonQT[] outputPersonList = from var person in personList
        select {firstName: person.firstName, lastName: person.lastName, age: person.age};
    return outputPersonList;
}

function testSimpleSelectQueryWithRecordVariable() returns PersonQT[] {
    PersonQT[] personList = [
        {firstName: "Alex", lastName: "George", age: 23},
        {firstName: "Ranjan", lastName: "Fonseka", age: 30},
        {firstName: "John", lastName: "David", age: 33}
    ];
    PersonQT[] outputPersonList = from var {firstName: nm1, lastName: nm2, age: a} in personList
        select {firstName: nm1, lastName: nm2, age: a};
    return outputPersonList;
}

function testSimpleSelectQueryWithRecordVariableV2() returns PersonQT[] {
    PersonQT[] personList = [
        {firstName: "Alex", lastName: "George", age: 23},
        {firstName: "Ranjan", lastName: "Fonseka", age: 30},
        {firstName: "John", lastName: "David", age: 33}
    ];
    var outputPersonList = from var {firstName, lastName, age} in personList
        select {firstName: firstName, lastName: lastName, age: age};
    return outputPersonList;
}

function testSimpleSelectQueryWithRecordVariableV3() returns PersonQT[] {
    TeacherQT[] teacherList = [
        {firstName: "Alex", lastName: "George", age: 23, teacherId: "XYZ01"},
        {firstName: "Ranjan", lastName: "Fonseka", age: 30, teacherId: "ABC01"},
        {firstName: "John", lastName: "David", age: 33, teacherId: "ABC10"}
    ];
    var outputPersonList = from var {firstName, lastName, age, teacherId} in teacherList
        select {firstName: firstName, lastName: lastName, age: age};
    return outputPersonList;
}

function testSimpleSelectQueryWithWhereClause() returns PersonQT[] {
    PersonQT[] personList = [
        {firstName: "Alex", lastName: "George", age: 23},
        {firstName: "Ranjan", lastName: "Fonseka", age: 30},
        {firstName: "John", lastName: "David", age: 33}
    ];
    var outputPersonList = from var person in personList
        where person.age >= 30
        select {firstName: person.firstName, lastName: person.lastName, age: person.age};
    return outputPersonList;
}

function testQueryExpressionForPrimitiveType() returns boolean {
    int[] intList = [12, 13, 14, 15, 20, 21, 25];
    var outputIntList = from var value in intList where value > 20 select value;
    return outputIntList == [21, 25];
}

function testQueryExpressionWithSelectExpression() returns boolean {
    int[] intList = [1, 2, 3];
    var stringOutput = from var value in intList select value.toString();
    return stringOutput == ["1", "2", "3"];
}

function testFilteringNullElements() returns PersonQT[] {
    PersonQT p1 = {firstName: "Alex", lastName: "George", age: 23};
    PersonQT p2 = {firstName: "Ranjan", lastName: "Fonseka", age: 30};
    PersonQT?[] personList = [p1, (), p2];
    var outputPersonList = from var person in personList
        where person is PersonQT
        select {firstName: person.firstName, lastName: person.lastName, age: person.age};
    return outputPersonList;
}

function testMapWithArity() returns boolean {
    map<any> m = {a: "1A", b: "2B", c: "3C", d: "4D"};
    var val = map from var v in m where <string>v == "1A" select ["a", v];
    return val == {a: "1A"};
}

function testJSONArrayWithArity() returns boolean {
    json[] jdata = [{name: "bob", age: 10}, {name: "tom", age: 16}];
    var val = from var v in jdata select <string>checkpanic v.name;
    return val == ["bob", "tom"];
}

function testArrayWithTuple() returns boolean {
    [int, string][] arr = [[1, "A"], [2, "B"], [3, "C"]];
    var val = from var [i, v] in arr where i == 3 select v;
    return val == ["C"];
}

function testQueryExpressionWithVarType() returns TeacherQT[] {
    PersonQT[] personList = [
        {firstName: "Alex", lastName: "George", age: 23},
        {firstName: "Ranjan", lastName: "Fonseka", age: 30},
        {firstName: "John", lastName: "David", age: 33}
    ];
    var outputPersonList = from var person in personList
        select {firstName: person.firstName, lastName: person.lastName, age: person.age, teacherId: "TER1200"};
    return outputPersonList;
}

function testSimpleSelectQueryWithSpreadOperator() returns PersonQT[] {
    PersonQT[] personList = [
        {firstName: "Alex", lastName: "George", age: 23},
        {firstName: "Ranjan", lastName: "Fonseka", age: 30},
        {firstName: "John", lastName: "David", age: 33}
    ];
    PersonQT[] outputPersonList = from var person in personList select {...person};
    return outputPersonList;
}

function testQueryExpressionWithSpreadOperatorV2() returns TeacherQT[] {
    PersonQT[] personList = [
        {firstName: "Alex", lastName: "George", age: 23},
        {firstName: "Ranjan", lastName: "Fonseka", age: 30},
        {firstName: "John", lastName: "David", age: 33}
    ];
    var outputPersonList = from var person in personList select {...person, teacherId: "TER1200"};
    return outputPersonList;
}

public function testQueryWithStream() returns boolean {
    NumberGenerator numGen = new;
    var numberStream = new stream<int, error?>(numGen);
    var oddNumberList = stream from var num in numberStream where num % 2 == 1 select num;
    int[] result = [];
    record {|int value;|}|error? v = oddNumberList.next();
    while v is record {|int value;|} {
        result.push(v.value);
        v = oddNumberList.next();
    }
    return result == [1, 3, 5];
}

function testSimpleSelectQueryReturnStream() returns boolean {
    PersonQT p1 = {firstName: "Alex", lastName: "George", age: 23};
    PersonQT p2 = {firstName: "Ranjan", lastName: "Fonseka", age: 30};
    PersonQT p3 = {firstName: "John", lastName: "David", age: 33};
    PersonQT[] personList = [p1, p2, p3];
    var outputPersonStream = stream from var person in personList
        select {firstName: person.firstName, lastName: person.lastName, age: person.age};
    boolean testPassed = true;
    PersonQT? returnedVal = getRecordValue(outputPersonStream.next());
    testPassed = testPassed && returnedVal is PersonQT && returnedVal == p1;
    returnedVal = getRecordValue(outputPersonStream.next());
    testPassed = testPassed && returnedVal is PersonQT && returnedVal == p2;
    returnedVal = getRecordValue(outputPersonStream.next());
    testPassed = testPassed && returnedVal is PersonQT && returnedVal == p3;
    return testPassed;
}

string fname = "";

function testVariableShadowingWithQueryExpressions1() returns boolean {
    EmployeeEntity[] entities = [
        {id: 1232, fname: "Sameera", lname: "Jayasoma", age: 30},
        {id: 1232, fname: "Asanthi", lname: "Kulasinghe", age: 30},
        {id: 1232, fname: "Khiana", lname: "Jayasoma", age: 2}
    ];
    EmployeeQT[] records = from var {fname, lname, age} in entities select {fname, lname, age};
    boolean testPassed = true;
    EmployeeQT e = records[0];
    testPassed = testPassed && e.fname == "Sameera" && e.lname == "Jayasoma" && e.age == 30;
    e = records[1];
    testPassed = testPassed && e.fname == "Asanthi" && e.lname == "Kulasinghe" && e.age == 30;
    e = records[2];
    testPassed = testPassed && e.fname == "Khiana" && e.lname == "Jayasoma" && e.age == 2;
    return testPassed;
}

function testVariableShadowingWithQueryExpressions2() returns boolean {
    EmployeeEntity[] entities = [
        {id: 1232, fname: "Sameera", lname: "Jayasoma", age: 30},
        {id: 1232, fname: "Asanthi", lname: "Kulasinghe", age: 30},
        {id: 1232, fname: "Khiana", lname: "Jayasoma", age: 2}
    ];
    EmployeeQT[] records = from var {fname, lname, age} in entities select {fname, lname, age};
    var lname = 5;
    boolean testPassed = true;
    EmployeeQT e = records[0];
    testPassed = testPassed && e.fname == "Sameera" && e.lname == "Jayasoma" && e.age == 30;
    e = records[1];
    testPassed = testPassed && e.fname == "Asanthi" && e.lname == "Kulasinghe" && e.age == 30;
    e = records[2];
    testPassed = testPassed && e.fname == "Khiana" && e.lname == "Jayasoma" && e.age == 2;
    testPassed = testPassed && lname == 5;
    return testPassed;
}

type Student record {
    readonly string name;
    int id;
};

function testSimpleSelectQueryWithTable() {
    table<Student> key(name) t = table [{name: "Amy", id: 1234}, {name: "John", id: 4567}];
    var ids = from var {id} in t select {id};
    table<record {|int id;|}> t2 = ids;
    assertEquality(2, ids.length());
    assertEquality((table [{"id":1234},{"id":4567}]).toString(), t2.toString());
}

type UserQuery record {
    readonly int id;
    string firstName;
    string lastName;
    int age;
};

function testQueryConstructingTableWithVar() returns error? {
    UserQuery u1 = {id: 1, firstName: "John", lastName: "Doe", age: 25};
    UserQuery u2 = {id: 2, firstName: "Anne", lastName: "Frank", age: 30};
    table<UserQuery> key(id) users = table [];
    users.add(u1);
    users.add(u2);
    var result1 = table key(user) from var user in users
        where user.age > 21 && user.age < 60
        select {user};
    assertEquality(true, result1 is table<record {| UserQuery user; |}> key(user));
    assertEquality({"user": u1}, result1.get(u1));
    UserQuery[] userList = [u1, u2];
    var result2 = table key(user) from var user in userList
        where user.age > 21 && user.age < 60
        select {user};
    assertEquality(true, result2 is table<record {| UserQuery user; |}> key(user));
    assertEquality({"user": u1}, result2.get(u1));
}

type ScoreEvent readonly & record {|
    string email;
    string problemId;
    float score;
|};

type Team readonly & record {|
    string user;
    int teamId;
|};

ScoreEvent[] events = [
    {email: "jake@abc.com", problemId: "12", score: 80.0},
    {email: "anne@abc.com", problemId: "20", score: 95.0},
    {email: "peter@abc.com", problemId: "3", score: 72.0}
];
Team[] team = [
    {user: "jake@abc.com", teamId: 1},
    {user: "anne@abc.com", teamId: 2},
    {user: "peter@abc.com", teamId: 2}
];

function testUsingDestructuringRecordingBindingPatternWithAnIntersectionTypeInFromClause() {
    json j = from var {email, problemId, score} in events where score > 85.5 select {email, score};
    assertEquality([{email: "anne@abc.com", score: 95.0}], j);
    j = from var {email: em, problemId: pi, score: sc} in events where sc < 80.0 select {em, sc};
    assertEquality([{em: "peter@abc.com", sc: 72.0}], j);
}

function testUsingDestructuringRecordingBindingPatternWithAnIntersectionTypeInJoinClause() {
    json j = from var {email, problemId, score} in events
        join var {user, teamId} in team on email equals user
        where teamId == 2 && score > 85.5 select {email, score};
    assertEquality([{email: "anne@abc.com", score: 95.0}], j);
    j = from var {email: em, problemId: pi, score: sc} in events
        join var {user: us, teamId: ti} in team on em equals us
        where sc < 80.0 select {ti, sc};
    assertEquality([{ti: 2, sc: 72.0}], j);
}

function testUsingAnIntersectionTypeInQueryExpr() {
    json j = from var ev in events where ev.score < 80.0 select {email: ev.email, score: ev.score};
    assertEquality([{email: "peter@abc.com", score: 72.0}], j);
    j = from var ev in events
        join var tm in team on ev.email equals tm.user
        where ev.score < 80.0 select {email: ev.email, teamId: tm.teamId};
    assertEquality([{email: "peter@abc.com", teamId: 2}], j);
}

type ScoreEventType ScoreEvent;
type TeamType Team;
ScoreEventType[] events2 = events;
TeamType[] team2 = team;

function testUsingDestructuringRecordingBindingPatternWithAnIntersectionTypeInFromClause2() {
    json j = from var {email, problemId, score} in events2 where score > 85.5 select {email, score};
    assertEquality([{email: "anne@abc.com", score: 95.0}], j);
    j = from var {email: em, problemId: pi, score: sc} in events2 where sc < 80.0 select {em, sc};
    assertEquality([{em: "peter@abc.com", sc: 72.0}], j);
}

function testUsingDestructuringRecordingBindingPatternWithAnIntersectionTypeInJoinClause2() {
    json j = from var {email, problemId, score} in events2
        join var {user, teamId} in team2 on email equals user
        where teamId == 2 && score > 85.5 select {email, score};
    assertEquality([{email: "anne@abc.com", score: 95.0}], j);
    j = from var {email: em, problemId: pi, score: sc} in events2
        join var {user: us, teamId: ti} in team2 on em equals us
        where sc < 80.0 select {ti, sc};
    assertEquality([{ti: 2, sc: 72.0}], j);
}

function testUsingAnIntersectionTypeInQueryExpr2() {
    json j = from var ev in events2 where ev.score < 80.0 select {email: ev.email, score: ev.score};
    assertEquality([{email: "peter@abc.com", score: 72.0}], j);
    j = from var ev in events2
        join var tm in team2 on ev.email equals tm.user
        where ev.score < 80.0 select {email: ev.email, teamId: tm.teamId};
    assertEquality([{email: "peter@abc.com", teamId: 2}], j);
}

function testMethodCallExprsOnQueryExprs() {
    string[] words = ["a", "b", "c"];
    var len = (from string str in words select str).length();
    assertEquality(3, len);
    len = (from string str in words where str == "a" select str).length();
    assertEquality(1, len);
    string word = (from string str in words select str).pop();
    assertEquality("c", word);
    int? index = (from string str in words select str).indexOf("b");
    assertEquality(1, index);
    boolean isReadonly = (from string str in words select str).isReadOnly();
    assertEquality(false, isReadonly);
    word = (from string str in words select str).remove(0);
    assertEquality("a", word);
    words = (from string str in words select str).filter(w => w is string);
    assertEquality(["a", "b", "c"], words);
    words = (from string str in words select str).reverse();
    assertEquality(["c", "b", "a"], words);
}

function assertEquality(anydata expected, anydata actual) {
    if expected == actual {
        return;
    }
    panic error("expected '" + expected.toString() + "', found '" + actual.toString() + "'");
}

public function main() {
    PersonQT[] simple = testSimpleSelectQueryWithSimpleVariable();
    io:println(simple.length()); // @output 3
    io:println(simple[0].firstName); // @output Alex
    io:println(simple[1].lastName); // @output Fonseka
    io:println(simple[2].age); // @output 33

    PersonQT[] recordResult = testSimpleSelectQueryWithRecordVariable();
    io:println(recordResult[0].firstName); // @output Alex
    io:println(recordResult[1].lastName); // @output Fonseka
    io:println(recordResult[2].age); // @output 33

    PersonQT[] recordV2 = testSimpleSelectQueryWithRecordVariableV2();
    io:println(recordV2[0].firstName); // @output Alex
    io:println(recordV2[1].lastName); // @output Fonseka
    io:println(recordV2[2].age); // @output 33

    PersonQT[] recordV3 = testSimpleSelectQueryWithRecordVariableV3();
    io:println(recordV3[0].firstName); // @output Alex
    io:println(recordV3[1].lastName); // @output Fonseka
    io:println(recordV3[2].age); // @output 33

    PersonQT[] filtered = testSimpleSelectQueryWithWhereClause();
    io:println(filtered[0].firstName); // @output Ranjan
    io:println(filtered[1].firstName); // @output John
    io:println(filtered[0].age); // @output 30
    io:println(filtered[1].age); // @output 33

    io:println(testQueryExpressionForPrimitiveType()); // @output true
    io:println(testQueryExpressionWithSelectExpression()); // @output true

    PersonQT[] nonNull = testFilteringNullElements();
    io:println(nonNull[0].firstName); // @output Alex
    io:println(nonNull[0].age); // @output 23
    io:println(nonNull[1].firstName); // @output Ranjan
    io:println(nonNull[1].age); // @output 30

    io:println(testMapWithArity()); // @output true
    io:println(testJSONArrayWithArity()); // @output true
    io:println(testArrayWithTuple()); // @output true

    TeacherQT[] varType = testQueryExpressionWithVarType();
    io:println(varType[0].firstName); // @output Alex
    io:println(varType[1].lastName); // @output Fonseka
    io:println(varType[2].age); // @output 33
    io:println(varType[2].teacherId); // @output TER1200

    PersonQT[] spread = testSimpleSelectQueryWithSpreadOperator();
    io:println(spread.length()); // @output 3
    io:println(spread[0].firstName); // @output Alex
    io:println(spread[1].lastName); // @output Fonseka
    io:println(spread[2].age); // @output 33

    TeacherQT[] spreadV2 = testQueryExpressionWithSpreadOperatorV2();
    io:println(spreadV2[0].firstName); // @output Alex
    io:println(spreadV2[1].lastName); // @output Fonseka
    io:println(spreadV2[2].age); // @output 33
    io:println(spreadV2[2].teacherId); // @output TER1200

    io:println(testQueryWithStream()); // @output true
    io:println(testSimpleSelectQueryReturnStream()); // @output true
    io:println(testVariableShadowingWithQueryExpressions1()); // @output true
    io:println(testVariableShadowingWithQueryExpressions2()); // @output true

    testSimpleSelectQueryWithTable();
    error? ignored = testQueryConstructingTableWithVar();
    testMethodCallExprsOnQueryExprs();
    testUsingDestructuringRecordingBindingPatternWithAnIntersectionTypeInFromClause();
    testUsingDestructuringRecordingBindingPatternWithAnIntersectionTypeInJoinClause();
    testUsingAnIntersectionTypeInQueryExpr();
    testUsingDestructuringRecordingBindingPatternWithAnIntersectionTypeInFromClause2();
    testUsingDestructuringRecordingBindingPatternWithAnIntersectionTypeInJoinClause2();
    testUsingAnIntersectionTypeInQueryExpr2();
}
