import test/pkg.org_foo_baz as baz;

function textPrivateObjAccess1() {
    baz:ParentFoo _ = new(12, new("Mad")); // @error // @error
}

function textPrivateObjAccess2() {
    var _ = baz:newPrivatePerson();
}

function textPrivateObjAccess3() {
   string _ = baz:privatePersonAsParam(new(21, "Mad")); // @error
}

function textPrivateObjAccess4() {
    var _ = baz:privatePersonAsParamAndReturn(new(21, "Mad")); // @error
}

function textPrivateObjAccess5() {
    baz:PrivatePerson p = new(21, "Mad"); // @error
    string _ = p.getPrivatePersonName();
}
