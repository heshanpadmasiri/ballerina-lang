import testorg/enumaccess.enumsdef;

function test() {
   string pinkFloyd = enumsdef:PF; // @error // @error
   enumsdef:Bands q = enumsdef:Queen; // @error // @error // @error
   enumsdef:PF pf = "Pink Floyd"; // @error // @error
}
