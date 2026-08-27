annotation map<string> v0 on source var; // @error
annotation Foo v1 on source annotation; // @error
annotation Bar v2 on source const, type; // @error
annotation map<anydata> v3 on return, source external; // @error
annotation map<int> v4 on source const, source external; // @error
annotation Foo v5 on source type; // @error
annotation Bar v6 on source listener, return; // @error
annotation Bar v7 on class, source function; // @error
annotation Bar v8 on source object function, source parameter; // @error
annotation map<string> v9 on source worker; // @error

type Foo record {
    string val1;
};

type Bar record {|
    string val1;
    int val2;
|};
