function testSingleIterable() {
    map<string> words = {a: "ant", b: "bear"};
    float[] flArray = [4.0, 5.0, 6.0, 7.0];

    int[] lambda2 = words.map(word => word[1].toUpperAscii()); // @error
    string[] lambda3 = words.map((index, word) => word[1].toUpperAscii()); // @error @error

    int avg1 = flArray.map((index, value) => value).length(); // @error
    string avg2 = flArray.map(entry => entry).length(); // @error
    string avg3 = flArray.map(entry => entry.toUpperAscii()).length(); // @error @error
    string str1 = flArray.map(entry => entry.toString()); // @error
}

function testChainedIterable() {
    map<string> words = {a: "ant", b: "bear"};
    float[] flArray = [4.0, 5.0, 6.0, 7.0];
    string[] lambda1 = words.filter(word => word[1] == "ant").map(word => word.toUpperAscii() + " MAN"); // @error
    string[] str = words.filter(word => word[1] == "ant").map(word => word[1].toUpperAscii() + " MAN").length(); // @error
}
