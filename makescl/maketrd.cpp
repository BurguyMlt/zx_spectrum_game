#include "fstools.h"
#include "sclfile.h"
#include "trdfile.h"
#include <iostream>
#include <stdint.h>
#include <vector>
#include <limits>
#include <string.h>
#include <stdlib.h> // strtoul
#include <memory>

template<class A, class B>
void set(std::unique_ptr<A>& o, B* n)
{
    std::unique_ptr<A> tmp(n);
    o.swap(tmp);
}

const char* getFileExtension(const char* str)
{
    char* ext = strrchr((char*)str, '.');
    if (!ext) return "";
    if (strchr(ext, '/')) return "";
    return ext + 1;
}

class TrdosFileInfo
{
public:
    char name[9];
    char ext;
    uint16_t start;
};

bool parseTrdosFileInfo(TrdosFileInfo& out, const char* srcFullName, uint16_t defaultStart)
{
    const char* srcName = strrchr(srcFullName, '/');
    if (srcName) srcName++; else srcName = srcFullName;

    char name[strlen(srcName) + 1];
    strcpy(name, srcName);

    char* extPtr = strrchr(name, '.');
    if (!extPtr || extPtr[1] == '\0') return false;
    extPtr[0] = '\0';
    out.ext = extPtr[1];

    if (out.ext == 'B')
    {
        out.start = defaultStart;
    }
    else
    {
        char* startPtr = strrchr(name, '.');
        if (!startPtr) return false;
        *startPtr++ = '\0';
        char* startOk;
        unsigned long r = strtoul(startPtr, &startOk, 16);
        if (r > std::numeric_limits<typeof(out.start)>::max() || startOk[0] != '\0') return false;
        out.start = (typeof(out.start))r;
    }

    if (strlen(name) > sizeof(out.name) - 1) return false;
    strncpy(out.name, name, sizeof(out.name));
    return true;
}

bool makeSclFile(const char* destFileName, unsigned srcFileNamesCount, const char** srcFileNames)
{    
    std::unique_ptr<AbstractFileWriter> fileWriter;

    const char* outputFileExt = getFileExtension(destFileName);
    if (0 == strcasecmp(outputFileExt, "trd"))
    {
        set(fileWriter, new TrdFileWriter);
    }
    else if (0 == strcasecmp(outputFileExt, "scl"))
    {
        set(fileWriter, new SclFileWriter);
    }
    else
    {
        std::cout << "Unsupported file extension " << destFileName << std::endl;
        return false;
    }

    std::vector<uint8_t> file;

    std::cout << "Make file " << destFileName << std::endl;

    for (unsigned i = 0; i < srcFileNamesCount; i++)
    {
        const char* srcFileName = srcFileNames[i];

        // Загружаем файл
        if (!loadFile(file, srcFileName, SclFileStruct::maxFileSize)) return false;

        // Разбор имени
        TrdosFileInfo info;
        if (!parseTrdosFileInfo(info, srcFileName, (uint16_t)file.size()))
        {
            std::cerr << "Incorrenct file name " << srcFileName << std::endl;
            return false;
        }

        // Запись файла
        if (!fileWriter->pushBack(info.name, info.ext, info.start, file.data(), file.size()))
        {
            std::cerr << "Can't put file " << srcFileName << std::endl;
            return false;
        }

        // Вывод информации
        std::cout << "+ " << info.name << "." << info.ext << " start " << info.start << " size " << file.size() << " bytes" << std::endl;
    }

    // Сохранение SCL-файла
    fileWriter->serialize(file);
    if (!saveFile(destFileName, file.data(), file.size())) return false;

    // Вывод информации
    std::cout << "Total size " << file.size() << " bytes" << std::endl;
    return true;
}

int main(int argc, char** argv)
{
    if (argc < 2)
    {
        std::cerr << "Make TRD/SCL file (c) 30-10-2019 Alemorf" << std::endl
                  << "Syntax: " << argv[0] << " output_file input_files" << std::endl
                  << "Correct output file name: *.trd or *.scl" << std::endl
                  << "Correct input file name: (0-7 chars).B" << std::endl
                  << "Correct input file name: (0-7 chars).(load address in hex).(1 char)" << std::endl;
        return 1;
    }

    if (!makeSclFile(argv[1], (unsigned)argc - 2, (const char**)argv + 2))
        return 2;

    return 0;
}
