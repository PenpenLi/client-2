
local _G = _G
local ccui = ccui
local cc = cc

module("comm.kk.edit")

--任意输入编辑框
function createAny(size, holder_text, fontSize, multiLine)
    return createImpl(size, holder_text, multiLine and 0 or 6, 5, fontSize)
end
function createAnyWithParent(parent, name, holder_text, fontSize, multiLine)
    local r = createAny(parent:getContentSize(), holder_text, fontSize, multiLine)
    r:setName(name)
    parent:addChild(r)
    return r
end

--密码编辑框
function createPassword(size, holder_text, fontSize)
    return createImpl(size, holder_text, 6, 0, fontSize)
end
function createPasswordWithParent(parent, name, holder_text, fontSize)
    local r = createPassword(parent:getContentSize(), holder_text, fontSize)
    r:setName(name)
    parent:addChild(r)
    return r
end

--数字编辑框
function createNumber(size, holder_text, fontSize)
    return createImpl(size, holder_text, 2, 5, fontSize)
end
function createNumberWithParent(parent, name, holder_text, fontSize)
    local r = createNumber(parent:getContentSize(), holder_text, fontSize)
    r:setName(name)
    parent:addChild(r)
    return r
end

--实现
function createImpl(size, holder_text, mode, flag)
    local edit = ccui.EditBox:create(size, "")
    edit:setAnchorPoint(cc.p(0,0))
    edit:setReturnType(0)
    edit:setInputMode(mode)
    edit:setInputFlag(flag)
    --edit:setFontName("font/system.ttf")
    edit:setFontSize(fontSize or 20)
    edit:setPlaceholderFontSize(fontSize or 20)
    edit:setPlaceholderFontColor(cc.c4b(255, 255, 255, 128))
    edit:setPlaceHolder(holder_text or "")
    edit:setTouchEnabled(true)
    return edit
end