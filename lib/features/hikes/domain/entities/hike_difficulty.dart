/// Difficulty grade of a hike, ascending.
///
/// The backend stores and serves language-independent keys; the wording shown
/// to the user comes from the translations, never from the API response.
/// «Ниже средней» and «выше средней» are their own grades — organizers use both
/// ends of the scale, so they must not be collapsed into [easy] / [hard].
enum HikeDifficulty {
  easy('easy'),
  belowMedium('below_medium'),
  medium('medium'),
  aboveMedium('above_medium'),
  hard('hard');

  const HikeDifficulty(this.apiValue);

  /// Value used in `difficulty` request and response fields.
  final String apiValue;

  /// Parses a raw API value; returns `null` for a missing or unknown grade.
  static HikeDifficulty? tryParse(String? raw) {
    for (final HikeDifficulty difficulty in values) {
      if (difficulty.apiValue == raw) {
        return difficulty;
      }
    }

    return null;
  }
}
