type Value "foo"|"bar";
type Index -1|0|4;
public function main() {
    Value value = "foo";
    Index index = 4;
    _ = value[index]; // @panic
}
