type Person3 record {
    Address3 adrs?;
};

type Address3 record {
    string street = "";
    string city = "";
    string country = "LK";
};

function testOptionalNonDefField3() {
    Person3 p = {};
    anydata b = p.get("adrs"); // @panic
}

public function main() {
    testOptionalNonDefField3();
}
