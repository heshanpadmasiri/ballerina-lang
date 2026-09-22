function queryActionWithSelectClause() {
    from var i in [1, 2, 3, 4]
    select i // @error
    do {

    };
}

function queryActionWithCollectClasue1() {
    from var i in [1, 2, 3, 4]
    collect i // @error
    do {

    };
}

function queryActionWithCollectClasue2() {
    from var i in [1, 2, 3, 4]
    collect sum(i) // @error
    do {

    };
}
