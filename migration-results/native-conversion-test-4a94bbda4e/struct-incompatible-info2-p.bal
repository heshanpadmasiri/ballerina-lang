type Info2 record {|
    xml[] infoBlob = [];
|};

function trigger() {
    xml xml1 = xml `Hello, world!`;
    Info2 info = {infoBlob: [xml1]};
    var j = info.cloneWithType(json); // @panic
    if (j is json) {
        return;
    }
    panic j;
}

public function main() {
    trigger();
}
