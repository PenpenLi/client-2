
local _G = _G

module("comm.kk.crypt")

--ca1加密
function ca1Encode(content)
    return _G.encode_ca1(content)
end

function ca1Decode(content)
    return _G.decode_ca1(content)
end

