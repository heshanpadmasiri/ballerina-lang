function captureBindingPatternNegative1(any v) returns string {
    match v {
        var a => { // @error
            return "Matched";
        }
        _ => { // @error
            return "Not matched";
        }
    }
}
