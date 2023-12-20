/*
 *  Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  WSO2 Inc. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed on an
 *  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 *  KIND, either express or implied.  See the License for the
 *  specific language governing permissions and limitations
 *  under the License.
 */
package org.wso2.ballerinalang.compiler.bir.model;

/**
 * The kind of instruction.
 *
 * @since 0.980.0
 */
public enum InstructionKind {
    // Terminating instructions
    GOTO((byte) 1),
    CALL((byte) 2),
    BRANCH((byte) 3),
    RETURN((byte) 4),
    ASYNC_CALL((byte) 5),
    WAIT((byte) 6),
    FP_CALL((byte) 7),
    WK_RECEIVE((byte) 8),
    WK_SEND((byte) 9),
    FLUSH((byte) 10),
    LOCK((byte) 11),
    FIELD_LOCK((byte) 12),
    UNLOCK((byte) 13),
    WAIT_ALL((byte) 14),

    // Non-terminating instructions
    MOVE((byte) 20),
    CONST_LOAD((byte) 21),
    NEW_STRUCTURE((byte) 22),
    MAP_STORE((byte) 23),
    MAP_LOAD((byte) 24),

    RECORD_STORE((byte) 25),
    RECORD_LOAD((byte) 26),

    NEW_ARRAY((byte) 27),
    ARRAY_STORE((byte) 28),
    ARRAY_LOAD((byte) 29),
    NEW_ERROR((byte) 30),
    TYPE_CAST((byte) 31),
    IS_LIKE((byte) 32),
    TYPE_TEST((byte) 33),
    NEW_INSTANCE((byte) 34),
    OBJECT_STORE((byte) 35),
    OBJECT_LOAD((byte) 36),
    PANIC((byte) 37),
    FP_LOAD((byte) 38),
    STRING_LOAD((byte) 39),
    NEW_XML_ELEMENT((byte) 40),
    NEW_XML_TEXT((byte) 41),
    NEW_XML_COMMENT((byte) 42),
    NEW_XML_PI((byte) 43),
    NEW_XML_SEQUENCE((byte) 44),
    NEW_XML_QNAME((byte) 45),
    NEW_STRING_XML_QNAME((byte) 46),
    XML_SEQ_STORE((byte) 47),
    XML_SEQ_LOAD((byte) 48),
    XML_LOAD((byte) 49),
    XML_LOAD_ALL((byte) 50),
    XML_ATTRIBUTE_LOAD((byte) 51),
    XML_ATTRIBUTE_STORE((byte) 52),
    NEW_TABLE((byte) 53),
    NEW_TYPEDESC((byte) 54),
    NEW_STREAM((byte) 55),
    TABLE_STORE((byte) 56),
    TABLE_LOAD((byte) 57),

    // Binary expression related instructions.
    ADD((byte) 63),
    SUB((byte) 64),
    MUL((byte) 65),
    DIV((byte) 66),
    MOD((byte) 67),
    EQUAL((byte) 68),
    NOT_EQUAL((byte) 69),
    GREATER_THAN((byte) 70),
    GREATER_EQUAL((byte) 71),
    LESS_THAN((byte) 72),
    LESS_EQUAL((byte) 73),
    AND((byte) 74),
    OR((byte) 75),
    REF_EQUAL((byte) 76),
    REF_NOT_EQUAL((byte) 77),
    CLOSED_RANGE((byte) 78),
    HALF_OPEN_RANGE((byte) 79),
    ANNOT_ACCESS((byte) 80),

    // Unary expression related instructions.
    TYPEOF((byte) 82),
    NOT((byte) 83),
    NEGATE((byte) 84),
    BITWISE_AND((byte) 85),
    BITWISE_OR((byte) 86),
    BITWISE_XOR((byte) 87),
    BITWISE_LEFT_SHIFT((byte) 88),
    BITWISE_RIGHT_SHIFT((byte) 89),
    BITWISE_UNSIGNED_RIGHT_SHIFT((byte) 90),

    // Regular expression related instructions.
    NEW_REG_EXP((byte) 91),
    NEW_RE_DISJUNCTION((byte) 92),
    NEW_RE_SEQUENCE((byte) 93),
    NEW_RE_ASSERTION((byte) 94),
    NEW_RE_ATOM_QUANTIFIER((byte) 95),
    NEW_RE_LITERAL_CHAR_ESCAPE((byte) 96),
    NEW_RE_CHAR_CLASS((byte) 97),
    NEW_RE_CHAR_SET((byte) 98),
    NEW_RE_CHAR_SET_RANGE((byte) 99),
    NEW_RE_CAPTURING_GROUP((byte) 100),
    NEW_RE_FLAG_EXPR((byte) 101),
    NEW_RE_FLAG_ON_OFF((byte) 102),
    NEW_RE_QUANTIFIER((byte) 103),
    RECORD_DEFAULT_FP_LOAD((byte) 104),

    PLATFORM((byte) 128);

    byte value;

    InstructionKind(byte value) {
        this.value = value;
    }

    public byte getValue() {
        return this.value;
    }
}
