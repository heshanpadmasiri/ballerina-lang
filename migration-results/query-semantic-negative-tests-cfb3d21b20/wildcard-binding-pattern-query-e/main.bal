function testWildcardBindingPatternInQueryExprNegative() {
    error?[] x = [];

    int[] _ = from error? _ in x // @error
        select 1;

    error[] y = [];

    int[] _ = from var _ in y // @error
        select 1;
}

function testWildcardBindingPatternInQueryActionNegative() {
    error?[] x = [];

    error? res = from error? _ in x // @error
        do {
        };

    error[] y = [];

    res = from var _ in y // @error
        do {
        };

    boolean _ = res is (); // to avoid unused variable warning
}
