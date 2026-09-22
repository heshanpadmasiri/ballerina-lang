import ballerina/io;

int weightConst = 1000000;

string[] log = [];
int len = 0;

public function main() {
    io:println(orderingTest()); // @output ["child: end","parent: end"]
    io:println(testMergeSort([10, 9, 8, 7, 6, 5, 4, 3, 2, 1])); // @output [1,2,3,4,5,6,7,8,9,10]
}

function orderingTest() returns string[] {
    future<()> ap = start asyncFunction();
    int i = 0;
    while i < weightConst {
        i += 1;
    }

    checkpanic wait ap;

    append(log, "parent: end");
    return log;
}

function asyncFunction() {
    append(log, "child: end");
}

function append(string[] arr, string msg) {
    arr[len] = msg;
    len += 1;
}

function testMergeSort(int[] array) returns int[] {
    int[] helper = [];
    doParallelMergesort(array, helper, 0, array.length() - 1);
    return array;
}

function doParallelMergesort(int[] array, int[] helper, int low, int high) {
    if low < high {
        int middle = (low + high) / 2;
        fork {
            worker w1 {
                doParallelMergesort(array, helper, low, middle);
            }
            worker w2 {
                doParallelMergesort(array, helper, middle + 1, high);
            }
        }
        _ = wait {w1, w2};
        merge(array, helper, low, middle, high);
    }
}

function merge(int[] array, int[] helper, int low, int middle, int high) {
    foreach var i in low ... high {
        helper[i] = array[i];
    }

    int helperLeft = low;
    int helperRight = middle + 1;
    int current = low;

    while helperLeft <= middle && helperRight <= high {
        if helper[helperLeft] <= helper[helperRight] {
            array[current] = helper[helperLeft];
            helperLeft += 1;
        } else {
            array[current] = helper[helperRight];
            helperRight += 1;
        }
        current += 1;
    }

    while helperLeft <= middle {
        array[current] = helper[helperLeft];
        current += 1;
        helperLeft += 1;
    }
}
