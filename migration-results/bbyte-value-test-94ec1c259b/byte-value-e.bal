function testWorkerWithByteVariable() {
    worker w1 {
        byte a = 10;
        byte b = 12; // @error unused variable 'b'
        a -> w2;
        b = <- w2;
    }
    worker w2 {
        byte a = 0; // @error unused variable 'a'
        byte b = 15;
        a = <- w1;
        b -> w1;
    }
}
