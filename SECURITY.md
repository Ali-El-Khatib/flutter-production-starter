# Security Policy

## Supported Versions

This repository is a source-code starter, not a hosted service. Security fixes
are developed against the current repository state.

| Target | Security support |
|---|---|
| `main` branch | Supported |
| Latest published GitHub release, when one exists | Supported |
| Earlier tags or releases | Not supported |
| Downstream forks and applications | Maintained by their respective owners |

Consumers should regularly update Flutter, Dart, native build tooling, and
third-party packages. Copying this starter does not transfer responsibility for
the security of a product's backend, secrets, signing material, deployment, or
runtime configuration.

## Reporting a Vulnerability

Please do not disclose suspected vulnerabilities in a public issue, pull
request, discussion, or social-media post.

Use GitHub's private vulnerability reporting flow when it is available:

[Privately report a vulnerability](https://github.com/Ali-El-Khatib/flutter-production-starter/security/advisories/new)

If GitHub does not show the private reporting form, contact the maintainer using
the private contact method published on the
[maintainer's GitHub profile](https://github.com/Ali-El-Khatib) and ask for a
secure reporting channel before sharing sensitive details.

Include as much of the following as practical:

- the affected commit, release, package, or platform;
- a concise description of the vulnerability and its likely impact;
- minimal reproduction steps or a proof of concept;
- required preconditions and affected configurations;
- any suggested remediation;
- your preferred disclosure timeline and attribution.

Remove credentials, tokens, personal data, and unrelated sensitive information
from reports and diagnostic output.

## What to Expect

This is a volunteer-maintained open-source project and cannot promise a formal
service-level agreement. The maintainer will make a reasonable effort to:

1. acknowledge a report privately;
2. validate its scope and severity;
3. coordinate remediation and disclosure through a private security advisory;
4. credit the reporter if requested and appropriate;
5. publish a fix or mitigation before public disclosure whenever possible.

Please allow a reasonable period for investigation and remediation before
disclosing the issue publicly.

## Scope

Reports are in scope when they affect code, automation, dependencies, generated
configuration, or security guidance owned by this repository. Examples include
credential exposure, unsafe authentication or storage defaults, dependency
risks, and workflow behavior that could compromise consumers of the starter.

Vulnerabilities in Flutter, Dart, GitHub Actions, or third-party packages should
normally be reported to their upstream maintainers unless this repository's
specific configuration introduces or worsens the problem. Product-specific
vulnerabilities in an application built from this starter belong to that
application's maintainers.
