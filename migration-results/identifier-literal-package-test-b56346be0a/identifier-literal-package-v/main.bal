import ballerina/io;
import testproject.variable;

public function main() {
    [int, string, float, any] vars = getVarsInOtherPkg();
    io:println(vars[0]); // @output 800
    io:println(vars[1]); // @output value
    io:println(vars[2]); // @output 99.34323
    io:println(vars[3]); // @output 88343

    [string, int?] person = accessStructWithIL();
    io:println(person[0]); // @output Harry
    io:println(person[1]); // @output 25

    [string, int?] employee = accessTypeLabelWithIL();
    io:println(employee[0]); // @output John
    io:println(employee[1]); // @output 20

    record {| string name; |}[] anonymousRecords = getAnonFromFoo();
    io:println(anonymousRecords[0].name); // @output Waruna
}

function getVarsInOtherPkg() returns [int, string, float, any] {
    return [variable:'getVariable\ Int(), variable:'getVariable\ String(), variable:'getVariable\ Float(),
        variable:'getVariable\ Any()];
}

function accessStructWithIL() returns [string, int?] {
    return [variable:'getPerson\ 1().'first\ name, variable:'getPerson\ 1()?.'current\ age];
}

function accessTypeLabelWithIL() returns [string, int?] {
    return [variable:'getEmployee\ 1().'first\ name, variable:'getEmployee\ 1()?.'current\ age];
}

function getAnonFromFoo() returns record {| string name; |}[] {
    variable:Foo\$[] arr = [{name: "Waruna"}];
    return arr;
}
