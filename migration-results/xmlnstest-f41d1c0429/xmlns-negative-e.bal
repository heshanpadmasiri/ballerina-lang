// Copyright (c) 2024, WSO2 LLC. (https://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
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

const A = 1;
const string|int B = A;
const C = 2;
const E = "";

xmlns A as ns0; // @error
xmlns B as ns1; // @error
xmlns D as ns2; // @error
xmlns E as ns3; // @error

function foo() {
    xmlns C as ns4; // @error
    xmlns F as ns5; // @error
}

type G record {|
    int a;
|};

const X = G; // @error
xmlns X as ns;

const Z = K; // @error // @error
xmlns Z as ns6;
