import ballerina/io;
import ballerina/jballerina.java;
import ballerina/lang.value;

public function main() {
    io:println(testJavaCastFunction()); // @output cast this object
    io:println(testJavaCastFunction2()); // @output cast this object
    io:println(testIncorrectJavaCast()); // @output error("{ballerina/jballerina.java} Cannot cast `String1` to `ArrayList1`")
    io:println(testJavaCastForInvalidTypedesc3()); // @output error("{ballerina/jballerina.java} Error while initializing the new object from `String4` type: java.lang.ClassCastException: class io.ballerina.runtime.internal.values.HandleValue cannot be cast to class io.ballerina.runtime.api.values.BString (io.ballerina.runtime.internal.values.HandleValue and io.ballerina.runtime.api.values.BString are in unnamed module of loader 'app')")
    io:println(testJavaCastForInvalidClass1()); // @output error("{ballerina/jballerina.java} Error while casting `Object1` object to the typedesc provided: java.lang.ClassNotFoundException: java.lang.Str")
    io:println(testJavaCastForInvalidClass2()); // @output error("{ballerina/jballerina.java} Error while casting `Object3` object to the typedesc provided: java.lang.ClassNotFoundException: java.lang.Objecte")
    io:println(testJavaCastFunctionNulljObj()); // @output error("{ballerina/jballerina.java} Empty handle reference found for `jObj` field in `Object1`")
    io:println(testJavaCastMissingAnnotation1()); // @output error("{ballerina/jballerina.java} Error while retrieving details of the `@java:Binding` annotation from `String2` typedesc: java.lang.NullPointerException: Cannot invoke "io.ballerina.runtime.api.values.BMap.getStringValue(io.ballerina.runtime.api.values.BString)" because "castObjAnnotation" is null")
    io:println(testJavaCastMissingAnnotation2()); // @output error("{ballerina/jballerina.java} Error while retrieving details of the `@java:Binding` annotation from `Object2` object: java.lang.NullPointerException: Cannot invoke "io.ballerina.runtime.api.values.BMap.getStringValue(io.ballerina.runtime.api.values.BString)" because "objAnnotation" is null")
}

public function testJavaCastFunction() returns string|error {
    ArrayList1 arrayList = newArrayList1();
    String1 strValue = newString1("cast this object");
    _ = arrayList.add(strValue);
    Object1 result = arrayList.get(0);
    String1 castedValue = check java:cast(result);
    return castedValue.toString();
}

public function testJavaCastFunction2() returns string|error {
    ArrayList1 arrayList = newArrayList1();
    StringRef strValue = newString1("cast this object");
    _ = arrayList.add(strValue);
    Object1 result = arrayList.get(0);
    String1 castedValue = check java:cast(result);
    return castedValue.toString();
}

public function testIncorrectJavaCast() returns string|error {
    String1 strValue = newString1("cast this object");
    ArrayList1 castedValue = check java:cast(strValue);
    return value:toString(castedValue);
}

public function testJavaCastForInvalidTypedesc3() returns string|error {
    ArrayList1 arrayList = newArrayList1();
    String1 strValue = newString1("cast this object");
    _ = arrayList.add(strValue);
    Object1 result = arrayList.get(0);
    String4 castedValue = check java:cast(result);
    return castedValue.toString();
}

public function testJavaCastForInvalidClass1() returns string|error {
    ArrayList1 arrayList = newArrayList1();
    String3 strValue = newString3("cast this object");
    _ = arrayList.add(strValue);
    Object1 result = arrayList.get(0);
    String3 castedValue = check java:cast(result);
    return castedValue.toString();
}

public function testJavaCastForInvalidClass2() returns string|error {
    ArrayList3 arrayList = newArrayList3();
    String1 strValue = newString1("cast this object");
    _ = arrayList.add(strValue);
    Object3 result = arrayList.get(0);
    String1 castedValue = check java:cast(result);
    return castedValue.toString();
}

public function testJavaCastFunctionNulljObj() returns string|error {
    ArrayList1 arrayList = newArrayList1();
    String1 strValue = newString1("cast this object");
    _ = arrayList.add(strValue);
    Object1 result = arrayList.get(0);
    result.jObj = java:createNull();
    String1 castedValue = check java:cast(result);
    return castedValue.toString();
}

