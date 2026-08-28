public function main() {
    map<byte> bmap = {
        a: 0,
        b: 123,
        c: 255
    };
    map<int> imap = bmap;
    imap["d"] = 300; // @panic
}
