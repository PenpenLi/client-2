local UIHelper = require("app.common.UIHelper")
local LeftBaseLayer = require("app.views.common.LeftBaseLayer")
local ViewGameMission = class("ViewGameMission", LeftBaseLayer)

-- 测试数据
-- reward_type  1金币奖励，2钻石奖励
-- mession_type 1局数任务，2时间任务
-- status  0未完成，1已完成
-- time 时间倒计时
ViewGameMission.MISSION = {
	{id = 1, reward_type = 1, reward_number = 100, mession_type = 2, mession_number = 10, time = 120, status = 0},
	{id = 2, reward_type = 2, reward_number = 100, mession_type = 1, mession_number = 10, time = 0, status = 1},
	{id = 3, reward_type = 1, reward_number = 100, mession_type = 1, mession_number = 10, time = 0, status = 0}
}

function ViewGameMission:ctor()
	ViewGameMission.super.ctor(self)

	self.handles = {}

	local csbnode = cc.CSLoader:createNode("cocostudio/game/MissionLayer.csb")
	csbnode:addTo(self)

	self:addMissions()
	
end

function ViewGameMission:onEnter()
    ViewGameMission.super.onEnter(self)
end

function ViewGameMission:onExit()
    ViewGameMission.super.onExit(self)

    for _, handle in pairs(self.handles) do
    	scheduler.unscheduleGlobal(handle)
    end
end

function ViewGameMission:addMissions()
	local LANG =APP.GD.LANG
	for i = 1, #ViewGameMission.MISSION do
		local missionNode = cc.CSLoader:createNode("cocostudio/game/GameMissionNode.csb")
			:addTo(self)
			:move(-287, 1200 - i * 170)
		local img_Icon = UIHelper.seekNodeByName(missionNode, "Image_Icon")
		local text_Reward = UIHelper.seekNodeByName(missionNode, "Text_Reward")
		local text_MessionInfo = UIHelper.seekNodeByName(missionNode, "Text_MessionInfo")
		local btn_GetReward = UIHelper.seekNodeByName(missionNode, "Button_Get")
		local text_CountDown = UIHelper.seekNodeByName(missionNode, "Text_Countdown")
		local m = ViewGameMission.MISSION[i]
		if m.reward_type == 1 then
			img_Icon:loadTexture("cocostudio/game/image/mission/mission_icon_gold.png")
			text_Reward:setString(string.format(LANG.UI_MISSION_REWARD_GOLD, m.reward_number))
		else
			img_Icon:loadTexture("cocostudio/game/image/mission/mission_icon_diamond.png")
			text_Reward:setString(string.format(LANG.UI_MISSION_REWARD_DIAMOND, m.reward_number))
		end
		if m.mession_type == 1 then
			text_MessionInfo:setString(string.format(LANG.UI_MISSION_TIMES, m.mession_number))
			text_CountDown:hide()
		else
			local count_down = m.time
			text_MessionInfo:setString(string.format(LANG.UI_MISSION_ONLINE_TIME, m.mession_number))
			text_CountDown:setString(tostring(count_down))
			text_CountDown:show()
			local h = scheduler.scheduleGlobal(function()
				count_down = count_down - 1
				text_CountDown:setString(tostring(count_down))
				-- 取消定时器，并从数组中删除
				if count_down <= 0 then
					scheduler.unscheduleGlobal(h)
					btn_GetReward:show()
					for i = 1, #self.handles do
						if h == self.handles[i] then
							table.remove(self.handles, i)
							break
						end
					end
				end
			end, 1.0)
			table.insert(self.handles, h)
		end
		if m.status == 0 then
			btn_GetReward:hide()
		else
			btn_GetReward:show()
		end
	end
end

return ViewGameMission