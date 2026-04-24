# appcorectl-nix

Nix flake packaging for `appcorectl`, the AppCoreOS operator CLI.

## Install

Run directly:

```bash
nix run github:Goldeneye128/appcorectl-nix
```

Install into a profile:

```bash
nix profile install github:Goldeneye128/appcorectl-nix
```

Build locally:

```bash
nix build
./result/bin/appcorectl --help
```

## Update

The flake pins a specific `appcoreos` commit and source hash. To update:

1. Push the new `appcoreos` commit.
2. Update `rev` and `hash` in `flake.nix`.
3. Run `nix flake lock --update-input nixpkgs`.
4. Run `nix build`.
5. Commit and push the Nix repo.
