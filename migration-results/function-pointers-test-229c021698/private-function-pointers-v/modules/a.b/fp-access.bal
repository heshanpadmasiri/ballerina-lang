public function Fn1() returns function (int, int) returns int => privateFunc1;
public function Fn2() returns function (int, int) returns int => function (int a, int b) returns int => a + b;
function privateFunc1(int a, int b) returns int => a + b;
