type Car record {
    int id;
    string color;
};

Car {id: carId, color: carColor}; // @error

function init() {
    carId = 1009;
    carColor = "red";
}

public function main() {
   string myCarColor = carColor;
}
