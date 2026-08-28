function f1() = @natural:code external; // @error

function f2() = @natural:code {} external; // @error

function f3(string str) returns int[] = @natural:code {
    prompt: 1 // @error
} external;
