import 'package:bloc_signals/bloc_signals.dart';
import 'package:injectable/injectable.dart';
import '../../domain/repositories/profile_repository.dart';
import 'profile_state.dart';

export 'profile_state.dart';

sealed class ProfileEvent {}

class LoadProfileEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  UpdateProfileEvent({required this.name, this.bio});
  final String name;
  final String? bio;
}

/// BLoC orchestrating profile state management.
@injectable
class ProfileBloc extends BlocSignal<ProfileEvent, ProfileState> {
  ProfileBloc(this._profileRepository)
      : super(initialState: const ProfileState()) {
    on<LoadProfileEvent>((event, emit) async {
      emit(state.value.copyWith(isLoading: true, failure: null));
      final result = await _profileRepository.getProfile();

      result.when(
        success: (profile) {
          emit(state.value.copyWith(isLoading: false, profile: profile));
        },
        failure: (failure) {
          emit(state.value.copyWith(isLoading: false, failure: failure));
        },
      );
    });

    on<UpdateProfileEvent>((event, emit) async {
      emit(state.value.copyWith(isUpdating: true, failure: null));
      final result = await _profileRepository.updateProfile(
        name: event.name,
        bio: event.bio,
      );

      result.when(
        success: (profile) {
          emit(state.value.copyWith(isUpdating: false, profile: profile));
        },
        failure: (failure) {
          emit(state.value.copyWith(isUpdating: false, failure: failure));
        },
      );
    });
  }

  final ProfileRepository _profileRepository;

  void loadProfile() => add(LoadProfileEvent());
  void updateProfile({required String name, String? bio}) =>
      add(UpdateProfileEvent(name: name, bio: bio));
}
