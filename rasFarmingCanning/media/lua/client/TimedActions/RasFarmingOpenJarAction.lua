-- defines a new TimedAction for opening a jar
--
--
-- by razab







local rasSharedData = require("RasFarmingSharedData")
local rasFarmingTables = rasSharedData.Tables
local rasUtils = require("RasFarmingClientUtils")




-- some auxiliary functions which give the open jars the correct stats:
local function makeVanillaCraftedJar(player, jar, result) -- for jars crafted in vanilla before addition of the mod

      -- set correct age and durability
      local jarAge = jar:getAge()
      if jar:isCooked() then -- for cooked jars...
           local jarMaxAge = jar:getOffAgeMax()
           local jarStaleAge = jar:getOffAge()
           local resultMaxAge = result:getOffAgeMax()
           local resultStaleAge = result:getOffAge()
           if jarAge >= jarMaxAge then -- if jar is rotten, make open jar rotten
                  result:setAge(resultMaxAge)
           elseif jarAge >= jarStaleAge then -- if jar is stale, make open jar stale
                  if jarMaxAge - jarAge >= resultMaxAge - resultStaleAge then
                      result:setAge(resultStaleAge)
                  else
                      result:setAge(resultMaxAge - (jarMaxAge - jarAge))
                  end
           else -- if jar is fresh, make open jar fresh
                  if jarStaleAge - jarAge >= resultStaleAge then
                       result:setAge(0) 
                  else
                       result:setAge(resultStaleAge - (jarStaleAge - jarAge))
                  end
           end
     else         
         result:setAge(jarAge) -- in case jar hasn't been cooked, the open jar inherits the age of the original food item       
     end
     
     -- for remaining stats, take the default values of RasOpenJar item     
end



local function makeNormalJar(player, jar, result) -- for normal jars
 
      -- set correct age and durability
      local jarAge = jar:getAge()
      if jar:isCooked() then -- for cooked jars...
           local jarMaxAge = jar:getOffAgeMax()
           local jarStaleAge = jar:getOffAge()
           local resultMaxAge = result:getOffAgeMax()
           local resultStaleAge = result:getOffAge()
           if jarAge >= jarMaxAge then -- if jar is rotten, make open jar rotten
                  result:setAge(resultMaxAge)
           elseif jarAge >= jarStaleAge then -- if jar is stale, make open jar stale
                  if jarMaxAge - jarAge >= resultMaxAge - resultStaleAge then
                      result:setAge(resultStaleAge)
                  else
                      result:setAge(resultMaxAge - (jarMaxAge - jarAge))
                  end
           else -- if jar is fresh, make open jar fresh
                  if jarStaleAge - jarAge >= resultStaleAge then
                       result:setAge(0) 
                  else
                       result:setAge(resultStaleAge - (jarStaleAge - jarAge))
                  end
           end
     else         
         result:setAge(jarAge) -- in case jar hasn't been cooked, the open jar inherits the age of the original food item       
     end
     
     -- set correct nutritional values
     local jarData = jar:getModData()
     local cookingSkill = 0
     if jarData.RasFarming then
         if jarData.RasFarming.CookingSkill and jar:isCooked() then
             cookingSkill = math.floor(jarData.RasFarming.CookingSkill)
         end
     end
     local bonusFactor = 1 + ((cookingSkill*2) / 100) -- the bonus factor we gave the jar's stats coming from palyer's cooking skill     


     local factor = jar:getCalories()/ (math.floor(result:getCalories() * bonusFactor)) -- take bonus factor coming from player's cooking skill in account
     local hunger = bonusFactor * result:getBaseHunger() * factor -- in case less food with lower nutirional values than default has been used, give the jar less hunger redcution (this is done by "factor")
     
     result:setCalories(jar:getCalories()) -- set stats; coming from the jar which has been opened
     result:setCarbohydrates(jar:getCarbohydrates())
     result:setLipids(jar:getLipids())
     result:setProteins(jar:getProteins())
     result:setHungChange(hunger)
     
     local poison = jar:getPoisonPower()
     local poisonDect = jar:getPoisonDetectionLevel()
     result:setPoisonPower(poison)
     result:setPoisonDetectionLevel(poisonDect)
     
     if poison > 0 then
         local playerData = player:getModData()
         local resultData = result:getModData()
         rasUtils.transferPoisonKnowledge(nil, playerData, nil, jarData, nil, resultData) -- set poison knowledge    
     end 
