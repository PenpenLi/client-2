
local ctrl = createView("Game/right", "fruit/UILogic/Game/RightBar.csb", nil)

function ctrl:show()
    self.data = {}
    return self:create()
end

function ctrl:onInit(node)
    ctrl:refresh()
end

--desc:设置历史记录
function ctrl:setData(arr)
    for i=#arr,1,-1 do
        local pid = tonumber(arr[i])
        if pid and pid > 0 then
            table.insert(self.data, pid)
        end
    end
    self:refresh()
end

--desc:添加历史记录
function ctrl:addData(pid)
    pid = tonumber(pid)
    if pid and pid > 0 then
        table.insert(self.data, pid)
    end
    self:refresh()
end

--desc:刷新界面
function ctrl:refresh()
    local node = self:getNode()
    if not node then
        return
    end
    
    local panel = node:findChild("panel")
    local idx = 1
    for i=#self.data,1,-1 do
        if idx > 9 then
            break
        end

        local pid = self.data[i]
        local a = panel:findChild("a"..idx)
        local path = self:getImagePath(pid)
        if path ~= "" then
            a:setSpriteFrame(path)
            a:setVisible(true)
        else
            a:setVisible(false)
        end
        idx = idx + 1
    end

    panel:findChild("new"):setVisible(idx > 1)

    for i=idx,9 do
        local a = panel:findChild("a"..i)
        a:setVisible(false)
    end
end

--desc:根据pid获取图片路径
function ctrl:getImagePath(id)
    return (id >= 1 and id <= 8) and string.format("fruit/atlas/Game/img%02d.png", 30 + id - 1) or ""
end

return ctrl
