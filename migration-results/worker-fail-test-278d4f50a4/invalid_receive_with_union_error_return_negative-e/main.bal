const FOO = "foo";
type FooError distinct error;
type TrxError distinct error<TrxErrorData>;
type TrxErrorData record {| string message?; error cause?; |};

public function main() {
    worker w1 returns FooError|TrxError? {
        int j = 25; // @error
        if 0 > 1 {
            return error FooError(FOO);
        }
        j = <- w2;
        if 1 == 2 {
            TrxError e = error TrxError("trxError"); // @error
            return e;
        }
        j = <- w2;
        j = <- w2;
        return;
    }
    worker w2 returns boolean|error {
        int i = 2;
        TrxError? success = i ->> w1; // @error @error
        success = i ->> w1; // @error
        () _ = i ->> w1; // @error
        return true;
    }
}
