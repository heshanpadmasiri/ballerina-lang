type PersonAM record { string name = ""; };

public function main() {
    (boolean|float)?[] values = [true, 2.0, true, 15.0];
    (boolean|float|PersonAM)?[] widened = values;
    widened[0] = 1.0;
    PersonAM person = {name: "John"};
    widened[1] = person; // @panic
}
