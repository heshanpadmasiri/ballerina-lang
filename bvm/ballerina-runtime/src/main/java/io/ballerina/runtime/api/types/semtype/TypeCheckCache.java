package io.ballerina.runtime.api.types.semtype;

import io.ballerina.runtime.internal.types.semtype.UniqueLookupKey;

import java.util.Map;
import java.util.Optional;
import java.util.WeakHashMap;

/**
 * Generalized implementation of type check result cache. It is okay to access this from multiple threads but makes no
 * guarantee about the consistency of the cache under parallel access. Given result don't change due to race conditions
 * this should eventually become consistent.
 *
 * @since 2201.11.0
 */
public class TypeCheckCache {

    // Not synchronizing this should be fine since race conditions don't lead to inconsistent results. (i.e. results
    // of doing multiple type checks are agnostic to the order of execution). Data races shouldn't lead to tearing in
    // 64-bit JVMs.
    private final Map<TypeCheckCacheKey, Boolean> cachedResults = new WeakHashMap<>();
    private final TypeCheckCacheKey ownerKey;

    public TypeCheckCache(CacheableTypeDescriptor owner) {
        this.ownerKey = owner.getLookupKey();
    }

    public Optional<Boolean> cachedTypeCheckResult(CacheableTypeDescriptor other) {
        TypeCheckCacheKey otherKey = other.getLookupKey();
        if (otherKey.equals(ownerKey)) {
            return Optional.of(true);
        }
        return Optional.ofNullable(cachedResults.get(otherKey));
    }

    public void cacheTypeCheckResult(CacheableTypeDescriptor other, boolean result) {
        TypeCheckCacheKey lookupKey = other.getLookupKey();
        // FIXME: this is just to prevent cache becoming too large. Revisit this after structured keys
        if (lookupKey instanceof UniqueLookupKey) {
            return;
        }
        cachedResults.put(lookupKey, result);
    }
}
