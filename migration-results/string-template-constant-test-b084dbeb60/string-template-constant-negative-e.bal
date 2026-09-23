const v1 = {a:4};
const v2 = string `hello${v1}`; // @error

boolean bool = true;
const v3 = string `This is ${bool}`; // @error
const v4 = string `This is ${foo()}`; // @error

function foo() returns boolean {
    return false;
}

final string baz = "FOO";
string gim = "BAR";
const A = string `${baz}:${gim}`; // @error
