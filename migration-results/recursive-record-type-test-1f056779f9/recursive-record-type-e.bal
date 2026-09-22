type RecursiveRecordWithRestType record {|
    int i;
    RecursiveRecordWithRestType...;
|};

public function main() {
    RecursiveRecordWithRestType a = {i: 4};
    RecursiveRecordWithRestType b = {i: 5, "a": a};
    RecursiveRecordWithRestType c = {i: 5, "a": a, "b": b}; // @error: unused variable 'c'
}
