type SimpleType record {
    string? field1;
};

string fieldOne = let string? f1 = conf1.field1 in f1 is string ? f1 : "default-value-1"; // @error

SimpleType conf1 = {
    field1: fieldOne
};

string modVar = let string[] ar = [letRef] in ar[0];

type RecordTypeWithDefaultLetExpr record {
    int code = let int m = moduleCode in m + 1; // @error
};
