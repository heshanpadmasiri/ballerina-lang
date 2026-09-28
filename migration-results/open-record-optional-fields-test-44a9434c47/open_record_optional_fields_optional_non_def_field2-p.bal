type Person3 record {
    Address3 adrs?;
};

type Address3 record {
    string street = "";
    string city = "";
    string country = "LK";
};

function testOptionalNonDefField2() {
    Person3 p = {};
    Address3 a = <Address3>p?.adrs; // @panic
    Address3 b = <Address3>p.get("adrs");
}

public function main() {
    testOptionalNonDefField2();
}
