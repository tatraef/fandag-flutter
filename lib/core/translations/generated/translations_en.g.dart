///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'translations.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final TranslationsCommonEn common = TranslationsCommonEn._(_root);
	late final TranslationsNavigationEn navigation = TranslationsNavigationEn._(_root);
	late final TranslationsFeedEn feed = TranslationsFeedEn._(_root);
	late final TranslationsDifficultyEn difficulty = TranslationsDifficultyEn._(_root);
	late final TranslationsFiltersEn filters = TranslationsFiltersEn._(_root);
	late final TranslationsDetailEn detail = TranslationsDetailEn._(_root);
	late final TranslationsOrganizerEn organizer = TranslationsOrganizerEn._(_root);
	late final TranslationsFavoritesEn favorites = TranslationsFavoritesEn._(_root);
	late final TranslationsUnitsEn units = TranslationsUnitsEn._(_root);
}

// Path: common
class TranslationsCommonEn {
	TranslationsCommonEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Fændag'
	String get appTitle => 'Fændag';

	/// en: 'Retry'
	String get retry => 'Retry';

	late final TranslationsCommonErrorsEn errors = TranslationsCommonErrorsEn._(_root);
}

// Path: navigation
class TranslationsNavigationEn {
	TranslationsNavigationEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Hikes'
	String get hikes => 'Hikes';

	/// en: 'Favorites'
	String get favorites => 'Favorites';
}

// Path: feed
class TranslationsFeedEn {
	TranslationsFeedEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No hikes yet'
	String get empty => 'No hikes yet';

	/// en: 'Failed to load. Pull down to retry'
	String get loadError => 'Failed to load. Pull down to retry';
}

// Path: difficulty
class TranslationsDifficultyEn {
	TranslationsDifficultyEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Low'
	String get easy => 'Low';

	/// en: 'Below average'
	String get belowMedium => 'Below average';

	/// en: 'Average'
	String get medium => 'Average';

	/// en: 'Above average'
	String get aboveMedium => 'Above average';

	/// en: 'High'
	String get hard => 'High';
}

// Path: filters
class TranslationsFiltersEn {
	TranslationsFiltersEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Filters'
	String get title => 'Filters';

	/// en: 'Apply'
	String get apply => 'Apply';

	/// en: 'Reset'
	String get reset => 'Reset';

	/// en: 'Date from'
	String get dateFrom => 'Date from';

	/// en: 'Date to'
	String get dateTo => 'Date to';

	/// en: 'Difficulty'
	String get difficulty => 'Difficulty';

	/// en: 'Max price'
	String get priceMax => 'Max price';

	/// en: 'Any'
	String get priceAny => 'Any';

	/// en: 'Region'
	String get region => 'Region';

	/// en: 'Organizer'
	String get organizer => 'Organizer';

	/// en: 'Any'
	String get anyValue => 'Any';
}

// Path: detail
class TranslationsDetailEn {
	TranslationsDetailEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Parameters'
	String get parameters => 'Parameters';

	/// en: 'Price'
	String get price => 'Price';

	/// en: 'Distance'
	String get distance => 'Distance';

	/// en: 'Elevation gain'
	String get elevation => 'Elevation gain';

	/// en: 'Departure time'
	String get departureTime => 'Departure time';

	/// en: 'Meeting point'
	String get departurePlace => 'Meeting point';

	/// en: 'Spots left'
	String get spotsLeft => 'Spots left';

	/// en: 'Region'
	String get region => 'Region';

	/// en: 'What to bring'
	String get requirements => 'What to bring';

	/// en: 'Included'
	String get includes => 'Included';

	/// en: 'Organizer'
	String get organizer => 'Organizer';

	/// en: 'Call'
	String get call => 'Call';

	/// en: 'Open original'
	String get openOriginal => 'Open original';

	/// en: 'Failed to load the hike'
	String get loadError => 'Failed to load the hike';
}

// Path: organizer
class TranslationsOrganizerEn {
	TranslationsOrganizerEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Upcoming hikes'
	String get upcomingHikes => 'Upcoming hikes';

	/// en: 'Failed to load the organizer'
	String get loadError => 'Failed to load the organizer';
}

// Path: favorites
class TranslationsFavoritesEn {
	TranslationsFavoritesEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'You haven't saved anything yet'
	String get emptyMessage => 'You haven\'t saved anything yet';

	/// en: 'Failed to load favorites'
	String get loadError => 'Failed to load favorites';
}

// Path: units
class TranslationsUnitsEn {
	TranslationsUnitsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '₽'
	String get rub => '₽';

	/// en: 'km'
	String get km => 'km';

	/// en: 'm'
	String get m => 'm';
}

// Path: common.errors
class TranslationsCommonErrorsEn {
	TranslationsCommonErrorsEn._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No internet connection'
	String get network => 'No internet connection';

	/// en: 'Session expired. Please sign in again.'
	String get unauthorized => 'Session expired. Please sign in again.';

	/// en: 'Request timed out. Please try again.'
	String get timeout => 'Request timed out. Please try again.';

	/// en: 'Server error. Please try again later.'
	String get server => 'Server error. Please try again later.';

	/// en: 'Something went wrong'
	String get unknown => 'Something went wrong';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'common.appTitle' => 'Fændag',
			'common.retry' => 'Retry',
			'common.errors.network' => 'No internet connection',
			'common.errors.unauthorized' => 'Session expired. Please sign in again.',
			'common.errors.timeout' => 'Request timed out. Please try again.',
			'common.errors.server' => 'Server error. Please try again later.',
			'common.errors.unknown' => 'Something went wrong',
			'navigation.hikes' => 'Hikes',
			'navigation.favorites' => 'Favorites',
			'feed.empty' => 'No hikes yet',
			'feed.loadError' => 'Failed to load. Pull down to retry',
			'difficulty.easy' => 'Low',
			'difficulty.belowMedium' => 'Below average',
			'difficulty.medium' => 'Average',
			'difficulty.aboveMedium' => 'Above average',
			'difficulty.hard' => 'High',
			'filters.title' => 'Filters',
			'filters.apply' => 'Apply',
			'filters.reset' => 'Reset',
			'filters.dateFrom' => 'Date from',
			'filters.dateTo' => 'Date to',
			'filters.difficulty' => 'Difficulty',
			'filters.priceMax' => 'Max price',
			'filters.priceAny' => 'Any',
			'filters.region' => 'Region',
			'filters.organizer' => 'Organizer',
			'filters.anyValue' => 'Any',
			'detail.parameters' => 'Parameters',
			'detail.price' => 'Price',
			'detail.distance' => 'Distance',
			'detail.elevation' => 'Elevation gain',
			'detail.departureTime' => 'Departure time',
			'detail.departurePlace' => 'Meeting point',
			'detail.spotsLeft' => 'Spots left',
			'detail.region' => 'Region',
			'detail.requirements' => 'What to bring',
			'detail.includes' => 'Included',
			'detail.organizer' => 'Organizer',
			'detail.call' => 'Call',
			'detail.openOriginal' => 'Open original',
			'detail.loadError' => 'Failed to load the hike',
			'organizer.upcomingHikes' => 'Upcoming hikes',
			'organizer.loadError' => 'Failed to load the organizer',
			'favorites.emptyMessage' => 'You haven\'t saved anything yet',
			'favorites.loadError' => 'Failed to load favorites',
			'units.rub' => '₽',
			'units.km' => 'km',
			'units.m' => 'm',
			_ => null,
		};
	}
}
