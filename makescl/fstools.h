#pragma once

#include <stdint.h>
#include <stddef.h>
#include <vector>

bool loadFile(std::vector<uint8_t>& output, const char* fileName, unsigned maxFileSize);
bool saveFile(const char* file_name, const void* data, size_t size);
