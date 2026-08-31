function foobar(string param) returns (boolean){
	return true;
}

function foobar(string param) { // @error
	string a;
	a = param;
}
