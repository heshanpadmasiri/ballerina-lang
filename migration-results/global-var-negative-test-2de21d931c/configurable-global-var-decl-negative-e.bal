// Configurable variable declarations.
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
configurable int x; // @error
configurable var a = 5; // @error
configurable object {int a;} b = object {int a = 5;}; // @error
configurable record {int c;} d = {c:5};

function foo() {
    // Cannot declare configurable variables locally. // @error
    configurable int e = 6;
} // @error

configurable () & readonly j2 = ?; // @error

configurable [int, string] [intVar, stringVar] = ?; // @error

final configurable string systemAlias = "Ballerina"; // @error

type Person record {|
    readonly string name;
|};

type Person1 record {|
    () nilField;
    anydata anydataField;
|};

type Person2 record {|
    int|() unionField;
|};

type Person3 record {|
    ()[] nilArr;
|};

type Person4 record {|
    string name;
    Person1 person;
|};

type Person5 record {|
    () field1;
    () field2;
|};

type Colors "Red" | "Green";

configurable Person1 person1 = ?; // @error
configurable Person2 person2 = ?; // @error
configurable Person3 person3 = ?; // @error
configurable Person4 person4 = ?; // @error
configurable Person5 person5 = ?; // @error

configurable table<map<()>> tableVar1 = ?; // @error
configurable table<Person1> tableVar2 = ?; // @error
configurable table<()> tableVar3 = ?; // @error // @error

configurable ()[] arrayVar = ?; // @error

configurable map<()> & readonly mapVar = ?; // @error

configurable string|() unionVar1 = ?; // @error
configurable () unionVar2 = ?; // @error

configurable [int, string, ()] tupleVar = ?; // @error

type Person6 record {|
    () field1;
    string? field2;
|};

configurable () nilVar = ?; // @error
configurable ()[] nilArr = ?; // @error
configurable string? nilUnion = ?; // @error
configurable map<()> nilMap = ?; // @error
configurable Person6 nilRecord1 = ?; // @error
configurable table<map<()>> nilTable = ?; // @error

configurable string host = ?;
configurable int host = ?; // @error
