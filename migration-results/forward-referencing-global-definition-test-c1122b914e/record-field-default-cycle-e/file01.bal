type Person record {|
    string name = name;
    int age;
|};
Person person = {age : 22};

record {| string n = gVar;|} p = {};

// Global variable referenced inside of nested record decl causing a dependency cycle.
final string gVarNested = nestedRec.r.n; // @error
record {| record { string n = gVarNested; } r = {};|} nestedRec = {};

record {| record { string n = nillableNestedRecordGVar; }? r = {};|} nillableNestedRec = {};

class A {
    record { string n = nestedRecordFieldDefaultValue; } r = {};
}
