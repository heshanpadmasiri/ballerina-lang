type CountryCode "LK"|"USA"|"UK";

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

function testOptionalNonDefField3() {
    Person3 p = {};
    anydata b = p.get("adrs"); // @panic
}

public function main() {
    testOptionalNonDefField3();
}
