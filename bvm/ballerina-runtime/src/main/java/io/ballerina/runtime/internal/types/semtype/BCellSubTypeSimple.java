package io.ballerina.runtime.internal.types.semtype;

import io.ballerina.runtime.api.types.semtype.BasicTypeCode;
import io.ballerina.runtime.api.types.semtype.BddNode;
import io.ballerina.runtime.api.types.semtype.CellAtomicType;
import io.ballerina.runtime.api.types.semtype.Context;
import io.ballerina.runtime.api.types.semtype.Core;
import io.ballerina.runtime.api.types.semtype.Env;
import io.ballerina.runtime.api.types.semtype.SemType;
import io.ballerina.runtime.api.types.semtype.SubType;
import io.ballerina.runtime.api.types.semtype.TypeAtom;
import io.ballerina.runtime.internal.TypeChecker;

import static io.ballerina.runtime.api.types.semtype.BddNode.bddAtom;

final class BCellSubTypeSimple extends BCellSubType implements DelegatedSubType {

    private final SemType type;
    private BddNode inner;

    BCellSubTypeSimple(SemType type) {
        super(type.all() == BasicTypeCode.VT_MASK, type.all() == 0);
        assert type.some() == 0;
        this.type = type;
    }

    @Override
    public SubType union(SubType other) {
        if (other instanceof BCellSubTypeSimple simple) {
            return new BCellSubTypeSimple(Core.union(type, simple.type));
        } else if (other instanceof BCellSubTypeImpl complex) {
            return createDelegate(inner().union(complex.inner()));
        }
        throw new IllegalArgumentException("union of different subtypes");
    }

    @Override
    public SubType intersect(SubType other) {
        if (other instanceof BCellSubTypeSimple simple) {
            return new BCellSubTypeSimple(Core.intersect(type, simple.type));
        } else if (other instanceof BCellSubTypeImpl complex) {
            return createDelegate(inner().intersect(complex.inner()));
        }
        throw new IllegalArgumentException("intersection of different subtypes");
    }

    @Override
    public SubType complement() {
        return new BCellSubTypeSimple(Core.complement(type));
    }

    @Override
    public boolean isEmpty(Context cx) {
        return type.all() == 0;
    }

    @Override
    public SubTypeData data() {
        throw new IllegalStateException("unimplemented");
    }

    @Override
    public SubType inner() {
        if (inner != null) {
            return inner;
        }
        CellAtomicType atomicCell = CellAtomicType.from(type, CellAtomicType.CellMutability.CELL_MUT_LIMITED);
        Env env = TypeChecker.context().env;
        TypeAtom atom = env.cellAtom(atomicCell);
        inner = bddAtom(atom);
        return inner;
    }

    @Override
    public int hashCode() {
        return type.hashCode();
    }

    @Override
    public boolean equals(Object o) {
        return o instanceof BCellSubTypeSimple simple && type.equals(simple.type);
    }
}
