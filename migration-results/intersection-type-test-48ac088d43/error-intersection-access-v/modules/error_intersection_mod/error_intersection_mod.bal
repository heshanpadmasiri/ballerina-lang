public type Status record {
    int code;
};

public type Error distinct error;
public type ClientRequestError distinct Error & error;
public type RemoteServerError distinct error & error;
public type ApplicationResponseError distinct ClientRequestError & RemoteServerError;
public type ApplicationResponseErrorWithStatusCode distinct ApplicationResponseError & error<Status>;
public type ClientRequestErrorWithStatusCode distinct ClientRequestError & error<Status>;
public type BadRequestError distinct ApplicationResponseErrorWithStatusCode & ClientRequestErrorWithStatusCode;
