// Authentication feature implementation.
//
// Provides use cases, BLoC Signals state, UI presentation components, and
// explicit dependency-injection registration while keeping data internals private.
// Use Cases
export 'src/domain/usecases/get_current_user_use_case.dart';
export 'src/domain/usecases/login_use_case.dart';
export 'src/domain/usecases/logout_use_case.dart';

// Presentation
export 'src/presentation/pages/login_page.dart';
export 'src/presentation/state/auth_bloc.dart';
export 'src/presentation/widgets/login_form.dart';

// DI Registration
export 'src/di/auth_module.dart';