end


local function makePickles(player, jar, result) -- for pickles

     -- set correct age and durability
     if jar:isCooked() then
         local resultMaxAge = 14   -- pickled food has longer durability when opened than basic jars
         local resultStaleAge = 10        
         if jar:getFullType() == "Base.RasCannedPickledPotato" then -- vanilla potatoes have long durability, so make their durability when pickled even longer
             resultMaxAge = 32      
             resultStaleAge = 24
         end
         result:setOffAgeMax(resultMaxAge)       
         result:setOffAge(resultStaleAge) 
         local jarAge = jar:getAge()
         local jarMaxAge = jar:getOffAgeMax()
         local jarStaleAge = jar:getOffAge()
         if jarAge >= jarMaxAge then -- if jar is rotten, make open jar rotten
                result:setAge(resultMaxAge)
         elseif jarAge >= jarStaleAge then -- if jar is stake, make open jar stale
                if jarMaxAge - jarAge >= resultMaxAge - resultStaleAge then
                    result:setAge(resultStaleAge)
                else
                    result:setAge(resultMaxAge - (jarMaxAge - jarAge))
                end
         else -- if jar is fresh, make open jar fresh
                 if jarStaleAge - jarAge >= resultStaleAge then
                       result:setAge(0)
                 else
                       result:setAge(resultStaleAge - (jarStaleAge - jarAge))  
                 end 
         end      
     else
         result:setOffAgeMax(jar:getOffAgeMax()) -- in case jar hasn't been cooked, it has same age and durability as the original food item
         result:setOffAge(jar:getOffAge()) 
         result:setAge(jar:getAge())             
     end
    
     local jarData = jar:getModData()
     local cookingSkill = 0
     if jarData.RasFarming then
         if jarData.RasFarming.CookingSkill and jar:isCooked() then
              cookingSkill = math.floor(jarData.RasFarming.CookingSkill)
         end
     end
     local bonusFactor = 1 + ((cookingSkill*2) / 100) 

     
     local factor = jar:getCalories() / (math.floor( math.floor(result:getCalories() * 1.1) * bonusFactor )) -- *1.1 because pickled jar have 1.1 times the calories of their script.txt entries
     local hunger = bonusFactor * result:getBaseHunger() * factor
     result:setHungChange(hunger) 
     result:setBoredomChange(-10 * factor)

     result:setCalories(jar:getCalories())
     result:setCarbohydrates(jar:getCarbohydrates())
     result:setLipids(jar:getLipids())
     result:setProteins(jar:getProteins())
     
     local poison = jar:getPoisonPower()
     local poisonDect = jar:getPoisonDetectionLevel()
     result:setPoisonPower(poison)
     result:setPoisonDetectionLevel(poisonDect)
    
     if poison > 0 then
         local playerData = player:getModData()
         local resultData = result:getModData()
         rasUtils.transferPoisonKnowledge(nil, playerData, nil, jarData, nil, resultData) -- set poison knowledge    
     end 
end


