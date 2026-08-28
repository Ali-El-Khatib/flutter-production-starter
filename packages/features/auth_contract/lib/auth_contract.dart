/// Stable authentication contracts, entities, and repository interfaces.
///
/// Designed to be consumed by application composition, route guards,
/// profile, and interchangeable auth implementation packages.
library auth_contract;

export 'src/entities/auth_session.dart';
export 'src/entities/user.dart';
export 'src/repositories/auth_repository.dart';
