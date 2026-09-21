public class Class1 {
    int i = 0;

    public function foo(int arg1 = i) { // @error
        int _ = self.i;
    }
}

public class Class2 {
    int i = 0;

    public function foo(int i = i) { // @error
    }
}

class Class3 {
    int i = 0;
    string s = "";

    public function foo(int arg1 = i, string arg2 = s) { // @error // @error
    }
}

class Class4 {
    int i = 0;
    string s = "";
    string|int u;

    function init() {
        self.u = 2;
    }

    public function foo(int arg1 = i, string arg2 = s, string|int arg3 = u) { // @error // @error // @error
    }
}

public class Class5 {
    int i = 0;

    public function foo(int arg1 = i) { // @error
        int _ = self.i;
    }

    public function bar() {
        self.foo(2);
    }
}

public class Class6 {
    int i = 0;

    public function foo(int arg1 = i) { // @error
        object {} _ = object {
            int i = 0;

            function foo(int arg2 = i) { // @error
                int _ = self.i;
            }
        };
    }
}

public class Class7 {
    int i = 0;

    public function foo(int arg1 = i) { // @error
        object {} _ = object {

            function foo(int arg2 = i) { // @error
            }
        };
    }
}

public class Class8 {
    int i = 0;

    public function foo(int arg1 = i) { // @error
        object {} _ = object {
            int i = 0;

            function foo(int arg2 = i) { // @error
                int _ = self.i;
                object {} _ = object {
                    int i = 0;

                    function foo(int arg3 = i) { // @error
                        int _ = self.i;
                    }
                };
            }
        };
    }
}

type Object1 object {
    int i;
    function foo(int arg1 = i); // @error
};

type Object2 object {
    int i;
    function foo(int arg1 = i); // @error
    function bar(int arg1 = i); // @error
};

class Class9 {
    int i = 0;
    string s = "";
    string|int u;

    function init() {
        self.u = 2;
    }

    public function foo(int arg1 = self.i, string arg2 = self.s, string|int arg3 = self.u) { // @error // @error // @error
    }
}
