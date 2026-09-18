class G {
    string s;
    function init(string s) { self.s = s; }
}

public function main() {
    G[] a = [new("hello"), new("world")];
    a[3] = new("test"); // @panic
}
