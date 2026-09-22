
public function bar() {
    http:Client httpClient = new("url"); // @error // @error
    io:println("Hello world!"); // @error // @error
    string csv = io:CSV; // @error
}
