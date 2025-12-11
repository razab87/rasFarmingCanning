-- modify the TimedAction ISAddItemInRecipe.lua so that the crafted food item behaves better under the poison system; also apply this to any vanilla food btw: when players craft a food recipe item and know that an ingredient
-- is poisonous, they will also know that the resulting item is poisonous, no matter their cooking skill; vanilla game does not work in this way
--
--
-- by razab


local rasSharedData = require("RasFarmingSharedData")
local rasFarmingTables = rasSharedData.Tables
local rasUtils = require("RasFarmingClientUtils")




local vanilla_perform = ISAddItemInRecipe.perform   
function ISAddItemInRecipe.perform(self, ...)

      -- store some data before vanilla code gets executed 
      local item = self.usedItem -- the item which will be added
      local itemPoison = 0
      if item and instanceof(item, "Food") then
         itemPoison = item:getPoisonPower() -- this value seems to be set to 0 by vanilla perform() function (??), therefore backup
      end
      local basePoison = 0 
      if self.baseItem and instanceof(self.baseItem, "Food") then
               basePoison = self.baseItem:getPoisonPower()
      end


      vanilla_perform(self, ...) -- execute vanilla code 


      -- note: self.baseItem contains now the result item  
      if self.baseItem then
          if instanceof(self.baseItem, "Food") then

                      -- fix vanilla "bug": sometimes resulting food has less poisonPower than the original base food -> makes no sense -> fix
                      if basePoison > 0 and self.baseItem:getPoisonPower() < basePoison then
                            self.baseItem:setPoisonPower(basePoison)
                      end

                      -- adjust poisonDetectionLevel
                      if self.baseItem:getPoisonPower() > 0 then
                            self.baseItem:setPoisonDetectionLevel( math.max(3, self.baseItem:getPoisonDetectionLevel()) ) -- by default, players with cooking skill >= 7 will be able to detect the poison
                      end

                      local resultData = self.baseItem:getModData()   -- the result item's mod data (same as baseItem, so poison knowledge from other players might still be present)        
                      

                      -- transfer poison knowledge from used item 
                      if itemPoison > 0 then
                          local itemData = item:getModData() 
                          local playerData = self.character:getModData() 
                          rasUtils.transferPoisonKnowledge(self.character, playerData, item, itemData, nil, resultData)
                      end
          end
      end
end    




