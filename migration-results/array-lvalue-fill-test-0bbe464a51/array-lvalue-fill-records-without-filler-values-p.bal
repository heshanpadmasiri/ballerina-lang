public function main() {
    testRecordsWithoutFillerValues();
}

function testRecordsWithoutFillerValues() {
    record {| string name; |}[][] arr = [];
    arr[2][1] = {name: "Pubudu"}; // @panic
}
