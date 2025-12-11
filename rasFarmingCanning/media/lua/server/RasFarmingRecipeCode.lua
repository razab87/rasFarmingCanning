-- here we realize the food preservation mechanics; we modify some functions from vanilla server/recipecode.lua by prefixing and appending code; we also make it so that opening a box of jar returns 9 jar lids instead
-- of 6
--
--
-- by razab



local rasSharedData = require("RasFarmingSharedData")
local rasFarmingTables = rasSharedData.Tables


local monthTable = { }
monthTable[0] = getText("UI_rasFarming_Jan")
monthTable[1] = getText("UI_rasFarming_Feb")
monthTable[2] = getText("UI_rasFarming_March")
monthTable[3] = getText("UI_rasFarming_April")
monthTable[4] = getText("UI_rasFarming_May")
monthTable[5] = getText("UI_rasFarming_June")
monthTable[6] = getText("UI_rasFarming_July")
monthTable[7] = getText("UI_rasFarming_Aug")
monthTable[8] = getText("UI_rasFarming_Sep")
monthTable[9] = getText("UI_rasFarming_Oct")
monthTable[10] = getText("UI_rasFarming_Nov")
monthTable[11] = getText("UI_rasFarming_Dec")

      
-- auxiliary function: calculate the expiry date of a jar
local function CalculateDate(jar)

      local currentAge = math.floor(jar:getAge())
      local maxAge = jar:getOffAgeMax()
      local time = GameTime:getInstance()
      local month = time:getMonth() -- note: month are counted starting with 0
      local day = time:getDay() -- note: days are counted starting with 0
      local year = time:getYear()
      local result = nil
      
      local timeToSpoil = maxAge - currentAge
      if timeToSpoil > 0 then
           local daysInMonth = time:daysInMonth(year, month) - (day + 1)
           while timeToSpoil > daysInMonth do
                 timeToSpoil = timeToSpoil - daysInMonth
                 month = month + 1
                 if month < 12 then
                     daysInMonth = time:daysInMonth(year, month)
                 else
                     year = year + 1
                     month = 0
                     daysInMonth = time:daysInMonth(year, month)
                 end 
            end
            result = monthTable[month] .. " " .. tostring(timeToSpoil) .. ", " .. tostring(year)
            local language = Translator.getLanguage():toString()
            if language == "DE" then
                 result = tostring(timeToSpoil) .. "." .. tostring(month + 1) .. "." .. tostring(year)
            end

            -- add new date formats here

      else
            result = "already_rotten"
      end
     
      return result       
end



local function predicateNotRotten(item)
    return (not item:isRotten())
end



-- auxiliary function: returns table containing n food ingredients from player inventory (not for foraged berries; they are treated below)
local function getIngredientsFromInventory(itemType, playerInv, n)
         local result = {}
         local tmpTable = playerInv:getAllTypeEval(itemType, predicateNotRotten)

         for i=1,tmpTable:size() do
                local item = tmpTable:get(i-1)
                table.insert(result, item)
                playerInv:Remove(item) -- remove item since it will be consumed during recipe creation
                if i == n then
                    return result
                end
         end

         print("Mod_rasFarming_Warning: Something wrong in getIngredientsFromInventory, RasFarmingRecipeCode, server")
         return result
end


-- auxiliary function: returns table containing n foraged berries from player inventory
local function getBerriesFromInventory(playerInv, n)
        local result = {}
        local count = 0

        for index,_ in pairs(rasFarmingTables.Berries) do
              local tmpTable = playerInv:getAllTypeEval(index, predicateNotRotten)
              for i=1,tmpTable:size() do
                   local item = tmpTable:get(i-1)
                   table.insert(result, item)
                   playerInv:Remove(item)
                   count = count + 1
                   if count == n then
                      return result
                   end
              end
        end

        print("Mod_rasFarmingMod_Warning: Something wrong in getBerriesFromInventory, RasFarmingRecipeCode, server")
        return result
end





