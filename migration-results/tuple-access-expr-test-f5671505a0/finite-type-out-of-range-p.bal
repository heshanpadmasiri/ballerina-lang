type Bar record {| string fieldOne; |};
type FiniteTwo 0|1|4;

public function main() {
    [string, boolean, Bar, float] tuple = ["string", true, {fieldOne: "string"}, 1.1];
    FiniteTwo index = 4;
    var result = tuple[index]; // @panic
    _ = result;
}
