class ObjectWithInvalidFillingReadOnUninitializedField {
    map<int[]> s; // @error

    function init() {
        self.s["one"][0] = 1;
    }
}
