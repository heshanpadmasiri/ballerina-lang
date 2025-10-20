package io.ballerina.fs;

class WebFile implements File {

    WebFile() {
    }

    @Override
    public long length() {
        throw new RuntimeException("File operations not supported in web environment");
    }
}
