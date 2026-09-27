# Norm GitHub Registry

[简体中文](README.zh-CN.md)

`registry.json` maps a Norm Module name to the public GitHub repository that owns its immutable releases.

Each registered repository publishes `v<version>` with `<artifact>-<version>.nar` and its SHA-256 sidecar. Module identity and dependencies remain declared only in `module.norm`.

New packages register their name and repository through a pull request. Existing owners publish new versions independently.

Package repositories call [the shared workflow](.github/workflows/package.yml) with an explicit Norm toolchain version. It resolves the declaration, rejects uncommitted resolution changes, packages one root Module, runs module tests and existing `Main.norm` regressions outside `samples/`, attests tagged artifacts, and publishes the immutable Release. Each owner validates its `samples/` separately.

Modules with a Windows Java dependency graph set `runner: windows-2025` when calling the shared workflow. The default runner is Linux.
