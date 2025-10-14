/*
 * Copyright (c) 2020, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

package io.ballerina.identifier;

import jsinterop.annotations.JsMethod;

/**
 * Identifier encoder to encode user defined identifiers with special
 * characters.
 *
 * @since 2.0.0
 */
public final class Utils {

  private static final String CHAR_PREFIX = "&";
  private static final String ESCAPE_PREFIX = "\\";
  private static final String GENERATED_METHOD_PREFIX = "$gen$";

  private Utils() {
  }

  private static String encodeSpecialCharacters(String identifier) {
    StringBuilder sb = new StringBuilder();
    int index = 0;
    while (index < identifier.length()) {
      String formattedString;
      if (identifier.charAt(index) == '\\' && (index + 1 < identifier.length()) &&
          (formattedString = getFormattedStringForQuotedIdentifiers(identifier.charAt(index + 1))) != null) {
        String unicodePoint = CHAR_PREFIX + formattedString;
        sb.append(unicodePoint);
        index += 2;
      } else {
        sb.append(identifier.charAt(index));
        index++;
      }
    }
    return sb.toString();
  }

  /**
   * Escape the special characters in an identifier with a preceding `\`.
   *
   * @param identifier encoded identifier string
   * @return decoded identifier
   */
  @JsMethod(namespace = "io.ballerina.identifier.jsutils")
  public static native String escapeSpecialCharacters(String identifier);

  private static String encodeIdentifier(String identifier) {
    if (identifier.contains(ESCAPE_PREFIX)) {
      identifier = encodeSpecialCharacters(identifier);
      return unescapeJava(identifier);
    }
    return identifier;
  }

  /**
   * <p>
   * Unescapes any Java literals found in the {@code String}.
   * For example, it will turn a sequence of {@code '\'} and
   * {@code 'n'} into a newline character, unless the {@code '\'}
   * is preceded by another {@code '\'}.
   * </p>
   *
   * @param str the {@code String} to unescape, may be null
   * @return a new unescaped {@code String}, {@code null} if null string input
   */
  public static String unescapeJava(String str) {
    if (str == null) {
      return null;
    }

    StringBuilder sb = new StringBuilder(str.length());
    int index = 0;

    while (index < str.length()) {
      char c = str.charAt(index);

      if (c == '\\' && index + 1 < str.length()) {
        char nextChar = str.charAt(index + 1);
        char unescapedChar = unescapeChar(nextChar);

        if (unescapedChar != 0) {
          // Valid escape sequence found
          sb.append(unescapedChar);
          index += 2;
        } else {
          // Not a valid escape sequence, keep the backslash
          sb.append(c);
          index++;
        }
      } else {
        sb.append(c);
        index++;
      }
    }

    return sb.toString();
  }

  private static char unescapeChar(char c) {
    return switch (c) {
      case 'n' -> '\n';
      case 't' -> '\t';
      case 'r' -> '\r';
      case 'b' -> '\b';
      case 'f' -> '\f';
      case '\\' -> '\\';
      case '\'' -> '\'';
      case '\"' -> '\"';
      case 'u' -> 0; // Unicode escape sequences are handled separately
      default -> 0; // Not a valid escape sequence
    };
  }

  private static Identifier encodeGeneratedName(String identifier) {
    StringBuilder sb = new StringBuilder();
    boolean isEncoded = false;
    int index = 0;
    while (index < identifier.length()) {
      String formattedString = getFormattedStringForJvmReservedSet(identifier.charAt(index));
      if (formattedString != null) {
        String unicodePoint = CHAR_PREFIX + formattedString;
        sb.append(unicodePoint);
        isEncoded = true;
      } else {
        sb.append(identifier.charAt(index));
      }
      index++;
    }
    return new Identifier(sb.toString(), isEncoded);
  }

  private static String getFormattedStringForQuotedIdentifiers(char c) {
    if (c == '$') {
      return "0036";
    }
    return getFormattedStringForJvmReservedSet(c);
  }

  private static String getFormattedStringForJvmReservedSet(char c) {
    return switch (c) {
      case '\\' -> "0092";
      case '.' -> "0046";
      case ':' -> "0058";
      case ';' -> "0059";
      case '[' -> "0091";
      case ']' -> "0093";
      case '/' -> "0047";
      case '<' -> "0060";
      case '>' -> "0062";
      default -> null;
    };
  }

