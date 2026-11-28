// Regression test for the FPS decoupling (Kanboard #3046): render fps presets, logic time scale
// steps and the lower bound of the frame rate limiter. Run with scripts\test-frameratelimit.ps1.
#include "PreRTS.h"
#include "Common/FrameRateLimit.h"
#include <stdio.h>

static int failures = 0;

static void expectEq(UnsignedInt actual, UnsignedInt expected, const char* what)
{
	if (actual != expected)
	{
		printf("FAIL %s: %u, expected %u\n", what, actual, expected);
		++failures;
	}
}

int main()
{
	// Render fps presets: the default 30 goes up to 50, uncapped is the top, 30 is the floor.
	expectEq(RenderFpsPreset::changeFpsValue(30, FpsValueChange_Increase), 50, "30 up");
	expectEq(RenderFpsPreset::changeFpsValue(60, FpsValueChange_Increase), 65, "60 up");
	expectEq(RenderFpsPreset::changeFpsValue(144, FpsValueChange_Decrease), 120, "144 down");
	expectEq(RenderFpsPreset::changeFpsValue(480, FpsValueChange_Increase), RenderFpsPreset::UncappedFpsValue, "480 up");
	expectEq(RenderFpsPreset::changeFpsValue(RenderFpsPreset::UncappedFpsValue, FpsValueChange_Increase), RenderFpsPreset::UncappedFpsValue, "uncapped up");
	expectEq(RenderFpsPreset::changeFpsValue(30, FpsValueChange_Decrease), 30, "30 down");
	// Values between presets snap to the neighbour preset.
	expectEq(RenderFpsPreset::changeFpsValue(45, FpsValueChange_Increase), 50, "45 up");
	expectEq(RenderFpsPreset::changeFpsValue(45, FpsValueChange_Decrease), 30, "45 down");

	// Logic time scale: steps of 5, never below the logic rate of 30.
	expectEq(LogicTimeScaleFpsPreset::changeFpsValue(30, FpsValueChange_Increase), 35, "logic 30 up");
	expectEq(LogicTimeScaleFpsPreset::changeFpsValue(35, FpsValueChange_Decrease), 30, "logic 35 down");
	expectEq(LogicTimeScaleFpsPreset::changeFpsValue(30, FpsValueChange_Decrease), 30, "logic 30 down");
	expectEq(LogicTimeScaleFpsPreset::changeFpsValue(32, FpsValueChange_Decrease), 30, "logic 32 down");

	// The limiter never returns before the frame time has passed (busy wait at the end).
	FrameRateLimit limit;
	limit.wait(RenderFpsPreset::UncappedFpsValue);
	for (int i = 0; i < 5; ++i)
	{
		const Real elapsed = limit.wait(100);
		if (elapsed < 0.01f)
		{
			printf("FAIL limiter: frame %d took %f s, expected at least 0.01 s\n", i, elapsed);
			++failures;
		}
	}

	if (failures == 0)
		printf("OK frameratelimit_test\n");
	return failures == 0 ? 0 : 1;
}
