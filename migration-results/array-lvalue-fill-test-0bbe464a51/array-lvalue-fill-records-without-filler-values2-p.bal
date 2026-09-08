public function main() {
    testRecordsWithoutFillerValues2();
}

function testRecordsWithoutFillerValues2() {
    record {| string name; |}[][2] arr = [];
    arr[0][1] = {name: "Pubudu"}; // @panic
}
