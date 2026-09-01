string letRef = modVar; // @error

string[] modVarQueryLet1 = from var item in [queryRef, "hello", "world"] let string prefix = queryRef select prefix + item; // @error
string[] modVarQueryLet2 = from var item in ["hello", "world"] let string prefix = queryRef2 select prefix + item; // @error
string[] modVarQuery = from var item in [queryRef, "hello", "world"] select item;

string queryRef = modVarQuery[0] + modVarQueryLet1[0];
string queryRef2 = modVarQueryLet2[0];

RecordTypeWithDefaultLetExpr recD = {}; // @error

final int moduleCode = recD.code;
