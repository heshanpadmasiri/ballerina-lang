class A {
    *B;
    int i = 0;
} // @error

class B {
    *A;
    *C;
    int i = 0;
}

type C object {
    *A;
}; // @error

type ServiceObject service object {
    resource function get name() returns string;
};

service class ServiceClass {
    *ServiceObject;
} // @error

type ClientObject client object {
    resource function get name() returns string;
};

client class ClientClass {
    *ClientObject;
} // @error

type ClientObject2 client object {
    *ClientObject;
};

client class ClientClass2 {
    *ClientObject2;
} // @error

client class ClientClass3 {
    *ClientClass2;
} // @error
