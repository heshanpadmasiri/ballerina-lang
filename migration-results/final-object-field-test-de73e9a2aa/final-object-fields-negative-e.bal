class Student {
    final string name;
    final int id;
    float avg = 80.0;
    function init(string n, int i) {
        self.name = n;
        self.id = i;
    }
}

function testInvalidUpdateOfObjectWithSimpleFinalFields() {
    Student st = new ("Maryam", 5);
    st.name = "Mary"; // @error
}

class Employee {
    final Details details;
    string department;
    function init(Details & readonly details, string department) {
        self.details = details;
        self.department = department;
    }
}

type Details record {
    string name;
    int id;
};

function testObjectWithStructuredFinalFields() {
    Details & readonly details = {name: "Kim", id: 1000};
    Employee e = new (details, "finance");
    e.details = details; // @error
    e.details.name = "Jo";
}

class Customer {
    final string name;
    int id;
    function init(string n, int i) {
        self.name = n;
        self.id = i;
    }
}

function testInvalidUpdateOfFinalFieldInUnion() {
    Customer customer = new ("Jo", 1234);
    Student|Customer sd = customer;
    sd.name = "May"; // @error
    sd.id = 123;
}

final Student[] students = [new ("Amy", 5), new ("Jo", 5)];

class Class {
    final Student[] allStudents = students;
    Student[] absentees;
    function init(Student[] absentees) {
        self.absentees = absentees;
    }
}

function testInvalidUpdateOfFinalFieldViaNestedAccess() {
    Class cl = new ([]);
    cl.allStudents[0].name = "May"; // @error
    cl.absentees[0].name = "May"; // @error
}
