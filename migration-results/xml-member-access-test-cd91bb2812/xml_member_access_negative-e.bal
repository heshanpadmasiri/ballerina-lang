function testXmlMemberAccessOnXmlNegative() {
    xml seq = xml `text item<elem>element item</elem><!--comment item--><?pi item?>`;

    xml:Element _ = seq[0]; // @error
    xml:Element|xml:Comment|xml:ProcessingInstruction _ = seq[1]; // @error
    xml:Comment|xml:ProcessingInstruction|xml:Text _ = seq[2]; // @error
}

function testXmlMemberAccessOnXmlElementSequencesNegative() {
    xml<xml:Element> seq = xml `<e1>element 1</e1><e2>element 2</e2>`;
    xml:Element _ = seq[0]; // @error
    xml<never> _ = seq[1]; // @error
}

function testXmlMemberAccessOnXmlCommentSequencesNegative() {
    xml<xml:Comment> seq = xml `<!--Comment 1--><!--Comment 2--><!--Comment 3-->`;
    xml:Comment _ = seq[0]; // @error
    xml<never> _ = seq[2]; // @error
}

function testXmlMemberAccessOnXmlTextSequencesNegative() {
    xml<xml:Text> seq = xml `baz`;
    xml<never> _ = seq[0]; // @error
}

function testXmlMemberAccessOnXmlProcessingInstructionSequencesNegative() {
    xml<xml:ProcessingInstruction> seq = xml `<?p1 v1?><?p2 v2?>`;
    xml:ProcessingInstruction _ = seq[0]; // @error
    xml<never> _ = seq[2]; // @error
}

function testXmlMemberAccessOnXmlSingletonsNegative() {
    xml:Element elem = xml `<elem>element value</elem>`;
    xml:Element _ = elem[0]; // @error

    xml:Text text = xml `text value`;
    xml<never> _ = text[0]; // @error

    xml:Comment comment = xml `<!--comment value-->`;
    xml:Comment _ = comment[0]; // @error

    xml:ProcessingInstruction pi = xml `<?pi value?>`;
    xml:ProcessingInstruction _ = pi[0]; // @error
}

function testXmlMemberAccessOnXmlUnionsNegative() {
    xml<xml:Element>|xml<xml:Comment> seq = <xml<xml:Element>> xml `<foo/><bar>val</bar>`;
    xml:Element|xml:Comment _ = seq[0]; // @error
    xml:Element|xml<never> _ = seq[1]; // @error

    xml<xml:Comment>|xml:ProcessingInstruction|xml<never> seq2 = xml `<?pi val?>`;
    xml:Comment|xml<never> _ = seq2[0]; // @error
}

function testXmlMemberAccessOnXmlUnionSequencesNegative() {
    xml<xml:Element|xml:Comment> seq = xml `<foo/><!--comment val--><bar>val</bar>`;
    xml:Element|xml:Comment _ = seq[0]; // @error
    xml:Comment|xml<never> _ = seq[1]; // @error

    xml<xml:Comment|xml:ProcessingInstruction|never> seq2 = xml `<?pi val?>`;
    xml:Comment|xml<never> _ = seq2[0]; // @error
}

function testXmlMemberAccessOnEmptySequenceTypeNegative() {
    xml<never> seq = xml ``;
    xml:Element _ = seq[0]; // @error
}
