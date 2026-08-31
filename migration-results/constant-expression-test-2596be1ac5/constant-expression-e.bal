const CI1 = 1;
const CI2 = 1 + 2;
const map<int> CIMap1 = {v1: 1 + 2, v2: 2 * 5};

const int CI3 = 1 / 0; // @error
const int CI4 = 0 / 0; // @error
const int CI5 = *(5 + 10); // @error // @error
const string CS1 = +("hello" + "world"); // @error
const boolean CB1 = !(10); // @error
const int CONST1 = ~~false; // @error
const int CONST2 = -!false; // @error
const int CONST3 = -~false; // @error

const int A = D + B; // @error
const int C = A;
const int B = C;
const int D = 1;

const float E = F; // @error
const float F = E;

const int CONST4 = -9223372036854775808; // @error

const T CONST5 = 3 + 5; // @error // @error
type T CONST5;
