// Copyright (c) 2020 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

type CustomErrorData record {|
    string message?;
    error cause?;
    int accountID?;
|};

type CustomError distinct error<CustomErrorData>;
type CustomError1 distinct error<CustomErrorData>;

class Iterator {
    int i = 0;
    public isolated function next() returns record {| int value; |}? {
        self.i += 1;
        return { value: self.i };
    }
}

function testIterator() {
    Iterator itr = new();
    // correct
    var streamA = new stream<int>(itr);
    stream<int> streamB = new(itr);

    record {| int value; |}|error? returnedVal = streamA.next();
    returnedVal = streamB.next();
}

class IteratorWithCustomError {
    int i = 0;
    public isolated function next() returns record {| int value; |}|CustomError? {
        self.i += 1;
        if (self.i == 2) {
            CustomError e = error CustomError("CustomError", message = "custom error occured", accountID = 1);
            return e;
        } else {
            return { value: self.i };
        }
    }
}

function testIteratorWithCustomError() {
    IteratorWithCustomError itr = new();

    // correct
    var streamA = new stream<int, CustomError?>(itr);
    stream<int, CustomError?> streamB = new(itr);

    var streamC = new stream<int, error?>(itr);
    stream<int, error?> streamD = new(itr);

    record {| int value; |}|CustomError? returnedValA = streamA.next();
    returnedValA = streamB.next();

    record {| int value; |}|error? returnedValB = streamC.next();
    returnedValB = streamD.next();

    // incorrect (next returns record {| int value; |}|CustomError?)
    record {| int value; |}? returnedValC = streamC.next(); // @error

    // incorrect (error type should be there in the stream<int, ?>)
    var streamE = new stream<int>(itr); // @error
    stream<int> streamF = new(itr); // @error
}

class IteratorWithGenericError {
    int i = 0;

    public isolated function next() returns record {| int value; |}|error? {
        self.i += 1;
        if (self.i == 2) {
            return error("GenericError", message = "generic error occured");
        } else {
            return { value: self.i };
        }
    }
}

function testIteratorWithGenericError() {
    IteratorWithGenericError itr = new();

    // correct
    var streamA = new stream<int, error?>(itr);
    stream<int, error?> streamB = new(itr);

    record {| int value; |}|error? returnedValA = streamA.next();
    returnedValA = streamB.next();

    // incorrect (next returns record {| int value; |}|error?)
    record {| int value; |}|CustomError? returnedValB = streamA.next(); // @error
    record {| int value; |}? returnedValC = streamB.next(); // @error

    // incorrect (itr returns an `error` instead of `CustomError`)
    var streamC = new stream<int, CustomError?>(itr); // @error
    stream<int, CustomError?> streamD = new(itr); // @error

    // incorrect (error type should be there in the stream<int, ?>)
    var streamE = new stream<int>(itr); // @error
    stream<int> streamF = new(itr); // @error
}

class IteratorWithOutError {
    int i = 0;

    public isolated function next() returns record {| int value; |}? {
        self.i += 1;
        return { value: self.i };
    }
}

function testIteratorWithOutError() {
    IteratorWithOutError itr = new();

    // correct
    var streamA = new stream<int>(itr);
    stream<int> streamB = new(itr);

    record {| int value; |}? returnedValA = streamA.next();
    returnedValA = streamB.next();

    // incorrect (error type shouldn't be there)
    var streamC = new stream<int, error?>(itr);
    stream<int, error?> streamD = new(itr);
    var streamE = new stream<int, CustomError?>(itr);
    stream<int, CustomError?> streamF = new(itr);

    // incorrect (next returns record {| int value; |}?)
    record {| int value; |}|error? returnedValB = streamA.next();
    record {| int value; |}|CustomError? returnedValC = streamB.next();
}

class IteratorWithOutNext {
    int i = 10;

    public function prev() returns record {| int value; |}? {
        self.i -= 1;
        return { value: self.i };
    }
}

