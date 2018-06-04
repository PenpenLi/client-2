local CMD = require("app.net.CMD")
local ErrorCode = require("app.net.ErrorCode")
local GameUser = require("app.models.GameUser")
local GameConfig = require("app.core.GameConfig")
local gameCMD = require("app.commands.LoginTexasPokerCommand")

local CoordinateServerHandlers = {}


function CoordinateServerHandlers.active()
SOCKET_HANDLERS.registerHandler(GameConfig.ID_COORDINATESERVER, CMD.COORDINATE_COMMOM_REPLY, 1, CoordinateServerHandlers.CommonReply);
SOCKET_HANDLERS.registerHandler(GameConfig.ID_COORDINATESERVER, CMD.COORDINATE_GET_GAME_SERVER_RESP, 1, CoordinateServerHandlers.handleGetGameServerResponse);
SOCKET_HANDLERS.registerHandler(GameConfig.ID_COORDINATESERVER, CMD.COORDINATE_SYNC_ITEM, 1, CoordinateServerHandlers.handleSyncItemNotify);
SOCKET_HANDLERS.registerHandler(GameConfig.ID_COORDINATESERVER, CMD.GAME_PRIVATE_ROOM_INFO, 1, CoordinateServerHandlers.privateRoomInfo);
SOCKET_HANDLERS.registerHandler(GameConfig.ID_COORDINATESERVER, CMD.GAME_SIGN_RESULT, 1, CoordinateServerHandlers.handleGetSignInfo);
SOCKET_HANDLERS.registerHandler(GameConfig.ID_COORDINATESERVER, CMD.GAME_SIGN_GET_RESULT, 1, CoordinateServerHandlers.handleAwardInfo);
SOCKET_HANDLERS.registerHandler(GameConfig.ID_COORDINATESERVER, CMD.COORDINATE_SAMEACCOUNT_LOGIN, 1, CoordinateServerHandlers.handleSameAccountLogin);
SOCKET_HANDLERS.registerHandler(GameConfig.ID_COORDINATESERVER, CMD.GAME_USER_MAIL_LIST_RESP, 1, CoordinateServerHandlers.handleSaveMailList);
SOCKET_HANDLERS.registerHandler(GameConfig.ID_COORDINATESERVER, CMD.GAME_USER_MAIL_LIST_RESP, 1, CoordinateServerHandlers.handleGetMailAttach);



end

function CoordinateServerHandlers.CommonReply(content)
    local cmd = tonumber(content.rp_cmd_)
    local err = tonumber(content.err_)
    if cmd == CMD.COORDINATE_USER_LOGIN_COORDINATE_REQ then
        -- 登陆协同服务器返回
        if err == ErrorCode.error_success then
            printLog("a", "登陆协同服务器成功")
            -- 断开账号服务器连接
            SOCKET_MANAGER.closeToAccountServer()
            -- 获取游戏服务器地址
            local data = {
                game_id_ = GameConfig.GameID
            }
            SOCKET_MANAGER.sendToCoordinateServer(CMD.COORDINATE_GET_GAME_SERVER_REQ, data)

        else
            APP:dispatchCustomEvent("COMMON_ERROR", APP.GD.LANG.ERR_CANNOT_FIND_COOR);
        end
    elseif cmd == CMD.COORDINATE_GET_GAME_SERVER_REQ then
        APP:dispatchCustomEvent("COMMON_ERROR", APP.GD.LANG.ERR_CANNOT_FIND_GAME);
    end
end

function CoordinateServerHandlers.handleGetGameServerResponse(content)
    printLog("a", "游戏服务器地址获取成功! %s, %s", content.ip_, content.port_);

    APP.GD.connect_game_options = {
        ip = content.ip_,
        port = tonumber(content.port_)
    }
    gameCMD.execute();
end

function CoordinateServerHandlers.handleSameAccountLogin(content)
	printLog("a", "SAME ACCOUNT LOGIN COR");
	APP.GD.SameAccountLogin = true;
end

function CoordinateServerHandlers.handleSyncItemNotify(content)
    local gameUser =APP.GD.GameUser
    gameUser:setItem(tonumber(content.item_id_), tonumber(content.count_))
end

function CoordinateServerHandlers.handleBroadcastNotify(content)
    local bContent = content.content_
    if tonumber(content.msg_type_) == 2 or tonumber(content.msg_type_) == 4 then
        if APP:isObjectExists("ScrollBar") then
            local broadcastView = APP:getObject("ScrollBar")
            broadcastView:pushMessage({msg_type = tonumber(content.msg_type_), content = bContent})
        end
    end
end 


---------------------------------大厅----------------------------------------

function CoordinateServerHandlers.handleGetSignInfo(content)

 print("=======================handleGetSignInfo jx ================")
  --ts if tonumber(content.login_state_) == 0 then
       local signInfoTable = {}
       signInfoTable.serial_days = tonumber(content.serial_days_) --连续登入天数
       signInfoTable.serial_state = tonumber(content.serial_state_)--最多三位数（个位-3天， 十位-6天，百位-9天，0-未领取 1-已领取）
       signInfoTable.login_day = tonumber(content.login_day_)--当前第几天 当前第几天(1~7)
       signInfoTable.login_state = tonumber(content.login_state_)--登录奖励状态：0-未领取 1-已领取]]--
   
   print("=====show signInfoTable=====")
   --  if signInfoTable[1].login_state == 0 then
       APP.hc:showSignLayer(signInfoTable)
  --ts  end 
   
    --APP.hc:CreateSign()
	--APP:dispatchCustomEvent("SIGN_CREATE_SUCC", content);
end


function CoordinateServerHandlers.handleAwardInfo(content)
print("====================================================================handleAwardInfo")
     dump(content)

    local strs = string.split(content.item_, ',')
    
    local awardInfo ={

          itemNumber = tonumber(strs[1]),
          coinNumber = tonumber(strs[2])   
    } 
   -- if tonumber(content.)
   print("=================",awardInfo.itemNumber,awardInfo.coinNumber)
   APP.hc:ShowSignAward(awardInfo)
end 

function CoordinateServerHandlers.handleSaveMailList(content)
    local data = {}
    data.id = content.id_
    data.title = content.title_
    data.attach_state = content.attach_state_
    data.timestamp = content.timestamp_
    gameUser:addMail(data)
end

function CoordinateServerHandlers.handleGetMailAttach(content)
    gameUser:attachMail(content)
end

return CoordinateServerHandlers