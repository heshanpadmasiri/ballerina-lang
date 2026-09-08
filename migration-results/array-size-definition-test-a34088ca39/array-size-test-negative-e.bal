const constLength = 2;
int intLength = 2;
const stringLength = "2";

function arraySizeTest() {
    int[constLength] _ = [1, 2, 3]; // @error
    int[intLength] _ = [1, 2]; // @error
    int[stringLength] _ = [1, 2]; // @error
    int[length] _ = [1, 2]; // @error
    int[2] _ = [1, 2, 3]; // @error

    int[2][constLength] _ = [[1, 2], [1, 2, 3]]; // @error
    int[2][intLength] _ = [[1, 2], [1, 2]]; // @error
    int[2][stringLength] _ = [[1, 2], [1, 2]]; // @error
    int[2][length] _ = [[1, 2], [1, 2]]; // @error
    int[2][2] _ = [[1, 2], [1, 2, 3]]; // @error

    int[constLength][2] _ = [[1, 2], [1, 2], [1, 2]]; // @error
    int[intLength][2] _ = [[1, 2], [1, 2]]; // @error
    int[stringLength][2] _ = [[1, 2], [1, 2]]; // @error
    int[length][2] _ = [[1, 2], [1, 2]]; // @error
    int[2][2] _ = [[1, 2], [1, 2], [1, 2]]; // @error

    int[2][constLength][2] _ = [[[1, 2], [1, 2], [1, 2]], [[1, 2], [1, 2]]]; // @error
    int[2][intLength][2] _ = [[[1, 2], [1, 2]], [[1, 2], [1, 2]]]; // @error
    int[2][stringLength][2] _ = [[[1, 2], [1, 2]], [[1, 2], [1, 2]]]; // @error
    int[2][length][2] _ = [[[1, 2], [1, 2]], [[1, 2], [1, 2]]]; // @error
    int[2][2][2] _ = [[[1, 2], [1, 2], [1, 2]], [[1, 2], [1, 2]]]; // @error
    int["TEST"] _ = []; // @error

    int[2147483638] _ = []; // @error
    int[int:MAX_VALUE] _ = []; // @error

    int[9223372036854775808] _ = []; // @error
    int[0x001234567890abcdef01] _ = []; // @error
}

const negativeLength = -1;

function arrayNegativeSizeTest() {
    int[negativeLength] z = []; // @error
}
