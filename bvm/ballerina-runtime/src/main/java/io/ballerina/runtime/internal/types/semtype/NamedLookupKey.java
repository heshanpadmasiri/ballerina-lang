package io.ballerina.runtime.internal.types.semtype;

import io.ballerina.runtime.api.Module;
import io.ballerina.runtime.api.types.semtype.TypeCheckCacheKey;

public record NamedLookupKey(Module pkg, String name) implements TypeCheckCacheKey {

    public NamedLookupKey {
        assert pkg != null;
        assert name != null;
    }

}
