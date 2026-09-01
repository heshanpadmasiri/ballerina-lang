type SMS error<record {| string message; error cause?; string detail; string extra?; |}>;
type BarError error<record {string message; error cause?; int code;}>;
type BazError error<record {string message; int abc; anydata def?;}>;

function testDuplicateBinding() {
    string? s; // @error
    SMS err1 = error SMS("Error One", message = "Msg One", detail = "Detail Msg");
    error(s, message = s, detail = s) = err1; // @error // @error
}

public function testAssigningValuesToFinalVars() {
    BazError e = error("ErrReason", message = "error message", abc = 1, def = 2.0);
    final var error(r, message = message, abc = abc) = e; // @error // @error // @error
    error(r, message = message, abc = abc) = e; // @error
    final var error(r2, message = message2, ...rest) = e; // @error // @error // @error
    BarError e3 = error BarError("bar", message = "error message", code = 1);
    final var error BarError(r3, message = message3) = e3; // @error // @error
    error(_, message = message3) = e3;
}
