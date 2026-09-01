import globalvarpkg.mod.efg;

int sample = 200;

function test() {
    _ = efg:getSuccessful();
}

public function getSample() returns int {
    return sample;
}
