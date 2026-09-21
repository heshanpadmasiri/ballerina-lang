public class person {
    public int age = 0;
    public string name = "";
    string ssn = "";
    int id = 0;
}

public function newPerson() returns person {
    person p = new;
    p.age = 12;
    p.name = "mad";
    p.ssn = "234-90-8887";
    return p;
}
