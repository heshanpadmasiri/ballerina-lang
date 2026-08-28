// Copyright (c) 2021, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

public const int A1 = 12;
public const float A2 = 5.0;

type A A1|A2;

type B int|string;

function testBinaryBitwiseOperationsNegativeScenarios() {
    float a1 = 1.0;
    int x1 = a1 & 64; // @error

    A a2 = 5.0;
    int x2 = 1 & a2; // @error

    int|float a3 = 12;
    int x3 = 1 & a3; // @error

    B a4 = 10;
    int x4 = 1 & a4; // @error

    int x5 = 1 & A2; // @error

    int x6 = a1 | 64; // @error

    int x7 = 1 | a2; // @error

    int x8 = 1 | a3; // @error

    int x9 = 1 | a4; // @error

    int x10 = 1 | A2; // @error

    int x11 = a1 ^ 64; // @error

    int x12 = 1 ^ a2; // @error

    int x13 = 1 ^ a3; // @error

    int x14 = 1 ^ a4; // @error

    int x15 = 1 ^ A2; // @error

    float? x16 = 4.0;
    int? x17 = 1;

    int? x18 = x16 & x17; // @error
    int? x19 = x16 | x17; // @error
    int? x20 = x16 ^ x17; // @error

    int:Unsigned8? x21 = 23;
    int:Unsigned16? x22 = 1;
    int:Unsigned8? x23 = x21 | x22; // @error

    int:Unsigned16? x24 = 1;
    byte? x25 = 1;
    byte? x26 = x24 | x25; // @error

    int:Unsigned32? x27 = 1;
    byte? x28 = x27 | x25; // @error

    byte a = 12;
    int:Unsigned16 e = 12;
    int:Unsigned32 f = 5;

    byte x29 = a | f; // @error
    byte x30 = a | e; // @error
    int:Unsigned8 x31 = a | f; // @error
    int:Unsigned8 x32 = a | e; // @error
}
