import 'package:freezed_annotation/freezed_annotation.dart';

part 'author.freezed.dart';
part 'author.g.dart';

@freezed
abstract class Author with _$Author {
  const factory Author({
    required String id,
    required String name,
    String? biography,
    String? imageUrl,
    String? country,
    DateTime? birthDate,
    DateTime? deathDate,
    String? website,
    @Default([]) List<String> genres,
    @Default([]) List<String> bookIds,
    @Default(false) bool isFollowed,
    DateTime? createdAt,
  }) = _Author;

  factory Author.fromJson(Map<String, dynamic> json) =>
      _$AuthorFromJson(json);
}