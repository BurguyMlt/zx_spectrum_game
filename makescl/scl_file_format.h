// Каждая дорожка содержит 32 сектора (на двух сторонах) размером 256 байт.
// Ёмкость каталога — 128 имён файлов. 
// Имена файлов состоят из 9 символов.
// Система чувствительна к регистру букв в именах символов и позволяет использовать в них пробелы и токены Бейсика.
// Максимум 128 файлов.
// Один файл может иметь длину не более 255 секторов.

#pragma once

#include <stdint.h>
#include <limits.h>
#include <string.h>
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

#pragma pack(push, 1)

struct scl_file_item_t
{
    char     name[8];
    char     ext;
    uint16_t start;
    uint16_t size;
    uint8_t  sectors;

    bool init(const char* _name, unsigned _start, unsigned _size, unsigned _sectors = UINT_MAX);
};

typedef struct scl_file_item_t scl_file_item_t;

static_assert(sizeof(scl_file_item_t) == 14, "scl_file_item_t != 14");

struct scl_file_id_t
{
    uint8_t bytes[8];
};

typedef struct scl_file_id_t scl_file_id_t;

static_assert(sizeof(scl_file_id_t) == 8, "scl_file_id_t != 8");

struct scl_file_t
{
    scl_file_id_t   id;
    unsigned char   items_count;
    scl_file_item_t items[0];

    void init(uint8_t src_file_names_count);

    static const scl_file_id_t const_id;
    static const unsigned const_sector_size;
    static const unsigned const_max_items;
    static const unsigned const_max_file_size;
    static const unsigned const_max_file_sectors;

    static size_t calc_header_size(unsigned items_count);
    static uint32_t calc_check_sum(const uint8_t* data, size_t data_size);
    static unsigned bytes_to_sectors(unsigned bytes);
    static unsigned calc_file_padding(unsigned bytes);
};

static_assert(sizeof(scl_file_t) == 9, "scl_file_t != 9");


typedef struct scl_file_t scl_file_t;

const scl_file_id_t scl_file_t::const_id = { 'S', 'I', 'N', 'C', 'L', 'A', 'I', 'R' };
const unsigned      scl_file_t::const_sector_size = 256;
const unsigned      scl_file_t::const_max_items = 128;
const unsigned      scl_file_t::const_max_file_sectors = 255;
const unsigned      scl_file_t::const_max_file_size = scl_file_t::const_max_file_sectors * scl_file_t::const_sector_size;

#pragma pack(pop)

inline size_t scl_file_t::calc_header_size(unsigned items_count) 
{
    if (items_count > const_max_items) return 0;
    return sizeof(scl_file_t) + sizeof(scl_file_item_t) * items_count;
}

inline void scl_file_t::init(uint8_t src_file_names_count)
{
    id = const_id;
    items_count = (uint8_t)src_file_names_count;
}

inline unsigned scl_file_t::bytes_to_sectors(unsigned bytes)
{
    return (bytes + const_sector_size - 1) / const_sector_size;
}

inline unsigned scl_file_t::calc_file_padding(unsigned bytes)
{
    unsigned p = bytes % const_sector_size;
    if (p == 0) return 0;
    return p == 0 ? 0 : const_sector_size - p;
}

inline bool scl_file_item_t::init(const char* _name, unsigned _start, unsigned _size, unsigned _sectors)
{
    if (_start > UINT16_MAX) return false;
    if (_size > scl_file_t::const_max_file_size) return false;
    if (_sectors == UINT_MAX) _sectors = scl_file_t::bytes_to_sectors(_size);
    if (_sectors > scl_file_t::const_max_file_sectors) return false;

    char _tmp[strlen(_name) + 1];
    strcpy(_tmp, _name);

    char* _ext = strrchr(_tmp, '.');
    if (_ext) *_ext++ = 0;

    if (_ext && _ext[0] == 'C')
    {
        char* _addr = strrchr(_tmp, '.');
        if (_addr)
        {
            *_addr++ = 0;
            _start = strtoul(_addr, NULL, 16);
        }
    }

    snprintf(name, sizeof(name) + 1, "%s        ", _tmp);
    ext = _ext && _ext[0] ? _ext[0] : 'C';
    start = _start;
    size = _size;
    sectors = _sectors;
    return true;
}

inline uint32_t scl_file_t::calc_check_sum(const uint8_t* data, size_t data_size)
{
    uint32_t check_sum = 0;
    for(const uint8_t* i = data, *ie = i + data_size; i != ie; i++)
        check_sum += *i;
    return check_sum;
}

