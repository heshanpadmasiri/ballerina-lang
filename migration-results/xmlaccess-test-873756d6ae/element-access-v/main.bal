import ballerina/io;

public function main() {
    [xml, xml, xml, xml, xml, xml] single = testXMLElementAccessOnSingleElementXML();
    io:println(single[0]); // @output <ns:root xmlns:ns="foo"/>
    io:println(single[1]); // @output <ns:root xmlns:ns="foo"/>
    io:println(single[2]); // @output <ns:root xmlns:ns="foo"/>
    io:println(single[3]); // @output 
    io:println(single[4]); // @output 
    io:println(single[5]); // @output 

    [xml, xml, xml, xml, xml, xml] sequence = testXMLElementAccessOnXMLSequence();
    io:println(sequence[0]); // @output <ns:root xmlns:ns="foo"/><k:root xmlns:k="bar"/><k:item xmlns:k="bar"/>
    io:println(sequence[1]); // @output <ns:root xmlns:ns="foo"/>
    io:println(sequence[2]); // @output <ns:root xmlns:ns="foo"/>
    io:println(sequence[3]); // @output 
    io:println(sequence[4]); // @output 
    io:println(sequence[5]); // @output <k:root xmlns:k="bar"/><k:item xmlns:k="bar"/>

    [xml, xml, xml, xml] filters = testXMLElementAccessMultipleFilters();
    io:println(filters[0]); // @output <ns:root xmlns:ns="foo"/><k:root xmlns:k="bar"/><k:item xmlns:k="bar"/>
    io:println(filters[1]); // @output <ns:root xmlns:ns="foo"/><k:root xmlns:k="bar"/><k:item xmlns:k="bar"/>
    io:println(filters[2]); // @output <ns:root xmlns:ns="foo"/><k:root xmlns:k="bar"/>
    io:println(filters[3]); // @output <k:item xmlns:k="bar"/>
}
