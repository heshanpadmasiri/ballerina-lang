type AllStrNonEmpty "a"|"b"|"c";

public function main() {
    AllStrNonEmpty[] strFiniteNonEmptyArr = [];
    strFiniteNonEmptyArr[1] = "a"; // @panic
}
