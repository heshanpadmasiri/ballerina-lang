import ballerina/io;

type CountryCode "LK"|"USA"|"UK";

type Person record {
    string fname = "default";
    string lname?;
    Address adrs = {};
};

type Address record {
    string street = "";
    string city = "";
    CountryCode country = "LK";
};

function testNonDefReqField() returns Person {
    Person p = {adrs: {country: "LK"}};
    return p;
}

function testNonDefReqField2() returns Person {
    Person p = {fname: "John", lname: "Doe", adrs: {country: "LK"}};
    return p;
}

type Person2 record {
    string fname = "default";
    string lname?;
    Address2 adrs = {};
};

type Address2 record {
    string street = "";
    string city = "";
    CountryCode country = "LK";
};

function testDefaultableReqField() returns Person2 {
    Person2 p = {};
    return p;
}

type Person3 record {
    string fname = "default";
    string lname?;
    Address3 adrs?;
};

type Address3 record {
    string street = "";
    string city = "";
    CountryCode country = "LK";
};

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

type Person4 record {
    string fname = "default";
    string lname?;
    Address4 adrs?;
};

type Address4 record {
    string street = "";
    string city = "";
    CountryCode country = "LK";
};

function testOptionalDefaultableField() returns Person4 {
    Person4 p = {};
    return p;
}

public function main() {
    Person nonDefReq = testNonDefReqField();
    io:println(nonDefReq.fname); // @output default
    io:println(nonDefReq.lname); // @output 
    io:println(nonDefReq.hasKey("age") ? nonDefReq.get("age") : ()); // @output
    io:println(nonDefReq.adrs.street); // @output 
    io:println(nonDefReq.adrs.city); // @output 
    io:println(nonDefReq.adrs.country); // @output LK

    Person nonDefReq2 = testNonDefReqField2();
    io:println(nonDefReq2.fname); // @output John
    io:println(nonDefReq2.lname); // @output Doe
    io:println(nonDefReq2.hasKey("age") ? nonDefReq2.get("age") : ()); // @output
    io:println(nonDefReq2.adrs.street); // @output 
    io:println(nonDefReq2.adrs.city); // @output 
    io:println(nonDefReq2.adrs.country); // @output LK

    Person2 defaultableReq = testDefaultableReqField();
    io:println(defaultableReq.fname); // @output default
    io:println(defaultableReq.lname); // @output 
    io:println(defaultableReq.hasKey("age") ? defaultableReq.get("age") : ()); // @output
    io:println(defaultableReq.adrs.street); // @output 
    io:println(defaultableReq.adrs.city); // @output 
    io:println(defaultableReq.adrs.country); // @output LK

    Person3 optionalNonDef = testOptionalNonDefField();
    io:println(optionalNonDef.fname); // @output default
    io:println(optionalNonDef.lname); // @output 
    io:println(optionalNonDef.hasKey("age") ? optionalNonDef.get("age") : ()); // @output
    io:println(optionalNonDef.adrs); // @output 

    [Address3, Address3] optionalNonDefValues = testOptionalNonDefField4();
    io:println(optionalNonDefValues[0]); // @output {"street":"Palm Grove","city":"Colombo 3","country":"LK"}
    io:println(optionalNonDefValues[0] is record {}); // @output true
    io:println(typeof optionalNonDefValues[0]); // @output typedesc Address3
    io:println(optionalNonDefValues[1]); // @output {"street":"Palm Grove","city":"Colombo 3","country":"LK"}
    io:println(optionalNonDefValues[1] is record {}); // @output true
    io:println(typeof optionalNonDefValues[1]); // @output typedesc Address3

    Person4 optionalDefaultable = testOptionalDefaultableField();
    io:println(optionalDefaultable.fname); // @output default
    io:println(optionalDefaultable.lname); // @output 
    io:println(optionalDefaultable.hasKey("age") ? optionalDefaultable.get("age") : ()); // @output
    io:println(optionalDefaultable.adrs); // @output 
}
