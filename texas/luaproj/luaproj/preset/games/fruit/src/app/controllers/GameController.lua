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
    self.viewRoom:onRandResult(Game.RandResult)      --���ÿ������
    self.viewRoom:onLastRandom(Game.LastRandom)      --������ʷ��¼
    self.viewRoom:onStateChanged(Game.CurState, Game.CurStateTime)   --ˢ�µ�ǰ״̬
    self.viewRoom:onPlayerSetBets()                  --�����ע
    self.viewRoom:onMySetBets()                      --�Լ���ע
    self.viewRoom:setPlayerNickName(Game.Player.NickName)
    self.viewRoom:setPlayerIId(Game.Player.IID)
    self.viewRoom:onRefreshPlayerGold(Game.Player.Gold)   
end

function GameController:onExit()
	GameController.super.onExit(self)
end
return GameController