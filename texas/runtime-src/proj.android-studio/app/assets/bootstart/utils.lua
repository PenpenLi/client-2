
local socket = require("socket")
local utils = {}

local print = print
local tconcat = table.concat
local tinsert = table.insert
local srep = string.rep
local type = type
local pairs = pairs
local tostring = tostring
local next = next
 
function utils.getRandomSeed()
    local time = socket.gettime()
    local delta = time - math.floor(time)
    return delta * 1000000
end

function utils.removeByKey(tab, to_remove)
	local ret = {}

	for k, v in pairs(tab) do
		if not to_remove[key] then
			ret[k] = v;
		end
	end
	return ret;
end

function utils.random(from, to)
    return math.random() * (to - from) + from
end

function utils.timeLastSeconds(targetTime)
    local time = socket.gettime()
    local hour = tonumber(os.date("%H", time))
    local min = tonumber(os.date("%M", time))
    local sc = tonumber(os.date("%S", time))

    local strs = string.split(targetTime, ':')
    local thour = tonumber(strs[1])
    local tmin = tonumber(strs[2])


    if hour > thour or (hour == thour and min > tmin) then
        return 0;
    end

    return (thour - hour) * 3600 + (tmin - min) * 60 - sc
end

function utils.random_x3(from, to)
    local x = utils.random(-1, 1)
    local x3 = x * x * x
    local delta = (to - from) / 2
    local center = (from + to) / 2
    return center + x3 * delta
end

function utils.random_x2(from, to)
    local x = utils.random(-1, 1)
    local x2
    if x >= 0 then
        x2 = x * x 
    else
        x2 = - (x * x)
    end
    local delta = (to - from) / 2
    local center = (from + to) / 2
    return center + x2 * delta
end