function testIteratorWithOutNext() {
    IteratorWithOutNext itr = new();
    // incorrect (itr doesn't have a next() method implemented)
    var streamA = new stream<int>(itr); // @error
    stream<int> streamB = new(itr); // @error
    var streamC = new stream<int, error?>(itr); // @error
    stream<int, error?> streamD = new(itr); // @error
    var streamE = new stream<int, CustomError?>(itr); // @error
    stream<int, CustomError?> streamF = new(itr); // @error
}

class IteratorWithMismatchedNextA {
    int i = 0;
    public function next(int i) returns record {| int value; |}? {
        self.i += 1;
        return { value: self.i };
    }
}

function testIteratorWithMismatchedNextA() {
    IteratorWithMismatchedNextA itr = new();
    // incorrect (`next(int i)` of itr, doesn't match with `next()`)
    var streamA = new stream<int>(itr); // @error
    stream<int> streamB = new(itr); // @error
    var streamC = new stream<int, error?>(itr); // @error
    stream<int, error?> streamD = new(itr); // @error
    var streamE = new stream<int, CustomError?>(itr); // @error
    stream<int, CustomError?> streamF = new(itr); // @error
}

class IteratorWithMismatchedNextC {
    int i = 0;

    public isolated function next() returns record {| int val; |}|CustomError? {
        self.i += 1;
        return { value: self.i }; // @error
    }
}

function testIteratorWithMismatchedNextC() {
    IteratorWithMismatchedNextC itr = new();
    // correct
    var streamA = new stream<int, error?>(itr); // @error
    stream<int, error?> streamB = new(itr); // @error

    // incorrect (`return type of `next()` of itr, doesn't match with value type)
    var streamC = new stream<string, error?>(itr); // @error
    stream<string, error?> streamD = new(itr); // @error
    var streamE = new stream<string, CustomError?>(itr); // @error
    stream<string, CustomError?> streamF = new(itr); // @error
}

class IteratorWithMismatchedError {
    int i = 0;

    public isolated function next() returns record {| int value; |}|CustomError? {
        self.i += 1;
        return { value: self.i };
    }
}

function testIteratorWithMismatchedError() {
    IteratorWithMismatchedError itr = new();
    // correct
    var streamA = new stream<int, CustomError?>(itr);
    stream<int, CustomError?> streamB = new(itr);

    var streamC = new stream<int, error?>(itr);
    stream<int, error?> streamD = new(itr);

    // incorrect (`CustomError` & `CustomError1` doesn't match)
    var streamE = new stream<string, CustomError1?>(itr); // @error
    stream<string, CustomError1?> streamF = new(itr); // @error
}

function testInvalidStreamConstructor() {
    IteratorWithOutError itr = new();

    // correct
    var streamA = new stream<int>(itr);
    stream<int> streamB = new(itr);

    // incorrect (`IteratorWithOutError` does not return an error from next() method)
    var streamC = new stream<int, CustomError?>(itr);
    stream<int, CustomError?> streamD = new(itr);
}


function testInvalidStreamConstructs() returns boolean {
    IteratorWithOutError itr = new();
    stream<int> stream1 = new(itr, itr); // @error
    stream<int> stream2 = new stream<int>(itr, itr); // @error
    stream<int, never> stream3 = new(itr, itr); // @error
    stream<int, error?> stream4 = new(itr, itr); // @error
    stream<int, never> stream5 = new stream<int, never>(itr, itr); // @error
    stream<int, error?> stream6 = new stream<int, error?>(itr, itr); // @error
    var stream7 = new stream<int>(itr, itr); // @error
    var stream8 = new stream<int, never>(itr, itr); // @error
    var stream9 = new stream<int, error?>(itr, itr); // @error
}

class IteratorWithIsolatedNext {
    int i = 0;
    public isolated function next() returns record {|int value;|}|error? {
        if (self.i == 5) {
            return ();
        }
        self.i += 1;
        return {value: self.i};
    }
}

