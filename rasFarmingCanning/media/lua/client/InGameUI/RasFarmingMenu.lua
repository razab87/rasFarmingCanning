-- add more info to farming-related info screens and tooltips: depending on farming skill, tell the player that we are in farming season and/or that the plant may be harvested during farming season;
-- modfies function from lua/client/Farming/ISUI/ISFarmingMenu.lua and ISFarmingInfo.lua; also corrects a vanilla "bug" in ISFarmingMenu.lua (average growth time in display randomized, growth time not correctly 
-- displayed when farming speed set to slow or very slow)
--
--
-- by razab






local rasSharedData = require("RasFarmingSharedData")
local rasFarmingTables = rasSharedData.Tables
local startMonth = rasSharedData.FixedValues.startMonth -- start and end month of the growing season
local endMonth = rasSharedData.FixedValues.endMonth 


------------------------------- auxiliary functions --------------------------------------


-- check whether we are in farming season
local function InFarmingSeason(time, month, day, startDate, endDate)
      
       if month == startMonth and day+1 >= startDate then
             return true
       elseif month > startMonth and month < endMonth then
             return true
       elseif month == endMonth and day+1 < endDate then
             return true
       else
             return false
       end

end


-- checks whether crops can be harvested in farming season
local function CanBeHarvested(typeOfSeed, time, day, month, year, startDate, endDate)
                   
      -- compute amount of days the seed needs to grow
      local daysToGrow = (farming_vegetableconf.props[typeOfSeed].timeToGrow * 7) / 24
      if rasFarmingTables.FarmingSpeed[typeOfSeed] then -- take our data if possible
            daysToGrow = (rasFarmingTables.FarmingSpeed[typeOfSeed] * 7) / 24
      end

      local n = 3
      local farmingSpeed = SandboxVars.Farming  -- adjust value according to sandbox settings    
      if farmingSpeed == 1 then -- very fast
                 daysToGrow = math.floor(daysToGrow / 3)
                 n = math.floor(n / 3)
      elseif farmingSpeed == 2 then -- fast
                 daysToGrow = math.floor(daysToGrow / 1.5)
                 n = math.floor(n / 1.5)
      elseif farmingSpeed == 3 then -- normal
                 daysToGrow =math.floor(daysToGrow)
      elseif farmingSpeed == 4 then -- slow
                 daysToGrow = math.floor(daysToGrow * 1.5)
                 n = math.floor(n * 1.5)
      elseif farmingSpeed == 5 then -- very slow
                 daysToGrow = math.floor(daysToGrow * 3)
                 n = math.floor(n * 3)
      end
      daysToGrow = daysToGrow + n -- add some extra days since growth time is randomized      

      -- check if can be harvested in farming season
      if month == endMonth then
            if day + 1 + daysToGrow >= endDate then
                 return false
            else
                 return true
            end
      end
      local daysInMonth = time:daysInMonth(year, month) - (day + 1)
      while daysToGrow > daysInMonth do
                 daysToGrow = daysToGrow - daysInMonth
                 month = month + 1
                 if month == endMonth and daysToGrow >= endDate then
                           return false
                 end
                 daysInMonth = time:daysInMonth(year, month)
       end  

       return true 
end



