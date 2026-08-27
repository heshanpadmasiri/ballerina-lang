public type Foo record {|
    string s;
    string t;
    boolean b = false;
|};

public type Bar record {|
    Foo[] f;
    int i = 10;
|};

public const annotation Bar v1 on source service, source listener;

string s2 = "s2";

service object {} ser2 = @v1 {
    f: [
        {s: "s", t: "t"},
        {s: s2, t: "t2"} // @error
    ]
} service object {
    resource function get res() {}
};

type Baz record {
    string st;
    Qux q?;
};

readonly class Qux {}

public const annotation Baz v2 on service, source listener;

service object {} ser3 = @v2 {
    st: "string value"
} service object {
    resource function get res() {}
};

const annotation record {|int[] arr;|}[] v3 on type;

int[] intArr = [1, 2];
int i = 1;
const TWO = 2;

@v3 {
    arr: intArr // @error
}
@v3 {
    arr: [TWO, i] // @error
}
@v3 {
    arr: [i, i] // @error @error
}
type Corge record {|
    int a;
    int b;
|};
