// Year 2017

function testComments() {
    // defining start name
    string startName = "foo";

    // defining end name
    string endName = "bar"; // defining end  name inline

    xml x = // initi xml
        xml `<foo>hello</foo>`;

    xml concat = xml:concat(x);
    fooFunc("hello", "world");

    Day day = MONDAY;
    if day == TUESDAY {
        string strConcat = "day is wrong!";
    }
}

function fooFunc(string a, // foo function
    string b) {
    // printing a
    string s = a;

    // printing b
    s = s + b;
    return;
}

type Person record { // Person type
    // name field
    string name = "";

    // only one field
};

type Day "MONDAY" | "TUESDAY"; // enum Day

final Day MONDAY = "MONDAY"; // enumerator Monday
final Day TUESDAY = "TUESDAY"; // enumerator Tuesday

// transformer <Person p,string s> {
// send the name of the person
// s = p.name;
// }

// end of file
public function main() {
}
