type Person record { string name = ""; };
type Employee record {| string name = ""; boolean intern = false; |};

function mismatchingCovariance() {
    Employee[] employees = [];
    Person[] persons = employees;

    Person[] otherPersons = [];
    Employee[] otherEmployees = otherPersons; // @error

    Employee[][] employeeMatrices = [];
    Person[][] personMatrices = employeeMatrices;

    Person[][] otherPersonMatrices = [];
    Employee[][] otherEmployeeMatrices = otherPersonMatrices; // @error

    Employee[][] moreEmployees = [];
    Person[] personsFromMatrix = moreEmployees; // @error
    Person[][][] personCubes = moreEmployees; // @error

    (int|Person?)[] unionValues = [];
    (int|Person|boolean?)[] widenedUnionValues = unionValues;
    (int|Person)?[] narrowedUnionValues = unionValues;

    int[] openIntegers = [];
    int[3] fixedIntegers = openIntegers; // @error

    int[3][] openMatrix = [[0, 0, 0], [0, 0, 0], [0, 0, 0]];
    int[3][3] fixedMatrix = openMatrix; // @error
}

class Animal { public string name = ""; }
class Cat { public string catName = ""; public int age = 0; }

function mismatchingCovariance2() {
    Cat[] cats = [new, new];
    Animal[] animals = cats; // @error
}

function mismatchingUnionArrays() {
    (int|boolean)?[] nullableValues = [0, 0, 0];
    int[]|boolean[] arrays = [0, 0, 0];
    arrays = nullableValues; // @error
}
