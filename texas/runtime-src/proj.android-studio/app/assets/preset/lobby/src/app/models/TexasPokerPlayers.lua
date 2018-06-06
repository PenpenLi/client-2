
local Player = class("Player")

function Player:ctor()
    self.uid = ""
    self.iid = 0
    self.uname = ""
    self.lv = 0
    self.pos = 0        -- 座位号
    self.roomid = 0
    self.sequence_1 = 0
    self.head_ico = 0
    self.headframe_id = 0

    self.is_ready = false
    self.action = -1    -- 玩家采取了什么操作
    self.setbet = 0    -- 数额

    self.cards = ""    -- 牌值

    self.credits = 0   -- 进场金币
    self.display_type = 0   -- 0，不需要飘字 1,要飘字, 2 保证金变化

    self.valid_op = 0       -- "弃牌,让牌,跟注,加注,"｛0,1,1,0｝1表示操作可用
    self.opkey = ""         -- 动作id，需要回传服务器
    self.time_left = 0      -- 剩余时间,毫秒数

    self.wins = 0           -- 获得数目

    self.csf_val = 0
    self.main_cards = ""
    self.attachment = ""
    self.isbalance = false      -- 是否结算时候发的
end

function Player:setServerData(data)
    self.uid = data.uid_
    self.iid = tonumber(data.iid_)
    self.uname = data.uname_
    self.lv = tonumber(data.lv_)
    self.pos = tonumber(data.pos_)
    self.roomid = tonumber(data.roomid_)
    self.sequence_1 = tonumber(data.sequence_1_)
    self.head_ico = tonumber(data.head_ico_)
    self.headframe_id = tonumber(data.headframe_id_)

    -- self.action = tonumber(data.action_)
    -- self.setbet = tonumber(data.setbet_)

    -- self.cards = data.cards_
    -- self.credits = tonumber(data.credits_)
    -- self.display_type = tonumber(data.display_type_)

    -- self.valid_op = tonumber(data.valid_op_)
    -- self.opkey = data.opkey_
    -- self.time_left = tonumber(data.time_left_)

    -- self.wins = tonumber(data.wins_)

    -- self.csf_val = tonumber(data.csf_val_)
    -- self.main_cards = data.main_cards_
    -- self.attachment = data.attachment_
    -- self.isbalance = data.isbalance_
end

function Player:setCards(cards)
    self.cards = cards
end

function Player:setReady(isReady, data)
    self.is_ready = isReady
    self.sequence_1 = tonumber(data.sequence_1_)
end

function Player:updateCredits(credits)
    self.credits = tonumber(credits)
end

function Player:updateAction(action, bet)
    self.action = action
    self.setbet = bet
end

function Player:updatePleaseOP(valid_op, op_key, left_time)
    self.valid_op = valid_op
    self.opkey = op_key
    self.time_left = left_time
end

function Player:updateCardType(csf_val, main_cards, attachment, isbalance)
    self.csf_val = csf_val
    self.main_cards = main_cards
    self.attachment = attachment
    self.isbalance = isbalance
end

-- 是否是最佳牌型中的一张牌，card是牌的数值
function Player:isInBestCard(card)
    local mainCards = string.split(self.main_cards, ",")
    local attachmentCards = string.split(self.attachment, ",")
    for _, c in pairs(mainCards) do
        if tonumber(c) == card then
            return true
        end
    end
    return false
end

function Player:clear()
    self.is_ready = false
    self.action = -1    -- 玩家采取了什么操作
    self.setbet = 0    -- 数额

    self.cards = ""    -- 牌值

    self.display_type = 0   -- 0，不需要飘字 1,要飘字, 2 保证金变化

    self.valid_op = 0       -- "弃牌,让牌,跟注,加注,"｛0,1,1,0｝1表示操作可用
    self.opkey = ""         -- 动作id，需要回传服务器
    self.time_left = 0      -- 剩余时间,毫秒数

    self.wins = 0           -- 获得数目

    self.csf_val = 0
    self.main_cards = ""
    self.attachment = ""
    self.isbalance = false      -- 是否结算时候发的
end

local TexasPokerPlayers = class("TexasPokerPlayers")

function TexasPokerPlayers:ctor()
    self.players = {}
end

function TexasPokerPlayers:addPlayer(playerData)
    local player = Player.new()
    player:setServerData(playerData)
    table.insert(self.players, player)
end

function TexasPokerPlayers:deletePlayerByPos(pos)
    for index = 1, #self.players do
        if self.players[index].pos == pos then
            return table.remove(self.players, index)
        end
    end
end

function TexasPokerPlayers:getPlayerByUid(uid)
    for _, player in pairs(self.players) do
        if player.uid == uid then
            return player
        end
    end
    return nil
end

function TexasPokerPlayers:getPlayerByPos(pos)
    for _, player in pairs(self.players) do
        if player.pos == pos then
            return player
        end
    end
    return nil
end

function TexasPokerPlayers:setPlayerReady(uid, isReady, data)
    local player = self:getPlayerByUid(uid)
    player:setReady(isReady, data)
end

return TexasPokerPlayers