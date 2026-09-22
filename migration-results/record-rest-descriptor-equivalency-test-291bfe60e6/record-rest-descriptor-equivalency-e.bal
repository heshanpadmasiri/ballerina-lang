type StringRest record {|
    string name = "";
    int id = 0;
    string...;
|};

type IntRest record {|
    string name = "";
    int id = 0;
    int...;
|};

type FloatRest record {|
    string name = "";
    int id = 0;
    float...;
|};

type BooleanRest record {|
    string name = "";
    int id = 0;
    float...;
|};

function testEquivOfStringAndIntRestDescriptors() {
    StringRest a = {};
    IntRest b = a; // @error

    b = {};
    StringRest aa = b; // @error
}

function testEquivOfFloatAndIntRestDescriptors() {
    FloatRest a = {};
    IntRest b = a; // @error

    b = {};
    FloatRest aa = b; // @error
}

function testEquivOfBooleanAndIntRestDescriptors() {
    BooleanRest a = {};
    IntRest b = a; // @error

    b = {};
    BooleanRest aa = b; // @error
}

function testEquivOfFloatAndStringRestDescriptors() {
    FloatRest a = {};
    StringRest b = a; // @error

    b = {};
    FloatRest aa = b; // @error
}

function testEquivOfBooleanAndStringRestDescriptors() {
    BooleanRest a = {};
    StringRest b = a; // @error

    b = {};
    BooleanRest aa = b; // @error
}

function testEquivOfBooleanAndFloatRestDescriptors() {
    BooleanRest a = {};
    FloatRest b = a;

    b = {};
    BooleanRest aa = b;
}

type StringRest2 record {|
    string name = "";
    int id = 0;
    float scale = 0.0;
    string...;
|};

type RecordRest1 record {|
    string id = "";
    StringRest...;
|};

type RecordRest2 record {|
    string id = "";
    StringRest2...;
|};

function testEquivWithRecordsAsRestDescriptors() {
     RecordRest2 a = {};
     RecordRest1 b = a; // @error

     b = {};
     RecordRest2 aa = b; // @error
}
