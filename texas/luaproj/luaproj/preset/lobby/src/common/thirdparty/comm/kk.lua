
local _G = _G

-- class:
--    view
--    animScale
--    animFall

-- uimgr
-- msgbox
-- msgup
-- waiting
-- timer
-- ql
-- event
-- edit
-- crypt
-- xml
-- enum

module("comm.kk")

view        = _G.require("comm.kk.view")
animScale   = _G.require("comm.kk.anim_scale")
animFall    = _G.require("comm.kk.anim_fall")

-- uimgr
-- uimgr.load(pathOrClass, parent, ...)
-- uimgr.get(nameOrClass)
-- uimgr.unload(nameOrClass)
-- uimgr.refresh(nameOrClass)
-- uimgr.call(nameOrClass, method, ...)
-- uimgr.sendData(nameOrClass, ...)
-- uimgr.exitAll()
uimgr = _G.require("comm.kk.uimgr")

-- msgbox
-- msgbox.showNull(text, callback, time)
-- msgbox.showOk(text, callback, time)
-- msgbox.showOkCancel(text, callback, time)
-- msgbox.hasBox()
-- msgbox.closeTop()
-- msgbox.closeBox(box)
-- msgbox.closeAll()
msgbox = _G.require("comm.kk.msgbox")

-- msgup
-- msgup.show(text)
-- msgup.showEx(parent, csb, text)
msgup = _G.require("comm.kk.msgup")

-- waiting
-- waiting.show(msg)
-- waiting.showEx(root, msg)
-- waiting.close()
-- waiting.isVisible()
waiting = _G.require("comm.kk.waiting")

-- timer
-- timer.delayOnce(interval, callback, ...)
-- timer.delay(interval, callback, ...)
-- timer.cancel(id)
timer = _G.require("comm.kk.timer")

-- ql
-- ql.httpPost(url, tbl, callback)
-- ql.httpPostWithCd(url, tbl, callback, cd)
-- ql.createSuccess()
-- ql.createError(msg)
ql = _G.require("comm.kk.ql")

-- event
-- event.addListener(node, evtName, callback)
-- event.dispatch(evtName, ...)
-- event.removeListener(evt)
event = _G.require("comm.kk.event")

-- edit
-- edit.createAny(size, holder_text, fontSize, multiLine)
-- edit.createAnyWithParent(parent, name, holder_text, fontSize, multiLine)
-- edit.createPassword(size, holder_text, fontSize)
-- edit.createPasswordWithParent(parent, name, holder_text, fontSize)
-- edit.createNumber(size, holder_text, fontSize)
-- edit.createNumberWithParent(parent, name, holder_text, fontSize)
-- edit.createImpl(size, holder_text, mode, flag)
edit = _G.require("comm.kk.edit")

-- crypt
-- crypt.ca1Encode(content)
-- crypt.ca1Decode(content)
crypt = _G.require("comm.kk.crypt")

-- xml
-- xml.getString(key)
-- xml.setString(key, str)
-- xml.getTable(key)
-- xml.setTable(key, tbl)
-- xml.clear(key)
xml = _G.require("comm.kk.xml")

-- util
-- util.convertMoneyToShortString(num)
-- util.convertMoneyToShortStringInt(num)
-- util.convertMoneyToRmb(num)
-- util.convertFileSize2String(size)
-- util.asyncLoadResource(plists, callback)
-- util.isExitPathOnPlist(path)
-- util.getPlatformTypeString()
-- util.getAppVersion()
-- util.sendErrorReport(errType, uid, gameStr, errContent, remark, callback)
-- util.getCoordinateChannelId()
util = _G.require("comm.kk.util")

-- enum
enum = _G.require("comm.kk.enum")
