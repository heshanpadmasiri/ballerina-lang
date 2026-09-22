import recordproject.org.foo.baz;

function textPrivateRecordAccess1() {
    baz:FooPerson fooP = baz:createRecord();
    var _ = fooP.family; // @error
}

function textPrivateRecordAccess2() {
    baz:FooDepartment fooD = baz:createRecordOfRecord();
    var _ = fooD.employees[0].family; // @error
}

function textPrivateRecordAccess3() {
    baz:FooEmployee fooE = baz:createAnonRecord();
    var _ = fooE.address;
}
