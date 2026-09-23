function foo() returns error? {
    int i = trap 1 + 2 * 2; // @error
    int j = trap 1 / 1; // @error

    boolean|error b = fTrue() ? trap fTrue() : trap fTrue();
    boolean|error be = trap fTrue() ? fTrue() : fTrue();

    if trap fTrue() && fTrue() || fTrue() { // @error

    }

    boolean|error comp = trap 1 < 2 ||
        check i > // @error
        check j; // @error
}

function fTrue() returns boolean => true;
