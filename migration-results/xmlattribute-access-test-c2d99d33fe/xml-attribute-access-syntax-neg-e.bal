type R record {
    int i;
};

function testXMLAttributeAccessWithNamespaceSyntaxNeg() {
    R r = {i: 0};
    var p = r.b:c; // @error

    map<string> m = {};
    var q = m.b:c; // @error
}

type XC xml:Comment;

function testXmlAttributeAccessOnNonXmlElementValueNeg() {
    xml:Comment x1 = xml `<!--This is a comment-->`;
    xml _ = x1.attr; // @error
    xml _ = x1?.attr; // @error
    string _ = x1.attr; // @error
    string _ = x1?.attr; // @error

    xml:ProcessingInstruction x2 = xml `<?data?>`;
    xml _ = x2.attr; // @error
    xml _ = x2?.attr; // @error
    string _ = x1.attr; // @error
    string|error r = x1?.attr; // @error

    xml:Text x3 = xml `This is an xml text`;
    xml? _ = x3.attr; // @error
    xml _ = x3?.attr; // @error
    string? _ = x3.attr; // @error
    r = x3?.attr; // @error

    xml<xml:ProcessingInstruction|xml:Text> x4 = xml `<?pi?>text two<?data?>`;
    xml? _ = x4.attr; // @error
    xml _ = x4?.attr; // @error
    string _ = x4.attr; // @error
    r = x4?.attr; // @error

    XC x5 = xml `<!--comment2-->`;
    xml _ = x5.attr; // @error
    xml _ = x5.attr.attr2; // @error
    string _ = x5.attr?.attr3; // @error
}


function testOptionalXmlAttributeAccessNeg() {
    xml:Element x1 = xml `<x/>`;
    string _ = x1.attr; // @error
    string? _ = x1?.attr; // @error

    XC x2 = xml `<!--comment-->`;
    string _ = x2.attr; // @error
    string|error r = x1?.attr; // @error

    xml:ProcessingInstruction x3 = xml `<?data?>`;
    string _ = x3.attr; // @error
    string? _ = x3?.attr; // @error

    xml:Text x4 = xml `xml text`;
    string? _ = x4.attr; // @error
    string? _ = x4?.attr; // @error

    xml:Text|xml:Comment x5 = xml `<!--comment2-->`;
    string _ = x5.attr; // @error
    xml? _ = x5?.attr; // @error
}
