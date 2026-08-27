import balTest/proj.B as io;
import balTest/proj.A;

public function main() {
    json j = {"a": 25};
    A:Bar f = j; // @error @error

    io:println(f);
}
