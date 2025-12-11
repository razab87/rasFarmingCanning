-- modify vanilla ISAddBaitAction; we store some data related to poison and age of food in trap's modData
--
--
-- by razab



local rasSharedData = require("RasFarmingSharedData")
local rasFarmingTables = rasSharedData.Tables



-- auxiliary function: checks if player knows whether item is poisonous 
local function knowsPoison(player, playerData, item)

        local itemData = item:getModData()

        if itemData.RasFarming then
                if itemData.RasFarming.KnowsAboutPoison then
                       if itemData.RasFarming.KnowsAboutPoison[playerData.RasFarming.PlayerID] then
                              return true
                       end
                end               
        end

        local herbType = item:getHerbalistType()
        if (herbType == "Berry" or herbType == "Mushroom") and player:isRecipeKnown("Herbalist") then
             return true
        end
       
        return false
end



local vanilla_perform = ISAddBaitAction.perform
function ISAddBaitAction.perform(self, ...)
 
    local player = self.character
    local food = self.bait
    local trapData = self.trap:getIsoObject():getModData()

    if (trapData.RasFarmingTrapAgeFresh or trapData.RasFarmingTrapPoison) then -- delete modData from pre-update to 1.1 version (TODO: can be removed in later versions)
         trapData.RasFarmingTrapAgeFresh = nil      
         trapData.RasFarmingTrapAgeRotten = nil
         trapData.RasFarmingTrapPoison = nil  
         trapData.RasFarmingTrapHunger = nil
         trapData.RasFarmingTrapKnownPoison = nil
    end 

    local foodName = food:getFullType()
    if rasFarmingTables.JarsOpen[foodName] or rasFarmingTables.PickledJarsOpen[foodName] or rasFarmingTables.JamsOpen[foodName] or rasFarmingTables.VanillaJarsOpen[foodName] then
             trapData.RasFarming = {}
             trapData.RasFarming.TrapAgeFresh = food:getOffAge()      -- those data are needed to adjust the age in case food is taken from jars; age adjustment is done in RasFarmingRemoveBaitAction
             trapData.RasFarming.TrapAgeRotten = food:getOffAgeMax()
    else
            trapData.RasFarming = nil      -- delete mod data which may have been set earlier
    end

    if food:getPoisonPower() > 0 then
        if not trapData.RasFarming then
             trapData.RasFarming = {}
        end
        trapData.RasFarming.TrapPoison = food:getPoisonPower()
        trapData.RasFarming.TrapHunger = food:getHungChange() -- hunger value needed to adjust poison amount when removing bait
        local playerData = player:getModData()
        if knowsPoison(player, playerData, food) then
             trapData.RasFarming.TrapOwner = playerData.RasFarming.PlayerID -- store in trap that player knows there is poison
        else
             trapData.RasFarming.TrapOwner = nil -- delete data from previous players who used the trap
        end
    else
        if trapData.RasFarming then
            trapData.RasFarming.TrapPoison = nil  -- delete modData we may have added previously
            trapData.RasFarming.TrapHunger = nil
            trapData.RasFarming.TrapOwner = nil
        end
    end

    vanilla_perform(self, ...) -- execute vanilla code

end


