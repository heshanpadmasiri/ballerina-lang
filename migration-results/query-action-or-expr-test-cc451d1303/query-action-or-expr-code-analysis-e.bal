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
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

function testQueryActionOrExprWithSyncSendAction() {
    worker w1 {
        int a = 5;

        _ = from var i in 1...2
            let any _ = a ->> w6 // @error
            select a ->> w6; // @error
        int _ = <- w6;
    }

    worker w2 {
        int c = 5;

        _ = from var i in 1...2
            let any _ = c ->> w6, int _ = 1 // @error
            select c ->> w6; // @error
        int _ = <- w6;
    }

    worker w3 {
        int e = 5;

        _ = from int i in 1...2
            let any _ = e ->> w6 // @error
            order by i
            select e ->> w6; // @error
        int _ = <- w6;
    }

    worker w4 {
        int g = 5;

        _ = from var i in 1...2
            let any _ = g ->> w6 // @error
            limit 1
            select g ->> w6; // @error
        int _ = <- w6;
    }

    worker w5 {
        int i = 5;

        _ = from var m in 1...2
            let any _ = i ->> w6 // @error
            let int _ = 10
            select i ->> w6; // @error
        int _ = <- w6;
    }

    worker w6 {
        int b = 15;
        _ = <- w1;
        b -> w1;

        int d = 15;
        _ = <- w2;
        d -> w2;

        int f = 15;
        _ = <- w3;
        f -> w3;

        int h = 15;
        _ = <- w4;
        h -> w4;

        int j = 15;
        _ = <- w5;
        j -> w5;
    }
}

function testQueryActionOrExprWithSingleReceiveAction() {
    worker w1 {
        int a = 5;

        a -> w6;
        _ = from var i in 1...2
            let any _ = <- w6 // @error
            select <- w6; // @error
    }

    worker w2 {
        int c = 5;

        c -> w6;
        _ = from var i in 1...2
            let any _ = <- w6, int _ = 1 // @error
            select <- w6; // @error
    }

    worker w3 {
        int e = 5;

        e -> w6;
        _ = from int i in 1...2
            let any _ = <- w6 // @error
            order by i
            select <- w6; // @error
    }

    worker w4 {
        int g = 5;

        g -> w6;
        _ = from var i in 1...2
            let any _ = <- w6 // @error
            limit 1
            select <- w6; // @error
    }

    worker w5 {
        int i = 5;

        i -> w6;
        _ = from var m in 1...2
            let any _ = <- w6 // @error
            let int _ = 10
            select <- w6; // @error
    }

    worker w6 {
        int b = 15;
        _ = <- w1;
        b -> w1;

        int d = 15;
        _ = <- w2;
        d -> w2;

        int f = 15;
        _ = <- w3;
        f -> w3;

        int h = 15;
        _ = <- w4;
        h -> w4;

        int j = 15;
        _ = <- w5;
        j -> w5;
    }
}

function testQueryActionOrExprAsyncSendActionInSelectClause() {
    worker w1 {
        _ = from var i in [1]
            select i -> w2; // @error
    }

    worker w2 {
        _ = <- w1;
    }
}

function testQueryActionOrExprAsyncSendActionInLetClause() {
    worker w1 {
        _ = from var i in [1]
            let int? _ = i -> w2 // @error
            select i;
    }

    worker w2 {
        _ = <- w1;
    }
}
