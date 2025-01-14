// Generated by Flexc++ V2.06.02 on Wed, 13 Nov 2019 10:25:59 +0300

#ifndef Scanner_H_INCLUDED_
#define Scanner_H_INCLUDED_

// $insert baseclass_h
#include "Scannerbase.h"
#include <map>
#include <functional>
#include <list>
#include "const.h"
#include "fstools.h"

// $insert classHead
class Scanner: public ScannerBase
{
    public:
        bool preprocessor = false;

        explicit Scanner(std::istream &in = std::cin,
                                std::ostream &out = std::cout);

        Scanner(std::string const &infile, std::string const &outfile);
        
        // $insert lexFunctionDecl
        int lex();
        typedef std::function<void(unsigned, const std::string&)> onNextLine_t;
        void setSval(Parser::STYPE__* d_val__, std::map<std::string, Const> *consts, onNextLine_t onNextLine);
        void setSourceForGetLine(const std::string& fileName, const std::string& getLineSource);
        void setFilename(std::string const &name) { ScannerBase::setFilename(name); }
        void include(const std::string& fileName);
        bool unclude();

    private:
        int lex__();
        int executeAction__(size_t ruleNr);

        void print();
        void preCode();     // re-implement this function for code that must 
                            // be exec'ed before the patternmatching starts

        void postCode(PostEnum__ type);    
                            // re-implement this function for code that must 
                            // be exec'ed after the rules's actions.

        std::string getLine(unsigned l);

        Parser::STYPE__* d_val = nullptr;
        std::map<std::string, Const>* consts = nullptr;
        onNextLine_t onNextLine;

        class GetLine
        {
        public:
            std::string getLineSource;
            unsigned getLineCacheLine = 1;
            std::string::size_type getLineCacheOff = 0;
        };

        std::list<GetLine> getLineStack;
};

// $insert scannerConstructors
inline Scanner::Scanner(std::istream &in, std::ostream &out)
:
    ScannerBase(in, out)
{}

inline Scanner::Scanner(std::string const &infile, std::string const &outfile)
:
    ScannerBase(infile, outfile)
{}

// $insert inlineLexFunction
inline int Scanner::lex()
{
    return lex__();
}

inline void Scanner::preCode() 
{
    // optionally replace by your own code
}

inline void Scanner::postCode(PostEnum__ type) 
{
    // optionally replace by your own code
}

inline void Scanner::print() 
{    
    print__();
}

inline void Scanner::setSval(Parser::STYPE__* d_val__,  std::map<std::string, Const>* _consts, onNextLine_t _onNextLine)
{
    onNextLine = _onNextLine;
    consts = _consts;
    d_val = d_val__;
}

inline void Scanner::include(const std::string& inputFile)
{
    // Input file
    std::string inputFileBody;
    if (!loadFile(inputFileBody, inputFile))
        throw "Can't open file " + inputFile;

    setSourceForGetLine(inputFile, inputFileBody);

    // Std
    pushStream(inputFile);
}

inline bool Scanner::unclude()
{
    if (getLineStack.empty()) return false;
    getLineStack.pop_back();
    return popStream();
}

inline void Scanner::setSourceForGetLine(const std::string& fileName, const std::string& _getLineSource)
{
    getLineStack.push_back(GetLine());
    GetLine& l = getLineStack.back();
    l.getLineSource = _getLineSource;
    l.getLineCacheLine = 1;
    l.getLineCacheOff = 0;
}

inline std::string Scanner::getLine(unsigned line)
{
    if (getLineStack.empty()) return "";

    GetLine& l = getLineStack.back();

    std::string::size_type pos = 0;
    unsigned currentLine = 1;
    if (line >= l.getLineCacheLine)
    {
        currentLine = l.getLineCacheLine;
        pos = l.getLineCacheOff;
    }
    for(; currentLine < line; currentLine++)
    {
        pos = l.getLineSource.find('\n', pos);
        if (pos == l.getLineSource.npos) return "";
        pos++;
    }
    l.getLineCacheLine = line;
    l.getLineCacheOff = pos;

    while (l.getLineSource.data()[pos] == ' ') pos++;
    std::string::size_type pos1 = l.getLineSource.find('\n', pos);

    return filename() + ":" + std::to_string(line) + " "
       + (pos1 == l.getLineSource.npos ? l.getLineSource.substr(pos) : l.getLineSource.substr(pos, pos1 - pos));
}

#endif // Scanner_H_INCLUDED_

