public type Details record {|
    string name;
    int yob;
|};

public type Department record {
    string name = "IT";
};

public readonly class Employee {
    public Details details;
    public Department dept;
    public int id;

    public function init(Details & readonly details, Department & readonly dept, int id) {
        self.details = details;
        self.dept = dept;
        self.id = id;
    }

    public function getId() returns int {
        return self.id;
    }
}

public type Controller object {
    public function getValue() returns int;
};

public type Config record {|
    Controller & readonly c1;
    Controller c2;
    Controller c3;
|};

public readonly class DefaultController {
    public final string id = "default";
    public map<int>? & readonly mp = ();

    public function getValue() returns int {
        return 0;
    }
}

public readonly class CustomController {
    public string id;

    public function init(string id) {
        self.id = id;
    }

    public function getValue() returns int {
        return 120;
    }
}

public class MutableController {
    public string id = "mutable";

    public function getValue() returns int {
        return 200;
    }
}

public function main() {
}
