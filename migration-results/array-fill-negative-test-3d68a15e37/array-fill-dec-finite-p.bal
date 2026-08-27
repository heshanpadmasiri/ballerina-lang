const decimal ZERO = 1.5;
const int ONE_TWO = 1;
const decimal TWO_THREE = 2.3;

type DEC ZERO|ONE_TWO|TWO_THREE;

public function main() {
    DEC value = 1.5;
    DEC[] ar = [];
    ar[5] = value; // @panic
}
