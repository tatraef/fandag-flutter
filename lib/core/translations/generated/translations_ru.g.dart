///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'translations.g.dart';

// Path: <root>
class TranslationsRu with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsRu({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ru,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ru>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsRu _root = this; // ignore: unused_field

	@override 
	TranslationsRu $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsRu(meta: meta ?? this.$meta);

	// Translations
	@override late final _TranslationsCommonRu common = _TranslationsCommonRu._(_root);
	@override late final _TranslationsNavigationRu navigation = _TranslationsNavigationRu._(_root);
	@override late final _TranslationsFeedRu feed = _TranslationsFeedRu._(_root);
	@override late final _TranslationsDifficultyRu difficulty = _TranslationsDifficultyRu._(_root);
	@override late final _TranslationsFiltersRu filters = _TranslationsFiltersRu._(_root);
	@override late final _TranslationsDetailRu detail = _TranslationsDetailRu._(_root);
	@override late final _TranslationsOrganizerRu organizer = _TranslationsOrganizerRu._(_root);
	@override late final _TranslationsFavoritesRu favorites = _TranslationsFavoritesRu._(_root);
	@override late final _TranslationsUnitsRu units = _TranslationsUnitsRu._(_root);
}

// Path: common
class _TranslationsCommonRu implements TranslationsCommonEn {
	_TranslationsCommonRu._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get appTitle => 'Fændag';
	@override String get retry => 'Повторить';
	@override late final _TranslationsCommonErrorsRu errors = _TranslationsCommonErrorsRu._(_root);
}

// Path: navigation
class _TranslationsNavigationRu implements TranslationsNavigationEn {
	_TranslationsNavigationRu._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get hikes => 'Походы';
	@override String get favorites => 'Избранное';
}

// Path: feed
class _TranslationsFeedRu implements TranslationsFeedEn {
	_TranslationsFeedRu._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get empty => 'Походов пока нет';
	@override String get loadError => 'Не удалось загрузить. Потяните, чтобы повторить';
}

// Path: difficulty
class _TranslationsDifficultyRu implements TranslationsDifficultyEn {
	_TranslationsDifficultyRu._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get easy => 'Низкая';
	@override String get belowMedium => 'Ниже средней';
	@override String get medium => 'Средняя';
	@override String get aboveMedium => 'Выше средней';
	@override String get hard => 'Высокая';
}

// Path: filters
class _TranslationsFiltersRu implements TranslationsFiltersEn {
	_TranslationsFiltersRu._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get title => 'Фильтры';
	@override String get apply => 'Применить';
	@override String get reset => 'Сбросить';
	@override String get dateFrom => 'Дата от';
	@override String get dateTo => 'Дата до';
	@override String get difficulty => 'Сложность';
	@override String get priceMax => 'Цена до';
	@override String get priceAny => 'Любая';
	@override String get region => 'Регион';
	@override String get organizer => 'Организатор';
	@override String get anyValue => 'Любой';
}

// Path: detail
class _TranslationsDetailRu implements TranslationsDetailEn {
	_TranslationsDetailRu._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get parameters => 'Параметры';
	@override String get price => 'Цена';
	@override String get distance => 'Дистанция';
	@override String get elevation => 'Набор высоты';
	@override String get departureTime => 'Время выезда';
	@override String get departurePlace => 'Место сбора';
	@override String get spotsLeft => 'Осталось мест';
	@override String get region => 'Регион';
	@override String get requirements => 'Взять с собой';
	@override String get includes => 'Входит в стоимость';
	@override String get organizer => 'Организатор';
	@override String get call => 'Позвонить';
	@override String get openOriginal => 'Открыть оригинал';
	@override String get loadError => 'Не удалось загрузить поход';
}

// Path: organizer
class _TranslationsOrganizerRu implements TranslationsOrganizerEn {
	_TranslationsOrganizerRu._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get upcomingHikes => 'Ближайшие походы';
	@override String get loadError => 'Не удалось загрузить организатора';
}

// Path: favorites
class _TranslationsFavoritesRu implements TranslationsFavoritesEn {
	_TranslationsFavoritesRu._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get emptyMessage => 'Вы пока ничего не сохранили';
	@override String get loadError => 'Не удалось загрузить избранное';
}

// Path: units
class _TranslationsUnitsRu implements TranslationsUnitsEn {
	_TranslationsUnitsRu._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get rub => '₽';
	@override String get km => 'км';
	@override String get m => 'м';
}

// Path: common.errors
class _TranslationsCommonErrorsRu implements TranslationsCommonErrorsEn {
	_TranslationsCommonErrorsRu._(this._root);

	final TranslationsRu _root; // ignore: unused_field

	// Translations
	@override String get network => 'Нет подключения к интернету';
	@override String get unauthorized => 'Сессия истекла. Пожалуйста, войдите снова.';
	@override String get timeout => 'Время ожидания истекло. Попробуйте ещё раз.';
	@override String get server => 'Ошибка сервера. Попробуйте позже.';
	@override String get unknown => 'Что-то пошло не так';
}

/// The flat map containing all translations for locale <ru>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsRu {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'common.appTitle' => 'Fændag',
			'common.retry' => 'Повторить',
			'common.errors.network' => 'Нет подключения к интернету',
			'common.errors.unauthorized' => 'Сессия истекла. Пожалуйста, войдите снова.',
			'common.errors.timeout' => 'Время ожидания истекло. Попробуйте ещё раз.',
			'common.errors.server' => 'Ошибка сервера. Попробуйте позже.',
			'common.errors.unknown' => 'Что-то пошло не так',
			'navigation.hikes' => 'Походы',
			'navigation.favorites' => 'Избранное',
			'feed.empty' => 'Походов пока нет',
			'feed.loadError' => 'Не удалось загрузить. Потяните, чтобы повторить',
			'difficulty.easy' => 'Низкая',
			'difficulty.belowMedium' => 'Ниже средней',
			'difficulty.medium' => 'Средняя',
			'difficulty.aboveMedium' => 'Выше средней',
			'difficulty.hard' => 'Высокая',
			'filters.title' => 'Фильтры',
			'filters.apply' => 'Применить',
			'filters.reset' => 'Сбросить',
			'filters.dateFrom' => 'Дата от',
			'filters.dateTo' => 'Дата до',
			'filters.difficulty' => 'Сложность',
			'filters.priceMax' => 'Цена до',
			'filters.priceAny' => 'Любая',
			'filters.region' => 'Регион',
			'filters.organizer' => 'Организатор',
			'filters.anyValue' => 'Любой',
			'detail.parameters' => 'Параметры',
			'detail.price' => 'Цена',
			'detail.distance' => 'Дистанция',
			'detail.elevation' => 'Набор высоты',
			'detail.departureTime' => 'Время выезда',
			'detail.departurePlace' => 'Место сбора',
			'detail.spotsLeft' => 'Осталось мест',
			'detail.region' => 'Регион',
			'detail.requirements' => 'Взять с собой',
			'detail.includes' => 'Входит в стоимость',
			'detail.organizer' => 'Организатор',
			'detail.call' => 'Позвонить',
			'detail.openOriginal' => 'Открыть оригинал',
			'detail.loadError' => 'Не удалось загрузить поход',
			'organizer.upcomingHikes' => 'Ближайшие походы',
			'organizer.loadError' => 'Не удалось загрузить организатора',
			'favorites.emptyMessage' => 'Вы пока ничего не сохранили',
			'favorites.loadError' => 'Не удалось загрузить избранное',
			'units.rub' => '₽',
			'units.km' => 'км',
			'units.m' => 'м',
			_ => null,
		};
	}
}
