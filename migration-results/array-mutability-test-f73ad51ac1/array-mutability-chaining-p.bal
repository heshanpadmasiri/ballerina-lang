type PersonAM record { string name = ""; };

public function main() {
    (int|string)?[] first = [];
    (int|string?)[] second = first;
    (int|string|boolean?)[] third = second;
    (int|string|boolean|PersonAM?)[] fourth = third;
    fourth[0] = 1;
    fourth[1] = "string";
    fourth[2] = true; // @panic
}
