import ballerina/io;

type Person record {
    string name = "";
    int age = 0;
    Person|() parent = ();
    json info = null;
    map<any> address = {};
    int[] marks = [];
};

function testMultiValuedStructInlineInit() returns Person {
    Person p1 = {
        name: "aaa", age: 25,
        parent: {name: "bbb", age: 50},
        address: {"city": "Colombo", "country": "SriLanka"},
        info: {status: "single"}
    };
    return p1;
}

function testAccessJsonInStruct() returns [string, string, string]|error {
    Person p1 = {
        name: "aaa",
        age: 25,
        parent: {
            name: "bbb",
            age: 50,
            address: {"city": "Colombo", "country": "SriLanka"},
            info: {status: "married"}
        },
        info: {status: "single"}
    };
    string status1 = "";
    string status2 = "";
    string status3 = "";

    var result1 = p1.parent;
    if result1 is Person {
        status1 = check result1.info.status;
    }

    var result2 = p1["parent"];
    if result2 is Person {
        status2 = check result2["info"].status;
        status3 = check result2.info.status;
    }

    return [status1, status2, status3];
}

function testAccessMapInStruct() returns [any, any, any, string] {
    Person p1 = {
        name: "aaa",
        age: 25,
        parent: {
            name: "bbb",
            age: 50,
            address: {"city": "Colombo", "country": "SriLanka"},
            info: {status: "married"}
        },
        info: {status: "single"}
    };
    string cityKey = "city";
    string city = "";

    var result = p1["parent"];
    if result is Person {
        city = checkpanic result.address[cityKey].ensureType();
        return [result.address["city"], result["address"]["city"], result.address["city"], city];
    }
    return [(), (), (), city];
}

function testSetValueToJsonInStruct() returns json {
    Person p1 = {
        name: "aaa",
        age: 25,
        parent: {
            name: "bbb",
            age: 50,
            address: {"city": "Colombo", "country": "SriLanka"},
            info: {status: "married"}
        },
        info: {status: "single"}
    };

    var result = p1.parent;
    if result is Person {
        map<json> info = <map<json>>result.info;
        info["status"] = "widowed";
        info["retired"] = true;
        return result.info;
    }
    return null;
}

function testAccessArrayInStruct() returns [int, int] {
    Person p1 = {marks: [87, 94, 72]};
    return [p1.marks[1], p1["marks"][2]];
}

public function main() returns error? {
    Person person = testMultiValuedStructInlineInit();
    io:println(person.name); // @output aaa
    io:println(person.age); // @output 25
    var parent = person.parent;
    if parent is Person {
        io:println(parent.name); // @output bbb
        io:println(parent.age); // @output 50
    }
    io:println(person.info); // @output {"status":"single"}
    io:println(person.address["city"]); // @output Colombo
    io:println(person.address["country"]); // @output SriLanka

    [string, string, string] jsonValues = check testAccessJsonInStruct();
    io:println(jsonValues[0]); // @output married
    io:println(jsonValues[1]); // @output married
    io:println(jsonValues[2]); // @output married

    [any, any, any, string] mapValues = testAccessMapInStruct();
    io:println(mapValues[0]); // @output Colombo
    io:println(mapValues[1]); // @output Colombo
    io:println(mapValues[2]); // @output Colombo
    io:println(mapValues[3]); // @output Colombo

    [int, int] arrayValues = testAccessArrayInStruct();
    io:println(arrayValues[0]); // @output 94
    io:println(arrayValues[1]); // @output 72

    io:println(testSetValueToJsonInStruct()); // @output {"status":"widowed","retired":true}
}
