import ballerina/io;

type Person record {
    string name = "John";
    int age = 30;
    string spouse?;
};

function getDefaultPerson() returns Person {
    return {};
}

function getNewPerson() returns Person {
    Person person = {name: "Jane", age: 25, spouse: "John", "gender": "female"};
    return person;
}

public function main() {
    Person defaultPerson = getDefaultPerson();
    io:println(defaultPerson.hasKey("name")); // @output true
    io:println(defaultPerson.name); // @output John
    io:println(defaultPerson.hasKey("spouse")); // @output false
    io:println(defaultPerson["spouse"]); // @output
    var previousLastName = defaultPerson["last-name"];
    defaultPerson["last-name"] = "Doe";
    io:println(previousLastName); // @output
    io:println(defaultPerson["last-name"]); // @output Doe
    io:println(defaultPerson.hasKey("first-name")); // @output false
    io:println(defaultPerson.hasKey("last-name")); // @output true
    string defaultEntries = "[";
    boolean first = true;
    foreach var entry in defaultPerson.entries() {
        if !first {
            defaultEntries += ", ";
        }
        defaultEntries += "{" + entry[0] + ":" + entry[1].toString() + "}";
        first = false;
    }
    defaultEntries += "]";
    io:println(defaultEntries); // @output [{name:John}, {age:30}, {last-name:Doe}]
    string defaultKeys = "[";
    first = true;
    foreach string key in defaultPerson.keys() {
        if !first {
            defaultKeys += ", ";
        }
        defaultKeys += key;
        first = false;
    }
    defaultKeys += "]";
    io:println(defaultKeys); // @output [name, age, last-name]
    string defaultValues = "[";
    first = true;
    foreach var value in defaultPerson.toArray() {
        if !first {
            defaultValues += ", ";
        }
        defaultValues += value.toString();
        first = false;
    }
    defaultValues += "]";
    io:println(defaultValues); // @output [John, 30, Doe]
    io:println(defaultPerson.entries().length()); // @output 3
    io:println(defaultPerson.entries().length() == 0); // @output false
    io:println(defaultPerson.toString()); // @output {"name":"John","age":30,"last-name":"Doe"}
    defaultPerson.spouse = "Jane";
    io:println(defaultPerson.spouse); // @output Jane
    io:println(defaultPerson.hasKey("spouse")); // @output true

    Person newPerson = getNewPerson();
    io:println(newPerson.hasKey("name")); // @output true
    io:println(newPerson.name); // @output Jane
    io:println(newPerson.hasKey("spouse")); // @output true
    io:println(newPerson.spouse); // @output John
    io:println(newPerson["gender"]); // @output female
    string newEntries = "[";
    first = true;
    foreach var entry in newPerson.entries() {
        if !first {
            newEntries += ", ";
        }
        newEntries += "{" + entry[0] + ":" + entry[1].toString() + "}";
        first = false;
    }
    newEntries += "]";
    io:println(newEntries); // @output [{name:Jane}, {age:25}, {spouse:John}, {gender:female}]
    string newKeys = "[";
    first = true;
    foreach string key in newPerson.keys() {
        if !first {
            newKeys += ", ";
        }
        newKeys += key;
        first = false;
    }
    newKeys += "]";
    io:println(newKeys); // @output [name, age, spouse, gender]
    string newValues = "[";
    first = true;
    foreach var value in newPerson.toArray() {
        if !first {
            newValues += ", ";
        }
        newValues += value.toString();
        first = false;
    }
    newValues += "]";
    io:println(newValues); // @output [Jane, 25, John, female]
    io:println(newPerson.entries().length()); // @output 4
    io:println(newPerson.entries().length() == 0); // @output false
    io:println(newPerson.toString()); // @output {"name":"Jane","age":25,"spouse":"John","gender":"female"}
}
