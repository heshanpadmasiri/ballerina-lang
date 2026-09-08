const constLength = 2;

function arraySizeTest() {
    int[constLength] _ = [1, 2];
    int[2][constLength] f = [[1, 2], [1, 2]];
    int[constLength][2] k = [[1, 2], [1, 2]];
    int[2][constLength][2] _ = [[[1, 2], [1, 2]], [[1, 2], [1, 2]]];
    int[0x2] q = [1, 2];
    int[0x00012345678] r; // @error
    int[2] s = q; // @error
    int[0x2][2] t = f; // @error
    int[0x2][0x2] u = k; // @error
    int[0] v; // @error
    int[2147483637] w; // @error
}
