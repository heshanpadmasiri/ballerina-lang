type INT int;

public function main(int x, int? y, int a = 3, string s = "abc", float f = 5.5, INT i = 10, int:Signed16 j = 12) { // @error attempt to expose non-public symbol 'INT'
}
