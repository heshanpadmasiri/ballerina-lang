import ballerina/io;

public function main() {
    xmlns "http://www.so2w.org" as localNS;
    xml x9 = xml ``;
    from int i in [1] // @error unused variable 'i'
    do {
        from int j in [1]
        do {
            x9 = xml `<empRecord employeeId="${j}"><localNS:id>${j}</localNS:id></empRecord>`;
        };
    };
    io:println(x9);
}
