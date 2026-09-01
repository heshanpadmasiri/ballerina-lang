function test1() {
    streams:Select selectVar = streams:createSelect(outputProcess.process, function (string k) returns map<any> { // @error // @error // @error // @error // @error
        int[2] arr = [12, 13];
        int index = 1;
        return {
            "val1": arr[3], // @error
            "val3": 24
        };
    });
}
