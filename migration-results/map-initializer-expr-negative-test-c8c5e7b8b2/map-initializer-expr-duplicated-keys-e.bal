function duplicatedMapKeys() returns map<any> {
    map<any> dupKey = {key: "value-1", key: "value-2"}; // @error
    return dupKey;
}

function duplicatedMapKeysStrKey() returns map<any> {
    map<any> dupKey = {key: "value-1", "key": "value-2"}; // @error
    return dupKey;
}

function duplicatedMapKeysBothStrKey() returns map<any> {
    map<any> dupKey = {"key": "value-1", "key": "value-2"}; // @error
    return dupKey;
}
