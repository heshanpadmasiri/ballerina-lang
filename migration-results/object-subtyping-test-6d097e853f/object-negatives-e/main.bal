import testorg/object_negatives.subtyping;

type ObjWithPvtField object {
    string name;
    private int ssn; // @error private qualifier in object member descriptor
};

type ObjWithPvtMethod object {
    string name;
    int ssn;
    private function test(); // @error private qualifier in object member descriptor
};

class AnotherObjWithAPvtField { string name = ""; private int ssn = 0; }
class AnotherObjWithPvtMethod { string name = ""; int ssn = 0; private function test() {} }

function testObjsWithPvtMembers() {
    ObjWithPvtField o1 = new AnotherObjWithAPvtField();
    ObjWithPvtMethod o2 = new AnotherObjWithPvtMethod();
}

class Subtype1 { public string name = ""; public string address = ""; int age = 0; }
class Subtype2 { public string name = ""; public int age = 0; function updateAge(int age) { self.age = age; } }

function testModuleLevelSubtypableObjs() {
    subtyping:ModuleLevelSubtypableObj o1 = new Subtype1();
    subtyping:ModuleLevelSubtypableObj2 o2 = new Subtype2();
}
