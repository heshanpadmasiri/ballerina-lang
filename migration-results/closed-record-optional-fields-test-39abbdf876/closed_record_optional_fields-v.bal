import ballerina/io;

type CountryCode "LK"|"USA"|"UK";

type Person record {|
    string fname = "default";
    string lname?;
    Address adrs = {};
|};

type Address record {|
    string street = "";
    string city = "";
    CountryCode country = "LK";
|};

function testNonDefReqField() returns Person {
    Person p = {adrs: {country: "LK"}};
    return p;
}

function testNonDefReqField2() returns Person {
    Person p = {fname: "John", lname: "Doe", adrs: {country: "LK"}};
    return p;
}

type Person2 record {|
    string fname = "default";
    string lname?;
    Address2 adrs = {};
|};

type Address2 record {|
    string street = "";
    string city = "";
    CountryCode country = "LK";
|};

function testDefaultableReqField() returns Person2 {
    Person2 p = {};
    return p;
}

type Person3 record {|
    string fname = "default";
    string lname?;
    Address3 adrs?;
|};

type Address3 record {|
    string street = "";
    string city = "";
    CountryCode country = "LK";
|};

function testOptionalNonDefField() returns Person3 {
    Person3 p = {};
    return p;
}

function testOptionalNonDefField4() returns [Address3, Address3] {
    Person3 p = {adrs: {street: "Palm Grove", city: "Colombo 3"}};
    Address3 a = <Address3>p.get("adrs");
    Address3 b = <Address3>p?.adrs;
    return [a, b];
}

type Person4 record {|
    string fname = "default";
    string lname?;
    Address4 adrs?;
|};

type Address4 record {|
    string street = "";
    string city = "";
    CountryCode country = "LK";
|};

function testOptionalDefaultableField() returns Person4 {
    Person4 p = {};
    return p;
}

public function main() {
    Person nonDefReqField = testNonDefReqField();
    io:println(nonDefReqField.fname); // @output default
    io:println(nonDefReqField.lname); // @output
    io:println(nonDefReqField.hasKey("age") ? nonDefReqField.get("age") : ()); // @output
    io:println(nonDefReqField.adrs.street); // @output 
    io:println(nonDefReqField.adrs.city); // @output 
    io:println(nonDefReqField.adrs.country); // @output LK

    Person nonDefReqField2 = testNonDefReqField2();
    io:println(nonDefReqField2.fname); // @output John
    io:println(nonDefReqField2.lname); // @output Doe
    io:println(nonDefReqField2.hasKey("age") ? nonDefReqField2.get("age") : ()); // @output
    io:println(nonDefReqField2.adrs.street); // @output 
    io:println(nonDefReqField2.adrs.city); // @output 
    io:println(nonDefReqField2.adrs.country); // @output LK

    Person2 defaultableReqField = testDefaultableReqField();
    io:println(defaultableReqField.fname); // @output default
    io:println(defaultableReqField.lname); // @output
    io:println(defaultableReqField.hasKey("age") ? defaultableReqField.get("age") : ()); // @output
    io:println(defaultableReqField.adrs.street); // @output 
    io:println(defaultableReqField.adrs.city); // @output 
    io:println(defaultableReqField.adrs.country); // @output LK

    Person3 optionalNonDefField = testOptionalNonDefField();
    io:println(optionalNonDefField.fname); // @output default
    io:println(optionalNonDefField.lname); // @output
    io:println(optionalNonDefField.hasKey("age") ? optionalNonDefField.get("age") : ()); // @output
    io:println(optionalNonDefField.adrs); // @output

    [Address3, Address3] optionalNonDefField4 = testOptionalNonDefField4();
    io:println(optionalNonDefField4[0]); // @output {"street":"Palm Grove","city":"Colombo 3","country":"LK"}
    io:println(optionalNonDefField4[0] is record {}); // @output true
    io:println(typeof optionalNonDefField4[0]); // @output typedesc Address3
    io:println(optionalNonDefField4[1]); // @output {"street":"Palm Grove","city":"Colombo 3","country":"LK"}
    io:println(optionalNonDefField4[1] is record {}); // @output true
    io:println(typeof optionalNonDefField4[1]); // @output typedesc Address3

    Person4 optionalDefaultableField = testOptionalDefaultableField();
    io:println(optionalDefaultableField.fname); // @output default
    io:println(optionalDefaultableField.lname); // @output
    io:println(optionalDefaultableField.hasKey("age") ? optionalDefaultableField.get("age") : ()); // @output
    io:println(optionalDefaultableField.adrs); // @output
}
