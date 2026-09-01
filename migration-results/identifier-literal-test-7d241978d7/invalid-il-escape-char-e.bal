function getStringValue() returns string {
    string '\a\B\c\x\y\z_var = "sample value"; // @error @error @error @error @error @error
    return '\a\B\c\x\y\z_var; // @error @error @error @error @error @error
}

public function main() {
    string value = getStringValue();
}
