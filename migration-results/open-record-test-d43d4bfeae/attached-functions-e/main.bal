type Person record {
    int age = 9;
    string name = "default first name";
};

function Person.getName() returns string { // @error
    return self.name; // @error
}
