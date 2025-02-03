package io.ballerina.runtime.internal.types.semtype;

import io.ballerina.runtime.api.types.Type;
import io.ballerina.runtime.api.types.semtype.SemType;
import io.ballerina.runtime.api.types.semtype.TypeCheckCacheKey;
import io.ballerina.runtime.internal.types.BType;

import java.util.Arrays;
import java.util.Objects;

public class StructuredLookupKey implements TypeCheckCacheKey {

    private final Kind kind;
    private TypeCheckCacheKey[] children;
    public static final StructuredLookupKey TOP = new StructuredLookupKey(Kind.TOP, new TypeCheckCacheKey[0]);
    private int hash = -1;
    private int bitSet = 0;
    public static final int READONLY_BIT = 1;

    public StructuredLookupKey(Kind kind) {
        this.kind = kind;
    }

    public StructuredLookupKey(Kind kind, TypeCheckCacheKey[] children) {
        this.kind = kind;
        this.children = children;
    }

    private static StructuredLookupKey updateBitSet(BType bType, StructuredLookupKey key) {
        if (bType.isReadOnly()) {
            key.bitSet |= READONLY_BIT;
        }
        return key;
    }

    public static StructuredLookupKey from(Type type) {
        if (type instanceof BType bType) {
            if (bType.isAnonType()) {
                return updateBitSet(bType, bType.getStructuredLookupKey());
            }
            return new StructuredLookupKey(Kind.NAMED, new TypeCheckCacheKey[]{bType.getLookupKey()});
        }
        assert type instanceof SemType;
        return new StructuredLookupKey(Kind.SEMTYPE, new TypeCheckCacheKey[]{new SemTypeLookupKey((SemType) type)});
    }

    public void setChildren(TypeCheckCacheKey[] children) {
        this.children = children;
    }

    @Override
    public int hashCode() {
        if (hash == -1) {
            // This is correct since you can't make un-named recursive types
            hash = Objects.hash(kind, bitSet, Arrays.deepHashCode(children));
        }
        return hash;
    }

    @Override
    public boolean equals(Object obj) {
        if (!(obj instanceof StructuredLookupKey other)) {
            return false;
        }
        return kind == other.kind && bitSet == other.bitSet && Arrays.deepEquals(children, other.children);
    }

    public enum Kind {
        NAMED, SEMTYPE, TUPLE, UNION, RECORD, REST, OBJECT, FINITE, FUNCTION, INTERSECTION, TABLE, STREAM, MAP, FUTURE,
        ARRAY, ERROR, TYPE_DESC, ITERATOR, XML_ATTRIBUTE, TOP
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("(").append(kind).append(", ").append(bitSet).append(", [");
        for (int i = 0; i < children.length; i++) {
            if (i != 0) {
                sb.append(", ");
            }
            sb.append(children[i]);
        }
        sb.append("])");
        return sb.toString();
    }
}