public function testJavaCastMissingAnnotation1() returns string|error {
    ArrayList1 arrayList = newArrayList1();
    String2 strValue = newString2("cast this object");
    _ = arrayList.add(strValue);
    Object1 result = arrayList.get(0);
    String2 castedValue = check java:cast(result);
    return castedValue.toString();
}

public function testJavaCastMissingAnnotation2() returns string|error {
    ArrayList2 arrayList = newArrayList2();
    String1 strValue = newString1("cast this object");
    _ = arrayList.add(strValue);
    Object2 result = arrayList.get(0);
    String1 castedValue = check java:cast(result);
    return castedValue.toString();
}

@java:Binding { 'class: "java.lang.String" }
public class String1 {
    *java:JObject;
    public function init(handle obj) { self.jObj = obj; }
    public function toString() returns string { return java:toString(self.jObj) ?: "null"; }
}

type StringRef String1;

@java:Binding { 'class: "java.lang.Object" }
public class Object1 {
    *java:JObject;
    public function init(handle obj) { self.jObj = obj; }
}

@java:Binding { 'class: "java.util.ArrayList" }
public class ArrayList1 {
    *java:JObject;
    public function init(handle obj) { self.jObj = obj; }
    public function add(Object1 arg0) returns boolean { return java_util_ArrayList_add(self.jObj, arg0.jObj); }
    public function get(int arg0) returns Object1 { return new(java_util_ArrayList_get(self.jObj, arg0)); }
}

public class String2 {
    *java:JObject;
    public function init(handle obj) { self.jObj = obj; }
    public function toString() returns string { return java:toString(self.jObj) ?: "null"; }
}

public class Object2 {
    *java:JObject;
    public function init(handle obj) { self.jObj = obj; }
}

@java:Binding { 'class: "java.util.ArrayList" }
public class ArrayList2 {
    *java:JObject;
    public function init(handle obj) { self.jObj = obj; }
    public function add(Object2 arg0) returns boolean { return java_util_ArrayList_add(self.jObj, arg0.jObj); }
    public function get(int arg0) returns Object2 { return new(java_util_ArrayList_get(self.jObj, arg0)); }
}

@java:Binding { 'class: "java.lang.Str" }
public class String3 {
    *java:JObject;
    public function init(handle obj) { self.jObj = obj; }
    public function toString() returns string { return java:toString(self.jObj) ?: "null"; }
}

@java:Binding { 'class: "java.lang.Objecte" }
public class Object3 {
    *java:JObject;
    public function init(handle obj) { self.jObj = obj; }
}

@java:Binding { 'class: "java.util.ArrayList" }
public class ArrayList3 {
    *java:JObject;
    public function init(handle obj) { self.jObj = obj; }
    public function add(Object3 arg0) returns boolean { return java_util_ArrayList_add(self.jObj, arg0.jObj); }
    public function get(int arg0) returns Object3 { return new(java_util_ArrayList_get(self.jObj, arg0)); }
}

@java:Binding { 'class: "java.lang.String" }
public class String4 {
    *java:JObject;
    public function init(string obj) { self.jObj = java:fromString(obj); }
    public function toString() returns string { return java:toString(self.jObj) ?: "null"; }
}

public function newArrayList1() returns ArrayList1 {
    return new(java_util_ArrayList_newArrayList());
}

public function newArrayList2() returns ArrayList2 {
    return new(java_util_ArrayList_newArrayList());
}

public function newArrayList3() returns ArrayList3 {
    return new(java_util_ArrayList_newArrayList());
}

public function newString1(string arg0) returns String1 {
    return new(java_lang_String_newString(java:fromString(arg0)));
}

public function newString2(string arg0) returns String2 {
    return new(java_lang_String_newString(java:fromString(arg0)));
}

public function newString3(string arg0) returns String3 {
    return new(java_lang_String_newString(java:fromString(arg0)));
}

function java_util_ArrayList_newArrayList() returns handle = @java:Constructor {
    'class: "java.util.ArrayList",
    paramTypes: []
} external;

function java_util_ArrayList_add(handle receiver, handle arg0) returns boolean = @java:Method {
    name: "add",
    'class: "java.util.ArrayList",
    paramTypes: ["java.lang.Object"]
} external;

function java_util_ArrayList_get(handle receiver, int arg0) returns handle = @java:Method {
    name: "get",
    'class: "java.util.ArrayList",
    paramTypes: ["int"]
} external;

function java_lang_String_newString(handle arg0) returns handle = @java:Constructor {
    'class: "java.lang.String",
    paramTypes: ["java.lang.String"]
} external;
