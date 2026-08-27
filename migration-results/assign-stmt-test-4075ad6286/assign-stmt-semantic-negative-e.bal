final int i = 10;
final string aa = "sam";

function testConstAssignment() {
    i = 20; // @error
}

function constantAssignment() {
    aa = "mad"; // @error
}
