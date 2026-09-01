string '_; // @error '_' is a keyword, and may not be used as an identifier
'_ foo; // @error '_' is a keyword, and may not be used as an identifier
int '_ = 21; // @error '_' is a keyword, and may not be used as an identifier

type '_ int|float; // @error '_' is a keyword, and may not be used as an identifier

function '_(any|error bar) { // @error '_' is a keyword, and may not be used as an identifier
    string '_; // @error '_' is a keyword, and may not be used as an identifier
    '_ foo; // @error '_' is a keyword, and may not be used as an identifier
    int '_ = 21; // @error '_' is a keyword, and may not be used as an identifier

    match bar {
        var error (message, ...'_) => { // @error '_' is a keyword, and may not be used as an identifier
        }
    }
}
