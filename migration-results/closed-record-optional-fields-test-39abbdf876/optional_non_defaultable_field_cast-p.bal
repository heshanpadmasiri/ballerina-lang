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

function testOptionalNonDefField2() {
    Person3 p = {};
    Address3 a = <Address3>p?.adrs; // @panic
    Address3 b = <Address3>p.get("adrs");
}

public function main() {
    testOptionalNonDefField2();
}
