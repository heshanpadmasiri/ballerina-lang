import test/object_initializer_negative_project.initializers as inp;

function testPrivateInitializerInvocation() {
    inp:student _ = new; // @error
}
