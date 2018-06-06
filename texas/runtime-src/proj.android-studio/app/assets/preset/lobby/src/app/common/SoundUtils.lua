local SoundUtils = {}

-- 游戏中的音效
SoundUtils.GameSoundBG = {"audio/game/bg.mp3"} 		--背景音乐
SoundUtils.GameSound = {}

SoundUtils.GameSound.ALLIN = {"audio/game/woman/allIn_0_1.mp3", "audio/game/woman/allIn_0_2.mp3"}				-- allin
SoundUtils.GameSound.DISCARD = {"audio/game/woman/discard_0_1.mp3", "audio/game/woman/discard_0_2.mp3"} 		-- 弃牌
SoundUtils.GameSound.FLUSH = {"audio/game/woman/flush_0_1.mp3", "audio/game/woman/flush_0_2.mp3"}				-- 同花
SoundUtils.GameSound.Follow = {"audio/game/woman/follow_0_1.mp3", "audio/game/woman/follow_0_2.mp3"}			-- 跟牌
SoundUtils.GameSound.FOURA = {"audio/game/woman/fourOfAKind_0_1.mp3", "audio/game/woman/fourOfAKind_0_2.mp3"}	-- 炸弹
SoundUtils.GameSound.LAGENARIA = {"audio/game/woman/lagenaria_0_1.mp3", "audio/game/woman/lagenaria_0_2.mp3"} -- 葫芦
SoundUtils.GameSound.PAIR = {"audio/game/woman/pair_0_1.mp3", "audio/game/woman/pair_0_2.mp3"}				-- 对子
SoundUtils.GameSound.PASS = {"audio/game/woman/pass_0_1.mp3", "audio/game/woman/pass_0_2.mp3"}				-- 过
SoundUtils.GameSound.PLUSCHIP = {"audio/game/woman/plusChip_0_1.mp3", "audio/game/woman/plusChip_0_2.mp3"}	-- 加注
SoundUtils.GameSound.ROYAL = {"audio/game/woman/royalStraightFlush_0_1.mp3", "audio/game/woman/royalStraightFlush_0_2.mp3"} 		-- 皇家同花顺
SoundUtils.GameSound.SCATTER = {"audio/game/woman/scatterCard_0_1.mp3", "audio/game/woman/scatterCard_0_2.mp3"}					-- 散牌
SoundUtils.GameSound.STRAIGHT = {"audio/game/woman/straight_0_1.mp3", "audio/game/woman/straight_0_2.mp3"}						-- 顺子
SoundUtils.GameSound.STRAIGHTFLUSH = {"audio/game/woman/straightFlush_0_1.mp3", "audio/game/woman/straightFlush_0_2.mp3"}			-- 同花顺
SoundUtils.GameSound.THREEA = {"audio/game/woman/threeOfAKind_0_1.mp3", "audio/game/woman/threeOfAKind_0_2.mp3"}					-- 三条
SoundUtils.GameSound.TWOPAIRS = {"audio/game/woman/twoPairs_0_1.mp3", "audio/game/woman/twoPairs_0_2.mp3"}						-- 两对

SoundUtils.GameSound.CHIPFLYCHI = {"audio/game/gameEffect/effect_chipflychizi.mp3"}			-- 金币飞到池子
SoundUtils.GameSound.CHIPFLYPLAYER = {"audio/game/gameEffect/effect_chipflypeople.mp3"} 		-- 金币飞到玩家
SoundUtils.GameSound.FANPAI = {"audio/game/gameEffect/effect_fapai1.mp3", "audio/game/gameEffect/effect_fapai2.mp3", "audio/game/gameEffect/effect_fapai3.mp3"}	--翻牌
SoundUtils.GameSound.TURN = {"audio/game/gameEffect/effect_turn0.mp3", "audio/game/gameEffect/effect_turn0.mp3"}						-- 倒计时
SoundUtils.GameSound.WIN = {"audio/game/gameEffect/effect_win.mp3"}			-- 胜利


function SoundUtils.preloadMusic()
	for _, bgFile in pairs(SoundUtils.GameSoundBG) do
		audio.preloadMusic(bgFile)
	end
end

function SoundUtils.playMusic()
	if not APP.GD:musicOn() then
		return
	end
	local musicCount = #SoundUtils.GameSoundBG
	local index = math.random(1, musicCount)
	audio.playMusic(SoundUtils.GameSoundBG[index])
end

function SoundUtils.pauseMusic()
	audio.pauseMusic()
end

function SoundUtils.stopMusic()
	audio.stopMusic(false)
end

function SoundUtils.playEffect(name)
	if not APP.GD:soundOn() then
		return
	end
	local soundCount = #name
	local index = math.random(1, soundCount)
	audio.playSound(name[index])
end

function SoundUtils.playFanpai(i)
	if not APP.GD:soundOn() then
		return
	end
	audio.playSound(SoundUtils.GameSound.FANPAI[i])
end

function SoundUtils.preloadGameSound()
	for _, soundFiles in pairs(SoundUtils.GameSound) do
		for _, soundFile in pairs(soundFiles) do
			audio.preloadSound(soundFile)
		end
	end
end

function SoundUtils.unloadGameSound()
	for _, soundFiles in pairs(SoundUtils.GameSound) do
		for _, soundFile in pairs(soundFiles) do
			audio.preloadSound(soundFile)
		end
	end
end

function SoundUtils.playSound(gender, name)
	if not APP.GD:soundOn() then
		return
	end
	local soundCount = #name
	local index = math.random(1, soundCount)
	-- printInfo("soundCount:%d, index:%d", soundCount, index)
	audio.playSound(name[index])
end

return SoundUtils