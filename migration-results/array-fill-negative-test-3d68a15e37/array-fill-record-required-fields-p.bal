type Rec record {
    int i;
};

public function main() {
    Rec[] x = [];
    x[1] = {i: 1}; // @panic
}
