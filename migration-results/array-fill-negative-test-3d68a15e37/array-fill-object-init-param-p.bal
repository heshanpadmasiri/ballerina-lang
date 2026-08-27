class ObjInitWithParam {
    int i;

    function init(int i) {
        self.i = i;
    }
}

public function main() {
    ObjInitWithParam[] objWithParamsArray = [];
    ObjInitWithParam o = new(1);
    objWithParamsArray[0] = o;
    objWithParamsArray[3] = o; // @panic
}
