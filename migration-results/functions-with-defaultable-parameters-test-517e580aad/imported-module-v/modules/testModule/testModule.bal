public isolated client class Client {
    resource isolated function get .(int year, string? quarter = ()) returns int {
        int result = year;
        if quarter is () {
            result += 1;
        } else {
            result += 2;
        }
        return result;
    }
}
