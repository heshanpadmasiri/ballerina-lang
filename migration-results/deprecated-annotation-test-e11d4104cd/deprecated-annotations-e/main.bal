// Module-level declarations whose documentation metadata is examined by the
// migrated harness. Uses below make each deprecated construct observable as a
// compiler diagnostic.

@deprecated
public type CountryCode "LK"|"LKA"|"USA";

public type NewCountryCode "LK"|"USA";

@deprecated
public type State "on"|"off";

public type NewState "on"|"off";

@deprecated
public class Person {
    public string firstName = "John";
    public string lastName = "Doe";
    Address addr = {street: "Palm Grove", city: "Colombo 3", countryCode: LKA}; // @error

    @deprecated
    public function getFullName() returns string {
        return self.firstName + " " + self.lastName;
    }

    public function getCity() returns string {
        return self.addr.city;
    }
}

public class Student {
}

@deprecated
public type Address record {|
    string street;
    string city;
    CountryCode countryCode; // @error
|};

public type Bank record {|
    string street;
    string city;
    CountryCode countryCode; // @error
|};

public type Employee record {|
    @deprecated
    string name;
    int age;
|};

type InvalidAccountTypeErrorData record {
    string accountType;
};

@deprecated
public type InvalidAccountTypeError error<InvalidAccountTypeErrorData>;

public type InvalidBankTypeError error<InvalidAccountTypeErrorData>;

@deprecated
public const string LKA = "LKA";

public const string LK = "LK";
public const string USA = "USA";

public type HelloConfiguration record {|
    string salutation = "Hello!";
|};

public type ByeConfiguration record {|
    string salutation = "Hello!";
|};

public annotation HelloConfiguration Greeting on function;

@deprecated
public annotation ByeConfiguration Bye on function;

@deprecated
public function createPerson(string fname, string lname, string street, string city,
                             CountryCode countryCode) returns Person { // @error
    Person p = new; // @error
    p.firstName = fname;
    p.lastName = lname;
    p.addr = {street, city, countryCode};
    return p;
}

public function sayHello(string name) {
}

public function getFullName(string title, @deprecated string fName, string mName = "Chris",
                     @deprecated string lName = "Wood") returns string {
    return fName + mName + lName; // @error
}

public class Player {
    @deprecated
    public string name = "Saman";
    public int age = 15;
}

@Bye {salutation: "Bye"} // @error
function deprecatedAnnotationUse() {
}

function observeDeprecatedConstructs() {
    CountryCode countryCode = LKA; // @error
    State state = "on"; // @error
    Person person = new; // @error
    Address address = {street: "Castro Street", city: "Mountain View", countryCode}; // @error
    InvalidAccountTypeError invalidAccountTypeError = error("invalid", accountType = "checking"); // @error
    Person created = createPerson("Jane", "Doe", address.street, address.city, countryCode); // @error
    string fullName = person.getFullName(); // @error
    Player player = new;
    string playerName = player.name; // @error
    Employee employee = {name: "Anne", age: 30}; // @error
    string employeeName = employee.name; // @error
    string parameterName = getFullName("Mr.", "Jane", "Q.", "Doe"); // @error
    _ = [state, invalidAccountTypeError, created, fullName, playerName, employeeName, parameterName];
}
