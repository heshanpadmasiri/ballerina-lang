function foo() returns string => "Foo";
function bar() returns string => "Bar";

function testAssignValueToFunctionIdentifierNegative() {
    foo = function() returns string => "Bar"; // @error
    foo = foo; // @error
    [foo, bar] = [function() returns string => "Bar", bar]; // @error // @error
}

type BarRec record {|
    function() returns string func;
    int id;
|};

function testAssignValueToFunctionIdentifierInMapBindingPatternNegative() {
    int n;
    BarRec rec = {func : function() returns string => "Bar", id : 1};
    {func : foo, id : n} = rec; // @error
}

type TestError error<BarRec>;

function testAssignValueToFunctionIdentifierInErrorBindingPatternNegative() {
    string reason;
    int n;
    TestError testError = error("Error", func = function() returns string => "Bar", id = 1);
    error(reason, func = foo, id = n) = testError; // @error
}
