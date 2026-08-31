# Define a constant
# This constant is deprecated
@deprecated
const string CONST1 = "CONST1"; // @error
const string CONST2 = "CONST2";

# Define a type
# # Deprecated // @error
# This type is deprecated
public type Foo CONST1|CONST2;

# The `DummyObject` is a user-defined object.
#
# + fieldOne - This is the description of the `DummyObject`'s `fieldOne` field.
# + fieldTwo - This is the description of the `DummyObject`'s `fieldTwo` field.
# + fieldThree - This is the description of the `DummyObject`'s `fieldThree` field.
@deprecated
public class DummyObject { // @error

    public string fieldOne = "Foo";
    public string fieldTwo = "Foo";
    public string fieldThree = "";
    # The `doThatOnObject` function is attached to the `DummyObject` object.
    #
    # + paramOne - This is the description of the parameter of
    #              the `doThatOnObject` function.
    # # Deprecated // @error
    public function doThatOnObject(string paramOne) {
    }
}

# This function initialize the object
#
# This function is deprecated
@deprecated
public function func1() { // @error
}

# Test function doc
# + x - first integer
# + y - second integer
# + z - third integer
# + return - Returns the sum
# # Deprecated parameters
# + x - deprecated parameter
# + y - deprecated parameter
# # Deprecated
# function is deprecated
@deprecated
function add1(@deprecated int x, @deprecated int y, @deprecated int z) returns int { // Compile error // @error
    return 5;
}

# Test function doc
# + x - first integer
# + y - second integer
# + z - third integer
# + return - Returns the sum
function add2(@deprecated int x, @deprecated int y, @deprecated int z) returns int { // Compile error // @error // @error // @error
    return 4;
}

# Test function doc
# + x - first integer
# + y - second integer
# + z - third integer
# + return - Returns the sum
# # Deprecated parameters
# + x - deprecated parameter
# + y - deprecated parameter
# + z - deprecated parameter        // Compile error // @error
# # Deprecated
# function is deprecated
@deprecated
function add3(@deprecated int x, @deprecated int y, int z) returns int {
    return 2;
}

# Test object doc
# + xxx - This is int
# # Deprecated parameters
# + xxx - deprecated
# # Deprecated
@deprecated
class DummyObj { // @error

    @deprecated
    public int xxx = 0;
}

const string CONST3 = "CONST3";
const string CONST4 = "CONST4";

public type T1 CONST3|CONST4;

# The `OBject1` is a user-defined object.
#
# + fieldOne - This is the description of the `DummyObject`'s `fieldOne` field.
# + fieldTwo - This is the description of the `DummyObject`'s `fieldTwo` field.
# # Deprecated parameters
# + fieldOne - deprecated
# # Deprecated
@deprecated
public class Object1 { // @error

    @deprecated
    public string fieldOne = "Foo";
    @deprecated     // Compile error
    T1 t = CONST3;
    public string fieldTwo = "";
}

# The `Object2` is a user-defined object.
#
# + fieldOne - first field.
# + fieldTwo - second field.
# + t - third field
# # Deprecated parameters
# + fieldOne - deprecated
# + t - deprecated          // Compile error
public class Object2 { // @error

    @deprecated
    public string fieldOne = "Foo";
    public T1 t = CONST3;
    public string fieldTwo = "";
}

# The `Object3` is a user-defined object.
#
# + fieldOne - This is the description of the `DummyObject`'s `fieldOne` field.
# + fieldTwo - This is the description of the `DummyObject`'s `fieldTwo` field.
public class Object3 {

    @deprecated             // Compile error
    public string fieldOne = "Foo";
    T1 t = CONST3;
    public string fieldTwo = "";
}

# Test function doc
# + x - first integer
# + y - second integer
# + z - third integer
function add4(int x, int y, @deprecated int... z) {       // Compiler error // @error
}

# Test function doc
# + x - first integer
# + y - second integer
# + z - third integer
# # Deprecated parameters
# + z - deprecated rest parameter       // Compile error // @error
function add5(int x, int y, int... z) {
    int _ = z[0];
}

public class Object4 {

    # Describe the field here
    # # Deprecated // @error
    public string fieldOne = "Foo";
    # Describe the field here
    @deprecated                         // Compile error
    T1 t = CONST3; // @error
    public string fieldTwo = "";
}

# Docs for `Foo`
#
# # Deprecated parameters
# + s - deprecated s
type Bar record { // @error

    # Docs for s
    string s;
};

# Define a constant
# # Deprecated parameters
# + CONST5 - deprecated CONST5          // Compile error
# # Deprecated
@deprecated
const string CONST5 = "CONST5"; // @error

# Define a type
# # Deprecated parameters
# + TypeFoo - deprecated TypeFoo          // Compile error
# # Deprecated
@deprecated
public type TypeFoo CONST2; // @error

# Define a type
# # Deprecated parameters
# + i - deprecated i                    // Compile error
int i = 0; // @error

class Listener {

    public function attach(service object {} s, string[]|string? name) returns error? {

    }

    public function detach(service object {} s) returns error? {

    }

    public function 'start() returns error? {

    }

    public function gracefulStop() returns error? {

    }

    public function immediateStop() returns error? {

    }
}

# This is a test service
#
# # Deprecated parameters
# + x - deprecated x
# # Deprecated // @error
service /s on new Listener() { // @error

}

# The `Employee` is a user-defined record type
#
# + name - Employee name
# + id - Employee id number
# # Deprecated parameters       // warning
# + name - deprecated
# # Deprecated
@deprecated
type Employee record {| // @error
    @deprecated
    string name;
    int id;
|};

type Employee1 record {|
    # Describe the field here
    @deprecated                 // warning
    string name; // @error
    int id;
|};

type Employee2 record {|
    # Describe the field here
    # # Deprecated
    @deprecated
    string name;
    # Describe the field here
    # # Deprecated              // warning // @error
    int id;
|};
