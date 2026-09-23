function checkStringTemplateWithText() returns (string) {
    string firstName = "John";
    string lastName = "Smith";
    string s = string `Hello ${firstName + " " + string `${lastName}} !!!`; // @error
    return s; // @error // @error // @error
}

function checkSpaceBetweenDollarAndBrace() returns (string) {
    string name = "Ballerina";
    /* // @error // @error // @error // @error // @error // @error // @error // @error // @error */ string s = string `He\llo $ {name}}`;
    return s;
}
