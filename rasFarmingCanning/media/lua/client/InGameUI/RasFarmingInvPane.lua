-- this code patches a vanilla function from vanilla lua/client/ISUI/ISInventoryPane.lua; we arrange things so that the poisonous icon is correctly displayed when our new jars are poisonous; don't know how
-- to use the vanilla poison system properly, so I do it manually
--
--
-- by razab




local rasSharedData = require("RasFarmingSharedData")
local rasFarmingTables = rasSharedData.Tables


-- auxiliary function: checks if player knows whether item is poisonous; not necessary to treat the case of berries or mushrooms since
-- this is done by game according to herbalist trait; we only check our mod data
local function knowsPoison(playerData, itemData)

       if itemData.RasFarming.KnowsAboutPoison then
            return itemData.RasFarming.KnowsAboutPoison[playerData.RasFarming.PlayerID] 
       end
        
       return false
end




local vanilla_renderdetails = ISInventoryPane.renderdetails
function ISInventoryPane.renderdetails(self, doDragged, ...)

    local player = getSpecificPlayer(self.player)
    local playerData = player:getModData()

    local backUpList = { }
    for _,v in pairs(self.itemslist) do
        for _,item in pairs(v.items) do
            if instanceof(item, "Food") then 
                local itemData = item:getModData()
                if itemData.RasFarming then
                    if knowsPoison(playerData, itemData) then                  
                         if (not itemData.RasFarming.PoisonDetectionLevel) then 
                                 itemData.RasFarming.PoisonDetectionLevel = item:getPoisonDetectionLevel() -- back-up
                                 item:setPoisonDetectionLevel(10) -- set detection to 10 so that game attaches the green poison icon (later restored to original value) 
                                 table.insert(backUpList, item)                           
                         end
                    end
                end
            end
        end
    end


    vanilla_renderdetails(self, doDragged, ...) -- execute vanilla code
    

    for _,item in pairs(backUpList) do -- restore old data
          local itemData = item:getModData()
          if itemData.RasFarming.PoisonDetectionLevel then
                item:setPoisonDetectionLevel(itemData.RasFarming.PoisonDetectionLevel)
                itemData.RasFarming.PoisonDetectionLevel = nil 
          end
    end
end




