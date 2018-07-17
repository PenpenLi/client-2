--音效播放辅助函数
sound = {}

--播放背景音乐
local _currentMusic = ""
sound.playMusic = function(name, is_loop)
    if is_loop == nil then
        is_loop = true
    end
    --if _currentMusic ~= name then
        _currentMusic = name
        cc.SimpleAudioEngine:getInstance():playMusic(name, is_loop)
    --end
end

--播放音效
sound.playEffect = function(name)
    cc.SimpleAudioEngine:getInstance():playEffect(name)
end

--背景音乐
sound.playBackgroundMusic = function()
    sound.playMusic("fruit/Sound/JackpotPopupBackgroundSound.mp3", false)
end

--点击音效
sound.playClickEffect = function()
    sound.playEffect("fruit/Sound/click.wav")
end

--弹框提示音效
sound.playMsgBoxEffect = function()
    sound.playEffect("fruit/Sound/alert.wav")
end

--随机音效
sound.playRandomEffect = function()
    sound.playEffect("fruit/Sound/e2.wav")
end

--中奖音效
sound.playRewardEffect = function()
    sound.playEffect("fruit/Sound/e1.mp3")
end

--提示开始下注音效
sound.playStartEffect = function()
    sound.playEffect("fruit/Sound/start.mp3")
end

--播放中大奖音效
sound.playBigRewardEffect = function()
end

--播放胜利音效
sound.playWinEffect = function()
    sound.playEffect("fruit/Sound/win.mp3")
end

--播放失败音效
sound.playLoseEffect = function()
end

--播放下注音效
sound.playBetEffect = function()
    sound.playEffect("fruit/Sound/setbet.mp3")
end

