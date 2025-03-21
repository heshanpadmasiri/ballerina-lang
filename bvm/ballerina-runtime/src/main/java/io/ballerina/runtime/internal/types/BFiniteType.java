/*
 * Copyright (c) 2019, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package io.ballerina.runtime.internal.types;

import io.ballerina.runtime.api.flags.TypeFlags;
import io.ballerina.runtime.api.types.FiniteType;
import io.ballerina.runtime.api.types.TypeTags;
import io.ballerina.runtime.api.types.semtype.BasicTypeBitSet;
import io.ballerina.runtime.api.types.semtype.Builder;
import io.ballerina.runtime.api.types.semtype.Context;
import io.ballerina.runtime.api.types.semtype.Core;
import io.ballerina.runtime.api.types.semtype.SemType;
import io.ballerina.runtime.api.types.semtype.ShapeAnalyzer;
import io.ballerina.runtime.api.types.semtype.TypeCheckCache;
import io.ballerina.runtime.api.types.semtype.TypeCheckCacheFactory;
import io.ballerina.runtime.internal.TypeChecker;
import io.ballerina.runtime.internal.types.semtype.CacheFactory;
import io.ballerina.runtime.internal.values.RefValue;

import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.Map;
import java.util.Optional;
import java.util.Set;
import java.util.StringJoiner;

import static io.ballerina.runtime.api.utils.TypeUtils.getType;

/**
 * {@code BFiniteType} represents the finite type in Ballerina.
 * 
 * @since 0.995.0
 */
public class BFiniteType extends BType implements FiniteType {

    public Set<Object> valueSpace;
    private int typeFlags;
    private String originalName;
    private BasicTypeBitSet basicType;

    public BFiniteType(String typeName) {
        this(typeName, new LinkedHashSet<>(), 0);
    }

    public BFiniteType(String typeName, Set<Object> values, int typeFlags) {
        this(typeName, typeName, values, typeFlags);
    }

    public BFiniteType(String typeName, String originalName, Set<Object> values, int typeFlags) {
        super(typeName, null, RefValue.class, false);
        this.valueSpace = values;
        this.typeFlags = typeFlags;
        this.originalName = originalName;
        if (this.originalName != null && !originalName.isEmpty()) {
            var flyweight = TypeCheckCacheData.get(originalName);
            this.typeId = flyweight.typeId;
            this.typeCheckCache = flyweight.typeCheckCache;
        } else {
            initializeCache();
        }
    }

    @Override
    public <V extends Object> V getZeroValue() {
        if (valueSpace.stream().anyMatch(val -> val == null || TypeChecker.getType(val).isNilable())) {
            return null;
        }

        Iterator<Object> valueIterator = valueSpace.iterator();
        Object firstVal = valueIterator.next();

        if (isSingletonType()) {
            return (V) firstVal;
        }

        Object implicitInitValOfType = TypeChecker.getType(firstVal).getZeroValue();
        if (implicitInitValOfType.equals(firstVal)) {
            return (V) implicitInitValOfType;
        }

        while (valueIterator.hasNext()) {
            Object value = valueIterator.next();
            if (implicitInitValOfType.equals(value)) {
                return (V) implicitInitValOfType;
            }
        }

        return null;
    }

    @Override
    public String getName() {
        return this.originalName;
    }

    @Override
    public <V extends Object> V getEmptyValue() {
        if (valueSpace.stream().anyMatch(val -> val == null || TypeChecker.getType(val).isNilable())) {
            return null;
        }

        Iterator<Object> valueIterator = valueSpace.iterator();
        Object firstVal = valueIterator.next();

        if (isSingletonType()) {
            return (V) firstVal;
        }

        Object implicitInitValOfType = TypeChecker.getType(firstVal).getEmptyValue();
        if (implicitInitValOfType.equals(firstVal)) {
            return (V) implicitInitValOfType;
        }

        while (valueIterator.hasNext()) {
            Object value = valueIterator.next();
            if (implicitInitValOfType.equals(value)) {
                return (V) implicitInitValOfType;
            }
        }

        return null;
    }
    @Override
    public int getTag() {
        return TypeTags.FINITE_TYPE_TAG;
    }

    private boolean isSingletonType() {
        return valueSpace.size() == 1;
    }

    @Override
    public boolean isAnydata() {
        return TypeFlags.isFlagOn(this.typeFlags, TypeFlags.ANYDATA);
    }

    @Override
    public boolean isPureType() {
        return TypeFlags.isFlagOn(this.typeFlags, TypeFlags.PURETYPE);
    }

    @Override
    public boolean isReadOnly() {
        return true;
    }

    @Override
    public BasicTypeBitSet getBasicType() {
        if (basicType == null) {
            basicType = this.valueSpace.stream().map(TypeChecker::getBasicType)
                    .reduce(Builder.getNeverType(), BasicTypeBitSet::union);
        }
        return basicType;
    }

    @Override
    public Set<Object> getValueSpace() {
        return valueSpace;
    }

    @Override
    public int getTypeFlags() {
        return typeFlags;
    }

    @Override
    public String toString() {
        if (typeName != null && !typeName.isEmpty() && !typeName.startsWith("$anonType$")) {
            return typeName;
        }
        StringJoiner joiner = new StringJoiner("|");
        for (Object value : this.valueSpace) {
            switch (getType(value).getTag()) {
                case TypeTags.FLOAT_TAG:
                    joiner.add(value + "f");
                    break;
                case TypeTags.DECIMAL_TAG:
                    joiner.add(value + "d");
                    break;
                case TypeTags.STRING_TAG:
                case TypeTags.CHAR_STRING_TAG:
                    joiner.add("\"" + value + "\"");
                    break;
                case TypeTags.NULL_TAG:
                    joiner.add("()");
                    break;
                default:
                    joiner.add(value.toString());
            }
        }
        return valueSpace.size() == 1 ? joiner.toString() : "(" + joiner + ")";
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (!(o instanceof BFiniteType that)) {
            return false;
        }
        if (this.valueSpace.size() != that.valueSpace.size()) {
            return false;
        }
        for (var each : this.valueSpace) {
            try {
                if (!that.valueSpace.contains(each)) {
                    return false;
                }
            } catch (NullPointerException ex) {
                // If one of the sets is an immutable collection this can happen
                return false;
            }
        }
        return true;
    }

    @Override
    public SemType createSemType(Context cx) {
        return this.valueSpace.stream().map(each -> ShapeAnalyzer.inherentTypeOf(cx, each))
                .map(Optional::orElseThrow)
                .reduce(Builder.getNeverType(), Core::union);
    }

    private static class TypeCheckCacheData {

        private static final Map<String, TypeCheckFlyweight> cache = CacheFactory.createCachingHashMap();

        private record TypeCheckFlyweight(int typeId, TypeCheckCache typeCheckCache) {

        }

        private static TypeCheckFlyweight get(String originalName) {
            return cache.computeIfAbsent(originalName, TypeCheckCacheData::create);
        }

        private static TypeCheckFlyweight create(String originalName) {
            return new TypeCheckCacheData.TypeCheckFlyweight(TypeIdSupplier.getAnonId(),
                    TypeCheckCacheFactory.create());
        }
    }

}
