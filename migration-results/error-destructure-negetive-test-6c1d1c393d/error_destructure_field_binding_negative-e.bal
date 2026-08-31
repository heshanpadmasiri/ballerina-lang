// Copyright (c) 2022 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file under the Apache License, Version 2.0.

type FooError error<record {|string message?; string cause; boolean fatal?; string...;|}>;

FooError err = error("Error One", message = "Msg One", cause = "Cause One", fatal = false);

function testNonRequiredFieldBindingNegative() {
    string? reason1;
    string? reason2;
    string? message1;
    string? message2;
    string? cause1;
    string? cause2;
    boolean? fatal1;
    boolean? fatal2;

    error(reason1, message = message1, cause = cause1, fatal = fatal1) = err; // @error // @error
    error FooError(reason2, message = message2, cause = cause2, fatal = fatal2) = err; // @error // @error
}

function testUndefinedErrorDetailsNegative() {
    string? reason1;
    string? reason2;
    string? msg1;
    string? msg2;
    string? cause1;
    string? cause2;
    any? extra1;
    any? extra2;

    error(reason1, msg = msg1, cause = cause1, extra = extra1) = err; // @error // @error
    error FooError(reason2, msg = msg2, cause = cause2, extra = extra2) = err; // @error // @error
}
