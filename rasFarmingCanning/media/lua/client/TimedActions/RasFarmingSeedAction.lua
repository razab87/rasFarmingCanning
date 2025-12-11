-- adjust the planting mechanism so that no seeds are planted when outside of farming season; modifies vanilla function from lua/client/Farming/TimedActions/ISSeedAction.lua
--
--
-- by razab



local rasSharedData = require("RasFarmingSharedData")


-- check whether we are in farming season
local function isInFarmingSeason(month, day, player)

       local endMonth = rasSharedData.FixedValues.endMonth -- start and end month for growing season
       local startMonth = rasSharedData.FixedValues.startMonth 
      
       local data = player:getModData()
       if month == startMonth and day+1 >= data.RasFarming.Season.StartDate then
              return true
       elseif month > startMonth and month < endMonth then
              return true
       elseif month == endMonth and day+1 < data.RasFarming.Season.EndDate then
              return true
       else
              return false
       end

end


local vanilla_perform = ISSeedAction.perform
function ISSeedAction.perform(self, ...)

      local player = self.character

      local time = GameTime:getInstance()
      local day = time:getDay()
      local month = time:getMonth()
      local season = isInFarmingSeason(month, day, player)

      if season then
             vanilla_perform(self, ...) -- execute vanilla code when in farming season
      else -- when not in farming season, bypass vanilla code so that nothing is planted
            if self.sound and self.sound ~= 0 then
		          self.character:getEmitter():stopOrTriggerSound(self.sound)
	        end

	        for i=1, self.nbOfSeed do
		        local seed = self.seeds[i];
		        self.character:getInventory():Remove(seed); -- still remove seeds from inventory
	        end

            -- needed to remove from queue / start next.
	        ISBaseTimedAction.perform(self);
      end

end






