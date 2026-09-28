class ObjectWithAnyTypeVariables {
    public any x;
    public any y;

    function init() {
        self.x = "B";
        self.y = 100;
    }
}

class ObjectWithoutAnyTypeVariables {
    public string x;
    public int y;

    function init() {
        self.x = "A";
        self.y = 12;
    }
}

public function main() {
    ObjectWithoutAnyTypeVariables o1 = new;
    ObjectWithAnyTypeVariables o2 = o1;
    o2.x = (); // @panic
}
