import 'package:flutter_bloc/flutter_bloc.dart';
import '/features/home/Model/profile_repository.dart';
import '/features/home/Model/user_model.dart';

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
  ProfileActionSuccess(this.message, {this.requiresRelogin = false});
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
    on<SetGuestModeEvent>((event, emit) {
      emit(ProfileGuestMode());
    });
  }

  // في profile_bloc.dart
  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    // إذا كان المستخدم ضيفاً، ننهي العملية فوراً
    if (event.isGuest) {
      emit(ProfileGuestMode());
      return;
    }

    emit(ProfileLoading());
    try {
      _currentUser = await repository.fetchUserProfile();
      emit(ProfileLoaded(_currentUser!));
    } catch (e) {
      // فقط إذا كان هناك مستخدم حالي، لا تظهر Error، بل أظهر البيانات القديمة
      // أو قم بإعادة التوجيه لصفحة تسجيل الدخول
      emit(ProfileError("فشل تحميل البيانات: ${e.toString()}"));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    try {
      _currentUser = await repository.updateProfile(event.updatedUser);
      emit(ProfileActionSuccess('Profile updated successfully'));
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
          'Password changed successfully',
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
          'Email changed successfully',
          requiresRelogin: true,
        ),
      );
    } catch (e) {
      emit(ProfileError(e.toString()));
      if (_currentUser != null) emit(ProfileLoaded(_currentUser!));
    }
  }
}
