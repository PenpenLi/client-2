local CMD = require("app.net.CMD")
local ErrorCode = require("app.net.ErrorCode")
local GameConfig = require("app.common.GameConfig")
local PlayerList = g_Require("app.models.PlayerList")
local GameRoom = require("app.models.GameRoom")
local GameSpecificHandlers = {}

function GameSpecificHandlers.active()
 
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.TEXASPOKER_STATUS_CHANGE_NOTIFY, 1, GameSpecificHandlers.handleStatusChangeNotify, "GameSpecificHandlers.handleStatusChangeNotify");
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.TEXASPOKER_PROMOTE_BANKER_NOTIFY, 1, GameSpecificHandlers.handlePromoteBankerNotify, "GameSpecificHandlers.handlePromoteBankerNotify");
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.TEXASPOKER_PLEASE_TAKEOP_NOTIFY, 1, GameSpecificHandlers.handlePleaseTakeopNotify, "GameSpecificHandlers.handlePleaseTakeopNotify");
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.TEXASPOKER_PLAYER_CARDS, 1, GameSpecificHandlers.handlePlayerCardsNotify, "GameSpecificHandlers.handlePlayerCardsNotify");
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.TEXASPOKER_PUBLIC_CARDS, 1, GameSpecificHandlers.handlePublicCardsNotify, "GameSpecificHandlers.handlePublicCardsNotify");
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.TEXASPOKER_PLAYER_OPTION_NOTIFY,1, GameSpecificHandlers.handlePlayerOptionNotify, "GameSpecificHandlers.handlePlayerOptionNotify");
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.TEXASPOKER_BEST_PLAN_NOTIFY, 1, GameSpecificHandlers.handleBestPlanNotify, "GameSpecificHandlers.handleBestPlanNotify");
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.TEXASPOKER_POOL_CHANGE_NOTIFY, 1, GameSpecificHandlers.handlePoolChangeNotify, "GameSpecificHandlers.handlePoolChangeNotify");
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.TEXASPOKER_MATCH_RESULT_NOTIFY, 1, GameSpecificHandlers.handleMatchResultNotify, "GameSpecificHandlers.handleMatchResultNotify");
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.TEXASPOKER_POOL_SPLIT, 1, GameSpecificHandlers.handleTakePoolNotify, "GameSpecificHandlers.handleTakePoolNotify");

end

function GameSpecificHandlers.deactive()
 
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.TEXASPOKER_STATUS_CHANGE_NOTIFY, 1, nil, "GameSpecificHandlers.handleStatusChangeNotify");
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.TEXASPOKER_PROMOTE_BANKER_NOTIFY, 1, nil, "GameSpecificHandlers.handlePromoteBankerNotify");
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.TEXASPOKER_PLEASE_TAKEOP_NOTIFY, 1, nil, "GameSpecificHandlers.handlePleaseTakeopNotify");
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.TEXASPOKER_PLAYER_CARDS, 1, nil, "GameSpecificHandlers.handlePlayerCardsNotify");
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.TEXASPOKER_PUBLIC_CARDS, 1, nil, "GameSpecificHandlers.handlePublicCardsNotify");
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.TEXASPOKER_PLAYER_OPTION_NOTIFY,1, nil, "GameSpecificHandlers.handlePlayerOptionNotify");
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.TEXASPOKER_BEST_PLAN_NOTIFY, 1, nil, "GameSpecificHandlers.handleBestPlanNotify");
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.TEXASPOKER_POOL_CHANGE_NOTIFY, 1, nil, "GameSpecificHandlers.handlePoolChangeNotify");
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.TEXASPOKER_MATCH_RESULT_NOTIFY, 1, nil, "GameSpecificHandlers.handleMatchResultNotify");
    SOCKET_HANDLERS.registerHandler(GameConfig.ID_GAMESERVER, CMD.TEXASPOKER_POOL_SPLIT, 1, nil, "GameSpecificHandlers.handleTakePoolNotify");

end


function GameSpecificHandlers.handleStatusChangeNotify(content)
	-- print("GameSpecificHandlers.handleStatusChangeNotify")
	local room_id = APP.GD:getRoomId()
	if room_id ~= tonumber(content.roomid_) then
		printInfo("收到其他房间的消息")
		return
	end

	local room = APP.GD:getGameRoom()
	room:changeStatus(content)

 	if APP:getCurrentController().changeStatus then
		APP:getCurrentController():changeStatus()
	end
end

