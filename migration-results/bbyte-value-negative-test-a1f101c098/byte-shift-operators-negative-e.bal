function invalidByteShiftOperators() {
    byte q = 7 > > 3; // @error @error
    byte t = 6 < < 9; // @error @error @error
    byte u = 5 > >> 2; // @error @error
    byte v = 5 >> > 2; // @error @error
    byte p = 5 > > > 2; // @error @error
    byte r = 5 >    >     > 2; // @error @error
}
