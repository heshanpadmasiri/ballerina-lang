public function main() {
    map<json> j1 = {name: "Em", dataType: "json", pos: "inner"};
    map<json> j2 = {name: "Zee", dataType: "json", pos: "outer", innerJson: j1};
    map<json> j4 = j2.cloneReadOnly();
    map<json> j5 = <map<json>>j4["innerJson"];
    j5["newField"] = "Em"; // @panic
}
