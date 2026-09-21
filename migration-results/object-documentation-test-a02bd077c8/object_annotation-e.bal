# Documentation for Test annotation
#
# + a - annotation `field a` documentation // @error
# + b - annotation `field b` documentation // @error
# + c - annotation `field c` documentation // @error
class Tst {
    public string a = "";
    public string b = "";
    public string c = "";
}

# Documentation for Test annotation
annotation record {| |} Test;
