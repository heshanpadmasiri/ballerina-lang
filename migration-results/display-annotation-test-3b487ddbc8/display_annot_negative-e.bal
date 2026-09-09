@display {iconPath: "fooIconPath.icon", label: "l"} // @error
@display {iconPath: "fooIconPath.icon", label: "j"}
function foo(int i, string k) returns int {
    return i;
}

public type RefreshTokenGrantConfig record {|
    @display {iconPath: "Field.icon", label: "clientSecret field", kind: "passwordx"} // @error
    string clientSecret;
|};
