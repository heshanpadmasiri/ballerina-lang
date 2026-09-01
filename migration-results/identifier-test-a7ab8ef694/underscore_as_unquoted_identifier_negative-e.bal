string _; // @error variable declaration having binding pattern must be initialized
_ foo; // @error '_' is a keyword, and may not be used as an identifier

type _ int|float; // @error '_' is a keyword, and may not be used as an identifier

function _(any|error bar) { // @error '_' is a keyword, and may not be used as an identifier
    string _; // @error variable declaration having binding pattern must be initialized
    _ foo; // @error '_' is a keyword, and may not be used as an identifier

    match bar {
        var error (message, ..._) => { // @error '_' is a keyword, and may not be used as an identifier
        }
    }
}
