int[constLength] arr = [1, 2];

const constLength = 2;

int[constLength] a = [1, 2];

function arraySizeReferenceInDifferentScopeTest() {
    int[constLength] _ = [1, 2];

    function () anonFunction = function () {
        int[constLength] _ = [1, 2];
    };

    anonFunction();

    int x = 10;

    if (x == 10) {
        int[constLength] _ = [1, 2];
    }
}

public function main() {
}
