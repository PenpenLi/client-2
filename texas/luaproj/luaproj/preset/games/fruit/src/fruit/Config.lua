
Config = 
{
    ["ResolutionWidth"]     = 1280,
    ["ResolutionHeight"]    = 720,
    ["Title"]               = "水果转转",
    
    ["WORLDADDR"]           = "clogin.test.koko.com",
    ["WORLDPORT"]           = 10001,
    ["GAMEID"]              = 32,

    ["DefaultAccount"]      = "ztest5123",             --"12dd3@qq.com",
    ["DefaultPassword"]     = "123456",             --"123456",
    ["Bets"]                = {1000, 10000, 100000, 500000, 1000000},   --下注额度配置
    ["RandomTotalTime"]     = 8,                                        --转转总时间
    ["BalanceDelayTime"]    = 2,                                        --结算界面延迟弹出时间
    ["FruitFallTime"]       = 5,                                        --水果下落总时间
    ["FruitFallTable"]      = {1,3,5,7},                                --中奖为列表中的数字时，播放水果落下特效
    ["RechargeUrl"]         = "http://cpphelper.koko.com:8080/kokoportal/recharge/main.htm"  --充值地址
}

Config.ReconnectTimeout = 15                                    --重连超时时间，单位秒