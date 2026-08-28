// Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.

public const int A1 = 62;
public const float A2 = 63.0;

type A A1|A2;
type B int|string;

function testBitwiseShiftNegativeScenarios() {
    float a1 = 1.0;
    int x1 = a1 << 64; // @error

    A a2 = 62;
    int x2 = 1 << a2; // @error

    int|float a3 = 62;
    int x3 = 1 << a3; // @error

    B a4 = 62;
    int x4 = 1 << a4; // @error

    int x5 = 1 << A2; // @error

    int x6 = a1 >> 64; // @error

    int x7 = 1 >> a2; // @error

    int x8 = 1 >> a3; // @error

    int x9 = 1 >> a4; // @error

    int x10 = 1 >> A2; // @error

    int x11 = a1 >>> 64; // @error

    int x12 = 1 >>> a2; // @error

    int x13 = 1 >>> a3; // @error

    int x14 = 1 >>> a4; // @error

    int x15 = 1 >>> A2; // @error
}
