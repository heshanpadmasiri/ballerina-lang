client class Foo1 {
    any val;

    function init(any val) {
        self.val = val;
    }

    remote function getValue() returns any {
        return self.val;
    }
}

function testCastingToIncorrectType() {
    Foo1 foo = new(100);
    string s = <string>foo->getValue(); // @panic
}

public function main() {
    testCastingToIncorrectType();
}
