type UserInfo record {|
    string username;
    anydata password;
|};

type Person record {|
    readonly UserInfo user;
|};

configurable anydata var1 = 2;
configurable anydata[] arrayVar = ?;

configurable UserInfo admin = ?;
configurable Person person = ?;

configurable map<anydata> & readonly mapVar = ?;

configurable table<map<anydata>> tableVar1 = ?;
configurable table<Person> key(user) tableVar2 = ?;

configurable string|int|Person unionVar1 = ?;
configurable anydata|Person unionVar2 = ?;

enum HttpVersion {
    HTTP_1_1,
    HTTP_2
}

type ClientConfiguration record {|
    HttpVersion httpVersion?;
    map<anydata> customHeaders;
|};

configurable table<ClientConfiguration> tableVar = ?;

type Parent record {|
    string name;
    Parent child?;
|};

configurable Parent p = ?;

type CyclicUnion int|CyclicUnion[];

configurable CyclicUnion unionVar = ?;

configurable [int, string, float, decimal, anydata] a = ?;

type Student record {|
    () field1 = ();
    string? field2 = "default value";
|};

configurable () nilVar = ();
configurable ()[] nilArr = [];
configurable string? nilUnion = "abc";
configurable map<()> nilMap = {};
configurable Student nilRecord1 = ?;
configurable Student nilRecord2 = {field1: (), field2: "abc"};
configurable table<map<()>> nilTable = table [];

function compilationOnlySentinel() {
    int unused = 0; // @error
}
