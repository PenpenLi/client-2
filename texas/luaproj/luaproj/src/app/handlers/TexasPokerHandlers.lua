local CMD = require("app.net.CMD")
local ErrorCode = require("app.net.ErrorCode")

local TexasPokerHandlers = {}

function TexasPokerHandlers.handleStatusChangeNotify(content)
	-- print("TexasPokerHandlers.handleStatusChangeNotify")
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

function TexasPokerHandlers.handlePromoteBankerNotify(content)
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

function TexasPokerHandlers.handlePleaseTakeopNotify(content)
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

function TexasPokerHandlers.handlePlayerCardsNotify(content)
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

function TexasPokerHandlers.handlePublicCardsNotify(content)
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

function TexasPokerHandlers.handlePlayerOptionNotify(content)
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

function TexasPokerHandlers.handleBestPlanNotify(content)
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

function TexasPokerHandlers.handlePoolChangeNotify(content)

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

function TexasPokerHandlers.handleMatchResultNotify(content)
    local room_id = APP.GD:getRoomId()
    if room_id ~= tonumber(content.roomid_) then
        printInfo("收到其他房间的消息")
        return
    end

    if APP:getCurrentController().matchResult then
        APP:getCurrentController():matchResult(content)
    end
end

function TexasPokerHandlers.handleTakePoolNotify(content)
    local room = APP.GD:getGameRoom()
    local pool = {id = tonumber(content.pool_id_), count = tonumber(content.count_)}
    room.take_pools[content.uid] = room.take_pools[content.uid] or {}
    table.insert(room.take_pools[content.uid], pool)

end

return TexasPokerHandlers