annotation map<string> v0 on var; // @error @error
const annotation Foo v1 on annotation; // @error
annotation Bar v2 on const, type; // @error @error
const annotation map<anydata> v3 on return, external; // @error
const annotation map<anydata> v4 on listener; // @error

type Foo record {
    string val1;
};

type Bar record {|
    string val1;
    int val2;
|};
