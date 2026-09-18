type CRec record { float f; };
type DRec record {| float f; |};

public function main() {
    DRec d = { f: 2.0 };
    CRec c = d;
    c["g"] = 10; // @panic
}
