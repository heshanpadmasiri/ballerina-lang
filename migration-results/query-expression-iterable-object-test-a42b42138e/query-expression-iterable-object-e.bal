import ballerina/lang.'object;

class IterableObject {
    public function iterator() returns object {
        public isolated function next() returns record {|int value;|}?;
    } {
        return object {
            int[] integers = [12, 34, 56, 34, 78, 21, 90];
            int cursorIndex = 0;
            public isolated function next() returns record {|int value;|}? {
                self.cursorIndex += 1;
                if self.cursorIndex <= 7 {
                    return {value: self.integers[self.cursorIndex - 1]};
                }
                return ();
            }
        };
    }
}

public function testIterableObject() returns int[] {
    IterableObject p = new IterableObject();
    int[] integers = from var item in p select item; // @error
    return integers;
}

class AnotherIterable {
    *object:Iterable;
    public function iterator() returns object {
        public isolated function next() returns record {|IterableObject value;|}?;
    } {
        return object {
            int cursorIndex = 0;
            public isolated function next() returns record {|IterableObject value;|}? {
                self.cursorIndex += 1;
                if self.cursorIndex <= 2 {
                    return {value: new IterableObject()};
                }
                return ();
            }
        };
    }
}

public function testNestedIterableObject() returns int[] {
    AnotherIterable p = new AnotherIterable();
    int[] integers = from var itr in p
                     from var item in itr // @error
                     select item;
    return integers;
}

public type _Iterator object {
    public isolated function next1() returns record {|any|error value;|}|error?;
};

class IterableFromIterator {
    *object:Iterable;
    _Iterator itr;
    public function init(_Iterator itr) {
        self.itr = itr;
    }
    public function iterator() returns _Iterator { // @error
        return self.itr;
    }
}
