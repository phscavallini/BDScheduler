
function ThreadStatus(thread: thread)
	return coroutine.status(thread)
end

local scheduleMeta = {}
scheduleMeta.__index = scheduleMeta

scheduleMeta.__newindex = function(self, index, value)
	rawset(self, index, value)
end

scheduleMeta.__execute = function(self, index)
	local thread: thread = rawget(self, index)
	local lastThread: thread = rawget(self, index - 1)
	if lastThread == nil then return coroutine.resume(thread) end
	if ThreadStatus(thread) == "suspended" then
		while ThreadStatus(lastThread) ~= "dead" do
			--print(ThreadStatus(lastThread))
			task.wait()
		end
		return coroutine.resume(thread)
	end
end

local scheduler = {}
scheduler.__index = scheduler

function scheduler.Init(): {}
	local self = setmetatable({}, scheduler)
	self.schedule = setmetatable({}, scheduleMeta)
	return self
end

function scheduler:InsertTask(Fn: (...any?) -> ...any?): ()
	local schedule = self.schedule
	local newThread = coroutine.create(Fn)
	local newIndex = rawlen(schedule) + 1
	schedule[newIndex] = newThread
	return function ()
		schedule:__execute(newIndex)
	end
end

--[[
function scheduler:Execute(ThreadIndex: number)
	local schedule = self.schedule
	return schedule:__execute(ThreadIndex)
end]]

return scheduler