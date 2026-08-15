import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Model/profile_repository.dart';
import '../Model/user_model.dart';

// --- EVENTS ---
abstract class ProfileEvent {}

class LoadProfileEvent extends ProfileEvent {
  final bool isGuest;
  LoadProfileEvent({this.isGuest = false});
}

class UpdateProfileEvent extends ProfileEvent {
  final UserModel updatedUser;
  UpdateProfileEvent(this.updatedUser);
}

class ChangePasswordEvent extends ProfileEvent {
  final String currentPassword;
  final String newPassword;
  ChangePasswordEvent(this.currentPassword, this.newPassword);
}

class SetGuestModeEvent extends ProfileEvent {}

class ChangeEmailEvent extends ProfileEvent {
  final String newEmail;
  final String currentPassword;
  ChangeEmailEvent(this.newEmail, this.currentPassword);
}

// --- STATES ---
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;
  ProfileLoaded(this.user);
}

class ProfileGuestMode extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

class ProfileActionSuccess extends ProfileState {
  final String message;
  final bool requiresRelogin;
  final UserModel? updatedUser;

  ProfileActionSuccess(
    this.message, {
    this.requiresRelogin = false,
    this.updatedUser,
  });
}

// --- BLOC ---
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository repository;
  UserModel? _currentUser;

  ProfileBloc(this.repository) : super(ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<ChangePasswordEvent>(_onChangePassword);
    on<ChangeEmailEvent>(_onChangeEmail);
    on<SetGuestModeEvent>((event, emit) => emit(ProfileGuestMode()));
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (event.isGuest) {
      emit(ProfileGuestMode());
      return;
    }

    emit(ProfileLoading());
    try {
      _currentUser = await repository.fetchUserProfile();
      emit(ProfileLoaded(_currentUser!));
    } catch (e) {
      emit(ProfileError("Failed to load profile: ${e.toString()}"));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      _currentUser = await repository.updateProfile(event.updatedUser);
      emit(
        ProfileActionSuccess(
          'Profile updated successfully'.tr(),
          updatedUser: _currentUser,
        ),
      );
      emit(ProfileLoaded(_currentUser!));
    } catch (e) {
      emit(ProfileError(e.toString()));
      if (_currentUser != null) emit(ProfileLoaded(_currentUser!));
    }
  }

  Future<void> _onChangePassword(
    ChangePasswordEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      await repository.changePassword(event.currentPassword, event.newPassword);
      emit(
        ProfileActionSuccess(
          'Password changed successfully'.tr(),
          requiresRelogin: true,
        ),
      );
    } catch (e) {
      emit(ProfileError(e.toString()));
      if (_currentUser != null) emit(ProfileLoaded(_currentUser!));
    }
  }

  Future<void> _onChangeEmail(
    ChangeEmailEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      await repository.changeEmail(event.newEmail, event.currentPassword);
      emit(
        ProfileActionSuccess(
          'Email changed successfully'.tr(),
          requiresRelogin: true,
        ),
      );
    } catch (e) {
      emit(ProfileError(e.toString()));
      if (_currentUser != null) emit(ProfileLoaded(_currentUser!));
    }
  }
}