-- add new info concerning farming seasons in the tooltip shown when planting
local vanilla_canPlow = ISFarmingMenu.canPlow
function ISFarmingMenu.canPlow(seedAvailable, typeOfSeed, option) 

       -- here we correct a vanilla bug so that farming speed is correctly shown (bug occured when farming speed has been changed in sandbox)
       local origData = farming_vegetableconf.props[typeOfSeed].timeToGrow -- backup data
       if rasFarmingTables.FarmingSpeed[typeOfSeed] then -- use our data if possibe
              farming_vegetableconf.props[typeOfSeed].timeToGrow = rasFarmingTables.FarmingSpeed[typeOfSeed] -- take our hardcoded values for correct display
       end
       local farmingSpeed = SandboxVars.Farming
       local defaultSpeed = farming_vegetableconf.props[typeOfSeed].timeToGrow
            
       if farmingSpeed == 1 then -- very fast
              farming_vegetableconf.props[typeOfSeed].timeToGrow = math.floor(defaultSpeed / 3)
       elseif farmingSpeed == 2 then -- fast
              farming_vegetableconf.props[typeOfSeed].timeToGrow = math.floor(defaultSpeed / 1.5)
       elseif farmingSpeed == 4 then -- slow
              farming_vegetableconf.props[typeOfSeed].timeToGrow = math.floor(defaultSpeed * 1.5)
       elseif farmingSpeed == 5 then -- very slow
              farming_vegetableconf.props[typeOfSeed].timeToGrow = math.floor(defaultSpeed * 3)
       end

       vanilla_canPlow(seedAvailable, typeOfSeed, option) -- execute vanilla code
       
       farming_vegetableconf.props[typeOfSeed].timeToGrow = origData -- restore original data       

       local player = getPlayer()
       local farmingLvl = player:getPerkLevel(Perks.Farming)
       local prof = player:getDescriptor():getProfession()
        
       if farmingLvl >= 2 then

             local startDate = player:getModData().RasFarming.Season.StartDate
             local endDate = player:getModData().RasFarming.Season.EndDate

             local time = GameTime:getInstance()
             local day = time:getDay()
             local month = time:getMonth()
             local colorA = " <RGB:1,1,1> "
             local textA = "ERROR_rasFarmingMod_something_is_missing"
             local season = InFarmingSeason(time, month, day, startDate, endDate)
       
             if season then
                 colorA = " <RGB:0,1,0> "
                 textA = getText("UI_rasFarming_InSeason")
             else
                colorA = " <RGB:1,0,0> "
                textA = getText("UI_rasFarming_NotInSeasonWarn")
             end

             local oldDescription = option.toolTip.description
             option.toolTip.description = oldDescription .. " <LINE> <LINE> " .. colorA .. textA
             

             if (farmingLvl >= 5 or prof == "farmer" or prof == "rasBotanist") and season then -- farming skill >= 5 or farmer profession gets even more info
                    local harvest = CanBeHarvested(typeOfSeed, time, day, month, time:getYear(), startDate, endDate)
                    local colorB = "<RGB:1,1,1>" 
                    local textB = "ERROR_rasFarmingMod_something_is_missing"                  

                    if harvest then
                        colorB = "<RGB:0,1,0>"
                        textB = getText("UI_rasFarming_CanBeHarvested")
                    else
                        colorB = "<RGB:1,0,0>"
                        textB = getText("UI_rasFarming_CanNotBeHarvested")
                    end

                    oldDescription = option.toolTip.description
                    option.toolTip.description = oldDescription .. " <LINE> <LINE> " .. colorB .. textB
             end
      end 

end


-- add new info in the farming menu which is shown when clicking on a crop -> info
local vanilla_render = ISFarmingInfo.render 
function ISFarmingInfo.render(self, ...)
       
        vanilla_render(self,...) -- execute vanilla code
        
        if not self:isPlantValid() then return end

        local player = getPlayer()
        local farmingLvl = player:getPerkLevel(Perks.Farming)  
        local prof = player:getDescriptor():getProfession()

        if farmingLvl >= 2 then -- only add info if farming skill is at least 2

              local startDate = player:getModData().RasFarming.Season.StartDate
              local endDate = player:getModData().RasFarming.Season.EndDate

              local hght = self:getHeight()
              local yPos = hght + 2;
              local font = UIFont.Small;
              local FONT_HGT_NORMAL = getTextManager():getFontHeight(UIFont.Normal)
              local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
              local boxHght = getTextManager():getFontHeight(UIFont.Small) + 5
              local time = GameTime:getInstance()
              local month = time:getMonth()
              local day = time:getDay()
              local season = InFarmingSeason(time, month, day, startDate, endDate)
              local specialInfo = false              

              if farmingLvl < 5 and prof ~= "farming" and prof ~= "rasBotanist" then 
                   if season then
                        self:drawText(getText("UI_rasFarming_InSeason"), 13, yPos, 0, 1, 0, 1, font)
                   else
                        self:drawText(getText("UI_rasFarming_NotInSeason"), 13, yPos, 1, 0, 0, 1, font)
                   end
              else  -- farming skill >= 5 or farmer profession or skill >=5 has even more info
                   if season then
                         if month == endMonth and endDate-4 <= day+1 then
                             self:drawText(getText("UI_rasFarming_SeasonOverSoon"), 13, yPos, 1, 0.5, 0, 1, font) 
                             self:drawText(getText("UI_rasFarming_ShouldHarvest"), 13, yPos + FONT_HGT_SMALL, 1, 0.5, 0, 1, font)
                             specialInfo = true
                         else
                             self:drawText(getText("UI_rasFarming_InSeason"), 13, yPos, 0, 1, 0, 1, font)
                         end
                   else
                         self:drawText(getText("UI_rasFarming_NotInSeason"), 13, yPos, 1, 0, 0, 1, font)
                   end
              end
              if specialInfo then
                  self:setHeightAndParentHeight(self.height + FONT_HGT_NORMAL + FONT_HGT_SMALL + 8)
              else
                  self:setHeightAndParentHeight(self.height + FONT_HGT_NORMAL + 8)
              end
        end
