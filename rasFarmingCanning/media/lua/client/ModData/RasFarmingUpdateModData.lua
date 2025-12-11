-- recent mod update to 1.1 changed the table structure of player's modData to reduce the number of global variables (= better performance); here we transfer the season data from 
-- player's old modData to the new one and set the old data to nil; PlayerID is treated in the ManagePlayerID lua (TODO: maybe remove in later updates)
--
--
-- by razab


local function updateModData()

      local data = getPlayer():getModData()
       
      if data.RasFarmingStartDate and data.RasFarmingEndDate and not isClient() then -- season dates need only be updated in singleplayer (mp is done in ManageModDataMP)
           if not data.RasFarming then
                data.RasFarming = {}
           end
           data.RasFarming.Season = {}
           data.RasFarming.Season.StartDate = data.RasFarmingStartDate -- store start and end date for farming season
           data.RasFarming.Season.EndDate = data.RasFarmingEndDate
                          
           data.RasFarmingStartDate = nil  -- delete old data
           data.RasFarmingEndDate = nil
      end
end


Events.OnGameStart.Add(updateModData)
