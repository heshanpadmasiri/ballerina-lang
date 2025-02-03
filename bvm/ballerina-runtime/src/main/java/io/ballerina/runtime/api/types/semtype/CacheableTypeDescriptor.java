package io.ballerina.runtime.api.types.semtype;

import io.ballerina.runtime.api.types.Type;

import java.util.Optional;

/**
 * Represent TypeDescriptors whose type check results can be cached.
 *
 * @since 2201.11.0
 */
public interface CacheableTypeDescriptor extends Type {

    /**
     * Check whether the type check result of this type descriptor is cached for the given type descriptor.
     *
     * @param cx    Context in which the type check is performed
     * @param other Type descriptor to check the cached result for
     * @return Optional containing the cached result if it is cached, empty otherwise
     */
    Optional<Boolean> cachedTypeCheckResult(Context cx, CacheableTypeDescriptor other);

    /**
     * Cache the type check result of this type descriptor for the given type descriptor.
     *
     * @param other  Type descriptor to cache the result for
     * @param result Result of the type check
     */
    void cacheTypeCheckResult(CacheableTypeDescriptor other, boolean result);

    TypeCheckCacheKey getLookupKey();
}
