/// Authentication Feature Implementation.
///
/// Provides Clean Architecture data sources, repository implementations,
/// use cases, BLoC Signals state, and UI presentation components.
library feature_auth;

// Data & Repository Implementations (for composition/testing)
export 'src/data/datasources/auth_remote_data_source.dart';
export 'src/data/repositories/auth_repository_impl.dart';

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
