import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'current.freezed.dart';
part 'current.g.dart';

@freezed
class CurrentUser with _$CurrentUser {
  const factory CurrentUser({
    required int wikiPageVersionCount,
    required int artistVersionCount,
    required int poolVersionCount,
    required int forumPostCount,
    required int commentCount,
    required int flagCount,
    required int positiveFeedbackCount,
    required int neutralFeedbackCount,
    required int negativeFeedbackCount,
    required int uploadLimit,
    required int id,
    required DateTime createdAt,
    required String name,
    required int level,
    required int baseUploadLimit,
    required int postUploadCount,
    required int postUpdateCount,
    required int noteUpdateCount,
    required bool isBanned,
    required bool canApprovePosts,
    required bool canUploadFree,
    required String levelString,
    required int? avatarId,
    required bool showAvatars,
    required bool blacklistAvatars,
    required bool blacklistUsers,
    required bool descriptionCollapsedInitially,
    required bool hideComments,
    required bool showHiddenComments,
    required bool showPostStatistics,
    required bool hasMail,
    required bool receiveEmailNotifications,
    required bool enableKeyboardNavigation,
    required bool enablePrivacyMode,
    required bool styleUsernames,
    required bool enableAutoComplete,
    required bool hasSavedSearches,
    required bool disableCroppedThumbnails,
    required bool disableMobileGestures,
    required bool enableSafeMode,
    required bool disableResponsiveMode,
    required bool disablePostTooltips,
    required bool noFlagging,
    required bool noFeedback,
    required bool disableUserDmails,
    required bool enableCompactUploader,
    required DateTime updatedAt,
    required String email,
    required DateTime lastLoggedInAt,
    required DateTime? lastForumReadAt,
    required String? recentTags,
    required int commentThreshold,
    required String defaultImageSize,
    required String? favoriteTags,
    required String blacklistedTags,
    required String timeZone,
    required int perPage,
    required String? customStyle,
    required int favoriteCount,
    required int apiRegenMultiplier,
    required int apiBurstLimit,
    required int remainingApiLimit,
    required int statementTimeout,
    required int favoriteLimit,
    required int tagQueryLimit,
  }) = _CurrentUser;

  factory CurrentUser.fromJson(Map<String, dynamic> json) =>
      _$CurrentUserFromJson(json);
}