  /**
   * Decode the encoded identifiers for runtime calls.
   *
   * @param encodedIdentifier encoded identifier string
   * @return decoded identifier
   */
  public static String decodeIdentifier(String encodedIdentifier) {
    if (encodedIdentifier == null) {
      return null;
    }
    StringBuilder sb = new StringBuilder();
    int index = 0;
    while (index < encodedIdentifier.length()) {
      if (encodedIdentifier.charAt(index) == '&' && index + 4 < encodedIdentifier.length()) {
        if (isUnicodePoint(encodedIdentifier, index)) {
          sb.append((char) Integer.parseInt(encodedIdentifier.substring(index + 1, index + 5)));
          index += 5;
        } else {
          sb.append(encodedIdentifier.charAt(index));
          index++;
        }
      } else {
        sb.append(encodedIdentifier.charAt(index));
        index++;
      }
    }
    return decodeGeneratedMethodName(sb.toString());
  }

  private static String decodeGeneratedMethodName(String decodedName) {
    return decodedName.startsWith(GENERATED_METHOD_PREFIX) ? decodedName.substring(GENERATED_METHOD_PREFIX.length())
        : decodedName;
  }

  /**
   * Unescapes a ballerina string.
   *
   * @param text ballerina string to unescape
   * @return unescaped ballerina string
   */
  public static String unescapeBallerina(String text) {
    return escapeString(text);
  }

  @JsMethod(namespace = "goog.string")
  private static native String escapeString(String text);

  /**
   * Replace the unicode patterns in identifiers into respective unicode
   * characters.
   *
   * @param identifier identifier string
   * @return modified identifier with unicode character
   */
  @JsMethod(namespace = "io.ballerina.identifier.jsutils")
  public static native String unescapeUnicodeCodepoints(String identifier);

  /**
   * Returns whether the <a href=
   * "https://ballerina.io/ballerina-spec/spec.html#NumericEscape">NumericEscape</a>
   * is escaped, based on no. of leading backslashes.
   *
   * @param leadingSlashes preceding backslashes of the numeric escape.
   *                       e.g. {@code \\u{61}} has 1 leading backslash.
   * @return {@code true} if numeric escape is escaped, {@code false} otherwise.
   */
  public static boolean isEscapedNumericEscape(String leadingSlashes) {
    return !isEven(leadingSlashes.length());
  }

  private static boolean isEven(int n) {
    // (n & 1) is 0 when n is even.
    return (n & 1) == 0;
  }

  private static boolean isUnicodePoint(String encodedName, int index) {
    return (containsOnlyDigits(encodedName.substring(index + 1, index + 5)));
  }

  private static boolean containsOnlyDigits(String digitString) {
    for (int i = 0; i < digitString.length(); i++) {
      if (!Character.isDigit(digitString.charAt(i))) {
        return false;
      }
    }
    return true;
  }

  /**
   * Encode the function identifiers to avoid using jvm reserved characters.
   *
   * @param functionName function identifier string
   * @return encoded identifier
   */
  public static String encodeFunctionIdentifier(String functionName) {
    functionName = encodeIdentifier(functionName);
    switch (functionName) {
      case ".<init>":
        return "$gen$&0046&0060init&0062";
      case ".<start>":
        return "$gen$&0046&0060start&0062";
      case ".<stop>":
        return "$gen$&0046&0060stop&0062";
      case ".<testinit>":
        return "$gen$&0046&0060testinit&0062";
    }
    Identifier encodedName = encodeGeneratedName(functionName);
    return encodedName.isEncoded ? GENERATED_METHOD_PREFIX + encodedName.name : functionName;
  }

  /**
   * Encode the non-function identifiers to avoid using jvm reserved characters.
   *
   * @param identifierString non-function identifier string
   * @return encoded identifier
   */
  public static String encodeNonFunctionIdentifier(String identifierString) {
    identifierString = encodeIdentifier(identifierString);
    Identifier encodedName = encodeGeneratedName(identifierString);
    return encodedName.name;
  }

  private static class Identifier {
    boolean isEncoded;
    String name;

    Identifier(String name, boolean isEncoded) {
      this.name = name;
      this.isEncoded = isEncoded;
    }
  }
}
