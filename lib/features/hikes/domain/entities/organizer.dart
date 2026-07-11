import 'package:fandag/features/hikes/domain/entities/hike.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'organizer.freezed.dart';

@freezed
abstract class Organizer with _$Organizer {
  const factory Organizer({
    required int id,
    required String name,
    String? city,
    List<Hike>? hikes,
  }) = _Organizer;
}
