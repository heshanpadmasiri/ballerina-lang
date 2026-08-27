function AccessPrimitiveAsArray() returns int {
    int animal;
    animal[0] = 1; // @error
    return animal[0]; // @error
}
