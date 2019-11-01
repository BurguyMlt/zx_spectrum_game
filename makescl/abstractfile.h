#pragma once

#include <stdint.h>
#include <vector>

class AbstractFileWriter
{
public:
    virtual bool pushBack(const char* name, char ext, uint16_t start, const void* data, size_t data_size) = 0;
    virtual void serialize(std::vector<uint8_t>& output) = 0;
    virtual ~AbstractFileWriter() {};
};
