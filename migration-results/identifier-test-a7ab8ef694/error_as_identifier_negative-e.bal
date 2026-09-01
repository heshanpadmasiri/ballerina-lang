class ErrorField {
    public error 'error;
    public error 'error; // @error redeclared symbol 'error'
    public int 'int;

    function init(error er, int value = 20) {
        self.'error = er;
        self.'int = value;
    }
}

type ErrorDataWithErrorField record {
    error 'error;
    error 'error; // @error redeclared symbol 'error'
};

function getError() returns error {
    return error("Generated Error");
}

function funcErrorNamedDefaultArgument(error 'error = getError(), error 'error = getError()) {} // @error redeclared symbol 'error'

function funcErrorNamedIncludedParam(*ErrorDataWithErrorField 'error, *ErrorDataWithErrorField 'error) {} // @error redeclared symbol 'error'

function funcErrorNamedRequiredParam(ErrorDataWithErrorField 'error, ErrorDataWithErrorField 'error) {} // @error redeclared symbol 'error'

function funcErrorNamedRestParam(ErrorDataWithErrorField 'error, ErrorDataWithErrorField... 'error) {} // @error redeclared symbol 'error'

function funcErrorNamedIncludedAndRequiredParam(ErrorDataWithErrorField 'error, *ErrorDataWithErrorField 'error) {} // @error redeclared symbol 'error'
