import ballerina/io;

public type Address object {
    public string city;

    public function getCity() returns string;
};

public class StudentAddress {
    public string city;

    public function init(string city) {
        self.city = city;
    }

    public function getCity() returns string {
        return self.city;
    }
}

public class Employee {
    public string city;
    public Address address;

    function init(string city, Address address) {
        self.city = city;
        self.address = address;
    }

    public function getCity() returns string {
        return self.city;
    }
}

function testAbstractObjectInObject() returns Employee {
    StudentAddress stdAddr = new("Colombo");
    Employee emp = new("Colombo", stdAddr);
    return emp;
}

public function main() {
    Employee employee = testAbstractObjectInObject();
    io:println("{city:" + employee.city + ", address:{city:" + employee.address.city + "}}"); // @output {city:Colombo, address:{city:Colombo}}
}
