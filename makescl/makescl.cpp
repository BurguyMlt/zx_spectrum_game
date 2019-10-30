#include "scl_file_format.h"
#include <stdio.h> // printf
#include <stdint.h>
#include <vector>
#include <sys/stat.h> // fstat
#include <unistd.h> // unlink

typedef std::vector<uint8_t> byte_buffer_t;

void* byte_buffer_push_back(byte_buffer_t& data, void* begin, unsigned size)
{
    size_t p = data.size();
    data.resize(p + size);
    void* d = data.data() + p;
    if (begin) memcpy(d, begin, size);
          else memset(d, 0, size);
    return d;
}

bool load_file(byte_buffer_t& output, unsigned& readed_size, const char* file_name, unsigned max_file_size)
{
    FILE* o = fopen(file_name, "r");
    if (!o) 
    {
        printf("Can't open file %s\n", file_name);
        return false;
    }

    struct stat buff;
    if (fstat (fileno (o), &buff))
    {
        printf("Can't check file size %s\n", file_name);
        return false;
    }

    if (buff.st_size > max_file_size)
    {
        printf("Too big file %s current size %llu max size %llu\n", file_name, (long long unsigned)buff.st_size, (long long unsigned)max_file_size);
        fclose(o);
        return false;
    }

    void* d = byte_buffer_push_back(output, NULL, buff.st_size);

    if (buff.st_size)
    {
        if (fread(d, 1, buff.st_size, o) != buff.st_size)
        {
            fclose(o);
            return false;
        }
    }

    fclose(o);
    readed_size = buff.st_size;
    return true;
}

bool save_file(const char* file_name, const void* data, size_t size)
{
    FILE* o = fopen(file_name, "w");
    if (!o) 
    {
        printf("Can't create file %s\n", file_name);
        return false;
    }
    if (size)
    {
        if (fwrite(data, 1, size, o) != size)
        {
            fclose(o);
            unlink(file_name);
            return false;
        }
    }
    fclose(o);
    return true;
}

bool make_scl(const char* dest_file_name, unsigned src_file_names_count, const char** src_file_names)
{
    byte_buffer_t dest_file;

    // Выделяем память под заголовок файла
    size_t scl_header_size = scl_file_t::calc_header_size(src_file_names_count);
    if (scl_header_size == 0)
    {
        printf("Too many files\n"); 
        return false;
    }
    byte_buffer_push_back(dest_file, NULL, scl_header_size);

    // Инициализируем заголовок
    ((scl_file_t*)dest_file.data())->init(src_file_names_count);

    for (unsigned i = 0; i < src_file_names_count; i++)
    {
        const char* src_file_name = src_file_names[i];

        // Загружаем файл
        unsigned src_file_size;
        if (!load_file(dest_file, src_file_size, src_file_name, scl_file_t::const_max_file_size)) return false;

        // Вывод информации
        printf("Loaded file %s size %u bytes\n", src_file_name, src_file_size);

        // Добиваем последний сектор нулями
        byte_buffer_push_back(dest_file, NULL, scl_file_t::calc_file_padding(src_file_size));

        // Запись заголовка
        if (!((scl_file_t*)dest_file.data())->items[i].init(src_file_name, src_file_size, src_file_size))
        {
            printf("Incorrect file %s\n", src_file_name);
        }
    }

    // Расчет контрольной суммы
    uint32_t check_sum = scl_file_t::calc_check_sum(dest_file.data(), dest_file.size());
    byte_buffer_push_back(dest_file, &check_sum, sizeof(check_sum));

    // Сохранение файла
    if (!save_file(dest_file_name, dest_file.data(), dest_file.size())) return false;

    // Вывод информации
    printf("Saved file %s size %llu bytes\n", dest_file_name, (long long unsigned)dest_file.size());
    return true;
}

int main(int argc, char** argv)
{
    printf("Make SCL file (c) 30-10-2019 Alemorf\n");

    if (argc < 2)
    {
        printf("Syntax: %s output_file input_files\n", argv[0]);
        return 1;
    }

    if (!make_scl(argv[1], (unsigned)argc - 2, (const char**)argv + 2))
        return 2;

    return 0;
}
