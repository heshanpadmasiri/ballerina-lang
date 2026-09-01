service object {} x =
service object {
    resource function get foo() returns error? = external; // @error

    resource function put bar() = external; // @error

    resource function post baz(float f) = external; // @error
};
