// FIXME: add licences
@typeParam
type Foo int|string;
type FooFn function(Foo);

function fooFn(int val) {}
function fooConsumer(FooFn fn) {}

function test1() {
    fooConsumer(fooFn);
}

type FooIntFn function(Foo, int);
function fooIntFn(int val, int other) {}
function fooIntFn2(int val, int|float other) {}
function fooIntConsumer(FooIntFn fn) {}

function test2() {
    fooIntConsumer(fooIntFn);
}

function test3() {
    fooIntConsumer(fooIntFn2);
}

@typeParam
type Bar 1|2;

type BarFn function(Bar);

function barConsumer(BarFn fn) {}

function notBarFn(1|2|3 val) {}

function test4() {
    barConsumer(notBarFn);
}
