// Copyright (c) 2022 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.

function testMissingDigitAfterExponentIndicator() {
    _ = 32.99E-; // @error
    _ = 32.99E+; // @error
    _ = 22.99E; // @error
    _ = 22.99e-; // @error
    _ = 22.99e+; // @error
    _ = 22.99e; // @error
    _ = 22.99E-f; // @error
    _ = 22.99E+f; // @error
    _ = 22.99Ef; // @error
    _ = 22.99e-f; // @error
    _ = 22.99e+f; // @error
    _ = 22.99ef; // @error
    _ = 22.99E-d; // @error
    _ = 22.99E+d; // @error
    _ = 22.99Ed; // @error
    _ = 22.99e-d; // @error
    _ = 22.99e+d; // @error
    _ = 22.99ed; // @error
    _ = 99E-; // @error
    _ = 99E+; // @error
    _ = 99E; // @error
    _ = 99e-; // @error
    _ = 99e+; // @error
    _ = 99e; // @error
    _ = 99E-f; // @error
    _ = 99E+f; // @error
    _ = 99Ef; // @error
    _ = 99e-f; // @error
    _ = 99e+f; // @error
    _ = 99ef; // @error
    _ = 99E-d; // @error
    _ = 99E+d; // @error
    _ = 99Ed; // @error
    _ = 99e-d; // @error
    _ = 99e+d; // @error
    _ = 99ed; // @error
    _ = .99E-; // @error
    _ = .99E+; // @error
    _ = .99E; // @error
    _ = .99e-; // @error
    _ = .99e+; // @error
    _ = .99e; // @error
    _ = .99E-f; // @error
    _ = .99E+f; // @error
    _ = .99Ef; // @error
    _ = .99e-f; // @error
    _ = .99e+f; // @error
    _ = .99ef; // @error
    _ = .99E-d; // @error
    _ = .99E+d; // @error
    _ = .99Ed; // @error
    _ = .99e-d; // @error
    _ = .99e+d; // @error
    _ = .99ed; // @error
    _ = 0x2p; // @error
    _ = 0x2p+; // @error
    _ = 0x3p-; // @error
    _ = 0xcp; // @error
    _ = 0xcp+; // @error
    _ = 0xcp-; // @error
    _ = 0xc.4bp; // @error
    _ = 0xc.4bp+; // @error
    _ = 0xc.4bp-; // @error
    _ = 0X2p; // @error
    _ = 0X2p+; // @error
    _ = 0X3p-; // @error
    _ = 0Xcp; // @error
    _ = 0Xcp+; // @error
    _ = 0Xcp-; // @error
    _ = 0Xc.4bp; // @error
    _ = 0Xc.4bp+; // @error
    _ = 0Xc.4bp-; // @error
    _ = 0xp6; // @error
    _ = 0XP6; // @error
    _ = 0xp-6; // @error
    _ = 0XP-6; // @error

    10f _ = 100Ef; // @error
    0XA _ = 0XAAP+; // @error
    0XA _ = 0XP+0; // @error
}