function utils.print_r(root)
    local cache = {  [root] = "." }
    local function _dump(t,space,name)
        local temp = {}
        for k,v in pairs(t) do
            local key = tostring(k)
            if cache[v] then
                tinsert(temp,"+" .. key .. " {" .. cache[v].."}")
            elseif type(v) == "table" then
                local new_key = name .. "." .. key
                cache[v] = new_key
                tinsert(temp,"+" .. key .. _dump(v,space .. (next(t,k) and "|" or " " ).. srep(" ",#key),new_key))
            else
                tinsert(temp,"+" .. key .. " [" .. tostring(v).."]")
            end
        end
        return tconcat(temp,"\n"..space)
    end
    print(_dump(root, "",""))
end

function utils.ssq()
    local result = {}
    local red = {}
    local blue = {}
    for i = 1,33 do
        table.insert(red, i)
    end
    for i = 1, 16 do
        table.insert(blue, i)
    end
    math.randomseed(socket.gettime())
    for i = 1, 6 do
        local ball = red[math.random(1, #red)]
        utils.removeItem(red, ball)
        table.insert(result, ball)
    end
    table.insert(result, blue[math.random(1, #blue)])
end

function utils.angleClockWise(ccp1, ccp2)
    local angle = math.deg(cc.pGetAngle(ccp2, ccp1))
    local cross = cc.pCross(ccp2, ccp1)
    if cross < 0 then angle = 360 - angle end
    return angle
end

function utils.rectCircleIntersect(rectCenter, rectH, circleCenter, circleRadius)
    local v = cc.p(math.abs(circleCenter.x - rectCenter.x), math.abs(circleCenter.y - rectCenter.y))
    local u = cc.p(math.max(v.x - rectH.x, 0), math.max(v.y - rectH.y, 0))
    return cc.pDot(u, u) <= circleRadius * circleRadius
end

function utils.removeItem(list, item, removeAll)
    local rmCount = 0
    for i = 1, #list do
        if list[i - rmCount] == item then
            table.remove(list, i - rmCount)
            if removeAll then
                rmCount = rmCount + 1
            else
                rmCount = 1
                break
            end
        end
    end
    return rmCount
end

function utils.threeParamCalc(cond, a, b)
    return (cond and {a} or {b})[1]
end

function utils.stringTrim(str)
   return str:match( "^%s*(.-)%s*$" )
end

function utils.stringSplit(str, delimiter)
    if str == nil or str == '' or delimiter == nil then
        return {}
    end
    
    local result = {}
    for match in (str..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result

    -- local sub_str_tab = {}
    -- local i = 0
    -- local j = 0
    -- while true do
    --     j = string.find(str, split_char, i + 1)    --从目标串str第i+1个字符开始搜索指定串
    --     if j == nil then
    --         table.insert(sub_str_tab,str)
    --         break
    --     end
    --     table.insert(sub_str_tab, string.sub(str, i+1, j-1))
    --     i = j
    -- end
    -- return sub_str_tab
end

function utils.shuffleTable(t)
    math.randomseed(socket.gettime())
    local rand = math.random 
    local iterations = #t
    local j
    for i = iterations, 2, -1 do
        j = rand(i)
        t[i], t[j] = t[j], t[i]
    end
end

function utils.timeStr(timestamp, fmt)
    local time = timestamp or socket.gettime()
	if fmt then
		return os.date(fmt, time)
	else
		return os.date("%Y-%m-%d %H:%M:%S", time)
	end
end

function utils.timeStrHMS(seconds)
    local hour = math.floor(seconds / 60 / 60) % 24
    local min = math.floor(seconds / 60) % 60
    local sec = seconds % 60

	local fmt = "%02d";
	if min > 0 then fmt = fmt..":%02d" end;
	if sec > 0 then fmt = fmt..":%02d" end;
	return string.format(fmt, hour, min, sec)
end

function utils.timeStr2(seconds)
    local hour = math.floor((seconds + 0.1) / 3600);
    local min = math.floor((seconds + 0.1 - hour * 3600) / 60)
    local sec = seconds 
	
	if hour > 0 then
		return string.format("%d小时", hour);
	end

	if min > 0 then
		return string.format("%d分钟", min);
	end
	return string.format("%d秒", sec);
end

function utils.timeStrDate(timestamp)
    local time = timestamp or os.time()
    local year = tonumber(os.date("%Y", time))
    local month = tonumber(os.date("%m", time))
    local day = tonumber(os.date("%d", time))
    return string.format("%04d:%02d:%02d", year, month, day)
end

function utils.getCombines(source, targetCount)
    local output = {}
    utils._getCombines(source, targetCount, {}, 1, targetCount, output)
    return output
end

function utils._getCombines(source, targetCount, combineTemp, start, count, output)
    local totalCount = #source
    for i = start, totalCount + 1 - count do
        combineTemp[count] = i
        if count == 1 then
            local combine = {}
            for j = targetCount, 0, -1 do
                table.insert(combine, source[combineTemp[j]])
            end
            table.insert(output, combine)
        else
            utils._getCombines(source, targetCount, combineTemp, i + 1, count - 1, output)
        end
    end
end

-- 以万或亿为单位返回
function utils.convertNumberShort(number)
    if math.abs(number) < 10000 then
        return tostring(number)
    elseif math.abs(number) < 100000000 then
        local str = tostring(number / 10000)
        local dot = string.find(str, '%.') 
        if dot then
            return string.format("%s万", string.sub(str, 1, dot + 1))
        else
            return str .. "万"
        end
    else
        local str = tostring(number / 100000000)
        local dot = string.find(str, '%.') 
        if dot then
            return string.format("%s亿", string.sub(str, 1, dot + 1))
        else
            return str .. "亿"
        end
    end
end

-- 显示数字单位，万、亿
-- node单位图片，numberNode数字节点，unit单位，wan万图片，yi亿图片
function utils.setUnit(node,numberNode, unit, wan, yi)
    if unit == 1 then
        node:loadTexture(wan)
        node:setPositionX(numberNode:getContentSize().width + node:getContentSize().width / 2)
        node:setVisible(true)
    elseif unit == 2 then
        node:loadTexture(yi)
        node:setPositionX(numberNode:getContentSize().width + node:getContentSize().width / 2)
        node:setVisible(true)
    else
        node:setVisible(false)
    end
end

function utils.toChineseCapital(num)
    local cnum = {"零", "一", "二", "三", "四", "五", "六", "七", "八", "九"}
    local cunit = {"十", "百", "千", "万", "十", "百", "千", "亿"}

    num = math.floor(num)
    local result = ""
    local zero = true
    local count = 0
    local whole = ""
    while num > 0 do
        local n = num % 10 + 1
        if n == 1 then
            if count > 0 and count % 4 == 0 then
                if count % 8 == 0 then
                    whole = cunit[8]
                else
                    whole = cunit[4]
                end
            end

            if not zero and count % 4 ~= 0 then
                result = cnum[n] .. result
            end
            zero = true
        else
            local c = count % 8
            if count > 0 and c == 0 then
                c = 8
            end
            local unit = cunit[c] or ""
            local _cm = cnum[n]
            --去掉'一十'的'一'
            if unit == cunit[1] and _cm == cnum[2] then
                _cm = ""
            end
            result = string.format("%s%s%s%s", _cm, unit, whole, result)
            zero = false
            whole = ""
        end
        count = count + 1
        num = math.floor(num / 10)
    end
    return result
end

function utils.convertNumberShortKM(number)
    if math.abs(number) < 1000 then
        return tostring(number)
    elseif math.abs(number) < 1000000 then
		return string.format("%.1fKB", number / 1000);
    else
        return string.format("%.1fMB", number / 1000000);
    end
end

-- 判断utf8字符byte长度
-- 0xxxxxxx - 1 byte
-- 110yxxxx - 192, 2 byte
-- 1110yyyy - 225, 3 byte
-- 11110zzz - 240, 4 byte
local function chsize(char)
    if not char then
        print("not char")
        return 0
    elseif char > 240 then
        return 4
    elseif char > 225 then
        return 3
    elseif char > 192 then
        return 2
    else
        return 1
    end
end

function utils.trimUtf8String(str, numberOfChars)
	if utils.utf8len(str) > numberOfChars + 1 then
		return utils.utf8sub(str, 1, numberOfChars) ..".";
	else 
		return str;
	end
end

-- 计算utf8字符串字符数, 各种字符都按一个字符计算
-- 例如utf8len("1你好") => 3
function utils.utf8len(str)
    local len = 0
    local currentIndex = 1
    while currentIndex <= #str do
        local char = string.byte(str, currentIndex)
        currentIndex = currentIndex + chsize(char)
        len = len + 1
    end
    return len
end

-- 截取utf8 字符串
-- str:         要截取的字符串
-- startChar:   开始字符下标,从1开始
-- numChars:    要截取的字符长度
function utils.utf8sub(str, startChar, numChars)
    local startIndex = 1
    while startChar > 1 do
        local char = string.byte(str, startIndex)
        startIndex = startIndex + chsize(char)
        startChar = startChar - 1
    end

    local currentIndex = startIndex

    while numChars > 0 and currentIndex <= #str do
        local char = string.byte(str, currentIndex)
        currentIndex = currentIndex + chsize(char)
        numChars = numChars -1
    end
    return str:sub(startIndex, currentIndex - 1)
end

-- 这里把汉字当两个英文字符长度
function utils.strUIlen(str)
    local len = 0
    for uchar in string.gmatch(str, "([%z\1-\127\194-\244][\128-\191]*)") do
        -- printInfo("ddd:%s--%s", uchar, #uchar)
        local char_len = #uchar
        if char_len > 2 then
            char_len = 2
        end
        len = len + char_len
    end
    return len
end

-- 
function utils.checkStr(str, max)
    local len = 0
    local ret = {}
    for uchar in string.gmatch(str, "([%z\1-\127\194-\244][\128-\191]*)") do
        if len > max then
            table.insert(ret, '\n')
            len = 0
        end
        local char_len = #uchar
        if char_len > 2 then
            char_len = 2
        end
        len = len + char_len
        table.insert(ret, uchar)
    end
    return table.concat(ret)
end

function utils.date(timestamp)
    local time = timestamp or os.time()
    local year = tonumber(os.date("%Y", time))
    local month = tonumber(os.date("%m", time))
    local day = tonumber(os.date("%d", time))
    return year, month, day
end

return utils