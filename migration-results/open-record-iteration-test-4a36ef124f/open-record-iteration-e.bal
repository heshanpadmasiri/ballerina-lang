type Person record { string name; int age; Address address; };
type Address record { string street; string city; };

Person p = {name: "John Doe", age: 25, address: {street: "Palm Grove", city: "Colombo 3"}, "profession": "Software Engineer"};

function testInvalidArgForForeachWithOpenRecords() {
    any[] vals = [];
    int i = 0;
    foreach var [key, value, extra] in p { // @error
        vals[i] = value;
        i += 1;
    }
}

function testInvalidForeachOpWithOpenRecords() {
    p.forEach(function ([string, any] entry) { // @error
    });
    p.forEach(function (string|int|Address entry) { // @error
    });
    p.forEach(function (any entry) {
    });
}

function testInvalidMapOpWithOpenRecords() {
    map<any> newp = p.'map(function ([string, any] entry) returns [string, any] { // @error
        return ["", ""];
    });
    newp = p.'map(function (anydata entry) returns any {
        return "";
    });
    newp = p.'map(function (anydata entry) returns any|error { // @error
        return "";
    });
    newp = p.'map(function (anydata entry) returns string|int|Address {
        return "";
    });
    Person invMap = p.'map(function (anydata entry) returns anydata { // @error
        return "";
    });
}

function testInvalidFilterOpWithOpenRecords() {
    map<any> newp = p.filter(function ([string, any] entry) returns boolean { // @error
        return true;
    });
    newp = p.filter(function (anydata entry) returns boolean {
        return true;
    });
    newp = p.filter(function (anydata entry) returns string { // @error
        return "";
    });
    newp = p.filter(function (anydata entry) returns [string, any, string] { // @error
        return ["", "", ""];
    });
    Person invFil = p.filter(function (anydata entry) returns boolean { // @error
        return false;
    });
}

type RestrictedGrades record {| int maths; int physics; int chemistry; int...; |};

function testInvalidChainedItrOpReturns() {
    RestrictedGrades f = {maths: 80, physics: 75, chemistry: 65, "english": 78};
    map<int> m = f.'map(function (int grade) returns int { return grade + 10; }) // @error
        .'map(function (int grade) returns string { return grade > 75 ? "PASS" : "FAIL"; })
        .filter(function (string status) returns boolean { return status == "PASS"; })
        .'map(function (string status) returns float { return status == "PASS" ? 4.2 : 0.0; });
}

function testInvalidChainedItrOpReturns2() {
    RestrictedGrades f = {maths: 80, physics: 75, chemistry: 65, "english": 78};
    int[] ar = f.'map(function (int grade) returns int { return grade + 10; }) // @error
        .'map(function (int grade) returns string { return grade > 75 ? "PASS" : "FAIL"; })
        .filter(function (string status) returns boolean { return status == "PASS"; })
        .'map(function (string status) returns float { return status == "PASS" ? 4.2 : 0.0; });
}
