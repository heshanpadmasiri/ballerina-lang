// Copyright (c) 2023 WSO2 LLC. (http://www.wso2.com).
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

const string[2] ERR_ARR1 = [3, 1]; // @error @error
const int[1] ERR_ARR2 = [3, 1]; // @error
const (float|decimal)[] ERR_ARR3 = [3, 2.0 + 1d]; // @error
const int[] ERR_ARR4 = [1, 2, getIntValue()]; // @error

function getIntValue() returns int {
    return 3;
}

const TUPLE1 = [3, 1];
const float[] ERR_TUPLE1 = [...TUPLE1]; // @error @error

const [int, float] ERR_TUPLE2 = [3, 1, 3]; // @error
[record {| int a; 2 b;|}] ERR_TUPLE_3 = []; // @error
const [1|2] ERR_TUPLE4 = []; // @error
const int[2]|[int, int] ERR_TUPLE5 = [];
const TUPLE1 TUPLE2 = [3, 3]; // @error
const byte[2] ARR_1 = [300, 200]; // @error
const byte[2] ARR_2 = [300, 200, 100]; // @error
const byte[*] ARR_3 = [300, 400]; // @error @error
const [byte, byte, int:Signed8] TUPLE_3 = [300, 400, 500]; // @error @error @error

const float[]|decimal[] ARR_5 = [1, 2.0]; // @error
const string[]|boolean[] ARR_6 = [1, 2.0]; // @error
const int|float ARR_7 = [1, 2.0]; // @error
const int ARR_8 = [1, 2.0]; // @error
const TUPLE_4 = [2 > 3]; // @error
const [record {| int a = 5; 2 b;|}] TUPLE_5 = [{b: 2}]; // @error
const [int, table<int>] TUPLE_6 = [1]; // @error
