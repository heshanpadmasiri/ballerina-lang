public function main() {
    worker w1 {
        int sum = 0;
        foreach var i in 1...10 {
            sum = sum + i;
            "20" -> w2; // @error
        }
    }
    worker w2 {
        int j = <- w1; // @error
    }
}
