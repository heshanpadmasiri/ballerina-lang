type s1 record {
    float x;
};

function getGlobalVars() returns float {
    s1 v = {}; // @error
    float f = v.foo:x; // @error
    return f;
}

listener Listener uninitializedModuleListener; // @error // @error

public listener Listener uninitializedPublicModuleListener; // @error // @error

public class Listener { // @error
    *Listener;

    public function init() {
    }

    public function attach(service object {} s, string[]|string? name = ()) returns error? { }

    public function detach(service object {} s) returns error? { }

    public function 'start() returns error? {
    }

    public function gracefulStop() returns error? {
        return ();
    }

    public function immediateStop() returns error? {
        return ();
    }
}
