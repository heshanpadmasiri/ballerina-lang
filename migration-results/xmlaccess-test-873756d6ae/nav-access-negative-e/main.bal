function testXmlNegativeIndexedAndFilterStepExtend() {
    string s = "a";
    xml x1 = xml `<item><name>T-shirt</name><price>19.99</price></item>`;
    _ = x1/*[j].<name>; // @error
    _ = x1/*[s].<name>; // @error
    _ = x1/*.<ns:s>; // @error
    _ = x2/*.<s>; // @error
    _ = x2/*.<s>[j]; // @error
}

function testXmlMethodCallNegativeStepExtend() returns error? {
    int k = 0;
    string s = "s";

    xml x1 = xml `<item><name>T-shirt</name><price>19.99</price></item>`;

    _ = x1/*.get("0"); // @error
    _ = x1/*.get(0, 2); // @error
    _ = x1/*.get(s); // @error

    _ = x1/*.foo(); // @error
    _ = x1/*.length(); // @error
    _ = x1/*.slice(1, "5"); // @error

    _ = x1/*.slice(0).length(); // @error
    _ = x1/*.elementChildren().get(0).getChildren();


    _ = x1/<item>.get(r); // @error
    _ = x1/<item>.get(0).getChildren();
    _ = x1/<item>.filter(x => x); // @error

    _ = x1/<item>.map(y => xml:createProcessingInstruction(y.getTarget(), "sort")); // @error
    _ = x1/<item>.forEach(function (xml y) {k = k + 1;}); // @error

    _ = x1/**/<item>.get(r); // @error
    _ = x1/**/<item>.get(0).getChildren(); // error at the wrong place + invalid error
    _ = x1/**/<item>.filter(x => x); // @error
    _ = x1/**/<item>.filter(function (xml y) {k = k + 1;}); // @error
}
