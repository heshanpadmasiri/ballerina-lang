type CountryCode "LK"|"USA"|"UK";

type Person record {|
    string fname = "default";
    string lname?;
    int age? = 999; // @error // @error
    Address adrs;
|};

type Address record {|
    string street;
    string city;
    CountryCode country;
|};

function testNonDefReqField() {
    Person p1 = {}; // @error
    Person p2;
}
