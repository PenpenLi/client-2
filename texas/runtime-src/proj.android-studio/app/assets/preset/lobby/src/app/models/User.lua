local User = class("User")

-- 账号服务器返回的玩家信息，基本上用不到

function User:ctor()
	self.uid = ""				-- 玩家id
	self.iid = 0				-- 玩家数字id
    self.nickname = ""
    self.age = 0
    self.gold = 0				-- 钻石
    self.game_gold = 0			-- 金币
    self.game_gold_free = 0		-- 免费金币
    self.vip_level = 0
    self.channel = 0			-- 渠道
    self.gender = 0 			-- 性别：0男，1女
    self.level = 0				-- 等级
    self.idcard = ""			-- 身份证

    self.token = ""				-- 后面发送消息使用
    self.sequence = 0			-- 时间戳，发送消息时使用

    self.email = ""
    self.phone = ""
    self.address = ""
    
    self.email_verified = false 		-- 邮箱是否已经验证
    self.phone_verified = false 		-- 手机是否已经验证

    self.byear = 0				-- 出生年、月、日
    self.bmonth = 0
    self.bday = 0

    self.region1 = 0			-- 地址省、市、县
    self.region2 = 0
    self.region3 = 0

    self.isagent = 0			-- 代理：有特殊意义，未定
    self.isinit = 0				-- 暂未使用
    self.app_key = 0			-- 暂未使用
    self.party_name = 0			-- 暂未使用
end

function User:setInfo(info)
	self.uid = info.uid_
	self.iid = tonumber(info.iid_)
    self.nickname = info.nickname_
    self.age = tonumber(info.age_)
    self.gold = tonumber(info.gold_)
    self.game_gold = tonumber(info.game_gold_)
    self.game_gold_free = tonumber(info.game_gold_free_)
    self.vip_level = tonumber(info.vip_level_)
    self.channel = tonumber(info.channel_)
    self.gender = tonumber(info.gender_)
    self.level = tonumber(info.level_)
    self.idcard = info.idcard_
    self.head_ico = info.headico_
    self.token = info.token_
    self.sequence = tonumber(info.sequence_)

    self.email = info.email_
    self.phone = info.phone
    self.address = info.address_
    
    if info.email_verified_ == 0 then
    	self.email_verified = false
    else
    	self.email_verified = true
    end

    if info.phone_verified_ == 0 then
    	self.phone_verified = false
    else
    	self.phone_verified = true
    end

    self.byear = tonumber(info.byear_)
    self.bmonth = tonumber(info.bmonth_)
    self.bday = tonumber(info.bday_)

    self.region1 = tonumber(info.region1_)
    self.region2 = tonumber(info.region2_)
    self.region3 = tonumber(info.region3_)

    self.isagent = tonumber(info.isagent_)
    self.isinit = tonumber(info.isinit_)
    self.app_key = tonumber(info.app_key_)
    self.party_name = tonumber(info.party_name_)
end

return User