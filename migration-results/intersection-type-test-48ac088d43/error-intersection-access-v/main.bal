import ballerina/io;
import error_intersection_access.error_intersection_mod as err_lib;

const MESSAGE = "Message";

public function testErrorIntersectionFromImportedModule() {
    err_lib:RemoteServerError remoteServerErr = error err_lib:RemoteServerError(MESSAGE);
    assertError(remoteServerErr);

    err_lib:ApplicationResponseError applResponeErr = error err_lib:ApplicationResponseError(MESSAGE);
    assertError(applResponeErr);

    err_lib:ClientRequestErrorWithStatusCode clientReqErrWithStatusCode = error (MESSAGE, code = 404);
    assertError(clientReqErrWithStatusCode, 404);

    err_lib:ApplicationResponseErrorWithStatusCode appRespErrWithStatusCode = error (MESSAGE, code = 401);
    assertError(appRespErrWithStatusCode, 401);

    err_lib:BadRequestError badReqErr = error err_lib:BadRequestError(MESSAGE, code = 400);
    assertError(badReqErr, 400);

    err_lib:Error err = error err_lib:Error(MESSAGE);
    assertError(err);
}

function assertError(any|error actual, int? code = ()) {
    if actual !is error {
        panic error(string `expected an error, found '${actual.toString()}'`);
    }
    if MESSAGE != actual.message() {
        panic error(string `expected message: '${MESSAGE}', found: '${actual.message()}'`);
    }
    if code != () {
        var detail = <record {|int code;|} & readonly> actual.detail();
        if code != detail.code {
            panic error(string `expected code: '${code}', found: '${detail.code}'`);
        }
    }
}

function useIo() { io:println(""); }

public function main() {
    testErrorIntersectionFromImportedModule();
}
