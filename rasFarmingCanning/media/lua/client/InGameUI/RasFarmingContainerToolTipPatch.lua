-- modify vanilla function ISToolTipInv:render() (found in vanilla lua/client/ISUI); modifcation is necessary so that hiddenFoodItems are not displayed in the tooltip
-- of a container (e.g. backpacks, bags, ...)
--
--
-- by razab


-- TODO: can be removed after update to 1.1???


local rasSharedData = require("RasFarmingSharedData")
local rasFarmingTables = rasSharedData.Tables


local vanilla_render = ISToolTipInv.render
function ISToolTipInv.render(self, ...)
   
    local container = nil
    if self.item and instanceof(self.item, "InventoryContainer") then
         container = self.item:getInventory()            
    end

    local backUpList = {}    
    if container then -- temporarily remove all hiddenItems and restore them after vanilla code has been executed
          for hiddenItem,_ in pairs(rasFarmingTables.HiddenFoodItems) do
                local n = container:getAllType(hiddenItem):size()
                if n > 0 then
                   table.insert(backUpList, { theType = hiddenItem, theNumber = n })
                   local name = string.gsub(hiddenItem, "Base.", "")               
                   container:RemoveAll(name)
                end 
          end
    end


    vanilla_render(self, ...) -- execute vanilla code


    if container then -- restore old data and put them back to container
         for _,v in pairs(backUpList) do               
               container:AddItems(v.theType, v.theNumber)
         end
    end
end


