import 'package:app_core/app_core.dart';
import 'package:mobile/features/profile/domain/entities/user_profile.dart';

/// Presentation state for Profile feature.
class ProfileState {
  const ProfileState({
    this.isLoading = false,
    this.profile,
    this.failure,
    this.isUpdating = false,
  });

  final bool isLoading;
  final UserProfile? profile;
  final Failure? failure;
  final bool isUpdating;

  ProfileState copyWith({
    bool? isLoading,
    UserProfile? profile,
    Failure? failure,
    bool? isUpdating,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      profile: profile ?? this.profile,
      failure: failure,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileState &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          profile == other.profile &&
          failure == other.failure &&
          isUpdating == other.isUpdating;

  @override
  int get hashCode => Object.hash(isLoading, profile, failure, isUpdating);
}
