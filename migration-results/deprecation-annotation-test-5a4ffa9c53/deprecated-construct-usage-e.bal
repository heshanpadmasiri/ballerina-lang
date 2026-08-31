@deprecated
type Foo record {
    int i;
    int j;
};

Foo foo = {i: 1, j: 2}; // @error
