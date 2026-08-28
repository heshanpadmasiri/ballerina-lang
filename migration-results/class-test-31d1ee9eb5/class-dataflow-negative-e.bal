class Per {
    int i = 0;

    function f() {
        int i = 0;
        int j;
        j = 3;
        i = j;

        int k;
        i = k; // @error
        k = i;
        i = k;

        int q;
        i = q; // @error
        k = q; // @error
        q = q; // @error
        q = i;
        i = q;
        k = q;
        q = q;
    }
}
