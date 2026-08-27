type LiteralsAndType 1|"abc"|int;

public function main() {
    LiteralsAndType value = 1;
    LiteralsAndType[] ar = [];
    ar[5] = value; // @panic
}
