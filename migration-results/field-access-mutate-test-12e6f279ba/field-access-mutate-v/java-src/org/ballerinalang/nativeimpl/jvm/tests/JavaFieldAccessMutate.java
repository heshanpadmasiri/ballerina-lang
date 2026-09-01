package org.ballerinalang.nativeimpl.jvm.tests;

import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.values.BString;

import java.util.Date;
import java.util.UUID;

public class JavaFieldAccessMutate {
    public static BString contractId = StringUtils.fromString("Ballerina");
    public static int age = 10;
    public static short aShort = 11;
    public static boolean isAvailable;

    public Date createdAt = new Date();
    public boolean isEmpty = false;
    public float lkr = 0.0f;
    public int count = 101;
    public UUID uuid = UUID.fromString("951e8356-d08f-429a-b49d-77df6cee37e2");
    public BString balString = StringUtils.fromString("String value");

    public JavaFieldAccessMutate(Date createdAt) {
        this.createdAt = createdAt;
    }

    public JavaFieldAccessMutate() {
    }

    public static UUID deterministicUuid() {
        return UUID.fromString("b4f5c1d5-09b1-4d5a-b647-9d7e1fd8fa18");
    }

    public static BString uuidString(UUID uuid) {
        return StringUtils.fromString(uuid.toString());
    }

    public static BString contractIdString(Object contractId) {
        return (BString) contractId;
    }

    public static long dateTime(Date date) {
        return date.getTime();
    }

    public static boolean sameObject(Object first, Object second) {
        return first == second;
    }
}
