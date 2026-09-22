type Song record {|
    string name;
    int length;
|};

function duplicateKeyTest1() {
     Song _ = {
         name: "hello",
         length: 1,
         name: "hello" // @error
     };
}

function duplicateKeyTest2() {
    Song hi; // @error
    hi = {
        name: "hi",
        length: 2,
        name: "hi" // @error
    };
}

function duplicateKeyTest3() {
     Song _ = {
         name: "hola",
         length: 1,
         "name": "hola" // @error
     };
}
