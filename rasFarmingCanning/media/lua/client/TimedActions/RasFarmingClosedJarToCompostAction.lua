-- timed action for adding content of a rotten jar to compost
--
--
-- by razab





local rasSharedData = require("RasFarmingSharedData")
local rasFarmingTables = rasSharedData.Tables
local rasUtils = require("RasFarmingClientUtils")



local closedJarToCompostAction = ISBaseTimedAction:derive("closedJarToCompostAction")



function closedJarToCompostAction:isValid()
	return self.composter ~= nil and self.character:getInventory():contains(self.jar)
end



function closedJarToCompostAction:start()
     self:setActionAnim("Loot");
     self:setOverrideHandModels(nil, nil)
end

function closedJarToCompostAction:update()
	self.character:faceThisObject(self.composter)
    self.character:setMetabolicTarget(Metabolics.LightDomestic);
end

function closedJarToCompostAction:stop()
    ISBaseTimedAction.stop(self);
end

function closedJarToCompostAction:perform()
    local container = self.composter:getContainer()	
    local player = self.character
    local inv = player:getInventory()
    local closedJarType = self.jar:getFullType()
    
    inv:Remove(self.jar)
    inv:AddItem("Base.EmptyJar")
    inv:AddItem("Base.JarLid")

    -- make an opened version of the jar
    local openJarType = rasFarmingTables.ClosedToOpen[closedJarType]
    local openJar = InventoryItemFactory.CreateItem(openJarType)
    if openJar then
            openJar:setAge(openJar:getOffAgeMax()) -- make open jar rotten

            -- set correct values coming from the original jar
            local hunger = openJar:getBaseHunger()
            if not rasFarmingTables.VanillaCraftedJars[closedJarType] then
                local factor = self.jar:getCalories() / openJar:getCalories()
                hunger = factor * hunger

                openJar:setHungChange(hunger)
                openJar:setCalories(self.jar:getCalories()) 
                openJar:setCarbohydrates(self.jar:getCarbohydrates())
                openJar:setLipids(self.jar:getLipids())
                openJar:setProteins(self.jar:getProteins())
            end

            -- add rotten food items to composter; number of items which is added will depend on the hunger value of the open jar
            local content = rasFarmingTables.Content[openJarType]
            local food = InventoryItemFactory.CreateItem(content)
            if food then
                    food:setAge(food:getOffAgeMax()) -- make food rotten
                    hunger = openJar:getHungChange()
                    local foodHunger = food:getHungChange()

                    local poison = self.jar:getPoisonPower()
                    local poisonAmount = foodHunger/hunger
                    local playerData = player:getModData()
                    local jarData = self.jar:getModData()   
                        
                    while foodHunger > hunger do

                          -- transfer poison data
                          if poison > 0 then
                               food:setPoisonPower(math.max(math.floor(poison * poisonAmount),1))
                               food:setPoisonDetectionLevel(3)
                               local foodData = food:getModData()
                               rasUtils.transferPoisonKnowledge(nil, playerData, nil, jarData, nil, foodData)
                          end 

                          container:addItem(food)
                          hunger = hunger - foodHunger
                          food = InventoryItemFactory.CreateItem(content) 
                          food:setAge(food:getOffAgeMax())
                          --foodHunger = food:getHungChange()
                    end
                    
                    if hunger <= -0.05 then  -- adjust values for the last food item to be added

                       -- transfer poison data for last food item
                       if poison > 0 then
                              food:setPoisonPower(math.max(math.floor(poison * poisonAmount),1))
                              food:setPoisonDetectionLevel(3)
                              local foodData = food:getModData()
                              rasUtils.transferPoisonKnowledge(nil, playerData, nil, jarData, nil, foodData)
                      end 

                      food:setHungChange(hunger) 
                      local factor = hunger/foodHunger
                      food:setCalories(food:getCalories() * factor) 
                      food:setCarbohydrates(food:getCarbohydrates() * factor)
                      food:setLipids(food:getLipids() * factor)
                      food:setProteins(food:getProteins() * factor)
                      container:addItem(food)
                    end  
           end 
    end 
        
    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self);
end


function closedJarToCompostAction:new(character, composter, jar)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character;
	o.composter = composter;
	o.jar = jar
	o.stopOnWalk = true
	o.stopOnRun = true
	o.maxTime = 100
	if o.character:isTimedActionInstant() then o.maxTime = 1; end
	return o
end



return closedJarToCompostAction



