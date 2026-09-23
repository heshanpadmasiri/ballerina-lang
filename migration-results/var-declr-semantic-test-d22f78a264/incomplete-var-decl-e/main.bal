import testorg/vardef.test as test;

function foo() {
    test:Caller c1 = new test:L // @error
    test:Caller c2 = new test: // @error
} // @error // @error // @error // @error // @error // @error // @error
