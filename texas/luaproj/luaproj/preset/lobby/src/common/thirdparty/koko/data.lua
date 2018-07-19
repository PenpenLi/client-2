local _G = _G
local clsPlayerself = require("koko.data.player_self")
local clsEntryCache = require("koko.data.entry_cache")
local clsDownloadMgr = require("koko.data.downloadMgr")
module("koko.data")

playerself = clsPlayerself:create()
--entryCache = clsEntryCache:create()
downloadMgr = clsDownloadMgr:create()
StartupParamMgr = _G.require("koko.data.StartupParamMgr")
ReconnectMgr = _G.require("koko.data.ReconnectMgr")
