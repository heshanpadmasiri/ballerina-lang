type Foo record {|
    Bar x;
|};

type Bar record {|
    *Foo;
|};

function testCyclicInclusionViaFieldWithTypeReferenceTypesNegative() {
    Foo f = {}; // @error
    f.x = 1; // @error

    Foo _ = {x: 1}; // @error

    Foo _ = {x: {x: 1}}; // @error
}

public type ErrorRecord record {
    string code?;
    record {
        *ErrorRecord;
    } innerError;
};

function testCyclicInclusionViaFieldWithAnonymousTypesNegative() {
    ErrorRecord e = {code: "NotFound"}; // @error
    e.innerError = 1; // @error

    var nilableInnerError = e.innerError;
    int _ = nilableInnerError;
}
