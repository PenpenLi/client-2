#include "cl_prerequisites.h"
#include "cl_core.h"

namespace CL
{
    const static unsigned char b64encode_table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    const static unsigned char b64decode_table[] =
    {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0,	0, 0, 0, 0, 0, 0, 0, 0, 
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,62, 0, 0, 0,63,
        52,53,54,55,56,57,58,59,60,61, 0, 0, 0, 0, 0, 0,
        0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,
        15,16,17,18,19,20,21,22,23,24,25, 0, 0, 0, 0, 0,
        0,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,
        41,42,43,44,45,46,47,48,49,50,51
    };
}

std::string CL::Base64_Encode(const char *data, int len)
{
    std::string strEncoded;
    unsigned char cTmp[3]={0};
    int iDiv3Num = len/3;
    int iMod3Num = len % 3;

    int line_len=0;
    for(int i=0;i<iDiv3Num;i++)
    {
        cTmp[0] = *data++;
        cTmp[1] = *data++;
        cTmp[2] = *data++;

        strEncoded+= b64encode_table[cTmp[0] >> 2];
        strEncoded+= b64encode_table[((cTmp[0] << 4) | (cTmp[1] >> 4)) & 0x3F];
        strEncoded+= b64encode_table[((cTmp[1] << 2) | (cTmp[2] >> 6)) & 0x3F];
        strEncoded+= b64encode_table[cTmp[2] & 0x3F];		

        line_len += 4;
        if (line_len == 76)
        {
            //strEncoded+= "\r\n";
            line_len=0;
        }
    }

    if(iMod3Num==1)
    {
        cTmp[0] = *data++;
        strEncoded+= b64encode_table[(cTmp[0] & 0xFC) >> 2];
        strEncoded+= b64encode_table[((cTmp[0] & 0x03) << 4)];
        strEncoded+= "==";
    }
    else if(iMod3Num==2)
    {
        cTmp[0] = *data++;
        cTmp[1] = *data++;
        strEncoded+= b64encode_table[(cTmp[0] & 0xFC) >> 2];
        strEncoded+= b64encode_table[((cTmp[0] & 0x03) << 4) | ((cTmp[1] & 0xF0) >> 4)];
        strEncoded+= b64encode_table[((cTmp[1] & 0x0F) << 2)];
        strEncoded+= "=";
    }

    return strEncoded;
}

std::string CL::Base64_Decode(const char *data, int len)
{
    std::string strDecoded;

    int nValue;
    int i= 0;

    while (i < len)
    {
        if (*data == '\r' || *data == '\n')
        {
            data++;
            i++;
            continue;
        }

        nValue = (int)(b64decode_table[*data++] << 18);
        nValue += (int)(b64decode_table[*data++] << 12);
        strDecoded+=(nValue & 0x00FF0000) >> 16;

        if (*data != '=')
        {
            nValue += (int)(b64decode_table[*data++] << 6);
            strDecoded+=(nValue & 0x0000FF00) >> 8;

            if (*data != '=')
            {
                nValue += (int)(b64decode_table[*data++]);
                strDecoded+=nValue & 0x000000FF;
            }
        }
        i += 4;
    }
    return strDecoded;
}
