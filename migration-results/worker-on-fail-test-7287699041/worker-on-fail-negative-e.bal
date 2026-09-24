// Copyright (c) 2024 WSO2 LLC. (https://www.wso2.com).
// SPDX-License-Identifier: Apache-2.0

public function testNoMessageErrorForOnFailAsyncSend() {
    worker w1 {
        0 -> w2;
    } on fail {
        1 -> w2;
    }

    worker w2 {
        int _ = <- w1;
        int _ = <- w1; // @error
    }

    wait w2;
}

public function testNoMessageErrorForOnFailSyncSend() {
    worker w1 {
        0 ->> w2;
    } on fail {
        1 ->> w2;
    }

    worker w2 {
        int _ = <- w1;
        int _ = <- w1; // @error
    }

    wait w1;
}

public function testNoMessageErrorWithWorkerOnFail() {
    worker w1 {
        boolean b = true;
        check error("err");
        0 -> w2;
        if b {
            1 -> w2;
        }
    } on fail {
        boolean c = true;
        2 -> w2;
        if c {
            3 ->> w2;
        } else {
            4 -> w2;
        }
    }

    worker w2 {
        int _ = <- w1; // @error
        int _ = <- w1; // @error
        int _ = <- w1; // @error
        int _ = <- w1; // @error
        int _ = <- w1; // @error
    }

    wait w2;
}
