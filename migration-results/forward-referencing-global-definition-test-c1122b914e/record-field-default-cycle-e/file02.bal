final string name = person.name; // @error

final string gVar = p.n; // @error

final string nillableNestedRecordGVar = nillableNestedRec.r?.n ?: ""; // @error

final string nestedRecordFieldDefaultValue = (new A()).r.n; // @error
