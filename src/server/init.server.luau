local DBScheduler = require(script.DBScheduler)

local DSS: DataStoreService = game:GetService("DataStoreService")
local Workspace = game:GetService("Workspace")

local NewSchedule = DBScheduler.Init()
local GameDB: DataStore = DSS:GetDataStore("GameDB")

local PromptHandler = Workspace:WaitForChild("PromptHandler")
local ProximityPrompt = PromptHandler:FindFirstChild("ProximityPrompt")

ProximityPrompt.Triggered:Connect(function(User: Player)
    NewSchedule:InsertTask(function(...)
        local UpdatedData = GameDB:UpdateAsync(`USER_{User.UserId}`, function(Coins: number)
            if Coins == nil then
                Coins = 0
            end
            Coins += 10
            return Coins
        end)
        print(UpdatedData)
    end)()
end)

--[[
while task.wait(.1) do
    NewSchedule:InsertTask(function(...)
        local UpdatedData = GameDB:UpdateAsync("brizooow", function(Coins: number)
            if Coins == nil then
                Coins = 0
            end
            Coins += 10
            return Coins
        end)
        print(UpdatedData)
    end)
end]]