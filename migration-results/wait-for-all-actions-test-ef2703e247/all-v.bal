import ballerina/io;
import ballerina/lang.runtime;

public function main() {
    map<anydata|error> r1 = waitTest1();
    io:println(r1["f1"]); // @output 7
    io:println(r1["f2"]); // @output 22
    io:println(r1["f3"]); // @output hello foo
    io:println(r1["f4"]); // @output true
    map<int|string|error> r2 = waitTest2();
    io:println(r2["f1"]); // @output 7
    io:println(r2["str1"]); // @output hello foo
    io:println(r2["f3"]); // @output 150
    io:println(r2["str2"]); // @output hello xyz
    var r3 = waitTest3(); io:println(r3.f1); // @output 7
    io:println(r3.f3); // @output 150
    io:println(r3.f5); // @output hello bar
    map<anydata|error> r4 = waitTest4(); io:println(r4["f1"]); // @output 7
    io:println(r4["f4"]); // @output hello foo
    io:println(r4["f2"]); // @output 22
    map<anydata|error> r5 = waitTest5(); io:println(r5["id"]); // @output 66
    io:println(r5["name"]); // @output hello foo
    map<anydata|error> r6 = waitTest6(); io:println(r6["idField"]); // @output 150
    io:println(r6["stringField"]); // @output hello foo
    io:println(waitTest7()); // @output 7
    firstRec r8 = waitTest8(); io:println(r8.id); // @output 8
    io:println(r8.name); // @output hello moo
    secondRec r9 = waitTest9(); io:println(r9.f1); // @output 20
    io:println(r9.f5); // @output hello foo
    secondRec r10 = waitTest10(); io:println(r10.f1); // @output 30
    io:println(r10.f5); // @output hello xyz
    thirdRec r11 = waitTest11(); io:println(r11.f1); // @output 30
    io:println(r11.'field); // @output hello bar
    fourthRec r12 = waitTest12(); io:println(r12.id); // @output 86
    io:println(waitTest16()); // @output 0
    record {| any f1; any f2; |} r17 = <record {| any f1; any f2; |}>waitTest17(); io:println(r17.keys().length()); // @output 2
    TwoIntOrErrorFields r17a = <TwoIntOrErrorFields>r17.f1; io:println(r17a.f1); // @output 7
    io:println(r17a.f2); // @output 150
    map<int|string|error> r17b = <map<int|string|error>>r17.f2; io:println(r17b["name"]); // @output hello foo
    io:println(r17b["id"]); // @output 12
    secondRec r18 = waitTest18(); io:println(r18.f1); // @output 7
    io:println(r18.f5); // @output hello foo
    map<int> r19 = waitTest19(); io:println(r19["w1"]); // @output 30
    io:println(r19["w2"]); // @output 16
    map<int|string> r20 = waitTest20(); io:println(r20["w2"]); // @output hello world
    io:println(r20["w3"]); // @output 15
    sealedRec r21 = waitTest21(); io:println(r21.id); // @output 7
    io:println(r21.name); // @output hello foo
    openRec r22 = waitTest22(); io:println(r22.id); // @output 7
    io:println(r22.name); // @output hello foo
    io:println(r22["status"]); // @output hello bar
    restRec1 r23 = waitTest23(); io:println(r23.id); // @output 7
    io:println(r23.name); // @output hello foo
    io:println(r23["status"]); // @output 20
    restRec2 r24 = waitTest24(); io:println(r24.id); // @output 12
    io:println(r24.name); // @output hello foo
    io:println(r24["status"]); // @output hello bar
    map<anydata|error> r25 = waitTest25(); io:println(r25["id"]); // @output 7
    io:println(r25["name"]); // @output hello foo
    map<anydata|error> r26 = waitTest26(); io:println(r26["id"]); // @output 30
    io:println(r26["name"]); // @output hello world
    io:println(r26["status"]); // @output hello moo
    map<anydata|error> r27 = waitTest27(); io:println(r27["id"]); // @output 200
    io:println(r27["name"]); // @output hello mello
    io:println(r27["greet"]); // @output hello sunshine
}

function waitTest1() returns map<anydata|error> { future<int> f1 = @strand{thread:"any"} start add_1(5,2); future<int> f2 = @strand{thread:"any"} start add_2(10,12); future<string> f3 = @strand{thread:"any"} start concat("foo"); future<boolean> f4 = @strand{thread:"any"} start status(); return wait {f1,f2,f3,f4}; }
function waitTest2() returns map<int|string|error> { future<int> f1 = start add_1(5,2); future<string> f4 = @strand{thread:"any"} start concat("foo"); future<int> f3 = @strand{thread:"any"} start add_3(50,100); future<int|string> f7 = start concat("xyz"); return wait {f1,str1:f4,f3:f3,str2:f7}; }
function waitTest3() returns record {| int|error f1; int|error f3; string|error f5; |} { future<int> f1 = start add_1(5,2); future<int> f3 = @strand{thread:"any"} start add_3(50,100); future<string> f5 = @strand{thread:"any"} start concat("bar"); return wait {f1,f3,f5}; }
function waitTest4() returns map<anydata|error> { future<int> f1 = start add_1(5,2); future<string> f4 = @strand{thread:"any"} start concat("foo"); future<int> f2 = @strand{thread:"any"} start add_2(10,12); record {int|error f1 = 0; int|error f2 = 0; string|error f4 = "";} a = wait {f1,f4,f2}; return {f1:a.f1,f2:a.f2,f4:a.f4}; }
function waitTest5() returns map<anydata|error> { future<string> f5 = @strand{thread:"any"} start concat("foo"); record {int|error id; string|error name;} a = wait {id:fuInt(),name:f5}; return {id:a.id,name:a.name}; }
function waitTest6() returns map<anydata|error> { future<int> f3 = @strand{thread:"any"} start add_3(50,100); future<string> f4 = @strand{thread:"any"} start concat("foo"); record {int|error idField; string|error stringField;} a = wait {idField:f3,stringField:f4}; return {idField:a.idField,stringField:a.stringField}; }
function waitTest7() returns int|error { future<int> f1 = @strand{thread:"any"} start add_1(5,2); record {int|error f1; string|error f3?;} a = wait {f1}; return a.f1; }
function waitTest8() returns firstRec { future<int> f1 = @strand{thread:"any"} start add_1(4,4); future<string> f2 = @strand{thread:"any"} start concat("moo"); return wait {id:f1,name:f2}; }
function waitTest9() returns secondRec { future<int> f1 = @strand{thread:"any"} start add_1(10,10); future<string> f5 = @strand{thread:"any"} start concat("foo"); return wait {f1,f5}; }
function waitTest10() returns secondRec { future<int> f1 = @strand{thread:"any"} start add_1(20,10); future<string> f5 = @strand{thread:"any"} start concat("xyz"); return wait {f1:f1,f5}; }
function waitTest11() returns thirdRec { future<int> f1 = @strand{thread:"any"} start add_1(20,10); future<string> f2 = @strand{thread:"any"} start concat("bar"); return wait {f1:f1,'field:f2}; }
function waitTest12() returns fourthRec { future<int> f1 = @strand{thread:"any"} start add_1(20,66); return wait {id:f1}; }
function waitTest16() returns int { future<int> f1 = @strand{thread:"any"} start add_1(5,2); future<string> f3 = @strand{thread:"any"} start concat("foo"); future<boolean> f4 = @strand{thread:"any"} start status(); future<int> f2 = @strand{thread:"any"} start add_panic(10,12); var r = trap wait {f1,f2,f3,f4}; if r is map<int|string|boolean> { return 9; } return 0; }
function waitTest17() returns any { worker w1 returns any { future<int> f1 = @strand{thread:"any"} start add_1(5,2); future<int> f2 = @strand{thread:"any"} start add_3(50,100); TwoIntOrErrorFields r = wait {f1,f2}; return r; } worker w2 returns any { future<int> f1 = @strand{thread:"any"} start add_1(6,6); future<string> f2 = @strand{thread:"any"} start concat("foo"); map<int|string|error> m = wait {id:f1,name:f2}; runtime:sleep(2); return m; } record {| any f1; any f2; |} a = wait {f1:w1,f2:w2}; return a; }
function waitTest18() returns secondRec { worker w1 returns secondRec { future<int> f1 = @strand{thread:"any"} start add_1(5,2); future<string> f2 = @strand{thread:"any"} start concat("foo"); return wait {f1,f5:f2}; } return wait w1; }
function waitTest19() returns map<int> { fork { worker w1 returns int { return 30; } @strand{thread:"any"} worker w2 returns int { int y = 15; return y + 1; } } map<int> r = wait {w1,w2}; worker wy {} return r; }
function waitTest20() returns map<int|string> { fork { @strand{thread:"any"} worker w1 returns int { string a = "hello world"; a -> w2; int b = <-w2; return b; } @strand{thread:"any"} worker w2 returns string { string a = "no message"; int b = 15; a = <-w1; b -> w1; return a; } } return wait {w3:w1,w2}; }
function waitTest21() returns sealedRec { future<int> f1 = @strand{thread:"any"} start add_1(5,2); future<string> f2 = @strand{thread:"any"} start concat("foo"); return wait {id:f1,name:f2}; }
function waitTest22() returns openRec { future<int> f1 = @strand{thread:"any"} start add_1(5,2); future<string> f2 = @strand{thread:"any"} start concat("foo"); future<string> f3 = @strand{thread:"any"} start concat("bar"); return wait {id:f1,name:f2,status:f3}; }
function waitTest23() returns restRec1 { future<int> f1 = @strand{thread:"any"} start add_1(5,2); future<string> f2 = @strand{thread:"any"} start concat("foo"); future<int> f3 = @strand{thread:"any"} start add_1(10,10); return wait {id:f1,name:f2,status:f3}; }
function waitTest24() returns restRec2 { future<int> f1 = @strand{thread:"any"} start add_1(10,2); future<string> f2 = @strand{thread:"any"} start concat("foo"); future<string> f3 = @strand{thread:"any"} start concat("bar"); return wait {id:f1,name:f2,status:f3}; }
function waitTest25() returns map<anydata|error> { future<int> f1 = @strand{thread:"any"} start add_1(5,2); future<string> f2 = @strand{thread:"any"} start concat("foo"); record {|int|error id = 0; string|error name = "default";|} a = wait {id:f1,name:f2}; return {id:a.id,name:a.name}; }
function waitTest26() returns map<anydata|error> { future<int> f1 = @strand{thread:"any"} start add_1(15,15); future<string> f2 = @strand{thread:"any"} start concat("world"); future<string> f3 = @strand{thread:"any"} start concat("moo"); record {|int|error id = 0; string|error name = "default"; anydata|error...;|} a = wait {id:f1,name:f2,status:f3}; return {id:a.id,name:a.name,status:a["status"]}; }
function waitTest27() returns map<anydata|error> { future<int> f1 = @strand{thread:"any"} start add_1(100,100); future<string> f2 = @strand{thread:"any"} start concat("mello"); future<string> f3 = @strand{thread:"any"} start concat("sunshine"); record {|int|error id = 0; string|error name = "default"; string|error...;|} a = wait {id:f1,name:f2,greet:f3}; return {id:a.id,name:a.name,greet:a["greet"]}; }

type sealedRec record {| int|error id = 0; string|error name = "default"; |};
type openRec record {| int|error id = 0; string|error name = "default"; anydata|error...; |};
type restRec1 record {| int|error id = 0; string|error name = "default"; int|error...; |};
type restRec2 record {| int|error id = 0; string|error name = "default"; string|error...; |};
type firstRec record { int|error id = 1; string|error name = "first-default"; };
type secondRec record { int|error f1 = 1; string|error f5 = "second-default"; };
type thirdRec record { int|error f1 = 0; string|error 'field = "third-default"; int f4?; };
type fourthRec record { int|string|error id = 0; };
type TwoIntOrErrorFields record {| int|error f1; int|error f2; |};
function add_1(int i, int j) returns int { int l = 0; while l < 9999999 { l += 1; } return i + j; }
function add_2(int i, int j) returns int => i + j;
function add_3(int i, int j) returns int => i + j;
function concat(string name) returns string => "hello " + name;
function status() returns boolean => true;
function fuInt() returns future<int> { future<int> i = start add_3(11,55); return i; }
function add_panic(int i, int j) returns int { int l = 0; while l < 9999999 { l += 1; } panic error("err from panic"); }
