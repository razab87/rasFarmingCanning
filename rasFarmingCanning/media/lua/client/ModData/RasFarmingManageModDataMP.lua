-- write the start and end date for farming season in player's mod data; is only done in multiplayer; in single player, this is done in server/RasFarmingSeasons.lua
--
--
-- by razab



-- when player joins an mp game, request global mod data
local function requestModData()
      if isClient() then -- do this only when player is in multiplayer
            ModData.request("rasFarming_key_dates") -- request the dates for growing season
      end
end


-- add global mod data to palyer's mod data
local function addModDataToPlayer(key, globalData)
 
    if key == "rasFarming_key_dates" and globalData then -- tell player the dates for growing season
        if globalData["Start"] and globalData["End"] then
            local data = getPlayer():getModData()
            if not data.RasFarming then
                  data.RasFarming = {}
            end
            data.RasFarming.Season = {}
            data.RasFarming.Season.StartDate = globalData["Start"]
            data.RasFarming.Season.EndDate = globalData["End"]
        else
            print("Mod_rasFarmingCanning_MP_ERROR: Something wrong with transmitting modData from server, in RasFarminManageModDataMP, client. Consider reporting to mod author.")
            local data = getPlayer():getModData()
            if not data.RasFarming then
                  data.RasFarming = {}
            end
            data.RasFarming.Season = {}
            data.RasFarming.Season.StartDate = 15 -- set default values to avoid game breaking bugs
            data.RasFarming.Season.EndDate = 15
        end
    end  
end



Events.OnGameStart.Add(requestModData)
Events.OnReceiveGlobalModData.Add(addModDataToPlayer)
