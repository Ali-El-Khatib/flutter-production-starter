/// Auth V2 — Alternative authentication implementation demonstrating
/// LEGO feature replaceability and modular pluggability.
///
/// This is a demonstration brick showing that a feature can be swapped via DI
/// without modifying domain UseCases, BLoCs, or UI pages across the app.
library auth_v2;

export 'data/repositories/auth_v2_repository_impl.dart';
