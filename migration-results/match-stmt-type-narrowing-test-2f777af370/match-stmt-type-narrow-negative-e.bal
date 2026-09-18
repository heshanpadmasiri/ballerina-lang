type Insn record {
    string op;
};

function testMatchClauseWithTypeGuardNegative1(Insn insn) returns string? {
    match insn {
        var {op} if op is "+" => { return "+"; }
        var {op} if op is "+" => { return "-"; } // @error
    }
    return ();
}

const ONE = 1;
const ONE2 = 1;

function testMatchClauseWithTypeGuardNegative2() {
    int value = 1;
    match value {
        var a if a is ONE => {
        }
        var a if a is ONE => { // @error
        }
    }
}

function testMatchClauseWithTypeGuardNegative3() {
    int value = 1;
    match value {
        var a if a is ONE2 => {
        }
        var a if a is ONE => { // @error
        }
    }
}

function testMatchClauseWithTypeGuardNegative4() {
    int value = 1;
    match value {
        var a if a is 1|2 => {
        }
        var a if a is 1|2 => { // @error
        }
    }
}

type A 3|4;
type B 3|4;

function testMatchClauseWithTypeGuardNegative5() {
    int value = 3;
    match value {
        var a if a is A => {
        }
        var a if a is B => { // @error
        }
    }
}

function testMatchClauseWithTypeGuardNegative6() {
    int value = 3;
    match value {
        var a if a is int|string => {
        }
        var a if a is int|string => { // @error
        }
    }
}

function testMatchClauseWithTypeGuardNegative7() {
    int[] value = [1, 2, 3];
    match value {
        var a if a is [1, 2, 3] => {
        }
        var a if a is [1, 2, 3] => { // @error
        }
    }

    match value {
        var a if a is int[] => {
        }
        var a if a is int[] => { // @error
        }
    }
}

type Person record {|
    string name;
    int age;
    string address;
|};

function testMatchClauseWithTypeGuardNegative8(Person p) {
    match p {
        {name: var a, ...var b} if a is "John" => { // @error
        }
        {name: var a, ...var b} if a is "John" => { // @error
        }
    }

    match p {
        var {name, age, ...rest} if age is A => { // @error
        }
        var {name, age, ...rest} if age is B => { // @error
        }
    }
}

type C 1|2|1;
type D 1|2;

function testMatchClauseWithTypeGuardNegative9() {
    int value = 2;
    match value {
        var a if a is C => {
        }
        var a if a is D => { // @error
        }
    }

    match value {
        var a if a is int|string => {
        }
        var a if a is string|int|string => { // @error
        }
    }
}
