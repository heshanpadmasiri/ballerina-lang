import ballerina/io;

type TrxError distinct error<TrxErrorData>;
type TrxErrorData record {| string message?; error cause?; string data = ""; |};

public function main() {
    worker w1 {
        int i = 2;
        TrxError? success = i ->> w2; // @error
        io:println("w1");
    }
    worker w2 returns boolean|error {
        int j = 25;
        if 0 > 1 {
            return error("trxErr", data = "test");
        }
        j = <- w1;
        io:println(j);
        return true;
    }
}
