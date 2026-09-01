type SingleDistinctError distinct error;
type SingleDistinctError2 distinct error;
type DoubleDistinctError distinct error & distinct error;
type DoubleDistinctError2 distinct error & distinct error;
type DistinctErrorAndSingleDistinctError distinct error & SingleDistinctError;
type DistinctErrorAndSingleDistinctError2 distinct error & SingleDistinctError;
type GroupedDistinctError distinct (distinct error & distinct SingleDistinctError);
type GroupedDoubleDistinctError distinct (distinct error & distinct SingleDistinctError & distinct SingleDistinctError);

function testDistinctErrorIntersectionAssignability() {
    SingleDistinctError se = error("Single");
    SingleDistinctError2 se2 = se; // @error
    DoubleDistinctError de = se; // @error
    se = de; // @error
    DoubleDistinctError2 de2 = de; // @error
    DistinctErrorAndSingleDistinctError dse = error("DAndS");
    se = dse;
    dse = se; // @error
    DistinctErrorAndSingleDistinctError2 dde = se; // @error
    se = dde;
    dse = dde; // @error
    distinct error inlineDE = se; // @error
    se = inlineDE; // @error
    distinct SingleDistinctError dsde = error("dsde");
    SingleDistinctError sde1 = dsde;
    dsde = sde1;
    se = error GroupedDistinctError("GroupedDistinctError");
    se = error GroupedDoubleDistinctError("GroupedDoubleDistinctError");
}
