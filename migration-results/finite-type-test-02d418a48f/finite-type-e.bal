type Person record {
    string name;
};

type POrInt Person|int;

function finiteAssignmentRefValueTypeCaseTwo() returns POrInt {
    Person p = {name: "abc"}; // @error unused variable 'p'
    POrInt pi = 4;
    return pi;
}

type State "on"|"off";

class Channel {
    public State? b;

    function init(State b = "off", boolean a = true) {
        self.b = b;
        State o = "on";
        if (self.b == o) {
            int i = 4; // @error unused variable 'i'
        }
    }
}

function testFiniteTypesWithTuple() returns State {
    State onState = "on";
    [State, int] b = [onState, 20];
    var [i, j] = b; // @error unused variable 'j'
    return i;
}

type FooString "foo";
type BarString "bar";
type FooInt 1;
type BarInt 2;
type FooBoolean true;
type BarBoolean false;
type RecString1 record {| FooString|BarString a; FooInt|BarInt b; FooBoolean|BarBoolean c; |};
type RecString2 record {| string a; int b; boolean c; |};

function testRecordStringEquality() {
    RecString1 rec1 = {a: "foo", b: 1, c: true};
    RecString2 rec2 = rec1; // @error unused variable 'rec2'
}
