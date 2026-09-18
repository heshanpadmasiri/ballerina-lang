type UserDefinedError error<BasicErrorDetail>;
type BasicErrorDetail record {|
    int basicErrorNo;
    anydata...;
|};

string message1 = "my message one";
// Redeclare message1 inside error variable
UserDefinedError error(message1, basicErrorNo = detail1) = error UserDefinedError("error message one", basicErrorNo = 1); // @error
// Redeclare detail1 which is already declared inside error var
boolean detail1 = false; // @error

// Only simple variables are allowed to be isolated
isolated UserDefinedError error(message3, basicErrorNo = detail3) = error UserDefinedError("error message three", basicErrorNo = 3); // @error

// Only simple variables are allowed to be configurable
configurable UserDefinedError2 error(message4) = error UserDefinedError2("error message four"); // @error

const annotation annot on source function;

@annot // @error
UserDefinedError2 error(message5) = error UserDefinedError2("error message five");

UserDefinedError error(message7, basicErrorNo = errorNo2, ...otherDetails) = error UserDefinedError(
    message6, basicErrorNo = errorNo1); // @error // @error
var error(message6, basicErrorNo = errorNo1) = getError();
boolean n = false;

// Test incompatible types
type VarTestErrorDetail record {
    [int] fieldA;
    map<boolean> fieldB;
    error fieldC;
};

type VarTestError error<VarTestErrorDetail>;

var error(m, error(c), fieldA = {a: varA}, fieldD = {a: varB}) = foo(); // @error // @error

function foo() returns VarTestError =>
    error VarTestError("message", error("cause"), fieldA = [3], fieldC = error("fieldC message")); // @error

function getError() returns UserDefinedError {
    return error UserDefinedError("error message one", basicErrorNo = 1);
}

type UserDefinedError2 error<BasicErrorDetail2>;
type BasicErrorDetail2 record {|
    int basicErrorNo?;
    anydata...;
|};
