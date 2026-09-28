function testTupleVarDeclWithInvalidSyntax() {
    [error, boolean...] [error(g,), ...j] = [error("error!"), true]; // @error @error @error
    [error, boolean...] [error(g2),(), ...j] = [error("error!"), true]; // @error @error
    [error, boolean...] [error(g, /), ...j] = [error("error!"), true]; // @error @error @error
    [error, boolean...] [error(g, ~), ...j] = [error("error!"), true]; // @error @error @error
}
