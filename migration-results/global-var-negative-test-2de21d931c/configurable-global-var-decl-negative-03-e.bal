int[] nonReadOnlyArray = [];

configurable int[][] x = [nonReadOnlyArray]; // @error

type Foo record {|
    int i;
|};

Foo foo = {i: 1};

configurable Foo y = foo; // @error
