/// Utility for converting strings between different naming conventions
class StringCaseConverter {
  const StringCaseConverter._();

  /// Converts snake_case to PascalCase
  ///
  /// Example: `user_profile` -> `UserProfile`
  static String snakeToPascal(String snakeCase) {
    return snakeCase
        .split('_')
        .map(
          (word) =>
              word.isEmpty ? '' : '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join();
  }

  /// Converts snake_case to camelCase
  ///
  /// Example: `user_profile` -> `userProfile`
  static String snakeToCamel(String snakeCase) {
    final words = snakeCase.split('_');
    if (words.isEmpty) return '';

    return words.first +
        words
            .skip(1)
            .map(
              (word) => word.isEmpty
                  ? ''
                  : '${word[0].toUpperCase()}${word.substring(1)}',
            )
            .join();
  }

  /// Converts snake_case to kebab-case
  ///
  /// Example: `user_profile` -> `user-profile`
  static String snakeToKebab(String snakeCase) {
    return snakeCase.replaceAll('_', '-');
  }

  /// Converts snake_case to Title Case
  ///
  /// Example: `user_profile` -> `User Profile`
  static String snakeToTitle(String snakeCase) {
    return snakeCase
        .split('_')
        .map(
          (word) =>
              word.isEmpty ? '' : '${word[0].toUpperCase()}${word.substring(1)}',
        )
        .join(' ');
  }

  /// Converts snake_case to SCREAMING_SNAKE_CASE
  ///
  /// Example: `user_profile` -> `USER_PROFILE`
  static String snakeToScreaming(String snakeCase) {
    return snakeCase.toUpperCase();
  }
}
