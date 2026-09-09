const annotation annot on source const;

enum A {
    # Doc A ONE // @error
    ONE,
    # Doc A TWO // @error
    TWO
}
enum B {
    # Doc B ONE // @error
    ONE,
    # Doc B TWO // @error
    TWO
}
enum C {
    # Doc C THREE // @error
    THREE,
    # Doc C FOUR
    FOUR
}
enum D {
    # Doc D THREE // @error
    THREE,
    FOUR
}
enum E {
    @annot // @error
    FIVE,
    @annot // @error
    SIX
}
enum F {
    @annot // @error
    FIVE,
    @annot // @error
    SIX
}
enum G {
    @annot // @error
    SEVEN,
    @annot
    EIGHT
}
enum H {
    EIGHT,
    @annot // @error
    SEVEN
}
enum I {
    # Doc I NINE // @error
    @annot
    NINE
}
enum J {
    # Doc J NINE // @error
    @annot
    NINE
}
enum K {
    # Doc K TEN // @error
    TEN
}
enum L {
    @annot // @error
    TEN,
    ELEVEN
}
enum M {
    # Docs
    @annot
    ELEVEN,
    # Docs M TWELVE // @error
    TWELVE
}
enum N {
    # Docs N TWELVE // @error
    @annot
    TWELVE,
    # Docs N THIRTEEN
    THIRTEEN
}
enum O {
    # Docs O TWELVE // @error
    @annot
    TWELVE,
    THIRTEEN
}
