type Alpha record {
    Beta?[] betas = [];
};

type AlphaTwo record {
    Beta?[] betas?;
};

public type Beta record {|
    int i;
    string s?;
|};

function testInvalidFieldOptionalFieldAndMemberAccess1() {
    string sval = "test string";
    AlphaTwo a = {betas: [{i: 1, s: sval}, {i: 2}]};
    string? s1 = a.betas[0]?.s; // @error
}

function testInvalidFieldOptionalFieldAndMemberAccessType() {
    string sval = "test string";
    Alpha a = {betas: [(), {i: 1, s: sval}]};
    string s1 = a.betas[0]?.s; // @error
}

public class Gamma {
    Delta? delta;

    public function init(Delta? d) {
        self.delta = d;
    }
}

public class Delta {
    string? status = ();
}

function testInvalidMemberAccessOnNillableObjectField() {
    Gamma g = new(new);
    string? s = g.delta["status"]; // @error
}
