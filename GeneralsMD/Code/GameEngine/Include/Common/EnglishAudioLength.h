// generals-netfix: English length of localized audio files, the same on every machine.
// Localized voice files differ in length per language (ttoxi001.wav: English 3.5 s, German 1.4 s),
// which made map scripts waiting for a sound run apart in mixed-language games (TSH issue #2320).
// Table: scripts/gen-audio-lengths.py. Plain C so scripts/tests/audiolength can test it standalone.

#pragma once

#include <string.h>

struct EnglishAudioLengthEntry { unsigned int hash; unsigned int ms; };

/// Length in ms of a localized file, or -1 if it is not in the table.
/// path: e.g. "Data\Audio\Speech\German\ttoxi001.wav", language: the registry language, e.g. "German".
inline int LookupEnglishAudioLengthMS( const char *path, const char *language )
{
	static const EnglishAudioLengthEntry table[] = {
#include "AudioLengthTable.inl"
	};

	// Key: lower-case path without the language folder, e.g. data\audio\speech\ttoxi001.wav
	char key[260];
	char folder[64];
	size_t n = 0;
	for (; path[n] && n < sizeof(key) - 1; ++n)
		key[n] = (path[n] >= 'A' && path[n] <= 'Z') ? (char)(path[n] - 'A' + 'a') : path[n];
	key[n] = 0;
	size_t f = 0;
	folder[f++] = '\\';
	for (; *language && f < sizeof(folder) - 2; ++language)
		folder[f++] = (*language >= 'A' && *language <= 'Z') ? (char)(*language - 'A' + 'a') : *language;
	folder[f++] = '\\';
	folder[f] = 0;
	char *found = strstr(key, folder);
	if (found)
		memmove(found, found + f - 1, strlen(found + f - 1) + 1);

	unsigned int hash = 0x811C9DC5u;
	for (const char *s = key; *s; ++s)
		hash = (hash ^ (unsigned char)*s) * 0x01000193u;

	int lo = 0;
	int hi = (int)(sizeof(table) / sizeof(table[0])) - 1;
	while (lo <= hi) {
		const int mid = (lo + hi) / 2;
		if (table[mid].hash == hash)
			return (int)table[mid].ms;
		if (table[mid].hash < hash)
			lo = mid + 1;
		else
			hi = mid - 1;
	}
	return -1;
}
