package io.ballerina.runtime.internal.types.semtype;

import io.ballerina.runtime.api.types.semtype.Bdd;
import io.ballerina.runtime.api.types.semtype.SubType;

public abstract sealed class BCellSubType extends SubType permits BCellSubTypeImpl {

    public BCellSubType(boolean all, boolean nothing) {
        super(all, nothing);
    }

    public static BCellSubType createDelegate(SubType inner) {
        if (inner instanceof Bdd bdd) {
            return new BCellSubTypeImpl(bdd);
        } else if (inner instanceof BCellSubTypeImpl bCell) {
            return new BCellSubTypeImpl(bCell.inner);
        }
        throw new IllegalArgumentException("Unexpected inner type");
    }
}
