local cls = class("koko.data.player_self")
local CC = require("comm.CC")
function cls:ctor()
    self.uid = ""               --玩家UID
    self.iid = 0                --玩家数字ID
    self.pwd = ""                --密码
    self.partyName = ""         --账号类型
    self.exp = 0                --经验值
    self.nickName = ""          --昵称
    self.gold = 0               --k豆:总
    self.goldLobby = 0          --k豆:大厅
    self.goldGame = 0           --k豆:游戏
    self.diamond = 0            --钻石 （K币）
    self.ticket = 0             --k券 /100 =  话费券
    self.level = 0              --等级
    self.vipLimit = 0           --最大VIP等级  MaxLevel
    self.vipValue = 0           --Vip经验
    self.vipLevel = 0           --Vip等级
    self.isagent = 0            --0 不是,1销售,2银商
    self.age = 0                --年龄
    self.headIcon = ""          --头像图标
    self.goldGameLock = 0       --游戏币锁定
    self.byear = 0              --年
    self.bmonth = 0             --月
    self.bday = 0               --日
    self.mobileV = 0            --手机验证 0未  1已验证
    self.emailV = 0             --邮箱验证 0未  1已验证 
    self.mobile = ""            --手机号
    self.email = ""             --邮箱
    self.idcard = ""            --身份证
    self.address = ""           --地址
    self.region4 = 0            --国家
    self.region1 = 0            --省
    self.region2 = 0            --市
    self.region3 = 0            --区
    self.isBot = 0              --是不是机器人
    self.isNewBee = 0           --新玩家
    self.token = ""             --命令行token
    self.sequence = 0           --命令行sn
    self.chanelID = -1          --加入房间的chanel
    self.gender = 0             --性别（0男，1女)
    self.spreadfrom = ""        --注册方式（暂时未用到）
    self.secMobile = ""         --安全手机号码
    self.bankGold = 0           --保险箱K豆
    self.bankDiamond = 0        --保险箱钻石
    self.appKey = ""            --appKey(用户私钥)
    self.uname = ""             --用户名（账号）
    self.bankPsw = ""           --保险箱密码

    self.kLastLoginTime = ""    --上次登录时间
    self.kLastLocation = "未知"     --上次登录地点
    self.kLocation = "未知"         --定位
    self.tAchievement =             --成就
    {
        iKB = 0,                --赢K币次数
        iScore = 0,             --游戏积分
        iTime = 0,              --游戏时长
        iMatchWiner = 0,        --比赛奖励次数
        iRankTime = 0,          --进排名次数
        iGame = 0,              --游戏次数
        iMatch = 0,             --比赛次数
    }
    self.tWelcome = 
    {
        bGift = false,          --新手礼包
        bIDCard = false,        --实名认证
    }
    self.tProperty = {"goldLobby", "ticket", "goldGameLock", "bankDiamond", "bankGold"}
    self.tProperty[0] = "diamond"
    self.tProperty[102] = "vipValue"
    self.tProperty[103] = "vipLimit"
    return self
end

function cls:setPlayerselfInfo(t)
    self.exp = 0
    self.expMax = 0
    self:SetGold(t.goldGame, {Lobby = true})
    self.diamond = t.gold
    self.ticket = t.goldFree

    self.isagent = bit.band(t.isAgent, 0xffff)
    self.headIcon = t.headpicName
    self.nickName = t.nickname
    self.mobileV = t.mobileVerified
    self.emailV = t.mailVerified
    self.mobile = t.mobileNumber
    self.email = t.mail
    self.idcard = t.idnumber
    self.region4 = t.addrCountry
    self.region1 = t.addrCity
    self.region2 = t.addrProvince
    self.region3 = t.addrRegion
    self.isNewBee = bit.band(bit.rshift(t.isAgent, 17), 1)
    self.token = t.gameKey
    self.sequence = t.gameSn
    self.chanelID = os.time()
    self.spreadfrom = t.spreadFrom
    self.bankGold = t.goldGameInBank
    self.bankDiamond = t.goldInBank
    self.tWelcome.bGift = t.color == "1"
    self.tWelcome.bIDCard = t.manage == "1"
    CC.PlayerMgr.Invite.List.iStep = ((t.searchType == 2 or t.searchType == 4) and 3) or (t.searchType == 3 and 2) or (t.searchType == 5 and 4) or 1
    CC.Print("Player.searchType "..t.searchType)
    self.uid = t.uid
    self.iid = t.iid
    self.pwd = t.pwd
    self.level = t.level
    self.vipValue = t.vipValue
    self.vipLimit = t.vipLimit
    self.age = t.age
    self.goldGameLock = t.goldGameLock
    self.byear = t.byear
    self.bmonth = t.bmonth
    self.bday = t.bday
    self.address = t.address
    self.gender = t.gender
    self.secMobile = t.secMobile
    self.appKey = #t.appKey > 0 and t.appKey or self.appKey
    self.uname = t.uname
    self.bankPsw = t.bankPsw
    self.partyName = t.partyName

    local viplist = CC.Excel.VipList
    for i = 1, viplist:Count() do
        if i == t.vipLimit then
            self.vipLevel = i
            break
        end
        if t.vipValue < viplist[1].MinExp then
            self.vipLevel = 0
            break
        end
        if t.vipValue >= viplist[i].MinExp and t.vipValue < viplist[i + 1].MinExp then
            self.vipLevel = i
            break
        end    
    end 
    CC.Event("RefreshPlayer")
end

function cls:SetGold(iVal, tVal)
    if tVal.Lobby then
        self.goldLobby = iVal
    elseif tVal.Game then
        self.goldGame = iVal
    end
    self.gold = math.max(self.goldLobby, self.goldGame)
end

function cls:setPropertyByItemID(iID, iCount)
    local kKey = self.tProperty[iID]
    if kKey then
        if kKey == "goldLobby" then
            self:SetGold(iCount, {Lobby = true})
        else
            self[kKey] = iCount
        end
        if kKey == "diamond" then
            kk.event.dispatch(E.EVENTS.diamond_changed, iCount)
        elseif kKey == "goldLobby" then
            kk.event.dispatch(E.EVENTS.gold_changed, iCount)
        elseif kKey == "ticket" then
            kk.event.dispatch(E.EVENTS.ticked_changed, iCount)
        elseif kKey == "goldGameLock" then
            kk.event.dispatch(E.EVENTS.goldGameLock_changed, iCount)    
        elseif kKey == "bankDiamond" then
            kk.event.dispatch(E.EVENTS.bank_diamond_changed, iCount)
        elseif kKey == "bankGold" then
            kk.event.dispatch(E.EVENTS.bank_gold_changed, iCount)
        elseif kKey == "vipValue" then
            local viplist = CC.Excel.VipList
            for i = 1, viplist:Count() do
                if i == self.vipLimit then
                    self.vipLevel = i
                    break
                end
                if iCount < viplist[1].MinExp then
                    self.vipLevel = 0
                    break
                end
                if iCount >= viplist[i].MinExp and iCount < viplist[i + 1].MinExp then
                    self.vipLevel = i
                    break
                end    
            end    
            kk.event.dispatch(E.EVENTS.vip_value_changed)
        end
        CC.Event("RefreshPlayer")
        return true
    end
end

function cls:IsAccountNeedUpgrate()
    return self.pwd == "" and self.partyName == "tourist"
end

function cls:Sync()
    CC.SendWeb("user/info.htm", {}, function (tVal)
        if tVal.success then
            CC.Player:setPlayerselfInfo(tVal.data.result)
        end
    end)
end
return cls