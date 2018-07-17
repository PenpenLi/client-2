
--desc:弹框相关接口
msgbox = {}
--desc:弹框，只包含确定按钮
function msgbox.showOk(text, callback, showCloseButton)
    g_Require("fruit/module/msgbox"):showOk(text, callback, showCloseButton)
end
--desc:弹框，包含确定和取消两个按钮
function msgbox.showOkCancel(text, callback, showCloseButton)
    g_Require("fruit/module/msgbox"):showOkCancel(text, callback, showCloseButton)
end
--desc:是否存在弹框界面
function msgbox.hasOpenedBox()
    return findChild("MsgBox") ~= nil
end
--desc:关闭最顶层弹框
function msgbox.closeTopBox()
    local children = GetScene():getChildren()
    for i = #children,2,-1 do
        if children[i]:getName() == "MsgBox" then
            children[i]:removeFromParent()
            break
        end
    end
end

--desc:加载界面相关接口
loading = {}
--desc:创建加载界面
--@text     加载界面要显示的文本
function loading.show(text)
    loading.ui = g_Require("fruit/module/loading")
    loading.ui:show(text)
end
--desc:设置进度
--@rate         进度0~1
--@is_force     是否跳过过程强制更新到该进度
function loading.setProgress(rate, is_force)
    if loading.ui then
        loading.ui:setProgress(rate)
        if is_force then
            loading.ui:setProgressRaw(rate)
        end
    end
end
--desc:销毁loading界面
function loading.destroy()
    loading.ui:destroy()
end

--desc:弹出消息相关接口
msgup = {}
--desc:弹出消息提示
--@text     提示内容
function msgup.show(text)
    g_Require("fruit/module/msgup"):show(text)
end

--desc:设置界面
setting = {}
function setting.show()
    g_Require("fruit/module/setting"):show(Game.Player.NickName)
end
--初始化音效设置
function setting.initSound()
    local ctrl = g_Require("fruit/module/setting")
    local b1 = ctrl:getSoundMusic()
    local b2 = ctrl:getSoundEffect()
    cclog("[设置] 音乐：%s 音效：%s", b1 and "开" or "关", b2 and "开" or "关")
    ctrl:setMusicPlay(b1)
    ctrl:setEffectPlay(b2)
end

