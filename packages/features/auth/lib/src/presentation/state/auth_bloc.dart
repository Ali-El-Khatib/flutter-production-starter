import 'dart:async';

import 'package:bloc_signals/bloc_signals.dart';
import '../../domain/usecases/get_current_user_use_case.dart';
import '../../domain/usecases/login_use_case.dart';
import '../../domain/usecases/logout_use_case.dart';
import 'auth_event.dart';
import 'auth_state.dart';

export 'auth_event.dart';
export 'auth_state.dart';

/// Central BLoC managing authenticated session state.
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
      if (!event.completer.isCompleted) {
        event.completer.complete();
      }
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
      final result = await _logoutUseCase();
      result.when(
        success: (_) => emit(
          const AuthState(
            isAuthenticated: false,
            isLoading: false,
            user: null,
            failure: null,
          ),
        ),
        failure: (failure) => emit(
          state.value.copyWith(isLoading: false, failure: failure),
        ),
      );
    });
  }

  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  Future<void> checkSession() {
    final completer = Completer<void>();
    add(CheckAuthSessionEvent(completer));
    return completer.future;
  }

  void login({required String email, required String password}) =>
      add(LoginSubmittedEvent(email: email, password: password));
  void logout() => add(LogoutSubmittedEvent());
}
