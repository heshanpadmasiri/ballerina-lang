function testAsyncSendAsExpressionWithForEachStmt() {
    worker w1 {
        foreach var j in 5 -> w2 { // @error

        }
    }

    worker w2 {
        int x = <- w1;
    }

    _ = wait {w1, w2};
}

function testAsyncSendAsExpressionWithCompoundAssignmentStmt() {
    worker w1 {
        int result = 4;
        result += 5 -> w2; // @error
    }

    worker w2 {
        int x = <- w1;
    }

    _ = wait {w1, w2};
}
