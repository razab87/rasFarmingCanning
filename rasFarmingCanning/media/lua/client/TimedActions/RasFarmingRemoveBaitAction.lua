-- when player removes a bait which came from a jar, we make it so that the player does not receive a jar but a "piece of" the food item contained in the jar; this is to ensure that
-- there is no exploit where the player can multiply empty jars by using traps; also adjust age and poison values; modifies timedAction from vanilla ISRemoveBaitAction (can be found in vanilla's client folder, traps)
--
--
-- by razab



local rasSharedData = require("RasFarmingSharedData")
local rasFarmingTables = rasSharedData.Tables


-- auxiliary function: adjust food in case bait has been taken from a jar
local function adjustFood(trap, trapData, foodType, worldAge)

        resultType = rasFarmingTables.Baits[foodType]
        result = InventoryItemFactory.CreateItem(resultType)

        if trapData.RasFarming.TrapAgeFresh and trapData.RasFarming.TrapAgeRotten then
              result:setOffAge(trapData.RasFarming.TrapAgeFresh)
              result:setOffAgeMax(trapData.RasFarming.TrapAgeRotten)             
        end
        local age = trap.trapBaitDay + (math.abs((worldAge / 24) - trap.lastUpdate));
        result:setAge(age)
        result:setLastAged(worldAge)  

        if result:isRotten() then -- for rotten food, we take a different item so that the icon shows it is rotten
             resultType = rasFarmingTables.BaitsRotten[foodType]
             result = InventoryItemFactory.CreateItem(resultType)
             result:setAge(result:getOffAgeMax()) -- make food rotten
             result:setLastAged(worldAge)
        end     

        return result
end

-- auxiliary function: check whether bait has been taken from jar
local function isJar(foodType)
 
     if rasFarmingTables.JarsOpen[foodType] or rasFarmingTables.PickledJarsOpen[foodType] or rasFarmingTables.JamsOpen[foodType] or rasFarmingTables.VanillaJarsOpen[foodType] then
        return true
     end
 
     return false
end




-- modifed vanilla function:

local vanilla_perform = ISRemoveBaitAction.perform
function ISRemoveBaitAction.perform(self, ...)
       
    local trapData = self.trap:getIsoObject():getModData()

    if trapData.RasFarmingTrapAgeFresh then -- transfer modData from pre-update-1.1 to new modData (can be removed in later versions)
         if not trapData.RasFarming then
              trapData.RasFarming = {}
         end
         trapData.RasFarming.TrapAgeFresh =  trapData.RasFarmingTrapAgeFresh
         trapData.RasFarming.TrapAgeRotten = trapData.RasFarmingTrapAgeRotten

         trapData.RasFarmingTrapAgeFresh = nil -- delete old modData      
         trapData.RasFarmingTrapAgeRotten = nil         
    end 

    if trapData.RasFarmingTrapPoison then -- transfer modData from pre-update-1.1 to new modData (can be removed in later versions)
         if not trapData.RasFarming then
             trapData.RasFarming = nil
         end
         trapData.RasFarming.TrapPoison = trapData.RasFarmingTrapPoison 
         trapData.RasFarming.TrapHunger = trapData.RasFarmingTrapHunger
         trapData.RasFarming.TrapOwner = trapData.RasFarmingTrapKnownPoison
         
         trapData.RasFarmingTrapPoison = nil  
         trapData.RasFarmingTrapHunger = nil
         trapData.RasFarmingTrapKnownPoison = nil
    end

    if trapData.RasFarming then -- bypass vanilla code in case we set mod data for trap
            if trapData.RasFarming.TrapPoison then -- if bait was poisonous

                    local sq = self.trap:getSquare()
	                local args = { x = sq:getX(), y = sq:getY(), z = sq:getZ() }
	                CTrapSystem.instance:sendCommand(self.character, 'removeBait', args)

	                if self.trap.bait and self.trap.baitAmountMulti then
		                if self.trap.baitAmountMulti < 0 then
			                    local bait = InventoryItemFactory.CreateItem(self.trap.bait)
			                    local worldAge = getGameTime():getWorldAgeHours();
                                if isJar(self.trap.bait) then -- in case bait was taken from a poisonous jar
                                    bait = adjustFood(self.trap, trapData, self.trap.bait, worldAge)
                                else
			                        local baitAge = self.trap.trapBaitDay + (math.abs((worldAge / 24) - self.trap.lastUpdate));
			                        bait:setAge(baitAge);
			                        bait:setLastAged(worldAge);
			                        local baitMultiplier = math.min(self.trap.baitAmountMulti / bait:getHungChange(), 1.0);
			                        bait:multiplyFoodValues(baitMultiplier);
                                end

                                -- here we manage the poison stuff
                                local poison = trapData.RasFarming.TrapPoison
                                local hunger = trapData.RasFarming.TrapHunger
                                local factor = 5 / hunger
                                bait:setPoisonPower(math.max(math.floor(poison * factor), 2))
                                bait:setPoisonDetectionLevel(3)
                                local playerData = self.character:getModData()
                                if playerData.RasFarming.PlayerID == trapData.RasFarming.TrapOwner then -- does player know bait has been poisonous?
                                      local resultData = bait:getModData()
                                      resultData.RasFarming = {}
                                      resultData.RasFarming.KnowsAboutPoison = {}
                                      resultData.RasFarming.KnowsAboutPoison[playerData.RasFarming.PlayerID] = true 
                                end

                                self.character:getInventory():addItem(bait);
		                end
	                end

                    trapData.RasFarming = nil -- delete all modData for the trap

	                ISBaseTimedAction.perform(self);

            elseif isJar(self.trap.bait) then -- if bait was not poisonous but a jar

                    local sq = self.trap:getSquare()
	                local args = { x = sq:getX(), y = sq:getY(), z = sq:getZ() }
	                CTrapSystem.instance:sendCommand(self.character, 'removeBait', args)

	                if self.trap.bait and self.trap.baitAmountMulti then
		                if self.trap.baitAmountMulti < 0 then
                            local worldAge = getGameTime():getWorldAgeHours();
                            local bait = adjustFood(self.trap, trapData, self.trap.bait, worldAge)
			                self.character:getInventory():addItem(bait);
		                end
	                end

                    trapData.RasFarming = nil -- delete all modData

	                ISBaseTimedAction.perform(self)
           else
                vanilla_perform(self, ...) -- execute vanilla code (just in case; this situation should in fact never happen!)
           end
    else	
	    vanilla_perform(self, ...) -- execute vanilla code
    end

end


