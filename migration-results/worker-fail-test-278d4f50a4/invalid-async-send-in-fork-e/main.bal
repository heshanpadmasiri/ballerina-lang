public function main() {
    fork {
        worker w1 {
            int i = 20; // @error
        }
        worker w2 {
            int j = 25; // @error
            int sum = 0;
            fork {
                worker w3 {
                    foreach var i in 1...10 {
                        sum = sum + i;
                        i -> w4; // @error
                    }
                }
                worker w4 {
                    int k = <- w3; // @error
                }
            }
        }
    }
}
