-- here we manage the farming seasons
--
--
-- by razab


local rasSharedData = require("RasFarmingSharedData")
local startMonth = rasSharedData.FixedValues.startMonth -- start and end month of the growing season are hardcoded (see the mod's lua/shared folder)
local endMonth = rasSharedData.FixedValues.endMonth


-- check whether we are in farming season
local function InFarmingSeason()
      
       local myTable = ModData.get("rasFarming_key_dates")
       if myTable then
           local time = GameTime:getInstance()
           local month = time:getMonth()
           local day = time:getDay()
           if month == startMonth and day+1 >= myTable["Start"] then
                return true
           elseif month > startMonth and month < endMonth then
                return true
           elseif month == endMonth and day+1 < myTable["End"] then
                return true
           else
                return false
           end
       end
end



-- local function killing all crops on the map
local function KillAllPlants()

   local tmp = SFarmingSystem.instance   
   for i=1,tmp:getLuaObjectCount() do
       local luaObject = tmp:getLuaObjectByIndex(i)
       local square = luaObject:getSquare()
       if luaObject.state == "seeded" then
            if luaObject.state ~= "rotten" then
               luaObject:rottenThis()
            end
       end
   end
   print("Mod_rasFarmingCanning_Info: all plants killed")

end



-- init seasons when starting a new game (or adding the mod to an existing game)
local function seasonsInit()    
     
     if isClient() then -- only execute this for server or in single player
          return
     end

     local data = ModData.get("rasFarming_key_dates")
     if not data then -- in case data have not been initialized, do it now
           local myTable = ModData.getOrCreate("rasFarming_key_dates")
           myTable["Start"] = 1 + ZombRand(25) -- set day when farming season starts (only days required since months are hardcoded)
           myTable["End"] = 6 + ZombRand(22) -- set day when farming season ends  
           print("Mod_rasFarmingCanning_Info: dates for growing season initialized")
           if not InFarmingSeason() then
               KillAllPlants()  
           end
           if not isServer() then -- when in single player, write data in palyer's ModData
                 local playerData = getPlayer():getModData()
                 if not playerData.RasFarming then
                     playerData.RasFarming = {}
                 end
                 playerData.RasFarming.Season = {}
                 playerData.RasFarming.Season.StartDate = myTable["Start"]
                 playerData.RasFarming.Season.EndDate = myTable["End"]
           else -- in multiplayer, send the data to the clients (probably not necessary here, just in case...)
                ModData.transmit("rasFarming_key_dates")
           end                      
     end
end




-- calculate new season dates when a farming season is over and make all crops rotten; is checked once a day
local function seasonsManage()  

         if isClient() then -- only execute this for server or in single player
              return
         end
        
         local myTable = ModData.get("rasFarming_key_dates")
         if myTable then
              local time = GameTime:getInstance()
              local currentDay = time:getDay()
              local currentMonth = time:getMonth()
              if currentMonth == endMonth and currentDay+1 == myTable["End"] then -- if we reached end date of farming season   
                    KillAllPlants() -- make all crops rotten 
              elseif currentMonth == endMonth + 1 and currentDay == 1 then -- set new season dates (do it in the next month after season ends; simplifies some calculations)
                     myTable["Start"] = 1 + ZombRand(25) -- set new season dates
                     myTable["End"] = 6 + ZombRand(22)
                     print("Mod_rasFarmingCanning_Info: new dates for growing season set")
                     if not isServer() then -- when in single player, write data in palyer's ModData
                          local playerData = getPlayer():getModData()
                          if not playerData.RasFarming then
                               playerData.RasFarming = {}
                          end
                          playerData.RasFarming.Season = {}
                          playerData.RasFarming.Season.StartDate = myTable["Start"]
                          playerData.RasFarming.Season.EndDate = myTable["End"]
                     else -- in multiplayer, send data to clients
                          ModData.transmit("rasFarming_key_dates")
                     end
              end
         end
end



Events.OnGameStart.Add(seasonsInit)
Events.OnServerStarted.Add(seasonsInit) -- in multiplayer, init function must be executed here (note: OnGameStart code seems not to run on server??)

Events.EveryDays.Add(seasonsManage)






