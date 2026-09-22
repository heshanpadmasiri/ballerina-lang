
public type ParentFoo record {
    int i = 0;
    ChildFoo c = {}; // @error
};

type ChildFoo record {
    string name = "";
};

type PrivatePerson record {
    int age = 0;
    string name = "";
};

public function newPrivatePerson() returns PrivatePerson { // @error
    return {age:12, name:"mad"};
}

public function privatePersonAsParam(PrivatePerson p) returns string { // @error
    return p.name;
}

public function privatePersonAsParamAndReturn(PrivatePerson p) returns PrivatePerson { // @error
    return p;
}
