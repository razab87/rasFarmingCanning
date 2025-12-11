-- patch the transferItemsByWeight() function so that hidden food items are not transferred in case they are present in player's inventory and player presses the "transfer all" button
--
--
-- by razab


local rasSharedData = require("RasFarmingSharedData")
local rasFarmingTables = rasSharedData.Tables

-- removes all hidden food food items from myTable; returns whithout them
local function removeHiddenItems(myTable)
      local result = {}
      for _,v in pairs(myTable) do
            if not rasFarmingTables.HiddenFoodItems[v:getFullType()] then
                    table.insert(result, v)
            end
      end
      return result
end



local vanilla_transferItemsByWeight = ISInventoryPane.transferItemsByWeight
function ISInventoryPane.transferItemsByWeight(self, items, container, ...)
         local newItems = removeHiddenItems(items) 
         vanilla_transferItemsByWeight(self, newItems, container, ...) -- execute vanilla code
end
