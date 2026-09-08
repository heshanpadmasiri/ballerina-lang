type ClosedPerson record {|
    string name = "";
    int age = 0;
    ClosedAddress address = {};
|};

type ClosedAddress record {|
    string street = "";
    string city = "";
|};

type ClosedGrades record {|
    int maths = 0;
    int physics = 0;
    int chemistry = 0;
|};

ClosedPerson p = {name: "John Doe", age: 25, address: {street: "Palm Grove", city: "Colombo 3"}};

function testInvalidArgForForeachWithClosedRecords() {
    any[] vals = [];
    int i = 0;
    foreach var [k, val, e] in p { // @error
        vals[i] = val;
        i += 1;
    }
}

function testInvalidForeachOpWithClosedRecords() {
    p.forEach(function ([string, any] entry) { // @error
    });
}

function testInvalidMapOpWithClosedRecords() {
    map<any> newp = p.'map(function ([string, any] entry) returns [string, any] { // @error
        return ["", ""];
    });
    newp = p.'map(function ([string, any] entry) returns any { // @error
        return "";
    });
    newp = p.'map(function ([string, any] entry) returns [string, any, string] { // @error
        return ["", "", ""];
    });
    ClosedPerson invMap = p.'map(function ([string, any] entry) returns [string, any] { // @error // @error
        return ["", ""];
    });
}

function testInvalidFilterOpWithClosedRecords() {
    map<any> newp = p.filter(function ([string, any] entry) returns boolean { // @error
        return true;
    });
    newp = p.filter(function ([string, any] entry) returns string { // @error
        return "";
    });
    ClosedPerson invFil = p.filter(function ([string, any] entry) returns boolean { // @error // @error
        return false;
    });
}

function testInvalidChainedItrOpReturns() {
    ClosedGrades f = {maths: 80, physics: 75, chemistry: 65};
    map<int> m = f.'map(function ([string, int] entry) returns [string, int] { // @error // @error
        var [subj, grade] = entry;
        return [subj, grade + 10];
    }).'map(function ([string, int] entry) returns [string, string] {
        var [s, g] = entry;
        if g > 75 {
            return [s, "PASS"];
        }
        return [s, "FAIL"];
    }).filter(function ([string, string] entry) returns boolean {
        var [s, status] = entry;
        return status == "PASS";
    }).'map(function ([string, string] entry) returns [string, float] {
        var [s, status] = entry;
        return status == "PASS" ? [s, 4.2] : [s, 0.0];
    });
}

function testInvalidChainedItrOpReturns2() {
    ClosedGrades f = {maths: 80, physics: 75, chemistry: 65};
    int[] ar = f.'map(function ([string, int] value) returns int { // @error
        return value[1] + 10;
    }).'map(function (int grade) returns string {
        return grade > 75 ? "PASS" : "FAIL";
    }).filter(function (string status) returns boolean {
        return status == "PASS";
    }).'map(function (string status) returns float {
        return status == "PASS" ? 4.2 : 0.0;
    }); // @error
}
