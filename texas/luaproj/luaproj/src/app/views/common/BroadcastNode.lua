
-- 滚动条
local BroadcastNode = class("BroadcastNode", cc.mvc.ViewBase)

BroadcastNode.SPEED = 100
BroadcastNode.MAX_MSG_COUNT = 100

function BroadcastNode:ctor(options)
	BroadcastNode.super.ctor(self)

	local imageBG = options.image or "cocostudio/home/image/dating_gonggaodi.png"
	self.width = options.width or 500
	self.height = options.height or 46

	self.BG = display.newSprite(imageBG)
		:addTo(self)
		:align(display.LEFT_BOTTOM, 0, -4)

	local stencilNode = cc.DrawNode:create()
	local points = {cc.p(0,0), cc.p(self.width, 0), cc.p(self.width, self.height), cc.p(0, self.height)};
	stencilNode:drawPolygon(points, 4, cc.c4b(255, 255, 255, 255), 1, cc.c4b(255, 255, 255, 255));
	self.container = cc.ClippingNode:create()
        :addTo(self)
        :move(cc.p(60, 0))
    self.container:setStencil(stencilNode)
    self.container:setCascadeOpacityEnabled(true)
    self:setCascadeOpacityEnabled(true)

    self.msgQueue = {}
    self.isPlaying = false 		-- 是否正在播放
    self.isShown = true 		-- 是否显示出来了
    self.remainCount = 0 		-- 已经创建需要显示的数量
    self.handlerBroadcast = scheduler.scheduleGlobal(handler(self, self.handleMessage), 0.1)
    self:setOpacity(0)
end

function BroadcastNode:onEnter()
	print("BroadcastNode:onEnter()")
	BroadcastNode.super.onEnter(self)

	
end

function BroadcastNode:onExit()
	BroadcastNode.super.onExit(self)
	scheduler.unscheduleGlobal(self.handlerBroadcast)
end

function BroadcastNode:handleMessage()
	if self.isPlaying then
		return
	end
	if #self.msgQueue == 0 then
		return
	end
	if not self.isShown then
		self:actionShow()
	end
	self.isPlaying = true

	local broadcast = table.remove(self.msgQueue, 1)
	printInfo("broadcast:%s", broadcast)
	self.remainCount = self.remainCount + 1
	printInfo("remainCount:%d", self.remainCount)

	local LANG =APP.GD.LANG
	local text = ""
	if broadcast.msg_type == 2 then
		text = "[" .. LANG.UI_BROADCAST_TYPE_SYSTEM .."]"
	elseif broadcast.msg_type == 4 then
		text = "[" .. LANG.UI_BROADCAST_TYPE_BROADCAST .."]"
	end

	local labelNode = display.newNode()
        :move(self.width, self.height / 2)
        :addTo(self.container)
    local label1 = ccui.Text:create(text, "Arial", 30)
    	:align(display.LEFT_CENTER, 0, 0)
        :addTo(labelNode)
    label1:setTextColor(cc.c4b(218, 165, 32, 255))
    local label2 = ccui.Text:create(broadcast.content, "Arial", 30)
    	:align(display.LEFT_CENTER, label1:getContentSize().width, 0)
        :addTo(labelNode)
    label2:setTextColor(cc.c4b(220, 220, 220, 255))

    local totalDistance = self.width + label1:getContentSize().width + label2:getContentSize().width
    local totalTime = totalDistance / BroadcastNode.SPEED
    local showTime = (label1:getContentSize().width + label2:getContentSize().width) / BroadcastNode.SPEED

    labelNode:runAction(cc.Spawn:create(
    	cc.Sequence:create(
    		cc.MoveBy:create(totalTime, cc.p(-totalDistance, 0)),
    		cc.DelayTime:create(0.1),
    		cc.CallFunc:create(function()
    			self.remainCount = self.remainCount - 1
                if self.remainCount == 0 then
                    self:actionHide()
                end
    		end),
    		cc.RemoveSelf:create()
    	),
    	cc.Sequence:create(
    		cc.DelayTime:create(showTime + 1),
    		cc.CallFunc:create(function()
    			self.isPlaying = false
    		end)
    	)
    ))
end

-- 加入一条广播，如果要多次播放，需要多次调用
-- msg格式{msg_type = xx, content = xx}
function BroadcastNode:pushMessage(msg)
	self:actionShow()
	if #self.msgQueue > BroadcastNode.MAX_MSG_COUNT then
		printInfo("[BroadcastNode] message too much !!!")
		return
	end
	table.insert(self.msgQueue, msg)
end

function BroadcastNode:actionShow()
	print("BroadcastNode:actionShow")
	self:stopAllActions()
	self:runAction(
		cc.EaseSineOut:create(
			cc.FadeIn:create(0.2)
		))
	self.isShown = true
end

function BroadcastNode:actionHide()
	print("BroadcastNode:actionHide")
	self:stopAllActions()
	self:runAction(
		cc.EaseSineOut:create(
			cc.FadeOut:create(0.2)
		))
	self.isShown = false
end

return BroadcastNode