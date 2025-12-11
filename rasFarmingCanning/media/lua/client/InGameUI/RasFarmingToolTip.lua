-- we add info about a jar's durability to its tooltip; modifies vanilla function ISToolTipInv:render from vanilla's client folder, ISUI
--
--
-- by razab



local rasSharedData = require("RasFarmingSharedData")
local rasFarmingTables = rasSharedData.Tables

-- we modify vanilla function ISToolTipInv.render so that additional info for the jar's expiry date is displayed
local vanilla_render = ISToolTipInv.render
function ISToolTipInv:render(...)

     vanilla_render(self, ...) -- execute vanilla code
          
     if not ISContextMenu.instance or not ISContextMenu.instance.visibleCheck then -- render the tool tip only if there's no context menu showed
         if self.item:getCategory() == "Food" then

             local itemId = self.item:getFullType()
             if self.item:isCooked() and (rasFarmingTables.Jars[itemId] or rasFarmingTables.PickledJars[itemId] or rasFarmingTables.Jams[itemId]) then 
             
                   if not self.item:isRotten() then
                          local data = self.item:getModData()
                          local expiryDate = nil
                          if data.RasFarming and data.RasFarming.ExpiryDate then
                                expiryDate = data.RasFarming.ExpiryDate
                          elseif data.RasExpiryDate then -- could happen after update to 1.1 with an old save game (TODO: remove later)
                                if not data.RasFarming then
                                    data.RasFarming = {}
                                end
                                data.RasFarming.ExpiryDate = data.RasExpiryDate
                                expiryDate = data.RasFarming.ExpiryDate
                                data.RasExpiryDate = nil -- delete pre-update modData
                          end
                          if expiryDate then 
                             local hght = self.tooltip:getHeight();
                             local yPos = hght + 2;
                             local font = UIFont.Small;
                             local boxHght = getTextManager():getFontHeight(UIFont.Small) + 5
                             self:drawRect(0, self.height, self.width, boxHght, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b);
                             self:drawRectBorder(0, self.height, self.width, boxHght, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b);
                             self:drawText(getText("UI_rasFarming_Until") .. " " .. expiryDate, 13, yPos, 1, 1, 0.8, 1, font);
                          end
                   end
             end
        end     
     end
end



