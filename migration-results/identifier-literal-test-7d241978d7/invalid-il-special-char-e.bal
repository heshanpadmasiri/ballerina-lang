function getStringValue() returns string {
    string '_&"*%_var = "sample value"; // @error @error @error @error @error @error @error
    return '_&"*%_var; // @error @error @error
} // @error

public function main() {
    string value = getStringValue();
}
