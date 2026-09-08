int[constLength] arr = [1, 2, 3]; // @error

const constLength = 2;
int intLength = 2;
const stringLength = "2";

int[constLength] a = [1, 2, 3]; // @error
int[intLength] b = [1, 2]; // @error
int[stringLength] c = [1, 2]; // @error
int[length] d = [1, 2]; // @error

function arraySizeReferenceInDifferentScopeTest() {
    int[constLength] _ = [1, 2, 3]; // @error
    int[intLength] _ = [1, 2]; // @error
    int[stringLength] _ = [1, 2]; // @error
    int[length] _ = [1, 2]; // @error

    function () anonFunction = function () {
        int[constLength] _ = [1, 2, 3]; // @error
        int[intLength] _ = [1, 2]; // @error
        int[stringLength] _ = [1, 2]; // @error
        int[length] _ = [1, 2]; // @error
    };

    anonFunction();

    int x = 10;

    if (x == 10) {
        int[constLength] _ = [1, 2, 3]; // @error
        int[intLength] _ = [1, 2]; // @error
        int[stringLength] _ = [1, 2]; // @error
        int[length] _ = [1, 2]; // @error
    }
}
