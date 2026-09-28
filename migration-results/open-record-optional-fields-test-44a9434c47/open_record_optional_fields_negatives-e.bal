type CountryCode "LK"|"USA"|"UK";
type CustomRecord record {};
type CustomRecord2 CustomRecord;
type CustomRecord3 CustomRecord2;

type Person record {
    string fname = "default";
    string lname?;
    int age? = 999; // @error // @error
    Address adrs;
};

type Address record {
    string street;
    string city;
    CountryCode country;
};

function testNonDefReqField() {
    Person p1 = {}; // @error
    Person p2;
}

function testUserDefinedRecordNonExistingField() {
    CustomRecord3 x = {};
    string name = x?.name; // @error
}
