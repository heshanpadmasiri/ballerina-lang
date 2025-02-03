package io.ballerina.runtime.api.types.semtype;

import io.ballerina.runtime.internal.types.semtype.UniqueLookupKey;

import java.util.Map;
import java.util.WeakHashMap;
import java.util.concurrent.locks.ReadWriteLock;
import java.util.concurrent.locks.ReentrantReadWriteLock;

public final class TypeCheckCacheFactory {

    private static final ReadWriteLock lock = new ReentrantReadWriteLock();

    private static final Map<TypeCheckCacheKey, TypeCheckCache> cache = new WeakHashMap<>();

    private TypeCheckCacheFactory() {
    }

    public static TypeCheckCache getTypeCheckCache(CacheableTypeDescriptor owner) {
        var key = owner.getLookupKey();
        if (key instanceof UniqueLookupKey) {
            return new TypeCheckCache(owner);
        }
        lock.readLock().lock();
        try {
            if (cache.containsKey(key)) {
                return cache.get(key);
            }
        } finally {
            lock.readLock().unlock();
        }
        lock.writeLock().lock();
        try {
            if (cache.containsKey(key)) {
                return cache.get(key);
            }
            var typeCheckCache = new TypeCheckCache(owner);
            cache.put(key, typeCheckCache);
            return typeCheckCache;
        } finally {
            lock.writeLock().unlock();
        }
    }

}
