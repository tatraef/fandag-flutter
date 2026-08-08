import 'package:fandag/core/theme/theme.dart';
import 'package:fandag/core/translations/generated/translations.g.dart';
import 'package:fandag/core/utils/date_formatting.dart';
import 'package:fandag/features/hikes/domain/domain.dart';
import 'package:fandag/features/hikes/presentation/controllers/controllers.dart';
import 'package:fandag/features/hikes/presentation/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bottom sheet for editing feed filters. Returns the chosen [HikeFilters]
/// from [show] when the user taps «Применить», or `null` if dismissed.
class FiltersSheet extends ConsumerStatefulWidget {
  const FiltersSheet({required this.initial, super.key});

  final HikeFilters initial;

  static const List<String> regions = <String>[
    'Северный Кавказ',
    'Дагестан',
    'Ингушетия',
    'Чечня',
    'Кабардино-Балкария',
    'Северная Осетия',
    'Карачаево-Черкесия',
    'Адыгея',
  ];

  static const double _maxPrice = 20000;
  static const int _priceDivisions = 40;

  static Future<HikeFilters?> show(BuildContext context, HikeFilters initial) {
    return showModalBottomSheet<HikeFilters>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (BuildContext context) => FiltersSheet(initial: initial),
    );
  }

  @override
  ConsumerState<FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends ConsumerState<FiltersSheet> {
  late HikeFilters _draft = widget.initial;

  static const double _padding = 16;
  static const double _gap = 16;
  static const double _smallGap = 8;

  @override
  Widget build(BuildContext context) {
    final AsyncValue<List<Organizer>> organizers = ref.watch(
      organizersListProvider,
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(_padding, 0, _padding, _padding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(context.t.filters.title, style: context.primaryFonts.bold20),
              const SizedBox(height: _gap),
              _DateRow(
                draft: _draft,
                onChanged: (HikeFilters value) =>
                    setState(() => _draft = value),
              ),
              const SizedBox(height: _gap),
              _DifficultySelector(
                selected: _draft.difficulties,
                onChanged: (Set<HikeDifficulty> value) => setState(
                  () => _draft = _draft.copyWith(difficulties: value),
                ),
              ),
              const SizedBox(height: _gap),
              _PriceSlider(
                value: _draft.priceMax,
                onChanged: (int? value) =>
                    setState(() => _draft = _draft.copyWith(priceMax: value)),
              ),
              const SizedBox(height: _gap),
              _RegionDropdown(
                value: _draft.region,
                onChanged: (String? value) =>
                    setState(() => _draft = _draft.copyWith(region: value)),
              ),
              const SizedBox(height: _gap),
              _OrganizerDropdown(
                value: _draft.organizerId,
                organizers: organizers,
                onChanged: (int? value) => setState(
                  () => _draft = _draft.copyWith(organizerId: value),
                ),
              ),
              const SizedBox(height: _gap),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          setState(() => _draft = const HikeFilters()),
                      child: Text(context.t.filters.reset),
                    ),
                  ),
                  const SizedBox(width: _smallGap),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(_draft),
                      child: Text(context.t.filters.apply),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  const _DateRow({required this.draft, required this.onChanged});

  final HikeFilters draft;
  final ValueChanged<HikeFilters> onChanged;

  Future<void> _pick(BuildContext context, {required bool isFrom}) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: (isFrom ? draft.dateFrom : draft.dateTo) ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );

    if (picked == null) {
      return;
    }

    onChanged(
      isFrom
          ? draft.copyWith(dateFrom: picked)
          : draft.copyWith(dateTo: picked),
    );
  }

  String _label(DateTime? date) =>
      date == null ? '—' : DateFormatting.formatHikeDate(date, null);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _DateField(
            label: context.t.filters.dateFrom,
            value: _label(draft.dateFrom),
            onTap: () => _pick(context, isFrom: true),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _DateField(
            label: context.t.filters.dateTo,
            value: _label(draft.dateTo),
            onTap: () => _pick(context, isFrom: false),
          ),
        ),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(labelText: label),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(value, style: context.primaryFonts.regular16),
            Icon(
              Icons.calendar_today_outlined,
              color: context.colors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}

class _DifficultySelector extends StatelessWidget {
  const _DifficultySelector({required this.selected, required this.onChanged});

  final Set<HikeDifficulty> selected;
  final ValueChanged<Set<HikeDifficulty>> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          context.t.filters.difficulty,
          style: context.primaryFonts.semibold16,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: HikeDifficulty.values.map((HikeDifficulty value) {
            final bool isSelected = selected.contains(value);

            return FilterChip(
              label: Text(value.label(context)),
              selected: isSelected,
              onSelected: (bool _) {
                final Set<HikeDifficulty> next = <HikeDifficulty>{...selected};
                if (isSelected) {
                  next.remove(value);
                } else {
                  next.add(value);
                }
                onChanged(next);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _PriceSlider extends StatelessWidget {
  const _PriceSlider({required this.value, required this.onChanged});

  final int? value;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    final double current = (value ?? 0).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              context.t.filters.priceMax,
              style: context.primaryFonts.semibold16,
            ),
            Text(
              value == null
                  ? context.t.filters.priceAny
                  : '$value ${context.t.units.rub}',
              style: context.primaryFonts.medium14.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ),
        Slider(
          value: current.clamp(0, FiltersSheet._maxPrice),
          max: FiltersSheet._maxPrice,
          divisions: FiltersSheet._priceDivisions,
          label: value == null ? context.t.filters.priceAny : '$value',
          onChanged: (double next) =>
              onChanged(next <= 0 ? null : next.round()),
        ),
      ],
    );
  }
}

class _RegionDropdown extends StatelessWidget {
  const _RegionDropdown({required this.value, required this.onChanged});

  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(labelText: context.t.filters.region),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: value,
          isExpanded: true,
          isDense: true,
          items: <DropdownMenuItem<String?>>[
            DropdownMenuItem<String?>(child: Text(context.t.filters.anyValue)),
            ...FiltersSheet.regions.map(
              (String region) =>
                  DropdownMenuItem<String?>(value: region, child: Text(region)),
            ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class _OrganizerDropdown extends StatelessWidget {
  const _OrganizerDropdown({
    required this.value,
    required this.organizers,
    required this.onChanged,
  });

  final int? value;
  final AsyncValue<List<Organizer>> organizers;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    final List<Organizer> list = organizers.value ?? const <Organizer>[];
    // Guard the dropdown invariant: the value must match exactly one item.
    final int? effectiveValue = list.any((Organizer o) => o.id == value)
        ? value
        : null;

    return InputDecorator(
      decoration: InputDecoration(labelText: context.t.filters.organizer),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int?>(
          value: effectiveValue,
          isExpanded: true,
          isDense: true,
          items: <DropdownMenuItem<int?>>[
            DropdownMenuItem<int?>(child: Text(context.t.filters.anyValue)),
            ...list.map(
              (Organizer organizer) => DropdownMenuItem<int?>(
                value: organizer.id,
                child: Text(organizer.name),
              ),
            ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}
