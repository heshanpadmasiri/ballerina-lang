import ballerina/io;
import ballerina/lang.'object;

class Iterable {
    *object:Iterable;
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
    Iterable p = new Iterable();
    return from var item in p select item;
}

class AnotherIterable {
    *object:Iterable;
    public function iterator() returns object {
        public isolated function next() returns record {|Iterable value;|}?;
    } {
        return object {
            int cursorIndex = 0;
            public isolated function next() returns record {|Iterable value;|}? {
                self.cursorIndex += 1;
                if self.cursorIndex <= 2 {
                    return {value: new Iterable()};
                }
                return ();
            }
        };
    }
}

public function testNestedIterableObject() returns int[] {
    AnotherIterable p = new AnotherIterable();
    return from var itr in p
           from var item in itr
           select item;
}

class IterableWithError {
    *object:Iterable;
    public function iterator() returns object {
        public isolated function next() returns record {|int value;|}|error?;
    } {
        return object {
            int[] integers = [12, 34, 56, 34, 78];
            int cursorIndex = 0;
            public isolated function next() returns record {|int value;|}|error? {
                self.cursorIndex += 1;
                if self.cursorIndex == 3 {
                    return error("Custom error thrown.");
                } else if self.cursorIndex <= 5 {
                    return {value: self.integers[self.cursorIndex - 1]};
                }
                return ();
            }
        };
    }
}

public function testIterableWithError() {
    IterableWithError p = new IterableWithError();
    int[]|error integers = from var item in p select item;
    if integers is error {
        return;
    }
    panic error("Expected error, found: " + (typeof integers).toString());
}

class NumberGenerator {
    int i = 0;
    public isolated function next() returns record {|int value;|}? {
        self.i += 1;
        if self.i < 5 {
            return {value: self.i};
        }
        return ();
    }
}

class NumberStreamGenerator {
    int i = 0;
    public isolated function next() returns record {|stream<int> value;|}? {
        self.i += 1;
        if self.i < 5 {
            NumberGenerator numGen = new;
            stream<int> numberStream = new (numGen);
            return {value: numberStream};
        }
        return ();
    }
}

public function testStreamOfStreams() returns int[] {
    NumberStreamGenerator numStreamGen = new;
    stream<stream<int>> numberStream = new (numStreamGen);
    record {|stream<int> value;|}? nextStream = numberStream.next();
    return from var strm in numberStream
           from var num in liftError(toArray(strm))
           select <int>num;
}

function toArray(stream<any|error, error?> strm) returns any[]|error {
    any[] arr = [];
    record {|any|error value;|}|error? v = strm.next();
    while v is record {|any|error value;|} {
        any|error value = v.value;
        if !(value is error) {
            arr.push(value);
        }
        v = strm.next();
    }
    if v is error {
        return v;
    }
    return arr;
}

function liftError(any[]|error arrayData) returns any[] {
    if !(arrayData is error) {
        return arrayData;
    }
    return [];
}

public type _Iterator object {
    public isolated function next() returns record {|any|error value;|}|error?;
};

class IterableFromIterator {
    *object:Iterable;
    _Iterator itr;
    public function init(_Iterator itr) {
        self.itr = itr;
    }
    public function iterator() returns _Iterator {
        return self.itr;
    }
}

function getIterableObject(_Iterator iterator) returns IterableFromIterator {
    return new IterableFromIterator(iterator);
}

public function testIteratorInStream() returns int[]|error {
    int[] intArray = [1, 2, 3, 4, 5];
    stream<int> numberStream = intArray.toStream();
    return from var num in getIterableObject(numberStream.iterator())
           select <int>checkpanic num;
}

class MyIterable {
    *object:Iterable;
    public function iterator() returns object {
        public function next() returns record {|int value;|}?;
    } {
        return new MyIterator();
    }
}

int i = 0;

public class MyIterator {
    public function next() returns record {|int value;|}? {
        i += 1;
        if i < 5 {
            return {value: i};
        }
        return ();
    }
}

public function testObjectIterator() {
    int[] expectedArr = [1, 2, 3, 4];
    int[] integers = from var item in new MyIterable() select item;
    assertEquality(integers, expectedArr);
}

const ASSERTION_ERROR_REASON = "AssertionError";

function assertEquality(any|error expected, any|error actual) {
    if expected is anydata && actual is anydata && expected == actual {
        return;
    }
    if expected === actual {
        return;
    }
    string expectedValAsString = expected is error ? expected.toString() : expected.toString();
    string actualValAsString = actual is error ? actual.toString() : actual.toString();
    panic error(ASSERTION_ERROR_REASON,
        message = "expected '" + expectedValAsString + "', found '" + actualValAsString + "'");
}

public function main() returns error? {
    int[] iterableObject = testIterableObject();
    io:println(iterableObject[0]); // @output 12
    io:println(iterableObject[1]); // @output 34
    io:println(iterableObject[2]); // @output 56
    io:println(iterableObject[3]); // @output 34
    io:println(iterableObject[4]); // @output 78
    io:println(iterableObject[5]); // @output 21
    io:println(iterableObject[6]); // @output 90

    int[] nestedIterableObject = testNestedIterableObject();
    io:println(nestedIterableObject[0]); // @output 12
    io:println(nestedIterableObject[1]); // @output 34
    io:println(nestedIterableObject[2]); // @output 56
    io:println(nestedIterableObject[3]); // @output 34
    io:println(nestedIterableObject[4]); // @output 78
    io:println(nestedIterableObject[5]); // @output 21
    io:println(nestedIterableObject[6]); // @output 90
    io:println(nestedIterableObject[7]); // @output 12
    io:println(nestedIterableObject[8]); // @output 34
    io:println(nestedIterableObject[9]); // @output 56
    io:println(nestedIterableObject[10]); // @output 34
    io:println(nestedIterableObject[11]); // @output 78
    io:println(nestedIterableObject[12]); // @output 21
    io:println(nestedIterableObject[13]); // @output 90

    testIterableWithError();

    int[] streamOfStreams = testStreamOfStreams();
    io:println(streamOfStreams[0]); // @output 1
    io:println(streamOfStreams[1]); // @output 2
    io:println(streamOfStreams[2]); // @output 3
    io:println(streamOfStreams[3]); // @output 4
    io:println(streamOfStreams[4]); // @output 1
    io:println(streamOfStreams[5]); // @output 2
    io:println(streamOfStreams[6]); // @output 3
    io:println(streamOfStreams[7]); // @output 4
    io:println(streamOfStreams[8]); // @output 1
    io:println(streamOfStreams[9]); // @output 2
    io:println(streamOfStreams[10]); // @output 3
    io:println(streamOfStreams[11]); // @output 4

    int[] iteratorInStream = check testIteratorInStream();
    io:println(iteratorInStream[0]); // @output 1
    io:println(iteratorInStream[1]); // @output 2
    io:println(iteratorInStream[2]); // @output 3
    io:println(iteratorInStream[3]); // @output 4
    io:println(iteratorInStream[4]); // @output 5

    testObjectIterator();
}
