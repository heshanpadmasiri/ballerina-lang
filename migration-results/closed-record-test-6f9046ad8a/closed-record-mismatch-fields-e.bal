public function main() {
    FooError|BarError e = error FooError("message", bar = "bar"); // @error
}
type FooErrData record {|
    string foo;
    string message;
    error cause?;
|};
type BarErrData record {|
    string bar;
    string message?;
    error cause?;
|};
type FooError error<FooErrData>;
type BarError error<BarErrData>;
