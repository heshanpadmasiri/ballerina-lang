const R1 = "r1";
const R2 = "r2";
type E1 distinct error;
type E2 distinct error;

public function main() {
    worker w1 returns E1|E2? {
        if 0 > 1 {
            return error E1(R1);
        }
        100 ->> w2;
        if 0 < 1 {
            return error E2(R2);
        }
        "hello" ->> w2; // @error
        return;
    }
    worker w2 returns error? {
        int _ = <- w1; // @error
        if 0 < 1 {
            return error("w2 err");
        }
        string _ = <- w1; // @error
        return;
    }
    error? err = wait w1; // @error
}
