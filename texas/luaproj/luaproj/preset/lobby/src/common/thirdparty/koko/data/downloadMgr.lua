local cls = class("koko.data.downloadMgr")
local CC = require("comm.CC")

function cls:ctor()
    self.iMaxDownNum = 1          -- 最多同时下载数量
    self.DownList = {}              -- 正在进行的任务列表 {gameId,taskId,rate},...
    self.WaitList = {}              -- 游戏等待的id列表
    self.CallbackList = {}          -- 任务Id的回调函数映射表 gameId -> callback
end
-- 添加任务
--@callback         function callback(gameId, is_success, msg)
function cls:addTask(gameId, callback)
    table.insert(self.WaitList, gameId)
    self.CallbackList[gameId] = callback
    self:_processTask()
end
-- 删除任务
function cls:removeTask(gameId)
    local idx = table.indexof(self.WaitList, gameId)
    if idx then
        table.remove(self.WaitList, idx)
        self.CallbackList[gameId] = nil
        return
    end
    for i=1,#self.DownList do
        local task = self.DownList[i]
        if task.gameId == gameId then
            tryInvoke(self.CallbackList[gameId], gameId, false, "任务被取消")
            self.CallbackList[gameId] = nil
            cancel_download_task(task.taskId)
            table.remove(self.DownList, i)
            break
        end
    end
    _processTask()
end
-- 删除所有任务
function cls:removeAllTask()
    self.WaitList = {}
    for i=1,#self.DownList do
        local task = self.DownList[i]
        cancel_download_task(task.taskId)
    end
    self.DownList = {}
    self.CallbackList = {}
end    
-- 获取任务状态
-- @return
function cls:getAllTaskStatus()
    local tbl = {down = {}, wait = {}}
    for k, v in ipairs(self.WaitList) do
        table.insert(tbl.wait, v)
    end
    for k, v in ipairs(self.DownList) do
        table.insert(tbl.down, v)
    end
    return tbl
end
-- 获取gameid状态
function cls:getStatusByGameId(gameId)
    for k, v in ipairs(self.DownList) do
        if gameId == v.gameId then return v end
    end
    for k, v in ipairs(self.WaitList) do
        if gameId == v then return v end
    end
    return false
end
-- 处理任务
function cls:_processTask()
    --判断当前正在进行的任务数量小于规定最大数量时，从等待列表取任务执行下载
    while true do
        if #self.DownList >= self.iMaxDownNum then
            break
        end
        if not self:_startOneTask() then
            break
        end
    end
end

-- 从等待列表中获取一个任务，添加到下载队列并开始下载
-- @return              true代表有任务并添加到下载队列 false代表无任务
function cls:_startOneTask()
    if #self.WaitList == 0 then
        return false
    end

    local gameId = self.WaitList[1]
    table.remove(self.WaitList, 1)

    local tbl = CC.Excel.GameList[gameId]
    local LocalDir = tbl.LocalDir
    local RemoteDir = tbl.RemoteDir

    local task = {}
    task.gameId = gameId
    task.rate = 0
    task.taskId = add_download_task(LocalDir, RemoteDir, function(rate)
        task.rate = rate
    end,
    function(is_success, error_msg)
        ccerr("downloadMgr:_startOneTask()94__%s", json.encode(task))
        table.removebyvalue(self.DownList, task)
        tryInvoke(self.CallbackList[gameId], gameId, is_success, error_msg)
        self.CallbackList[gameId] = nil
        self:_processTask()
    end)
    table.insert(self.DownList, task)
    ccerr("downloadMgr:_startOneTask()101__%s", json.encode(task))
    return true
end

return cls