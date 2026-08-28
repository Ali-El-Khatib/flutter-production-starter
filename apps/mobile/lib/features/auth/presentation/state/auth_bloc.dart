import 'package:bloc_signals/bloc_signals.dart';
import 'package:injectable/injectable.dart';
import 'package:mobile/features/auth/domain/usecases/get_current_user_use_case.dart';
import 'package:mobile/features/auth/domain/usecases/login_use_case.dart';
import 'package:mobile/features/auth/domain/usecases/logout_use_case.dart';
import 'package:mobile/features/auth/presentation/state/auth_state.dart';

sealed class AuthEvent {}

class CheckAuthSessionEvent extends AuthEvent {}

class LoginSubmittedEvent extends AuthEvent {
  LoginSubmittedEvent({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}

class LogoutSubmittedEvent extends AuthEvent {}

/// Central BLoC managing authenticated session state.
@lazySingleton
class AuthBloc extends BlocSignal<AuthEvent, AuthState> {
  AuthBloc({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
  })  : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        super(initialState: const AuthState()) {
    on<CheckAuthSessionEvent>((event, emit) async {
      emit(state.value.copyWith(isLoading: true, failure: null));
      final result = await _getCurrentUserUseCase();

      result.when(
        success: (user) {
          emit(
            state.value.copyWith(
              isLoading: false,
              isAuthenticated: user != null,
              user: user,
            ),
          );
        },
        failure: (failure) {
          emit(
            state.value.copyWith(
              isLoading: false,
              isAuthenticated: false,
              failure: failure,
            ),
          );
        },
      );
    });

    on<LoginSubmittedEvent>((event, emit) async {
      emit(state.value.copyWith(isLoading: true, failure: null));

      final result = await _loginUseCase(
        email: event.email,
        password: event.password,
      );

      result.when(
        success: (session) {
          emit(
            state.value.copyWith(
              isLoading: false,
              isAuthenticated: true,
              user: session.user,
              failure: null,
            ),
          );
        },
        failure: (failure) {
          emit(
            state.value.copyWith(
              isLoading: false,
              isAuthenticated: false,
              failure: failure,
            ),
          );
        },
      );
    });

    on<LogoutSubmittedEvent>((event, emit) async {
      emit(state.value.copyWith(isLoading: true));
      await _logoutUseCase();
      emit(
        const AuthState(
          isAuthenticated: false,
          isLoading: false,
          user: null,
          failure: null,
        ),
      );
    });
  }

  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  void checkSession() => add(CheckAuthSessionEvent());
  void login({required String email, required String password}) =>
      add(LoginSubmittedEvent(email: email, password: password));
  void logout() => add(LogoutSubmittedEvent());
}
