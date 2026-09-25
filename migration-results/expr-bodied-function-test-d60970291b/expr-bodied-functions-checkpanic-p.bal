import ballerina/lang.'int;

function panicsACheck() returns int => checkpanic 'int:fromString("invalid"); // @panic

public function main() {
    testCheckPanic();
}

function testCheckPanic() {
    int res = panicsACheck();
}
