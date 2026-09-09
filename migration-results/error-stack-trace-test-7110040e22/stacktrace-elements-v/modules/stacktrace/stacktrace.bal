public function getStackTrace() returns error:StackFrame[] {
    error e = error("error!");
    return e.stackTrace();
}
