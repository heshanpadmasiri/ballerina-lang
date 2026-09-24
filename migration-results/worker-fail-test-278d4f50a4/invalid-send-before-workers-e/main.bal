function invalidWorkReceiveBeforeWorker() {
    int i = 1;
    i -> w1; // @error
    worker w1 {
        int m1 = <- function;
    }
}