-- here we set correct age, durability and nutrition values for food which is canned
local vanilla_CreateCannedFood = Recipe.OnCreate.CannedFood
function Recipe.OnCreate.CannedFood(items, result, player, ...)
      
    local resultId = result:getFullType()
    local moddedCannedFood = false
    if resultId == "Base.RasDefaultBerryJam" or resultId == "Base.RasStrawberryJam" or rasFarmingTables.Jars[resultId] or rasFarmingTables.PickledJars[resultId] then
        moddedCannedFood = true
    end 
   
    if not moddedCannedFood then
       vanilla_CreateCannedFood(items, result, player, ...) -- execute vanilla code in case a recipe is used which does not come from this mod (could happen when other canning mods enabled)
    else

       local playerInv = player:getInventory()
       local n = 0
       local ingredientsList = {} -- will contain the actual food items used for making jams/jars
       if resultId == "Base.RasDefaultBerryJam" then -- berry jam requires special treatement
             n = rasSharedData.FixedValues.RequiredBerries
             ingredientsList = getBerriesFromInventory(playerInv, n)
       else
             local name = string.gsub(resultId, "Base.", "")
             local ingredient = rasFarmingTables["Recipes"][name]["ingredient"]
             n = rasFarmingTables["Recipes"][name]["number"]
             ingredientsList = getIngredientsFromInventory(ingredient, playerInv, n) 
       end


       local food = nil
       local calories = 0
       local lipids = 0
       local carbohydrates = 0
       local proteins = 0
       local poison = 0
       local poisonDect = -1
       local hunger = 0
       local k = 1
       if items then
          for i=0,items:size() - 1 do 
              local currentItem = items:get(i)
              if rasFarmingTables.HiddenFoodItems[currentItem:getFullType()] then -- check whether item is actually a food item which is going to be canned (i.e. don't apply this to water, jars etc.)
                    if ingredientsList[k] then
                          currentItem = ingredientsList[k] -- take the actual food ingredient
                          k = k + 1
                    end                          
                    calories = calories + currentItem:getCalories() -- calculate nutrition values for the canned food
                    lipids = lipids + currentItem:getLipids()
                    carbohydrates = carbohydrates + currentItem:getCarbohydrates()
                    proteins = proteins + currentItem:getProteins()
                    hunger = hunger + currentItem:getHungChange()
                    poison = poison + currentItem:getPoisonPower()                 
                    if not food or (food:getAge() < currentItem:getAge()) or currentItem:isRotten() then
                        food = currentItem;
                    end
              end
          end
       end
       if food then

            if resultId == "Base.RasDefaultBerryJam" then -- give berry jam a random color for more variety
                 
                  local n = ZombRand(3)+1 
                  if n == 1 then
                     local myItem = InventoryItemFactory.CreateItem("Base.RasBlueBerryJam")      
                     result = myItem
                     player:getInventory():AddItem(result)
                  elseif n == 2 then
                     local myItem = InventoryItemFactory.CreateItem("Base.RasOrangeBerryJam") 
                     result = myItem
                     player:getInventory():AddItem(result)
                  else
                     local myItem = InventoryItemFactory.CreateItem("Base.RasRedBerryJam") 
                     result = myItem
                     player:getInventory():AddItem(result)
                  end
            end

            local cookingLvl = player:getPerkLevel(Perks.Cooking)
            local playerData = player:getModData()
            local resultData = result:getModData()
            resultData.RasFarming = {}
            resultData.RasFarming.CookingSkill = cookingLvl -- store the player's cooking skill in the jar's modData (used to calculate durability and nutrition values when cooked; see below)
          

            result:setAge(food:getAge());  -- set age and durability for the uncooked jar; those values are coming from the food items which are used
            result:setOffAgeMax(food:getOffAgeMax());
            result:setOffAge(food:getOffAge());
         
            -- add poison if the food item was poisonous or water was tainted
            if result:isTaintedWater() then 
                result:setPoisonPower(poison + 50) 
                result:setTaintedWater(false)
                result:setPoisonDetectionLevel(3) -- by default, players will be able to detect the poison with cooking skill 7
                if getSandboxOptions():getOptionByName("EnableTaintedWaterText"):getValue() then
                    resultData.RasFarming.KnowsAboutPoison = {} 
                    resultData.RasFarming.KnowsAboutPoison[playerData.RasFarming.PlayerID] = true -- player who created the jar will know that result is poisonous
                elseif poison > 0 and resultId == "Base.RasDefaultBerryJam" and player:isRecipeKnown("Herbalist") then
                    resultData.RasFarming.KnowsAboutPoison = {} 
                    resultData.RasFarming.KnowsAboutPoison[playerData.RasFarming.PlayerID] = true -- herbalist will know that result is poisonous if poisonous berries have been used
                end
            else
                result:setPoisonPower(poison)
                if poison > 0 then
                    result:setPoisonDetectionLevel(3)
                    if resultId == "Base.RasDefaultBerryJam" and player:isRecipeKnown("Herbalist") then -- in case poisonous berries have been used and player is herbalist...
                          resultData.RasFarming.KnowsAboutPoison = {} 
                          resultData.RasFarming.KnowsAboutPoison[playerData.RasFarming.PlayerID] = true -- player will know that result is poisonous
                    end
                else
                    result:setPoisonDetectionLevel(-1)
                end                
            end 

         

            if rasFarmingTables.Jars[result:getFullType()] then -- set values for basic jars
                 result:setCalories(calories) 
                 result:setCarbohydrates(carbohydrates)
                 result:setLipids(lipids)
                 result:setProteins(proteins)
            elseif rasFarmingTables.Jams[result:getFullType()] then -- if result is a fruit jam ...
                   if hunger <= -0.4 then -- adjust the stats (based on the hunger reduction the berries give)
                       result:setCalories(467) 
                       result:setCarbohydrates(114)
                       result:setLipids(0.11)
                       result:setProteins(0.92)
                   elseif hunger > -0.4 and hunger <= -0.25 then
                       result:setCalories(459) 
                       result:setCarbohydrates(109)
                       result:setLipids(0.1)
                       result:setProteins(0.9)
                   else
                       local factor = hunger / (-0.25)
                       result:setCalories(math.floor(459 * factor)) 
                       result:setCarbohydrates(109 * factor)
                       result:setLipids(0.1 * factor)
                       result:setProteins(0.9 * factor)
                       result:setUnhappyChange(-10 * factor)
                   end
            elseif rasFarmingTables.PickledJars[result:getFullType()] then -- if result is jar with pickles ...
                   local factor = calories / result:getCalories()
                   result:setCalories(math.floor(calories * 1.1)) -- some boni to nutritional values
                   result:setCarbohydrates(carbohydrates * 1.1)
                   result:setLipids(lipids * 1.1)
                   result:setProteins(proteins * 1.1)
                   result:setBoredomChange(-10 * factor)
            end   
       end
   end
end





-- if jar gets cooked, we give it long durability; takes the cooking skill of the player into account; also increase nutrion values when player has high cooking skill
local vanilla_CannedFood_OnCooked = CannedFood_OnCooked
function CannedFood_OnCooked(cannedFood, ...)
    
    local age = cannedFood:getAge()
    local maxAgeFresh = cannedFood:getOffAge()
    local maxAgeTotal = cannedFood:getOffAgeMax()
    
    vanilla_CannedFood_OnCooked(cannedFood, ...) -- execute vanilla code 
    

    local jarId = cannedFood:getFullType()
    if rasFarmingTables.Jams[jarId] or rasFarmingTables.Jars[jarId] or rasFarmingTables.PickledJars[jarId] then -- do not apply this to items coming from other mods

             -- set durability of cooked jar taking player's cooking skill into account         
             local cookingLvl = 0
             local data = cannedFood:getModData()
             if data.RasFarming and data.RasFarming.CookingSkill then
                  cookingLvl = math.floor(data.RasFarming.CookingSkill)
             end
             local timeFresh = 20 * cookingLvl
             local timeNotRotten = 30 * cookingLvl
             cannedFood:setOffAge(60 + timeFresh)
             cannedFood:setOffAgeMax(90 + timeNotRotten)
        
             if age >= maxAgeTotal then -- rotten food results in a rotten jar
                 cannedFood:setAge(90 + timeNotRotten)
             elseif age >= maxAgeFresh then -- stale food results in a stale jar
                cannedFood:setAge(60 + timeFresh)
             else -- fresh food gives a fresh jar
                cannedFood:setAge(0)
             end
             
             if data.RasFarming then -- set expiryDate
                  data.RasFarming.ExpiryDate = CalculateDate(cannedFood) 
             else
                  data.RasFarming = {}
                  data.RasFarming.ExpiryDate = CalculateDate(cannedFood)
             end

             -- set data for nutrinional values; they increase with cooking skill
             if cookingLvl > 0 then
                local bonusFactor = 1 + ((cookingLvl*2) / 100) -- max value is 1.2
                local calories = cannedFood:getCalories() -- calculate nutrition values for the canned food
                local lipids = cannedFood:getLipids()
                local carbohydrates = cannedFood:getCarbohydrates()
                local proteins = cannedFood:getProteins()
                cannedFood:setCalories(math.floor(calories * bonusFactor))
                cannedFood:setLipids(lipids * bonusFactor)
                cannedFood:setCarbohydrates(carbohydrates * bonusFactor)
                cannedFood:setProteins(proteins * bonusFactor)
             end
    end

end




-- patched Recipe.OnCreate for opening Box of Jars: it now returns 9 jar lids instead of 6
local vanilla_OpenBoxOfJars = Recipe.OnCreate.OpenBoxOfJars
function Recipe.OnCreate.OpenBoxOfJars(items, result, player, ...)
    
    vanilla_OpenBoxOfJars(items, result, player, ...) -- execute vanilla code
    player:getInventory():AddItems("Base.JarLid", 3) -- 3 additional jar lids
end














