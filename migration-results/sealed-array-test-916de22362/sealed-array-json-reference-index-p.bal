public function main() {
    invalidIndexReferenceJSONArray();
}

function invalidIndexReferenceJSONArray() {
    json[3] x1 = [1, true, "3"];
    json[] x2 = x1;
    x2[3] = 1.0; // @panic
}
