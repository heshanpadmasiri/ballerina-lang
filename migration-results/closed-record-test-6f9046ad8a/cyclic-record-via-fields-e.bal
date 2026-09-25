public type ClientCredentialsGrantConfig record {|
    string tokenUrl;
    ClientConfiguration clientConfig = {};
|};
type AnydataConfig record {| anydata auth?; |};
public type ClientConfiguration record {| *AnydataConfig; ClientAuth auth?; |};
public type ClientAuth ClientCredentialsGrantConfig;

public function func(ClientAuth cl) {
    anydata a = cl; // @error
}
