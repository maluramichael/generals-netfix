# generals-netfix

Bug fixes for Command & Conquer Generals and Zero Hour, with a focus on multiplayer (desyncs, connection drops). The game otherwise stays as it is: no gameplay changes, no new features.

## Source

The code is imported from [TheSuperHackers/GeneralsGameCode](https://github.com/TheSuperHackers/GeneralsGameCode) at commit `f5e823ba8b72237b1308ac1084ad484cfc1d48e6`. Their `.github` workflows are not included. Everything after the import commit is our own change.

Compatibility with the retail game (Generals 1.08, Zero Hour 1.04) or with TheSuperHackers' VC6 builds is not a goal. Builds from this repository only play against builds from this repository.

## Target

Windows XP SP3 and later, built with an official Microsoft toolchain (Visual Studio 2022 with the v141 toolset and XP support). Windows 98, ME and 2000 are out of reach for that toolset.

## Running the game

You need your own copy of the original game. This project does not include game data. Zero Hour also needs the base game Generals installed: it loads the Generals `.big` files from the path in the registry key `HKLM\SOFTWARE\Electronic Arts\EA Games\Generals\InstallPath` (on 64-bit Windows under `WOW6432Node`). Without it, textures show up pink and the game crashes after a while.

## Status

Code imported. XP build in progress.

## License

GPL-3.0 with additional terms from EA, see [LICENSE.md](LICENSE.md). EA has not endorsed and does not support this project. All trademarks are the property of their respective owners.
