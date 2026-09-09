enum Colour { RED, } // @error
enum Colours { BLUE = "Blue", } // @error
public enum Shape { CIRCLE, SQ = "SQUARE" }
public enum Artist { EMINEM, LANA, ED = "Ed Shereen" }
public enum Food { BIRIYANI = 1, KOTTU = 2.0 } // @error // @error
public enum LiftStatus {
    OPEN,
    OPEN, // @error
    CLOSED = "0",
    HOLD = "HO" + "D"
}
public enum TrailStatus { OPEN, CLOSED, HOLD = "h" + "d" } // @error
function testBasicEnumSupportNegative() {
    int circle = CIRCLE; // @error
    float em = EMINEM; // @error
}
function testEnumAsType() {
    Shape c = EMINEM; // @error
    Artist e = "Adele"; // @error
    ED p = "EMINEM"; // @error
}
const string A = x; // @error // @error
const B = 1;
enum E1 {
    A = "1", // @error
    B = "1" // @error
}
public enum NodeType {
    A = // @error
} // @error
public enum CyclicRef1 {
    CYCLIC1 = CYCLIC2, // @error
    CYCLIC2 = CYCLIC1
}
const string D = E; // @error
const string E = D;
public enum CyclicRef2 {
    D, // @error
    E // @error
}
