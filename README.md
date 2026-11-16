# generals-netfix

Netcode and bug fixes for Command & Conquer Generals and Zero Hour.

The game stays as it is. This project only fixes bugs, with a focus on multiplayer (desyncs, connection drops) and on a small patch mechanism to apply the fixes. No gameplay changes, no new features.

## Approach

- Own repository, not a fork. It holds only the patches, not the game source.
- Patches apply to a pinned commit of [TheSuperHackers/GeneralsGameCode](https://github.com/TheSuperHackers/GeneralsGameCode). A script fetches that commit, applies the patches and builds.
- Goal is compatibility with the retail versions (Generals 1.08, Zero Hour 1.04) and, where possible, old Windows versions via the VC6 build.

## Status

Early setup. No patches yet.

You need your own copy of the original game. This project does not include game data.
