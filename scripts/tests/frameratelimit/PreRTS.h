// Minimal stand-in for the game's PreRTS.h, so FrameRateLimit.cpp builds on its own for the test.
#pragma once
#include <windows.h>
typedef int Int;
typedef unsigned int UnsignedInt;
typedef float Real;
enum { LOGICFRAMES_PER_SECOND = 30 };
