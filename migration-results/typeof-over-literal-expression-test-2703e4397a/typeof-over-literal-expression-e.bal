type RecType0 record { string name; };

function cloneWithTypeWarnings() returns error? {
    RecType0 & readonly rec = {name: "test"};
    map<anydata> clonableRec = {name: "test"};
    anydata val = check clonableRec.cloneWithType(typeof rec);
    boolean _ = val.isReadOnly(); // @error

    map<string> & readonly mapVal = {s: "test"};
    map<anydata> clonableMap = {s: "test"};
    val = check clonableMap.cloneWithType(typeof mapVal);
    boolean _ = val.isReadOnly(); // @error

    table<map<string>> & readonly tableVal = table [{s: "test"}];
    table<map<anydata>> clonableTable = table [{s: "test"}];
    val = check clonableTable.cloneWithType(typeof tableVal);
    boolean _ = val.isReadOnly(); // @error
}

function cloneWithTypeDifferentValueWarnings() returns error? {
    RecType0 & readonly rec = {name: "test"};
    map<anydata> clonableRec = {name: "Hinduja"};
    anydata val = check clonableRec.cloneWithType(typeof rec);
    boolean _ = val.isReadOnly(); // @error

    map<string> & readonly mapVal = {s: "test"};
    map<anydata> clonableMap = {s: "Jane Doe"};
    val = check clonableMap.cloneWithType(typeof mapVal);
    boolean _ = val.isReadOnly(); // @error

    table<map<string>> & readonly tableVal = table [{s: "test"}];
    table<map<anydata>> clonableTable = table [{s: "test", a: "test 2"}];
    val = check clonableTable.cloneWithType(typeof tableVal);
    boolean _ = val.isReadOnly(); // @error
}

function ensureTypeWarnings() returns error? {
    RecType0 & readonly rec = {name: "test"};
    map<anydata> & readonly clonableRec = {name: "test"};
    anydata val = check clonableRec.ensureType(typeof rec);
    boolean _ = val.isReadOnly(); // @error

    map<string> & readonly mapVal = {s: "test"};
    map<anydata> & readonly clonableMap = {s: "test"};
    val = check clonableMap.ensureType(typeof mapVal);
    boolean _ = val.isReadOnly(); // @error

    table<map<string>> & readonly tableVal = table [{s: "test"}];
    table<map<anydata>> & readonly clonableTable = table [{s: "test"}];
    val = check clonableTable.ensureType(typeof tableVal);
    boolean _ = val.isReadOnly(); // @error
}
