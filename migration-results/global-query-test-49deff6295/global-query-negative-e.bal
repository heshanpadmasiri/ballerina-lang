int[] intList = [1, 2, 3];
int count = 0;

// Module-level query actions are not allowed.
var y = from var value in intList // @error
    do {
        count += value;
    };

public function main() {
}
