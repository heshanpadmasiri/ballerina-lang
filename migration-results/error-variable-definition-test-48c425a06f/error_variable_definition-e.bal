type SMS error <record {| string message?; error cause?; string...; |}>;
type SMA error <record {| string message?; error cause?; anydata...; |}>;

function testBasicErrorVariableWithMapDetails() {
    SMS err1 = error SMS("Error One", message = "Msg One", detail = "Detail Msg"); // @error
    SMA err2 = error SMA("Error Two", message = "Msg Two", fatal = true); // @error
    SMS error (reason11, ... detail11) = err1;
    SMS error (reason12) = err1;
    SMA error (reason11, ... detail21) = err2; // @error
    SMS error (reason22, detail = detail22, extra = extra22) = err2; // @error
    boolean reasonTest = reason12; // @error
}

function testBasicErrorVariable() {
    SMS err1 = error SMS("Error One", message = "Msg One", detail = "Detail Msg"); // @error
    SMA err2 = error SMA("Error Two", message = "Msg Two", fatal = true); // @error
    var error (reason11, ... detail11) = err1;
    var error (reason12,
        detail = detail12, // @error
        extra = extra12) = err1; // @error
    var error (reason11, ... detail21) = err2; // @error
    var error (reason22,
        detail = detail22, // @error
        extra = extra22) = err2; // @error
    boolean reasonTest = reason12; // @error
    string detailMessage = detail12; // @error
}

function testBasicErrorVariable2() {
    error err1 = error("Error One", message = "Msg One", detail = "Detail Msg");
    var error (reason11, ... detail11) = err1;
    var error (reason12,
        message = message12, // @error
        detail = detail12, // @error
        extra = extra12) = err1; // @error
    var error (reason13, message = message, ...rest) = err1; // @error
    var error (reason14, message = message, ...rest2) = err1; // @error // @error
    int detail = detail11; // @error
    var error (reason11, detail = detail11) = 12; // @error
}

function errorVarInTupleVar() {
    [int, error] tuple = [100, error("Error Code")];
    var [a, error(reason, message = message)] = tuple;
    boolean r = reason; // @error
    string m = message; // @error
}

function errorVarWithConstrainedMap() {
    error err = error("Error Code", message = "Fatal");
    var error (reason, message = message) = err; // @error
    string m = message; // @error
}
