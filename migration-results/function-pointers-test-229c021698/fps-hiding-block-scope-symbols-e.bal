function name(int y) returns function (int) returns int {
    var func = function (int y) returns int { // @error
        return y + y;
    };
    return func; // @error
}
function nameArrow(int y, int z) returns int {
    function (int, int, int) returns int lambda = (x, y, z) => x + y + z; // @error
    return lambda(12, 32, 33);
}
int z = 34;
function nameP() returns function (int) returns int {
    var func = function (int z) returns int { return z + z; };
    return func;
}
function nameArrowP() returns int {
    function (int, int) returns int lambda = (x, z) => x + z;
    return lambda(12, 32);
}
function nameX(int y) returns function (int) returns int {
    var func = function (int z) returns int {
        int y = 3; // @error
        return y + y;
    };
    return func;
}
public function test2() {
    int a = 10;
    var x = function (function(int a = 10) l) {}; // @error
}
public function test1() {
    int a = 10;
    var x = function (function(int a, int b = a) l) {}; // @error
}
