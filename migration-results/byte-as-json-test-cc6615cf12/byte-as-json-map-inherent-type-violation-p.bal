public function main() {
    testInherentTypeViolationForMap();
}

function testInherentTypeViolationForMap() {
    map<byte> bmap = {
        a: 0,
        b: 123,
        c: 255
    };
    map<json> jmap = bmap;
    jmap["d"] = 300; // @panic
}