local function makeFruitJam(player, jar, result) -- for fruit jam ...
 
     -- set correct age and durability
     if jar:isCooked() then
         local resultMaxAge = 14
         local resultStaleAge = 10
         result:setOffAgeMax(resultMaxAge) -- fruit jams have longer durability when opened than basic jars      
         result:setOffAge(resultStaleAge) 
         local jarAge = jar:getAge()
         local jarMaxAge = jar:getOffAgeMax()
         local jarStaleAge = jar:getOffAge()
         if jarAge >= jarMaxAge then -- if jar is rotten, make open jar rotten
                result:setAge(resultMaxAge)
         elseif jarAge >= jarStaleAge then -- if jar is stale, make open jar stale
                if jarMaxAge - jarAge >= resultMaxAge - resultStaleAge then
                       result:setAge(resultStaleAge)
                else
                       result:setAge(resultMaxAge - (jarMaxAge - jarAge))
                end
         else  -- if jar is fresh, make open jar fresh
                if jarStaleAge - jarAge >= resultStaleAge then
                      result:setAge(0) 
                else 
                      result:setAge(resultStaleAge - (jarStaleAge - jarAge))  
                end
         end      
     else
         result:setOffAgeMax(jar:getOffAgeMax()) -- in case jar hasn't been cooked, it has same age and durability as the original food item
         result:setOffAge(jar:getOffAge()) 
         result:setAge(jar:getAge())             
     end
     

     result:setCalories(jar:getCalories()) -- set correct nutrition values and poison coming from the food items which have been used
     result:setCarbohydrates(jar:getCarbohydrates())
     result:setLipids(jar:getLipids())
     result:setProteins(jar:getProteins())
     
   
     local cookingSkill = 0
     local jarData = jar:getModData()
     if jarData.RasFarming then
         if jarData.RasFarming.CookingSkill and jar:isCooked() then
             cookingSkill = math.floor(jarData.RasFarming.CookingSkill)
         end
     end
     local bonusFactor = 1 + ((cookingSkill*2) / 100) 

     if jar:getCalories() > math.floor(459 * bonusFactor) then -- set hunger value
        result:setHungChange(-0.35 * bonusFactor) -- some berries have hunger reduction 10 instead of 5; so we give the jar a little more hunger reduction in this case
        result:setUnhappyChange(-10)
     elseif  jar:getCalories() == math.floor(459 * bonusFactor) then
        result:setHungChange(-0.3 * bonusFactor)
        result:setUnhappyChange(-10)
     else
        local factor = jar:getCalories() / (math.floor(459 * bonusFactor))
        result:setHungChange(-0.3 * factor * bonusFactor)
        result:setUnhappyChange(-10 * factor)
     end


     local poison = jar:getPoisonPower()
     local poisonDect = jar:getPoisonDetectionLevel()
     result:setPoisonPower(poison)
     result:setPoisonDetectionLevel(poisonDect)
     
     if poison > 0 then
         local playerData = player:getModData()
         local resultData = result:getModData()
         rasUtils.transferPoisonKnowledge(nil, playerData, nil, jarData, nil, resultData) -- set poison knowledge    
     end  
end






-- the code for the actual TimedAction:


local openJarAction = ISBaseTimedAction:derive("openJarAction")

function openJarAction:isValid()
	return self.character:getInventory():contains(self.item);
end

function openJarAction:start()
    if self.item ~= nil then
	    self.item:setJobType(getText("IGUI_JobType_PourOut"));
	    self.item:setJobDelta(0.0);
	    self:setActionAnim(CharacterActionAnims.Craft);
    end
end

function openJarAction:update()
    if self.item ~= nil then
        self.item:setJobDelta(self:getJobDelta());
    end
end

function openJarAction:stop()
    ISBaseTimedAction.stop(self);
end

function openJarAction:perform()
	--self:stopSound()
    if self.item ~= nil then
        local jar = self.item
        local jarType = self.item:getFullType()
        local resultType = rasFarmingTables.ClosedToOpen[jarType]
        local result = InventoryItemFactory.CreateItem(resultType)

        -- give the resulting jar correct stats
        if result then
            if rasFarmingTables.Jars[jarType] then -- for normal jars 
                  makeNormalJar(self.character, jar, result)
            elseif rasFarmingTables.PickledJars[jarType] then -- for pickles
                  makePickles(self.character, jar, result)
            elseif rasFarmingTables.Jams[jarType] then -- for fruit jams
                  makeFruitJam(self.character, jar, result)
            elseif rasFarmingTables.VanillaCraftedJars[jarType] then -- for jars crafted in vanilla game (in case mod is added to a running game)
                  makeVanillaCraftedJar(self.character, jar, result)
            end

            self.character:getInventory():AddItem(result)
            self.character:getInventory():AddItem("Base.JarLid") -- give player the jar lid back
            self.character:getInventory():Remove(jar)
        end
    end
    -- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self);
end


function openJarAction:new(character, item)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.character = character;
	o.item = item;
	o.stopOnWalk = false;
	o.stopOnRun = false;
	o.maxTime = 30
	if o.character:isTimedActionInstant() then o.maxTime = 1; end
	return o
end




return openJarAction





