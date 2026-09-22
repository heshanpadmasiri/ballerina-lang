import ballerina/lang.'object as ob;

function testActionUseInInterpolation() {
    var fn = function () returns string { return "Pubudu"; };
    ob:RawTemplate rt = `Hello ${start fn()}!`; // @error
}
