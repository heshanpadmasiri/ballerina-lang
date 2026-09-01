import ballerina/io;
import ballerina/lang.runtime;

// Test when there is a lock block in an attached function.
class person {
    string stars = "";
    Student std = new;

    public function update(string s) {
        lock {
            foreach var i in 1 ... 1000 {
                self.stars = self.stars + s;
                self.std = new;
                self.std.score = i + 1;
                self.std.grade = i;
                self.std = new;
            }
        }
    }
}

person p1 = new;

function lockFieldInSameObject() returns string {
    worker w1 {
        p1.update("*");
    }

    p1.update("#");
    runtime:sleep(0.01);
    return p1.stars;
}

// Test locking when an object is global.
class Student {
    int score = 0;
    int grade = 0;
}

Student student = new;

function fieldLock() returns int {
    workerFunc();
    return student.score;
}

function workerFunc() {
    worker w1 {
        increment();
    }

    runtime:sleep(0.01);
    increment();
}

function increment() {
    lock {
        foreach var i in 1 ... 1000 {
            student.score += i;
        }
    }
}

// Test locking when an object is passed as a function parameter.
function objectParamLock() returns int {
    Student stParam = new;
    person p = new;
    workerFuncParam(stParam, p);
    return stParam.score;
}

function workerFuncParam(Student param, person p) {
    worker w1 {
        incrementParam(param, p);
    }

    runtime:sleep(0.01);
    incrementParam(param, p);
}

function incrementParam(Student param, person p) {
    lock {
        Student inLockObj = new;
        inLockObj.score = 10;
        foreach var i in 1 ... 1000 {
            p.std = new;
            param.score += i;
        }
    }
}

public function main() {
    io:println(lockFieldInSameObject()); // @output ########################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################################****************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************
    io:println(fieldLock()); // @output 1001000
    io:println(objectParamLock()); // @output 1001000
}
