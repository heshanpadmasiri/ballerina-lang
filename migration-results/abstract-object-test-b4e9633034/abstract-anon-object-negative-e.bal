
object {public int age; public string name; function init(int age, string name) {}} p1 = new; // @error // @error // @error // @error // @error
object {public int age; public string name; function test();} p2 = new; // @error

function test() returns int {
    object {public int age; public string name; function init(int age, string name) {}} p4; // @error // @error // @error // @error
    object {public int age; public string name; function test();} p5;
    object {public int age; public string name; function test();} p6 = new; // @error
    return 1;
}
