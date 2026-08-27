function testInferredArrayWithNilLiteral() {
    int[*]? _ = (); // @error
}
