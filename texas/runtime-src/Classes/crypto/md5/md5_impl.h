
#include <string>


void Md5_Buffer(const void *buffer, int len, unsigned char digest[16]);

std::string Md5_Buffer(const void* buffer, int len);

std::string Md5_String(const std::string& str);

std::string Md5_File(const char* full_path);
