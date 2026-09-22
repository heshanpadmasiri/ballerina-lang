type RecordWithErrorField record {|
    error 'error;
    error 'error; // @error
|};

type Song record {|
    string name;
    string name; // @error
|};
