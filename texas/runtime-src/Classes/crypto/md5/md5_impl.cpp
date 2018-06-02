#include "md5_impl.h"
#include "md51.h"

void Md5_Buffer(const void *buffer, int len, unsigned char digest[16])
{
    md5_state_t state;
    md5_init(&state);
    md5_append(&state, (unsigned char*)buffer, len);
    md5_finish(&state, static_cast<md5_byte_t*>(digest));
}

std::string Md5_Buffer(const void* buffer, int len)
{
    static const char HEX[16] =
    {
        '0', '1', '2', '3',
        '4', '5', '6', '7',
        '8', '9', 'a', 'b',
        'c', 'd', 'e', 'f',
    };

    unsigned char digest[16];
    Md5_Buffer(buffer, len, digest);

    std::string r;
    r.reserve(32);
    for(size_t i = 0; i < 16; i++)
    {
        unsigned char t = digest[i];
        unsigned char a = t / 16;
        unsigned char b = t % 16;
        r.push_back(HEX[a]);
        r.push_back(HEX[b]);
    }

    return r;
}

std::string Md5_String(const std::string& str)
{
    return Md5_Buffer(str.c_str(), (int)str.length());
}

std::string Md5_File(const char* full_path)
{
    std::string r;
	FILE *file = fopen(full_path, "rb");

    if (file)  {
        size_t size = 0;
        std::string data;
        int c = 0;
        fseek(file, 0, SEEK_END);
        size = ftell(file);
        fseek(file, 0, SEEK_SET);
        data.resize(size, 0);
        c = (int)fread((void *)data.c_str(), size, 1, file);
        fclose(file);

        if (c == 1)
            r = Md5_String(data);
    }

    return r;
}
