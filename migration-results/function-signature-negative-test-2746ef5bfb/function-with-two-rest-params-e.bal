function functionWithAllTypesParams(int a, int... b, float... c) returns [int[], float[]] { // @error
    return [b, c]; // @error
}
