public function main() {
    byte[] & readonly arr1 = <byte[] & readonly>base16 `aa bb`;
    consume(arr1.isReadOnly( // @error usage of construct 'ballerina/lang.value:0.0.0:isReadOnly' is deprecated
    ));

    int[2] & readonly arr2 = <int[2] & readonly>base16 `aa bb`;
    consume(arr2.isReadOnly( // @error usage of construct 'ballerina/lang.value:0.0.0:isReadOnly' is deprecated
    ));

    byte[2] & readonly arr3 = <readonly>base16 `aa bb`;
    consume(arr3.isReadOnly( // @error usage of construct 'ballerina/lang.value:0.0.0:isReadOnly' is deprecated
    ));

    anydata[] & readonly arr4 = <anydata[] & readonly>base16 `aa bb`;
    consume(arr4.isReadOnly( // @error usage of construct 'ballerina/lang.value:0.0.0:isReadOnly' is deprecated
    ));

    any[] arr5 = <any[] & readonly>base16 `aa bb`;
    byte[] arr6 = <byte[]> arr5;
    consume(arr6.isReadOnly( // @error usage of construct 'ballerina/lang.value:0.0.0:isReadOnly' is deprecated
    ));
}

function consume(boolean value) {
    if value {
        return;
    }
}
