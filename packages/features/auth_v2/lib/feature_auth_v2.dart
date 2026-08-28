/// Alternative Authentication (V2) Feature Implementation.
///
/// Demonstrates zero-blast-radius LEGO feature replaceability behind the shared
/// [AuthRepository] domain contract.
library feature_auth_v2;

export 'src/data/repositories/auth_v2_repository_impl.dart';
export 'src/di/auth_v2_module.dart';
