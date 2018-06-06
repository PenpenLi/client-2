local GameUser = class("GameUser")

-- 协同服务器和游戏服务器返回的玩家信息

function GameUser:ctor()
    self.uid        = ""                -- 玩家id
    self.iid        = 0                 -- 玩家数字id
    self.uname      = ""
    self.lv         = 0                 -- 等级
    self.currency   = 0
    self.exp        = 0
    self.exp_max    = 0
    self.head_pic   = ""
    self.op         = 0                 -- 动作id，需要回传服务器 
                                        -- 0让牌，1弃牌, 2跟注 3加注, 4 钱不够allin,5钱多allin
    self.value      = 0                 -- 数额
    self.okkey      = ""                -- 操作ID

    self.gold       = 0                 -- 钻石
    self.gold_game  = 0                 -- 金币
    self.head       = 0
    self.headframe  = 0

    self.best_csf_val = 0               -- 最好牌型
    self.maincards = ""                 -- 牌
    self.attachment = ""
    self.winrate = 0                    -- 胜率
    self.total_played = 0               -- 总局数
    self.is_observer_ = 1;              -- 是否正在观战

    --APP:addListener(self, "NET_MSG", handler(self, self.onMsg));

end

function GameUser:setInfo(info)
    self.uid            = info.uid_
    self.iid            = tonumber(info.iid_)
    self.uname          = info.uname_
    self.lv             = tonumber(info.lv_)
    self.currency       = tonumber(info.currency_)
    self.exp            = tonumber(info.exp_)
    self.exp_max        = tonumber(info.exp_max_)
    self.head_pic       = info.head_pic_
    self.op             = tonumber(info.op_)
    self.value          = tonumber(info.value_)
    self.opkey          = info.opkey_
end

function GameUser:setItem(id, count)
    printInfo("setItem:id:%d,count:%d", id, count)
    if id == 0 then
        self.gold = count
    elseif id == 1 then
        self.gold_game = count
    elseif id == 104 then
        self.head = count
    elseif id == 105 then
        self.headframe = count
    end
end

-- 需要显示的信息，胜率等
function GameUser:setInfoExt(info)
    self.best_csf_val = tonumber(info.best_csf_val_)
    self.maincards = info.maincards_
    self.attachment = info.attachment_
    self.winrate = tonumber(info.win_rate_)
    self.total_played = tonumber(info.total_played_)
end

function GameUser:updateGold(gold)
    self.gold_game = gold
end

function GameUser:addMail(data)
    self.mail_list = self.mail_list or {}
    self.mail_list[data.id] = data
end

function GameUser:getMailList()
    return self.mail_list or {}
end

function GameUser:attachMail(data)
    self.mail_list[data.id] = nil
end

return GameUser