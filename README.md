# generals-netfix

Netcode and bug fixes for Command & Conquer Generals and Zero Hour.

The game stays as it is. This project only fixes bugs, with a focus on multiplayer (desyncs, connection drops) and on a small patch mechanism to apply the fixes. No gameplay changes, no new features.

## Approach

- Own repository, not a fork. It holds only the patches, not the game source.
- Patches apply to a pinned commit of [TheSuperHackers/GeneralsGameCode](https://github.com/TheSuperHackers/GeneralsGameCode). A script fetches that commit, applies the patches and builds.
- Goal is compatibility with the retail versions (Generals 1.08, Zero Hour 1.04) and, where possible, old Windows versions via the VC6 build.

## Layout

- `upstream.conf`: upstream repository and the pinned commit.
- `patches/`: our changes as `git format-patch` files, applied in name order.
- `scripts/prepare.sh`: clones upstream into `upstream/` (ignored by git), checks out the pinned commit on branch `netfix` and applies the patches with `git am`.

To add a patch: run `scripts/prepare.sh`, commit the change inside `upstream/`, then `git -C upstream format-patch -1 -o ../patches`.

## Status

Early setup. No patches yet.

You need your own copy of the original game. This project does not include game data. Zero Hour also needs the base game Generals installed: it loads the Generals `.big` files from the path in the registry key `HKLM\SOFTWARE\Electronic Arts\EA Games\Generals\InstallPath` (on 64-bit Windows under `WOW6432Node`). Without it, textures show up pink and the game crashes after a while.
