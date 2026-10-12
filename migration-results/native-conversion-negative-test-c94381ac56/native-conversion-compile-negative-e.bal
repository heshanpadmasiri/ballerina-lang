import ballerina/lang.value;

class PersonObj {
    public string name = "Waruna";
    public int age = 10;
}

type Person record {|
    string name = "";
    int age = 0;
    Person? parent = ();
    json info?;
    map<anydata>? address?;
    int[]? marks?;
    anydata a = ();
    float score = 0.0;
    boolean alive = false;
    Person[]? children?;
|};

type Person2 record {|
    string name = "";
    int age = 0;
|};

type Person3 record {|
    string name = "";
    int age = 0;
    string gender = "";
|};

function testObjectToJson() returns json|error {
    PersonObj p = new PersonObj();
    return value:cloneWithType(p, json); // @error incompatible types: expected 'anydata', found 'PersonObj'
}
