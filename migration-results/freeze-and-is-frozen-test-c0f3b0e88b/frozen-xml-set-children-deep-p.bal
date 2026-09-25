import ballerina/lang.'xml as xmllib;

public function main() {
    xml x1 = xml `<book><name>The Lost World</name><authors></authors></book>`;
    xml x2 = xml `<author>Doyle</author>`;
    xmllib:Element x3 = <xmllib:Element & readonly>x1.cloneReadOnly();
    xml author = x3.getChildren().strip()[1];
    xmllib:Element authorEm = <xmllib:Element>author;
    authorEm.setChildren(x2); // @panic
}
