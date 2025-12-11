-- modify vanilla function ISCarftAction.perform() from lua/client/TimedActions; after crafting a fruit jam, we manually need to remove an item called
-- DefaultBerryJam from inventory; this item is necessary to make the fruit jams with different colors possible; the actual jam which the player receives is added to inventory in RasFarmingRecipeCode.lua
-- (see this mod's server folder)
--
--
-- by razab



local vanilla_perform = ISCraftAction.perform
function ISCraftAction.perform(self,...)

     vanilla_perform(self,...) -- execute vanilla code
  
     local resultId = self.recipe:getResult():getFullType()
     if resultId == "Base.RasDefaultBerryJam" then
          local inv = self.character:getInventory()
          inv:RemoveOneOf("Base.RasDefaultBerryJam")
     end   

end
