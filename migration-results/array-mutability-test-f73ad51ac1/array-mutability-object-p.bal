class Animal { public string name = ""; }
class Dog { public string name = ""; public int age = 0; }

public function main() {
    Animal animal = new;
    Dog dog = new;
    Dog[] dogs = [dog, new];
    Animal[] animals = dogs;
    animals[0] = animal; // @panic
}