function GameSpecificHandlers.handlePromoteBankerNotify(content)
	local room_id = APP.GD:getRoomId()
    if room_id ~= tonumber(content.roomid_) then
        printInfo("收到其他房间的消息")
        return
    end

    local room = APP.GD:getGameRoom()
    room:updateBanker(content)

    if APP:getCurrentController().promoteBanker then
        APP:getCurrentController():promoteBanker(content)
    end
end

function GameSpecificHandlers.handlePleaseTakeopNotify(content)
    local room_id = APP.GD:getRoomId()
    if room_id ~= tonumber(content.roomid_) then
        printInfo("收到其他房间的消息")
        return
    end

    local players = APP.GD:getRoomPlayers()
    local player = players:getPlayerByUid(content.uid_)

    if player then
        player:updatePleaseOP(content.valid_op_, content.opkey_, tonumber(content.time_left_))
    end

    if APP:getCurrentController().pleaseTakeop then
        APP:getCurrentController():pleaseTakeop(content)
    end
end

function GameSpecificHandlers.handlePlayerCardsNotify(content)
    local room_id = APP.GD:getRoomId()
    if room_id ~= tonumber(content.roomid_) then
        printInfo("收到其他房间的消息")
        return
    end

    local players = APP.GD:getRoomPlayers()
    local player = players:getPlayerByUid(content.uid_)
    if player then
        player:setCards(content.cards_)
    end

    if APP:getCurrentController().playerCards then
        APP:getCurrentController():playerCards(content)
    end
end

function GameSpecificHandlers.handlePublicCardsNotify(content)
    local room_id = APP.GD:getRoomId()
    if room_id ~= tonumber(content.roomid_) then
        printInfo("收到其他房间的消息")
        return
    end

    local room = APP.GD:getGameRoom()
    room:updatePublicCards(content)

    if APP:getCurrentController().publicCards then
        APP:getCurrentController():publicCards(content)
    end
end

function GameSpecificHandlers.handlePlayerOptionNotify(content)
    local room_id = APP.GD:getRoomId()
    if room_id ~= tonumber(content.roomid_) then
        printInfo("收到其他房间的消息")
        return
    end
    local players = APP.GD:getRoomPlayers()
    local player = players:getPlayerByUid(content.uid_)

    if player then
        player:updateAction(tonumber(content.action_), tonumber(content.setbet_))
    end

    if tonumber(content.action_) >= 2 then
        local room = APP.GD:getGameRoom()
        room:updateMaxBet(tonumber(content.setbet_))
    end

    if APP:getCurrentController().playerOption then
        APP:getCurrentController():playerOption(content)
    end
end

function GameSpecificHandlers.handleBestPlanNotify(content)
    local room_id = APP.GD:getRoomId()
    if room_id ~= tonumber(content.roomid_) then
        printInfo("收到其他房间的消息")
        return
    end

    local gameUser =APP.GD.GameUser
    local players = APP.GD:getRoomPlayers()
    local player = players:getPlayerByUid(content.uid_)
    player:updateCardType(tonumber(content.csf_val_), content.main_cards_, content.attachment_, tobool(content.isbalance_))

    if APP:getCurrentController().bestPlan then
        APP:getCurrentController():bestPlan(content.uid_, content)
    end
end

function GameSpecificHandlers.handlePoolChangeNotify(content)

    local room_id = APP.GD:getRoomId()
    if room_id ~= tonumber(content.roomid_) then
        printInfo("收到其他房间的消息")
        return
    end

    local room = APP.GD:getGameRoom()
    if tonumber(content.pool_id_) == 0 then
        room.base_pool = tonumber(content.value_)
    elseif tonumber(content.pool_id_) > 0 then
        room:changeSidePool(tonumber(content.pool_id_), tonumber(content.value_))
    end

    if APP:getCurrentController().poolChange then
        APP:getCurrentController():poolChange(tonumber(content.pool_id_))
    end
end

function GameSpecificHandlers.handleMatchResultNotify(content)
    local room_id = APP.GD:getRoomId()
    if room_id ~= tonumber(content.roomid_) then
        printInfo("收到其他房间的消息")
        return
    end

    if APP:getCurrentController().matchResult then
        APP:getCurrentController():matchResult(content)
    end
end

function GameSpecificHandlers.handleTakePoolNotify(content)
    local room = APP.GD:getGameRoom()
    local pool = {id = tonumber(content.pool_id_), count = tonumber(content.count_)}
    room.take_pools[content.uid] = room.take_pools[content.uid] or {}
    table.insert(room.take_pools[content.uid], pool)

end

return GameSpecificHandlers