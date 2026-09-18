const NIL = "()";
const ANY = "any";

public type BType NIL | ANY;

public type BUnionType record {|
    BType[] members;
|};

function testNilableTypeArrayIteration() {
    BType[*] tarr = [NIL, ANY];
    BUnionType ut = {members: tarr};

    BType?[] types = ut.members;

    foreach var v in types {
        BType x = v; // @error
    }
}
