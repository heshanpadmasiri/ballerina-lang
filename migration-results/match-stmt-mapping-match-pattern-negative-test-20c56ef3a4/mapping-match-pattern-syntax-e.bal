// Copyright (c) 2022 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

function testMappingMatchNegativeSyntax(map<string> m) {
    match m {
        {f: "s",} => { // @error @error
        }

        {f: "s", ...var c,} => { // @error
        }

        {...var c,} => { // @error
        }

        {...var c, f1: "s", var d, f2: "s2"} => { // @error @error @error
        }

        {f1: "s", ...var c, f2: "s2", var d, f3: "s"} => { // @error @error @error
        }

        {,} => { // @error
        }
    }
}
