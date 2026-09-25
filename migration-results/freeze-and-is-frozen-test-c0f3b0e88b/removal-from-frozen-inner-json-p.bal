public function main() {
    map<json> j1 = {name: "Em", dataType: "json", pos: "inner"};
    map<json> j2 = {name: "Zee", dataType: "json", pos: "outer", innerJson: j1};
    map<json> j3 = j2.cloneReadOnly();
    map<json> j4 = <map<json>>j3["innerJson"];
    _ = j4.remove("name"); // @panic
}
