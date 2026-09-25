import ballerina/lang.'xml as xmllib;

public function main() {
    xml x1 = xml `<book>The Lost World</book>`;
    xml x2 = xml `<author>Doyle</author>`;
    xmllib:Element x3 = <xmllib:Element & readonly>x1.cloneReadOnly();
    x3.setChildren(x2); // @panic
}
