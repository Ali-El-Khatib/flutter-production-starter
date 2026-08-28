import 'package:app_core/app_core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';
import '../state/auth_bloc.dart';
import '../widgets/login_form.dart';

/// Authentication Login Page.
class LoginPage extends StatelessWidget {
  const LoginPage({
    super.key,
    required this.authBloc,
    required this.messageResolver,
    required this.feedback,
    this.onLoginSuccess,
    this.onBack,
  });

  final AuthBloc authBloc;
  final FailureMessageResolver messageResolver;
  final AppFeedback feedback;
  final VoidCallback? onLoginSuccess;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication'),
        leading: onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: onBack,
              )
            : null,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingLg,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: SignalBuilder(
              builder: (context) {
                final state = authBloc.state();

                if (state.isAuthenticated && onLoginSuccess != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    feedback.showSuccess(
                      context,
                      'Welcome back, ${state.user?.name ?? 'Developer'}!',
                    );
                    onLoginSuccess!();
                  });
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.shield_outlined,
                      size: 64,
                      color: theme.colorScheme.primary,
                    ),
                    AppSpacing.gapV16,
                    Text(
                      'Welcome Back',
                      style: theme.textTheme.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    AppSpacing.gapV8,
                    Text(
                      'Sign in to access your dashboard and profile',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (state.failure != null) ...[
                      AppSpacing.gapV16,
                      Container(
                        padding: AppSpacing.paddingMd,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error.withValues(alpha: 0.1),
                          borderRadius: AppRadius.radiusMd,
                          border: Border.all(color: theme.colorScheme.error),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline,
                                color: theme.colorScheme.error, size: 20),
                            AppSpacing.gapH8,
                            Expanded(
                              child: Text(
                                messageResolver.resolve(state.failure!),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    AppSpacing.gapV24,
                    Card(
                      child: Padding(
                        padding: AppSpacing.paddingLg,
                        child: LoginForm(
                          isLoading: state.isLoading,
                          onSubmit: (email, password) {
                            authBloc.login(email: email, password: password);
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
