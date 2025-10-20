package io.ballerina.fs;

class NativeFile implements File{
    private final java.io.File nativeFile;

    NativeFile(java.io.File nativeFile) {
        this.nativeFile = nativeFile;
    }

    @Override
    public long length() {
        return nativeFile.length();
    }
}
