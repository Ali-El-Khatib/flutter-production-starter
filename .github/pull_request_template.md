## Summary

<!-- What changed? Keep this focused on observable behavior and repository boundaries. -->

## Why

<!-- What problem does this solve? Link the issue with "Closes #123" when applicable. -->

## Validation

<!-- List the exact commands and manual checks you ran. Never claim checks that were not run. -->

- [ ] `dart run melos run generate`
- [ ] `dart run melos run format:check`
- [ ] `dart run melos run analyze`
- [ ] `dart run melos run test`
- [ ] Relevant manual or device verification is described below.

Checks not run and why:

## Visual evidence

<!-- For UI changes, add before/after screenshots or recordings. Write "Not applicable" otherwise. -->

## Architecture and risk

- [ ] The change is focused and does not include unrelated cleanup.
- [ ] Dependency direction and public module boundaries remain valid.
- [ ] New dependencies or public APIs are justified below.
- [ ] Generated files are current and come from their authoritative inputs, or documented native ownership applies.
- [ ] Tests cover meaningful changed behavior, or the reason they do not is explained.
- [ ] Documentation and beginner guidance were updated when behavior or setup changed.
- [ ] No secrets, credentials, private keys, or personal data are included.

Breaking changes, migrations, new dependencies, or follow-up work:

## Contributor checklist

- [ ] I read `CONTRIBUTING.md` and `CODE_OF_CONDUCT.md`.
- [ ] I am willing to address focused review feedback for this pull request.
