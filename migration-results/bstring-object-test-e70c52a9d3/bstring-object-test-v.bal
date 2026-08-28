import ballerina/io;

class World {
    public string name = "Earth";
    public string value = "Happy 🙋";
}

function testObjectAccess() returns int {
    World world = new;
    string content = world.name + world.value;
    return content.length();
}

class Criminal {
    public string name1;
    public string name2;

    function init(string name1, string name2) {
        self.name1 = name1;
        self.name2 = validate(name2);
    }

    function validate(string name) returns string {
        return name;
    }

    function getName() returns string {
        return validate(self.name2);
    }
}

function validate(string name) returns string {
    return name;
}

function testObjectInitialization() returns int {
    Criminal criminal = new Criminal("John", "Doe🦹‍♂️");
    string content = criminal.validate(criminal.name1) + criminal.getName();
    return content.toString().length();
}

function testObjectSet() returns int {
    World world = new();
    world.name = "Sam";
    world.value = "Andy👨";
    string content = world.name + world.value;
    return content.length();
}

public function main() {
    io:println(testObjectAccess()); // @output 12
    io:println(testObjectInitialization()); // @output 11
    io:println(testObjectSet()); // @output 8
}
