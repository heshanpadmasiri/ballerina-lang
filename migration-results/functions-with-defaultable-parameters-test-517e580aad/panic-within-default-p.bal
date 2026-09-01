int GLB = 0;

function getIntOrPanic() returns int {
    if GLB == 0 {
        return GLB;
    }
    panic error("Panic!"); // @panic
}

function foo5(int a = getIntOrPanic()) returns int => a;

public function main() {
    GLB = 0;
    int a = foo5();
    GLB = 1;
    int b = foo5();
    _ = a;
    _ = b;
}
