package io.ballerina.runtime.api.types.semtype;

import io.ballerina.runtime.internal.types.semtype.UniqueLookupKey;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public final class TypeCheckCacheFactory {

    private static final Map<TypeCheckCacheKey, TypeCheckCache> cache = new ConcurrentHashMap<>(100);

    private TypeCheckCacheFactory() {
    }

    public static TypeCheckCache getTypeCheckCache(CacheableTypeDescriptor owner) {
        var key = owner.getLookupKey();
        if (key instanceof UniqueLookupKey) {
            return new TypeCheckCache(owner);
        }
        if (cache.containsKey(key)) {
            return cache.get(key);
        }
        var typeCheckCache = new TypeCheckCache(owner);
        cache.put(key, typeCheckCache);
        return typeCheckCache;
    }

}
