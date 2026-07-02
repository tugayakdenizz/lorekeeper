import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_library.freezed.dart';
part 'user_library.g.dart';

@freezed
abstract class UserLibrary with _$UserLibrary {
  const factory UserLibrary({
    required String id,
    required String userId,
    @Default([]) List<String> bookIds,
    @Default([]) List<String> favoriteBookIds,
    @Default([]) List<String> favoriteAuthorIds,
    @Default([]) List<String> followedAuthorIds,
    @Default([]) List<String> seriesIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserLibrary;

  factory UserLibrary.fromJson(Map<String, dynamic> json) =>
      _$UserLibraryFromJson(json);
}