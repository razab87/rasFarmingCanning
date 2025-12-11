-- timed action for adding content of a opened rotten jar to compost
--
--
-- by razab







local rasSharedData = require("RasFarmingSharedData")
local rasFarmingTables = rasSharedData.Tables
local rasUtils = require("RasFarmingClientUtils")





-- auxiliary function: checks if player knows whether jar is poisonous 
local function knowsPoison(playerData, jar)

        local jarData = jar:getModData()

        if jarData.RasFarming then
            if jarData.RasFarming.KnowsPoison then
                    return jarData.RasFarming.KnowsPoison[playerData.RasFarming.PlayerID]
           end
       end
       
       return false
end


-- the TimedAction code:

local openJarToCompostAction = ISBaseTimedAction:derive("openJarToCompostAction")


function openJarToCompostAction:isValid()
	return self.composter ~= nil and self.character:getInventory():contains(self.jar)
end

function openJarToCompostAction:start()
     self:setActionAnim("Loot");
     self:setOverrideHandModels(nil, nil)
end

function openJarToCompostAction:update()
	self.character:faceThisObject(self.composter)
    self.character:setMetabolicTarget(Metabolics.LightDomestic);
end

function openJarToCompostAction:stop()
    ISBaseTimedAction.stop(self);
end

function openJarToCompostAction:perform()
    local container = self.composter:getContainer()	
    local player = self.character
    local inv = player:getInventory()
    
    inv:Remove(self.jar)
    inv:AddItem("Base.EmptyJar")
    
    -- add rotten food items to composter; number of items which is added will depend on the hunger value of the jar
    local content = rasFarmingTables.Content[self.jar:getFullType()]   
    local food = InventoryItemFactory.CreateItem(content)
    food:setAge(food:getOffAgeMax()) -- make food rotten
    local hunger = self.jar:getHungChange()
    local foodHunger = food:getHungChange()

    local poison = self.jar:getPoisonPower()
    local poisonAmount = foodHunger/hunger
    local playerData = player:getModData() 
    local jarData = self.jar:getModData()      

    while foodHunger > hunger do -- note: hunger reduction values are negative!!

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
        
    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self);
end


function openJarToCompostAction:new(character, composter, jar)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character
	o.composter = composter
	o.jar = jar
	o.stopOnWalk = true
	o.stopOnRun = true
	o.maxTime = 70
	if o.character:isTimedActionInstant() then o.maxTime = 1; end
	return o
end


return openJarToCompostAction