end




-- add more info to tooltip shown when hovering over the crop
local function specialTooltip(tooltip, square)

    local plant = CFarmingSystem.instance:getLuaObjectOnSquare(square)
    if not plant or plant.typeOfSeed == "none" then return end

    local player = getPlayer()
    local farmingLvl = player:getPerkLevel(Perks.Farming)  
    local prof = player:getDescriptor():getProfession()

    if farmingLvl >= 4 then -- vanilla game shows this tooltip only for farming skill >= 4

         local startDate = player:getModData().RasFarming.Season.StartDate
         local endDate = player:getModData().RasFarming.Season.EndDate
         
         local time = GameTime:getInstance()
         local day = time:getDay()
         local month = time:getMonth()
         local season = InFarmingSeason(time, month, day, startDate, endDate)
         local text = "ERROR_rasFarmingMod_something_is_missing"
         local r = 1
         local g = 1
         local b = 1

         if farmingLvl == 4 and prof ~= "farmer" and prof ~= "rasBotanist" then

               if season then
                      text = getText("UI_rasFarming_InSeason")
                      r = 0
                      g = 1
                      b = 0
               else
                      text = getText("UI_rasFarming_NotInSeason")
                      r = 1
                      g = 0
                      b = 0
               end

               tooltip:DrawTextureScaled(tooltip:getTexture(), 0, tooltip:getHeight(), tooltip:getWidth(), 10 + getTextManager():getFontHeight(tooltip:getFont()), 0.75) -- 0.75 = make tooltip box transparent
               tooltip:DrawText(tooltip:getFont(), text, 5, 15 + (getTextManager():getFontHeight(tooltip:getFont()) * 3), r, g, b, 1) 

         else -- skill >= 5 or farmer profession have even more info!
            
            local specialInfo = false
            local textB = "ERROR_rasFarmingMod_something_is_missing"
            if season then                   
                   if month == endMonth and endDate - 4 <= day+1 then
                          text = getText("UI_rasFarming_SeasonOverSoonA")
                          textB = getText("UI_rasFarming_SeasonOverSoonB")
                          r = 1
                          g = 0.5
                          b = 0
                          specialInfo = true
                   else
                         text = getText("UI_rasFarming_InSeason")
                         r = 0
                         g = 1
                         b = 0
                   end
            else
                   text = getText("UI_rasFarming_NotInSeason")
                   r = 1
                   g = 0
                   b = 0          
            end
             
            if specialInfo and season then
                tooltip:DrawTextureScaled(tooltip:getTexture(), 0, tooltip:getHeight(), tooltip:getWidth(), 10 + (2 * getTextManager():getFontHeight(tooltip:getFont())), 0.75)
                tooltip:DrawText(tooltip:getFont(), text, 5, 15 + (getTextManager():getFontHeight(tooltip:getFont()) * 3), r, g, b, 1)
                tooltip:DrawText(tooltip:getFont(), textB, 5, 15 + (getTextManager():getFontHeight(tooltip:getFont()) * 4), r, g, b, 1) 
            else
                tooltip:DrawTextureScaled(tooltip:getTexture(), 0, tooltip:getHeight(), tooltip:getWidth(), 10 + getTextManager():getFontHeight(tooltip:getFont()), 0.75) 
                tooltip:DrawText(tooltip:getFont(), text, 5, 15 + (getTextManager():getFontHeight(tooltip:getFont()) * 3), r, g, b, 1)
           end
        end
   end
end


Events.DoSpecialTooltip.Add(specialTooltip)










