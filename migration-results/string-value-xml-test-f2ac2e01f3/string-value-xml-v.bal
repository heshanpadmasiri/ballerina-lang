// Copyright (c) 2020 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import ballerina/io;

function testXmlComment() returns int {
    xml x1 = xml `<!--h🥺llo-->`;
    return x1.toString().length();
}

function testXmlQName() returns int {
    xml x1 = xml `<book/>`;
    return x1.toString().length();
}

function testXmlText() returns int {
    xml x1 = xml `<book>Netty🔥</book>`;
    return x1.toString().length();
}

function testXmlProcessingIns() returns int {
    xml x1 = xml `<?hi name😂?>`;
    return x1.toString().length();
}

function testXmlStr() returns int {
    xml x1 = xml `hi name😊`;
    return x1.toString().length();
}

function testXmlFromString() returns int|error {
    string body = string `<?xml version="1.1" encoding="UTF8"?><A><B>123</B></A>`;
    xml val = check xml:fromString(body);
    return val.length();
}

function testComplexXml() returns int {
    xml x1 = xml `<book>
                         <name>Sherlock😀 Holmes</name>
                         <author>Sir Arthur🙈 Conan Doyle</author>
                         <!--Price: 🍇$10-->
                       </book>`;
    return x1.toString().length();
}

function testXmlNamespace() returns int {
    xmlns "http://ballerina.com/";
    xmlns "http://ballerina.com/💯aa" as ns0;
    xml x1 = xml `<book ns0:status="available">
                                 <ns0:name>Sherlock🕴️ Holmes</ns0:name>
                                 <author>Sir Arthur🚣 Conan Doyle</author>
                                 <!--Price: 🕳️$10-->
                               </book>`;
    return x1.toString().length();
}

function testXmlInterpolation() returns int {
    xmlns "http://ballerina.com/💯aa" as ns0;
    string title = "(Sir)";
    xml x1 = xml `<ns0:newBook>
                        <name>Sherlock Hol🏁mes</name>
                        <author>${title} Arthur Conan Doyle</author>
                        <!--Price: $${ 40 / 5 + 4 }-->
                      </ns0:newBook>`;
    return x1.toString().length();
}

public function main() {
    io:println(testXmlComment()); // @output 12
    io:println(testXmlQName()); // @output 7
    io:println(testXmlText()); // @output 19
    io:println(testXmlProcessingIns()); // @output 12
    io:println(testXmlStr()); // @output 8
    io:println(testComplexXml()); // @output 202
    io:println(testXmlNamespace()); // @output 334
    io:println(testXmlInterpolation()); // @output 249
    io:println(testXmlFromString()); // @output 2
}
