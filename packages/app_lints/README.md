# App Lints (`package:app_lints`)

Shared strict static analysis and linting rules enforced across all packages in the monorepo.

---

## 📦 Features

- **Strict Type Checking**: Enables `strict-casts`, `strict-inference`, and `strict-raw-types`.
- **Error Promotion**: Enforces errors on `missing_required_param` and `missing_return`.
- **Code Consistency Rules**: Enforces `prefer_const_constructors`, `prefer_const_declarations`, `unawaited_futures`, `avoid_relative_lib_imports`, and `use_build_context_synchronously`.

---

## 🚀 Usage

Include the shared rules in any package's `analysis_options.yaml`:

```yaml
include: package:app_lints/analysis_options.yaml
```
