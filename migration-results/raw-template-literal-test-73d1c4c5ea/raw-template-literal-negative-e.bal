import ballerina/lang.'object as ob;

function testBasicUsage() {
    string name = "Pubudu";
    string rt1 = `Hello ${name}!`; // @error
    anydata rt2 = `Hello ${name}!`; // @error
}

function testSubtyping1() {
    int x = 10;
    int y = 20;
    object {
        public (readonly & string[]) strings;
        public int insertions;
    } temp1 = `${x} + ${y} = ${x + y}`; // @error
    object {
        public string strings;
        public int[] insertions;
    } temp2 = `${x} + ${y} = ${x + y}`; // @error
}

type Template object {
    *ob:RawTemplate;
    public (readonly & string[]) strings;
    public [int, string] insertions;
};

function testSubtyping2() {
    int x = 25;
    string s = "foo";
    float f = 12.34;
    Template t1 = `Using tuples: ${x}, ${s}, ${f}`; // @error
    Template t2 = `Using tuples: ${x}`; // @error
    object {
        *ob:RawTemplate;
        public (readonly & string[]) strings;
        public [int, string, anydata...] insertions;
    } temp2 = `Using tuples 2: ${x}, ${s}, ${t1}`; // @error
}

const FOO = "Foo";
const BAR = "Bar";
type FooBar FOO|BAR;

function testSubtyping3() {
    int x = 10;
    object {
        *ob:RawTemplate;
        public (FooBar[] & readonly) strings;
        public int[] insertions;
    } temp1 = `Foo ${x}Bar`; // @error
}

class Template1 {
    *ob:RawTemplate;
    public (string[] & readonly) strings = [];
    public int[] insertions = [];
}

function testSubtyping4() {
    int x = 10;
    int y = 20;
    Template1 t = `${x} + ${y} = ${x + y}`; // @error
}

function testSubtyping5() {
    int x = 25;
    string s = "foo";
    float f = 12.34;
    object {
        *ob:RawTemplate;
        public (string[] & readonly) strings;
        public [anydata...] insertions;
        string name;
    } temp3 = `Using tuples: ${x}, ${s}, ${f}`; // @error
}

function testSubtyping6() {
    object {
        *ob:RawTemplate;
        public (readonly & string[]) strings;
        public int[] insertions;
        int name;
    } rt1 = `Hello World!`; // @error
    object {} rt2 = `Hello World!`; // @error
    object { public (readonly & string[]) strings; } rt3 = `Hello World!`; // @error
    object { public int[] insertions; } rt4 = `Hello World!`; // @error
    object { public int[] insertions; int foo; } rt5 = `Hello World!`; // @error
    object {
        *ob:RawTemplate;
        public (readonly & string[]) strings;
        public int[] insertions;
        function shouldNotBeHere();
    } rt6 = `Hello World!`; // @error
}

type Temp1 object {
    *ob:RawTemplate;
    public ([string, string, string] & readonly) strings;
    public [int, float] insertions;
};

function testTypeChecking() {
    Temp1 rt1 = `Foo${8}Bar${"asdf"}${23.45}`; // @error
    Temp1 rt2 = `${8}`; // @error
    Temp1 rt3 = `Foo${8}Bar${"asdf"}`; // @error
}

public type Temp2 object {
    *ob:RawTemplate;
    public (string[2] & readonly) strings;
    public int[1] insertions;
};

function testFixedLengthArrays() {
    Temp2 t = `Count:${1}${2}`; // @error
    t = `Count`; // @error
}

public type Temp3 object {
    *ob:RawTemplate;
    public string[] strings; // @error
    public int[] insertions;
};

function testReadonlyFieldMismatch() {
    Temp3 t = `Count:${1}${2}`; // @error
}

function testAmbiguousTypes() {
    ob:RawTemplate|Template1 rt = `Count: ${10}, ${20}`; // @error
}

type RawTemplateType object:RawTemplate;
final object:RawTemplate & readonly tmp1 = `Count: ${10}, ${20}`;
final Template1 & readonly tmp2 = `Count: ${10}, ${20}`;
final RawTemplateType & readonly tmp3 = `Count: ${10}, ${20}`;

function testRawTemplateWithIntersectionType() {
    tmp1.insertions[0] = 10; // @error
    tmp1.insertions.push(30); // @error
    tmp2.insertions[0] = 10; // @error
    tmp2.insertions.push(30); // @error
    tmp3.insertions[0] = 10; // @error
    tmp3.insertions.push(30); // @error
    final object:RawTemplate & readonly tmp4 = `Count: ${10}, ${20}`;
    tmp4.insertions[0] = 10; // @error
    tmp4.insertions.push(30); // @error
    final Template1 & readonly tmp5 = `Count: ${10}, ${20}`;
    tmp5.insertions[0] = 10; // @error
    tmp5.insertions.push(30); // @error
    final RawTemplateType & readonly tmp6 = `Count: ${10}, ${20}`;
    tmp6.insertions[0] = 10; // @error
    tmp6.insertions.push(30); // @error
}
