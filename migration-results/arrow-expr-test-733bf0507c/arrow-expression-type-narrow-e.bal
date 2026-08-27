function testArrowExpressionWithTypeNarrowing() {
    string|int s = "World";
    if s is string {
        function () returns string a = () => "Hello " + s; // @error
    }
}
