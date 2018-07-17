
local ctrl = createView("", "fruit/UICommon/Loading.csb", nil)

--desc:创建并显示界面
--@text     加载界面要显示的文本内容
function ctrl:show(text)
    self.Text = text
    self:setZOrder(100)
    return self:create()
end

--desc:初始化回调事件
function ctrl:onInit(node)
    self.space = 500
    self.curspace = 0
    node:schedule(handler(self, self.update), 0, "loading.update")
    node:findChild("btnExit"):onClick(handler(self, function() exitGame(false) end))
    node:findChild("btnExit"):setVisible(false)

    --  动画
    local action = cc.CSLoader:createTimeline(self:getCsb())
    node:runAction(action)
    action:gotoFrameAndPlay(0, 65, true)
    self:setProgressRaw(0)
    self:setProgress(0)
end

--desc:设置进度
--@rate     进度0~1
function ctrl:setProgress(rate)
    self.space = rate * 10000
end

--desc:设置原始进度
--@rate     原始进度0~1
function ctrl:setProgressRaw(rate)
    local node = self:getNode()
    if node then
        local back = node:findChild("progress/back")
        if back then
            local fore = back:findChild("fore")
            local board = back:findChild("board")
            local info = board:findChild("info")
            local attachnode = back:findChild("attachnode")
            local sz = fore:getContentSize()

             fore:setPercent(rate * 100)
             board:setPositionX(rate * sz.width)
             info:setString(string.format("正在加载%d%%", math.floor(rate * 100)))
             attachnode:setPositionX(rate * sz.width)
             self.curspace = math.floor(rate * 10000)
        end
    end
end

--desc:定时器回调函数
function ctrl:update()
    if self.space ~= self.curspace then
        local disp = self.space - self.curspace
        if disp >= -15 and disp <= 15 then
            self:setProgressRaw(self.space / 10000)
        else
            self:setProgressRaw((self.curspace + 0.2 * disp) / 10000)
        end
    end
end

return ctrl

