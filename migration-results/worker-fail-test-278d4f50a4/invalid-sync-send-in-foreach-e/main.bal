public function main() {
    worker w1 {
        int x = 44;
        int sum = 0;
        foreach var i in 1...10 {
            sum = sum + i;
            var r1 = x ->> w2; // @error
        }
        error? r2 = x ->> w2; // @error
    }
    worker w2 {
        int j = <- w1; // @error
        int i = <- w1; // @error
    }
}
