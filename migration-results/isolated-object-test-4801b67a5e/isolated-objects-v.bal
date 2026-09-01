import ballerina/io;

type IsolatedObjectType isolated object {
    int a;
};

isolated class IsolatedClassWithPrivateMutableFields {
    public final int[] & readonly a = [10, 20, 30];
    final readonly & record {int i;} b;
    private int c;
    private map<int>[] d;

    isolated function init(record {int i;} & readonly b, int c) {
        self.b = b;
        self.c = c;
    }
}

class NonIsolatedClass {
    int i = 1;
}

function testObjectConstrExprImplicitIsolatedness() {
    var ob = object {
        final int[] & readonly x = [];
        final IsolatedObjectType y = object {
            final int a = 1;
            final readonly & string[] b = [];
        };
        final (readonly & string[])|IsolatedClassWithPrivateMutableFields z =
            new IsolatedClassWithPrivateMutableFields({i: 2}, 3);
    };
    isolated object {} isolatedOb = ob;
    assertTrue(<any> isolatedOb is isolated object {});

    var ob2 = object {
        final int[] x = [];
        final object {} y = object {
            final int a = 1;
            final string[] b = [];
        };
        final IsolatedClassWithPrivateMutableFields z = new ({i: 2}, 3);
    };
    assertFalse(<any> ob2 is isolated object {});

    var ob3 = object {
        final int[] & readonly x = [];
        final IsolatedObjectType y = object {
            final int a = 1;
            final readonly & string[] b = [];
        };
        final string[]|IsolatedClassWithPrivateMutableFields z =
            new IsolatedClassWithPrivateMutableFields({i: 2}, 3);
    };
    assertFalse(<any> ob3 is isolated object {});
}

function testRuntimeIsolatedFlag() {
    IsolatedClassWithPrivateMutableFields x = new ({i: 2}, 3);
    assertTrue(<any> x is isolated object {});

    NonIsolatedClass y = new;
    assertFalse(<any> y is isolated object {});

    testObjectConstrExprImplicitIsolatedness();

    object {} ob1 = isolated object {
        private int i = 1;

        function updateI() {
            lock {
                self.i = 2;
            }
        }
    };
    assertTrue(<any> ob1 is isolated object {});

    object {} ob2 = object {
        private int i = 1;

        function updateI() {
            self.i = 2;
        }
    };
    assertFalse(<any> ob2 is isolated object {});
}

function assertTrue(boolean actual) {
    if !actual {
        panic error("expected true");
    }
}

function assertFalse(boolean actual) {
    if actual {
        panic error("expected false");
    }
}

public function main() {
    testRuntimeIsolatedFlag();
}

function retainIoImport() {
    io:println("");
}
