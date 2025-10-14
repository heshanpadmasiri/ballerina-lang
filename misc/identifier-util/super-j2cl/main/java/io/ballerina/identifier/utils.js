goog.module("io.ballerina.identifier.jsutils");

/**
 * Escape the special characters in an identifier with a preceding `\`.
 * Equivalent to Java's escapeSpecialCharacters method.
 *
 * @param {string} identifier encoded identifier string
 * @return {string} decoded identifier
 */
function escapeSpecialCharacters(identifier) {
  if (!identifier) {
    return identifier;
  }

  // Special character set: [$&+,:;=?@#\|/' \[}\]<>."^*{}~`()%!-]
  const specialCharRegex = /([$&+,:;=\?@#\\|/'\[\}\]<>\."^*{}~`()%!-])/g;

  return identifier.replace(specialCharRegex, '\\$1');
}

/**
 * Replace the unicode patterns in identifiers into respective unicode characters.
 * Equivalent to Java's unescapeUnicodeCodepoints method.
 *
 * @param {string} identifier identifier string
 * @return {string} modified identifier with unicode character
 */
function unescapeUnicodeCodepoints(identifier) {
  if (!identifier) {
    return identifier;
  }

  // Regex pattern: \\(\\*)u\{([a-fA-F0-9]+)\}
  const unicodeRegex = /\\(\\*)u\{([a-fA-F0-9]+)\}/g;

  return identifier.replace(unicodeRegex, function(match, leadingSlashes, hexCode) {
    // Check if the numeric escape is escaped (odd number of leading slashes)
    if (isEscapedNumericEscape(leadingSlashes)) {
      // e.g. \\u{61}, \\\\u{61} - keep as is
      return match;
    }

    // Parse the hex codepoint
    const codePoint = parseInt(hexCode, 16);

    // Convert to character using String.fromCodePoint (supports codepoints > 0xFFFF)
    let char = String.fromCodePoint(codePoint);

    // Special case for backslash character (codepoint 0x5C)
    // Ballerina string unescaping is done in two stages:
    // 1. unicode code point unescaping (this function)
    // 2. java unescaping
    // Replacing unicode code point of backslash at [1] would compromise [2].
    // Therefore, special case it.
    if (char === '\\') {
      char = '\\u005C';
    }

    return leadingSlashes + char;
  });
}

/**
 * Returns whether the NumericEscape is escaped, based on no. of leading backslashes.
 * Equivalent to Java's isEscapedNumericEscape method.
 *
 * @param {string} leadingSlashes preceding backslashes of the numeric escape
 * @return {boolean} true if numeric escape is escaped, false otherwise
 */
function isEscapedNumericEscape(leadingSlashes) {
  // Odd number of slashes means escaped
  return (leadingSlashes.length & 1) !== 0;
}

// Export functions for Java JsInterop access
exports.escapeSpecialCharacters = escapeSpecialCharacters;
exports.unescapeUnicodeCodepoints = unescapeUnicodeCodepoints;
