type Foo record {|
    int a;
    int b = a + 10; // @error
    record {
        int x = a; // @error
    } c;

    object {
        int z;
    } d = object { int z = a; }; // @error
|};

function fieldRefTest() {
    record {|
        string fname = "Pubudu";
        string lname = "Fernando";
        string fullName = fname + " " + lname; // @error // @error
    |} person = {};

    record {|
        int a;
        int b = a + 10; // @error

        record {
            int x = a; // @error
        } c;

        object {
            int z;
        } d = object { int z = a; }; // @error
    |} rec;

    int p = 25;
    record {
        int x = 10;
        int marks = let int e = 3, int z = 5 in z * e + x; // @error
        int y = p;
    } student = {};

    object {
        record {
            int a;
            int b = a; // @error
            record {
                int d = a; // @error
            } nestd = {};
        } f;
    } obj = object {
                    record {
                        int a;
                        int b = a; // @error
                        record {
                            int d = a; // @error
                        } nestd = {};
                    } f = {a: 10};
                };
}

int glbA = 100;

type Bar record {
    string glbA;
    string z = glbA; // @error
};
