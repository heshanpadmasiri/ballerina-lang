function getStringValue() returns string {
    string '    whiteSpace = "sample value"; // @error @error @error
    return '    whiteSpace; // @error @error @error
}

public function main() {
    string value = getStringValue();
}
