annotation int v1 on type; // @error

type VAL true;
type trueArray VAL[];

annotation trueArray v2 on type; // @error

annotation record {|Foo f;|} v3 on type; // @error

class Foo {
    int i = 0;
}

annotation map<object {}> v4 on field; // @error

annotation record {|Foo...;|} v5 on type; // @error
