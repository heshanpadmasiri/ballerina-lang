type CustomerY record {|
    readonly int id;
    readonly string name;
    int noOfItems;
|};

type CustomerProfileY record {|
    string name;
    int age;
    int noOfItems;
    string address;
|};

type PersonY record {|
    string firstName;
    string lastName;
    int age;
    string address;
|};

function testQueryActionWithMultipleOrderByClauses() {
    CustomerProfileY[] customerProfileList = [];
    CustomerY c1 = {id: 1, name: "Melina", noOfItems: 62};
    CustomerY c2 = {id: 5, name: "James", noOfItems: 5};
    CustomerY c3 = {id: 9, name: "James", noOfItems: 25};
    CustomerY c4 = {id: 0, name: "James", noOfItems: 25};
    CustomerY c5 = {id: 2, name: "James", noOfItems: 30};
    PersonY p1 = {firstName: "Jennifer", lastName: "Melina", age: 23, address: "California"};
    PersonY p2 = {firstName: "Frank", lastName: "James", age: 30, address: "New York"};
    PersonY p3 = {firstName: "Zeth", lastName: "James", age: 50, address: "Texas"};
    CustomerY[] customerList = [c1, c2, c3, c4, c5];
    PersonY[] personList = [p1, p2, p3];
    error? op = // @error unused variable 'op'
        from var customer in customerList
    join var person in personList
        on customer.name equals person.lastName
    order by customer.noOfItems descending
    limit 5
    order by person.address
    limit 2
    do {
        CustomerProfileY cp = {name: person.firstName, age: person.age, noOfItems: customer.noOfItems,
            address: person.address};
        customerProfileList[customerProfileList.length()] = cp;
    };
}