class IteratorWithIsolatedNextAndIsolatedClose {
    int i = 0;
    public isolated function next() returns record {|int value;|}|error? {
        if (self.i == 5) {
            return ();
        }
        self.i += 1;
        return {value: self.i};
    }

    public isolated function close() returns error? {

    }
}

class IteratorWithNonIsolatedNext {
    int i = 0;
    public function next() returns record {|int value;|}|error? {
        if (self.i == 5) {
            return ();
        }
        self.i += 1;
        return {value: self.i};
    }
}

class IteratorWithNonIsolatedNextAndIsolatedClose {
    int i = 0;
    public function next() returns record {|int value;|}|error? {
        if (self.i == 5) {
            return ();
        }
        self.i += 1;
        return {value: self.i};
    }

    public isolated function close() returns error? {

    }
}

class IteratorWithIsolatedNextAndNonIsolatedClose {
    int i = 0;
    public isolated function next() returns record {|int value;|}|error? {
        if (self.i == 5) {
            return ();
        }
        self.i += 1;
        return {value: self.i};
    }

    public function close() returns error? {

    }
}

class InvalidNumberGenerator { // @error
    int i = 0;
    public isolated function next() returns record {| int value; |} {
        self.i += 1;
        return {value: self.i};
    }
}

class InvalidNumberStreamGenerator { // @error
    int i = 0;
    public isolated function next() returns record {| stream<int> value;|} {
        self.i += 1;
        InvalidNumberGenerator numGen = new();
        stream<int> numberStream = new(numGen);
        return {value: numberStream};
    }
}

public function main() returns @tainted error? {
    IteratorWithIsolatedNext itr1 = new;
    IteratorWithIsolatedNextAndIsolatedClose itr2 = new;
    IteratorWithNonIsolatedNext itr3 = new;
    IteratorWithNonIsolatedNextAndIsolatedClose itr4 = new;
    IteratorWithIsolatedNextAndNonIsolatedClose itr5 = new;
    var intStr1 = new stream<int, error?>(itr1);
    var intStr2 = new stream<int, error?>(itr2);
    var intStr3 = new stream<int, error?>(itr3); // @error
    var intStr4 = new stream<int, error?>(itr4); // @error
    var intStr5 = new stream<int, error?>(itr5); // @error

    InvalidNumberStreamGenerator n = new ();
    stream<stream<int>> numberStream = new (n);
    var x = numberStream.next();
}

function testAssignabilityOfStreams() {
    // test the negative assignability of stream<int> and stream<int, ())>
    stream<int> emptyStream1 = new;
    stream<int> emptyStream2 = new stream<int>();
    stream<int, ()> emptyStream3 = new;
    stream<int, error?> emptyStream4 = new;
    stream<int, ()> emptyStream5 = new stream<int, ()>();
    stream<int, error?> emptyStream6 = new stream<int, error?>();
    var emptyStream7 = new stream<int>();
    var emptyStream8 = new stream<int, ()>();
    var emptyStream9 = new stream<int, error?>();

    emptyStream1 = emptyStream6; // @error
    emptyStream2 = emptyStream9; // @error
    emptyStream3 = emptyStream6; // @error
    emptyStream4 = emptyStream1;
    emptyStream5 = emptyStream6; // @error
    emptyStream7 = emptyStream9; // @error
    emptyStream8 = emptyStream9; // @error
}

function testNonIteratorsInStreamConstructor() {
    stream<int> intStrm = new("test"); // @error
}

function testUnboundedStreamWithEmptyConstructor() {
    stream<int, error?> _ = new;
    stream<int, error?> _ = new stream<int, error?>();
    stream<int, readonly> _ = new stream<int, readonly>(); // @error
    var _ = new stream<int, error?>();
    stream<int, error> _ = new stream<int, error>(); // @error
}
