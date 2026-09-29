public type TLift record {|
    readonly string id;
    string name;
    string status;
    int capacity;
    boolean night;
    int elevationgain;
    TTrail trailAccess;
|};

public type TTrail record {|
    string id;
    string name;
    string status;
    string difficulty;
    boolean groomed;
    boolean trees;
    boolean night;
|};

type LiftRecord record {
    int id;
    anydata status;
};

public class Lift {
    int id;
    anydata status;

    function init(LiftRecord lr) {
        self.id = lr.id;
        self.status = lr.status;
    }
}

type Status boolean;

client class TestService {
    resource function get closureTest1(string status) returns string {
        var addFunc = function (int funcInt) returns string {
            return status;
        };
        return addFunc(1);
    }

    resource function get closureTest2(string status) returns TLift[] {
        table<TLift> key(id) liftTable = table [{
            id: "l1", name: "Lift1", status: "OPEN", capacity: 10, night: false, elevationgain: 20,
            trailAccess: {id: "t1", name: "tail1", status: "OPEN", difficulty: "HARD", groomed: true,
                          trees: false, night: false}
        }];
        return from var l in liftTable where l.status == status select l;
    }

    resource function get closureTest3(Status? status) returns Lift[] {
        table<LiftRecord> liftTable = table [
            {id: 1, status: false}, {id: 2, status: true}, {id: 3, status: false}, {id: 4, status: true}
        ];
        LiftRecord[] lifts;
        if status is () {
            lifts = from var lift in liftTable select lift;
        } else {
            lifts = from var lift in liftTable where lift.status == status select lift;
        }
        return lifts.map(function (LiftRecord liftRecord) returns Lift => new Lift(liftRecord));
    }
}

public function main() {
    TestService t = new;
    string str = t->/closureTest1("foobar");
    TLift[] tLifts = t->/closureTest2("OPEN");
    Lift[] lifts = t->/closureTest3(true);
    assertEquality(str, "foobar");
    assertEquality(tLifts.length(), 1);
    assertEquality(tLifts[0]["name"], "Lift1");
    assertEquality(lifts.length(), 2);
    assertEquality(lifts[0].id, 2);
    assertEquality(lifts[1].id, 4);
}

function assertEquality(any|error actual, any|error expected) {
    if expected is anydata && actual is anydata && expected == actual {
        return;
    }

    if expected === actual {
        return;
    }
    panic error("AssertionError", message = "unexpected resource closure result");
}
