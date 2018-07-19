local utils = require("utils")
local SoundUtils = require("app.common.SoundUtils")
local GameConfig = require("app.common.GameConfig")
local CMD = require("app.net.CMD")
local UIHelper = require("app.common.UIHelper")

local ControllerBase = require("app.controllers.GameControllerBase")
local GameController = class("GameController", ControllerBase)

function GameController:ctor()
    GameController.super.ctor(self)
	
    self:enableNodeEvents()
    self.playerViews = {}
	self.lastScore = {}
	self.allScore = {}
end

function GameController:onEnter()
	GameController.super.onEnter(self)
	
	local a = g_Require("fruit.ui_game");
	a:show();

	self.viewRoom = a;
    self.viewRoom:onRandResult(Game.RandResult)      --设置开奖结果
    self.viewRoom:onLastRandom(Game.LastRandom)      --设置历史记录
    self.viewRoom:onStateChanged(Game.CurState, Game.CurStateTime)   --刷新当前状态
    self.viewRoom:onPlayerSetBets()                  --玩家下注
    self.viewRoom:onMySetBets()                      --自己下注
    self.viewRoom:setPlayerNickName(Game.Player.NickName)
    self.viewRoom:setPlayerIId(Game.Player.IID)
    self.viewRoom:onRefreshPlayerGold(Game.Player.Gold)   
end

function GameController:onExit()
	GameController.super.onExit(self)
end
return GameController