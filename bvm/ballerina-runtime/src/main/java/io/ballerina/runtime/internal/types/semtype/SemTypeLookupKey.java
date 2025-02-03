package io.ballerina.runtime.internal.types.semtype;

import io.ballerina.runtime.api.types.semtype.SemType;
import io.ballerina.runtime.api.types.semtype.TypeCheckCacheKey;

public record SemTypeLookupKey(SemType semType) implements TypeCheckCacheKey {

}
