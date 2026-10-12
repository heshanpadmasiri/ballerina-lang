type JsonMap map<json>;

function testNullJsonToMap() returns map<any> {
    json j = null;
    var m = j.cloneWithType(JsonMap); // @panic error: {ballerina/lang.value}ConversionError {"message":"cannot convert '()' to type 'JsonMap'"}
    if m is map<json> {
        return m;
    }
    panic m;
}

public function main() {
    map<any> ignored = testNullJsonToMap();
}
