type Detail record { string x; };
type DetailTwo record {| int x?; string...; |};
type DetailThree record { int x; };
type DetailTypeFour map<string>;
type ErrorOne error<Detail>;
type ErrorTwo error<DetailTwo>;
type ErrorThree error<DetailThree>;
type ErrorFour error<record { int x; }>;
type ErrorFive error<DetailTypeFour>;

type IntersectionError ErrorOne & ErrorTwo; // @error
type IntersectionErrorTwo ErrorOne & ErrorThree; // @error
type IntersectionErrorThree ErrorOne & ErrorFour; // @error
type IntersectionErrorFour ErrorOne & ErrorFive;
type DistinctErrorIntersection distinct (ErrorOne & ErrorFive);

function testRecordAndMapIntersection() {
    var err = error IntersectionErrorFour("message", x = "x", z = 10); // @error // @error
    DistinctErrorIntersection err2 = error IntersectionErrorFour("message", x = "x"); // @error
}

type DetailX record { string x = "defaultt"; };
type DetailY record { string x; string y; };
type ErrorX error<DetailX>;
type ErrorY error<DetailY>;
type IntersecDefaultValedDetail ErrorX & ErrorY; // @error // @error
type IntersecDefaultValedDetailInline error<DetailX> & error<DetailY>; // @error // @error
type IntersecDefaultValedDetailInlineMixed error<DetailY> & error<DetailX> & ErrorX; // @error // @error
type CloseDetailWithBuildInDetail error & ErrorX; // @error // @error
type CloseDetailWithBuildInDetail2 ErrorX & error; // @error // @error
type E distinct error;
type EDash distinct (E & ErrorX); // @error // @error

type ErrorIntersectionWithReadOnly readonly & error<record { int code; }> & readonly;
type MyError1 error<record { int code; }>;
type MyError2 error<record {| boolean fatal?; int...; |}>;
type MultipleErrorIntersectionWithReadOnly MyError2 & MyError1 & readonly;
function testInvalidArgsForErrorIntersectionWithReadOnly() {
    ErrorIntersectionWithReadOnly a = error("e1"); // @error
    error<record { int code; }> & readonly b = error("e2", c = 123); // @error // @error
    MultipleErrorIntersectionWithReadOnly c = error("e3"); // @error
    MultipleErrorIntersectionWithReadOnly d = error("e4", fatal = false); // @error
    MultipleErrorIntersectionWithReadOnly e = error("e5", oth = false); // @error // @error // @error
}
