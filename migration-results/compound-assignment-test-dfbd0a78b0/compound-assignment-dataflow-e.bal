final int i = 0;

function testFinalVarAssignmentInCompoundAssignment() {
    i += 1; // @error

    final string j = "ABC";
    j += "DEF"; // @error
}
