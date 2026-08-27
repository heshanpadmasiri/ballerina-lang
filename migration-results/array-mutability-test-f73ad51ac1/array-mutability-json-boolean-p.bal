public function main() {
    boolean[] booleans = [true, true];
    json[] jsonValues = booleans;
    jsonValues[2] = true;
    jsonValues[3] = "json"; // @panic
}
