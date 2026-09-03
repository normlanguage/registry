# Norm GitHub Registry

`registry.json` maps a Norm Module name to the public GitHub repository that owns its immutable releases.

Each registered repository publishes `v<version>` with `<artifact>-<version>.nar` and its SHA-256 sidecar. Module identity and dependencies remain declared only in `module.norm`.

New packages register their name and repository through a pull request. Existing owners publish new versions independently.
