public class Student {
    public string name = "";
    public string school = "";
    public int age = 0;
    public function init(string name, string school, int age) { self.name = name; self.age = age; self.school = school; }
    public function toString() returns string { return "Student{" + self.name + ", " + self.age.toString() + ", " + self.school + "}"; }
    public function getSchool() returns string { return self.school; }
}

public class ModuleLevelSubtypableObj { public string name = ""; int age = 0; }

public class ModuleLevelSubtypableObj2 {
    public string name = "";
    public int age = 0;
    function updateAge(int age) { self.age = age; }
}

public client class ClientObjectWithoutRemoteMethod {
    public string name;
    public string id = "";
    public function init(string name) { self.name = name; }
    public function send(string message) returns error? {}
    public function receive(string message) {}
}

public class NonClientObject {
    public string name;
    public string id = "";
    public function init(string name) { self.name = name; }
    public function send(string message) returns error? {}
    public function receive(string message) {}
}
