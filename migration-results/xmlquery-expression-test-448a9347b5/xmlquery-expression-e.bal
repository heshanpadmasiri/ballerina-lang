function testSimpleQueryExprForXMLWithReadonly1() {
    xml book1 = xml `<name>Sherlock Holmes</name>`;

    xml & readonly _ = from var x in book1
        select x; // @error

    xml:Element & readonly _ = from var x in book1
        where x is xml:Element
        select x; // @error

    xml<xml:Element> & readonly _ = from xml x in book1
        where x is xml:Element
        select x; // @error

    xml:Comment[] comments = [xml `<!--This is a comment 1-->`, xml `<!--This is a comment 1-->`];

    xml & readonly _ = from xml x in comments
        select x; // @error

    xml:Comment & readonly _ = from var x in comments
        select x; // @error

    xml<xml:Comment> & readonly _ = from xml:Comment x in comments
        select x; // @error

    xml:ProcessingInstruction[] processingInstructions = [xml `<?target data?>`, xml `<?target url?>`];

    xml & readonly _ = from xml x in processingInstructions
        select x; // @error

    xml:ProcessingInstruction & readonly _ = from var x in processingInstructions
        select x; // @error

    xml<xml:ProcessingInstruction> & readonly _ = from xml:ProcessingInstruction x in processingInstructions
        select x; // @error
}

type Book record {|
    string title;
    string author;
|};

class BookGenerator {
    int i = 0;

    public isolated function next() returns record {|Book value;|}|error? {
        self.i += 1;
        if (self.i < 0) {
            return error("Error");
        } else if (self.i >= 3) {
            return ();
        }
        return {value: {title: "Title " + self.i.toString(), author: "Author " + self.i.toString()}};
    }
}

BookGenerator bookGenerator = new ();
stream<Book, error?> bookStream = new (bookGenerator);

function testSimpleQueryExprForXML() {
    xml:Element _ = check from Book book in bookStream
        select xml `<Book><Author>${book.author}</Author><Title>${book.title}</Title></Book>`; // @error

    xml:Element|xml _ = check from Book book in bookStream
        select xml `<Book><Author>${book.author}</Author><Title>${book.title}</Title></Book>`; // @error

    xml:Text|xml _ = check from Book book in bookStream
        select xml `<Book><Author>${book.author}</Author><Title>${book.title}</Title></Book>`;
    xml:Element[]|xml _ = check from Book book in bookStream
        select xml `<Book><Author>${book.author}</Author><Title>${book.title}</Title></Book>`; // @error
}
