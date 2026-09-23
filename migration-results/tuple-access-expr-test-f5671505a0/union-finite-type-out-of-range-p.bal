type Bar record {| string fieldOne; |};
type FiniteTwo 0|1|4;
const SIX = 6;
type FiniteThree FiniteTwo|SIX;

public function main() {
    [string, boolean, Bar, float] tuple = ["string", true, {fieldOne: "string"}, 1.1];
    FiniteThree index = 6;
    var result = tuple[index]; // @panic
    _ = result;
}
