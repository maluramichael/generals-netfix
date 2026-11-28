// Regression test for LookupEnglishAudioLengthMS (generals-netfix, TSH issue #2320).
#include <stdio.h>
#include "Common/EnglishAudioLength.h"

static int failures = 0;
static void check(const char *path, const char *language, int expected)
{
	const int got = LookupEnglishAudioLengthMS(path, language);
	if (got != expected) {
		printf("FAIL %s (%s): expected %d, got %d\n", path, language, expected, got);
		++failures;
	}
}

int main()
{
	// German and English paths of the same file give the English length.
	check("Data\\Audio\\Speech\\German\\ttoxi001.wav", "German", 3469);
	check("Data\\Audio\\Speech\\English\\ttoxi001.wav", "English", 3469);
	check("DATA\\AUDIO\\SPEECH\\GERMAN2\\TTOXI001.WAV", "German2", 3469);
	// Path without language folder is found too.
	check("Data\\Audio\\Speech\\ttoxi001.wav", "German", 3469);
	// Unknown file is not in the table.
	check("Data\\Audio\\Sounds\\German\\nosuchfile.wav", "German", -1);
	check("", "German", -1);
	printf(failures ? "%d failure(s)\n" : "ok\n", failures);
	return failures ? 1 : 0;
}
