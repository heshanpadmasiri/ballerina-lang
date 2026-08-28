function Listener (string x, Listener e) { // @error
    e.message = x;
}

type 'error error; // @error
type 'json json; // @error
type 'anydata anydata; // @error
type 'int int; // @error
type 'never never; // @error
type 'readonly readonly; // @error
type 'xml xml; // @error
