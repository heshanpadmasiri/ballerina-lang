public function main(typedesc<any> t, // @error
    int|string m, // @error
    boolean n, // @error
    boolean[] o, // @error
    boolean? p, // @error
    map<int> q, // @error
    Student st2, // @error
    int|typedesc<any> i = 1, // @error
    float|string r = 3.0, // @error
    *Student st1, FooObject... f) { // @error
}

public class FooObject {
    string name = "invalid";
}

public type Student record {
    int a;
};
