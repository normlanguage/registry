# Registry Skill

Use this skill when registering Norm modules, validating ownership, or consuming immutable package releases.

## Registry contract

`registry.json` is the single source for Module-to-GitHub ownership. Its schema is [`registry.schema.json`](registry.schema.json). Each entry has exactly `name`, `owner`, and `repository`.

The Registry does not copy module versions, dependencies, API signatures, Skill text, or release metadata. Those facts remain in the package repository and its `module.norm` declaration.

## Lookup and Skill URL

For a registered entry `{name, owner, repository}`, the canonical repository is:

```text
https://github.com/{owner}/{repository}
```

A released library Skill is discovered at the immutable tag URL:

```text
https://raw.githubusercontent.com/{owner}/{repository}/v{version}/SKILL.md
```

The `main` URL may be used for development inspection. Agents should use a version tag for reproducible work and must not infer a Skill URL for an unregistered module.

## Registering a module

1. Confirm the repository is public, maintained, and follows the Package Standards Skill.
2. Confirm its `module.norm` name matches the proposed registry name and its repository identity follows the package naming rules.
3. Add one ownership entry to `registry.json`.
4. Run the schema and duplicate/name validation used by the repository CI.
5. Open a pull request containing only the ownership change and supporting evidence.

Existing owners publish new versions in their package repositories. A registry change does not publish or overwrite an artifact.

## Releases and installation

Package repositories publish immutable `v<version>` tags and `<artifact>-<version>.nar` plus its SHA-256 sidecar. Use the shared workflows and actions in `.github/` for package, checksum, license, and consumer verification. Pass one explicit `norm-version` or immutable `norm-source-ref`; do not silently select a moving compiler revision.

A package consumer resolves the registry entry, downloads the immutable artifact, verifies the sidecar and module identity, and installs through the Norm package manager. A missing registry entry, mismatched module identity, changed tag, checksum failure, or missing license is a release error.

## Agent workflow

Use the Registry to discover ownership and the package repository to read API and Skill content. Never treat Registry data as an API catalog. When adding a dependency, record it in the consumer's `module.norm` and use the package manager; do not create a local dependency directory or copy generated Skill content into the consumer.
