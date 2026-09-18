function testNeverTypedVariable() {
    never x; // @error
}

//------------ Testing a function with 'never' return type ---------

function functionWithNeverReturnType() returns never {
    string a = "hello";
}

function testAssignNeverReturnedFuncCall() {
    never x = functionWithNeverReturnType(); // @error
}

function testAssignAnyToNeverReturnedFuncCall() {
    any x = functionWithNeverReturnType();
}

function testNeverReturnTypeWithStringReturnStmt1() returns never {
    string s = "hello";
    return s; // @error
}

function testNeverReturnTypeWithStringReturnStmt2(boolean x) returns never {
    string s = "hello";
    if (x) {
        return s; // @error
    }
}

function testNeverReturnTypeWithNilReturnStmt1() returns never {
    return (); // @error
}

function testNeverReturnTypeWithNilReturnStmt2(boolean x) returns never {
        if (x) {
            return (); // @error
        }
}

//------------ Testing record type with 'never' typed field ---------

type Foo record {
    int x;
    never y;
};

type Bar record {
    int x;
    never y?;
};

function testAssignValueToRequiredNeverField() {
    Foo foo = {x:2, y:"example"}; // @error // @error
}

function testAssignValueToOptionalNeverField() {
    Bar bar = {x:2, y:"s"}; // @error
}

function testNeverFiledAssignNeverReturnedFunction() {
    Foo foo = {x:2, y:functionWithNeverReturnType()}; // @error
}

type Person record {|
    string name;
    never age?;
|};

function testAssignOptionalFieldWithAccessExpr1() {
    Person p = {name: "John"};
    p["age"] = 34; // @error
}

function testAssignOptionalFieldWithAccessExpr2() {
    Person p = {name: "Kafka"};
    p["age"] = (); // @error
}

type Vehicle record {|
    string brand;
    never...;
|};

function testAssignFieldWithNeverTypedSpreadOp1() {
    Vehicle p = {brand: "Mazda"};
    p["foo"] = "champ"; // @error
}

function testAssignFieldWithNeverTypedSpreadOp2() {
    Vehicle p = {brand: "Suzuki"};
    p["foo"] = (); // @error
}

type Employee record {|
    string role;
    *Person;
|};

function testReferencingTypeWithNeverField() {
    Employee e = {name: "John", age: 20, role: "SE"}; // @error
}

//------------ Testing 'map' type with 'never' type ---------

function testAssignFieldsOfMappingWithNeverType1() {
    map<never> m;
    m["a"] = 122; // @error
}

function testAssignFieldsOfMappingWithNeverType2() {
    map<never> m;
    m["a"] = (); // @error
}

// -------------Test 'never' with table key constraints --------------
type Human record {
  readonly string name;
  int age;
};

type HumanTable table<Human> key<never>;

function testNeverAsTableKeyConstraint() {
    HumanTable humanTable= table key(name)[ // @error
        { name: "DD", age: 33},
        { name: "XX", age: 34}
    ];
}

type SomeHumanTable table<Human> key<never|string>;

function testNeverInUnionTypedKeyConstraints() {
    SomeHumanTable someHumanTable = table [ // @error
        { name: "MM", age: 33},
        { name: "PP", age: 34}
    ];
}

//------------ Testing a never type assignment ---------
function testNeverAssignment() {
     string empty = "";
     xml<never> c = xml `${empty}`; // @error
     xml|'xml:Text d = xml ``;
     string e = d; // @error
     xml|'xml:Text f = xml ``;
     string g = f; // @error
     xml<never> h = xml ``;
     int|float i = h; // @error
     string|'xml:Text p = xml ``;
     string s8 = p; // @error
     int|string t = xml ``; // @error
}

function testNeverTypeLocalVarDeclWithoutInit() {
    never a; // @error
}

never b; // @error

const never c = (); // @error // @error

function testNeverTypeInTypedBindingPattern() {
    never x = foo(); // @error
    var y = foo(); // @error
}

function foo() returns never {
  error e = error("Bad Sad!!");
  panic e;
}

function blow1(never rec) { // @error
}

function blow2(record {| never x; |} rec) { // @error
}

function blow3(never rec) { // @error
}

function blow4(int val, record {| never x; |} rec = {}) { // @error
}

function blow5() returns error? {
    Bam bam = new;
    bam->func(); // @error
    bam->func2(); // @error
    bam->func3(); // @error
}

client class Bam {
    remote function func() returns never {
        panic error("error!");
    }

    remote function func2() returns [never] {
        panic error("error!");
    }

    remote function func3() returns record {| never x; |} {
        panic error("error!");
    }
}

function testNeverTypeInTypedBindingPattern2() {
    [never] x = []; // @error // @error
}

function testNeverEquivalentRequiredArgInFunc1([never] a = foo()) { // @error

}

function testNeverEquivalentRequiredArgInFunc2(record {| never x; |} a, object { never value; } b) { // @error // @error

}

type Record1 record {|
    int i;
    record {| never x; |} j;
|};

type Record2 record {|
    int i;
    record {| never x; |} j = {};
|};

function testNeverEquivRecord() {
    Record1 a = { i: 1 }; // @error
    Record2 b = { i: 1 }; // @error
}

type Pair record {
    int x;
};

function testNeverFieldTypeBinding() {
    Pair p = {
        x: 1,
        "y": 2,
        "color": "blue"
    };
    var {x: _, ...rest} = p;
    record {never x?; never y?;} y1 = rest; // @error

    record {} a = {"x": 11};
    record {never x?;} y2 = a; // @error
}

function testNeverRestFieldType() {
    record {|never...;|} a = {};
    record {|int x;|} copy = a; // @error

    record {|int x?;|} a1 = {};
    record {|never...; |} copy2 = a1; // @error

    record {|int x;never?...;|} a2 = {x: 12};
    record {||} copy3 = a2; // @error

    record {||} a3 = {};
    record {|int x;never...;|} copy4 = a3; // @error

    record {|never?...;|} a4 = {};
    record {never i?;} _ = a4; // @error
}

never N = check error("Error"); // error // @error

function testNeverTypeInTypedBindingPatternWithCheckingExpr() {
    never n1 = check error("Error2"); // error // @error
    never n2 = checkpanic error("Error2"); // error // @error
}

type NeverFoo never;
NeverFoo NF = check error("Error"); //error // @error
