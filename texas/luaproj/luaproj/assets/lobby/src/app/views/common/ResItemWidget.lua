--region *.lua
--Date
--Author WuShaoming
--此文件由[BabeLua]插件自动生成
--endregion

local ResItemWidget = class("ResItemWidget",cc.Node)

function ResItemWidget:ctor(reserveSize,bAdapt)
        self.bAdapt = bAdapt == nil and true or bAdapt
        self.reserveSize = reserveSize or 45
        local csbnode = cc.CSLoader:createNode("cocostudio/game/ResItemNode.csb")
        self:addChild(csbnode)
        self.Image_ResBG = csbnode:getChildByName("Image_ResBG")
        self.Image_ResIcon = self.Image_ResBG:getChildByName("Image_ResIcon")
        self.Atlas_ResFont = self.Image_ResBG:getChildByName("Atlas_ResFont")
end

function ResItemWidget:setString(str)
    self.Atlas_ResFont:setString(str)
    if self.bAdapt then 
        local bgSize = self.Image_ResBG:getContentSize()
        local size = self.Atlas_ResFont:getContentSize()
        local scaleX = self.Atlas_ResFont:getScaleX()
        bgSize.width = size.width * scaleX + self.reserveSize
        self.Image_ResBG:setContentSize(bgSize)
    else
        local bgSize = self.Image_ResBG:getContentSize()
        local iconSize = self.Image_ResIcon:getContentSize()
        self.Atlas_ResFont:setAnchorPoint(cc.p(0.5,0.5))
        --self.Atlas_ResFont:setPositionPercent(cc.p(0.5,0.5))
        local offX = (bgSize.width - iconSize.width) * 0.5  + iconSize.width
        self.Atlas_ResFont:setPosition(offX,bgSize.height * 0.5)
    end
end

function ResItemWidget:setBgTexture(path,textureType)
    self.Image_ResBG:loadTexture(path,textrureType or ccui.TextureResType.localType)
end

function ResItemWidget:setBgHeight(height)
    local size = self.Image_ResBG:getContentSize()
    size.height = height
    self.Image_ResBG:setContentSize(size)
end

function ResItemWidget:setBgSize(size)
    self.Image_ResBG:setContentSize(size)
end

function ResItemWidget:getBgSize()
    return self.Image_ResBG:getContentSize()
end

function ResItemWidget:setBgAnchor(anchor)
    self.Image_ResBG:setAnchorPoint(anchor)
end

function ResItemWidget:getBg()
    return self.Image_ResBG
end
-----------------------------------------------------------
function ResItemWidget:setResTexture(path,textureType)
    self.Image_ResIcon:loadTexture(path,textrureType or ccui.TextureResType.localType)
end

function ResItemWidget:setResIconSize(size)
    self.Image_ResIcon:setContentSize(size)
end

function ResItemWidget:getResIcon()
    return self.Image_ResIcon
end
-----------------------------------------------------
function ResItemWidget:getFont()
    return self.Atlas_ResFont
end



return ResItemWidget