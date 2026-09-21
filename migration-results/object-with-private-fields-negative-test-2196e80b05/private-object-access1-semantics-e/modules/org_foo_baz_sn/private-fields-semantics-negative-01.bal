
public class ParentFoo {

    public int i;
    public ChildFoo c; // @error
    private string s = "";

    function init (int i, ChildFoo c){
        self.i = i;
        self.c = c;
    }
}

class ChildFoo {
    private string name = "";

    function init (string name) {
        self.name = name;
    }
}

class PrivatePerson {

    public int age = 0;
    public string name = "";

    function init (int age, string name){
        self.age = age;
        self.name = name;
    }
    public function getPrivatePersonName() returns string { return self.name; }
}

public function newPrivatePerson() returns (PrivatePerson) { // @error
    return new PrivatePerson(12, "mad");
}

public function privatePersonAsParam(PrivatePerson p) returns (string){ // @error
    return p.name;
}

public function privatePersonAsParamAndReturn(PrivatePerson p) returns (PrivatePerson) { // @error // @error
    return p;
}
