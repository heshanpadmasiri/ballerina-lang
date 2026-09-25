type PersonA record {|
    string fname;
    string lname;
    int age;
}; // @error

type PersonB record {
    string fname;
    string lname;
    int age;
|}; // @error

type PersonC record { | // @error
    string fname;
    string lname;
    int age;
| }; // @error

type EmptyRec1 record {|| }; // @error

type EmptyRec2 record { ||}; // @error

type EmptyRec3 record { || }; // @error

type EmptyRec4 record { | | }; // @error
