function testIncompatibleTypes() {
    future<Bar> f1 = start getFoo(); // @error incompatible types: expected 'future<Bar>', found 'future<Foo>'
    future<int|string|error> f2 = start getFooOrBar(); // @error incompatible types: expected 'future<(int|string|error)>', found 'future<(Foo|Bar)>'

    future<Foo> f3 = f1; // @error incompatible types: expected 'future<Foo>', found 'future<Bar>'
    future<int|string> f4 = f2; // @error incompatible types: expected 'future<(int|string)>', found 'future<(int|string|error)>'

    future f5 = f1;
    future<Bar> f6 = f5; // @error incompatible types: expected 'future<Bar>', found 'future<(any|error)>'
}

type Foo record {
    int i;
};

type Bar record {|
    float f;
|};

function getFoo() returns Foo => {i: 1, "j": "hello"};

function getFooOrBar() returns Foo|Bar => {i: 1, "j": "hello"};
