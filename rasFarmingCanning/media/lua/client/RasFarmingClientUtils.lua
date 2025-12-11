-- some auxiliary functions we will use on several occassions in client code
--
--
-- by razab


local rasSharedData = require("RasFarmingSharedData")
local rasFarmingTables = rasSharedData.Tables



local function predicateNotRotten(item)
      return (not item:isRotten())
end


-- grab n berries from surrounding containers and put them to a lua table; in case we have a selectedContainer, take the first berry
-- from this one
local function grabBerries(n, playerObj, playerInv, selectedContainer)
       local result = {}
       local k = 0
       
       local selectedBerry = nil
       if selectedContainer then -- as in vanilla, use the selected item for crafting          
           for v,_ in pairs(rasFarmingTables.Berries) do
               selectedBerry = selectedContainer:getFirstTypeEval(v, predicateNotRotten)
               if selectedBerry then break; end
           end
          
           if selectedBerry then
              table.insert(result, selectedBerry)
              k = 1 
           else
              print("Mod_rasFarming_Warning: Something wrong in grabBerries(), Utils, client")
           end
       end

       -- select enough remaining berries; prioritize selecting from player inventory
       if k < n then
               for v,_ in pairs(rasFarmingTables.Berries) do
                       local berries = playerInv:getAllTypeEval(v, predicateNotRotten)
                       for j = 1,berries:size() do
                            local berry = berries:get(j-1) 
                            if berry ~= selectedBerry then -- selectedBerry is nil or already in our list
                               table.insert(result, berry)
                               k = k + 1
                            end 
                            if k == n then break; end
                       end
                       if k == n then break; end
               end

               if k < n then  -- grab berries from remaining containers
                    local containerList = ISInventoryPaneContextMenu.getContainers(playerObj)
                    for i=1,containerList:size() do
                          local container = containerList:get(i-1)
                          if container ~= playerInv then -- inventory has been searched above
                              for v,_ in pairs(rasFarmingTables.Berries) do
                                     local berries = container:getAllTypeEval(v, predicateNotRotten)
                                     for j=1,berries:size() do
                                           local berry = berries:get(j-1)
                                           if berry ~= selectedBerry then
                                               table.insert(result, berry)
                                               k = k + 1
                                           end
                                           if k == n then break; end  
                                     end 
                                     if k == n then break; end
                              end
                          end
                          if k == n then break; end
                    end
               end
       end

       return {items = result, number = k} -- may happen that we found less than n berries, therefore return their actual number k as well
end


-- grab n non-berry ingredients from surrounding containers
local function grabIngredients(n, ingredient, playerObj, playerInv, selectedContainer)
       local result = {}
       local k = 0
       
       local selectedItem = nil
       if selectedContainer then -- as in vanilla, use the selected item for crafting          
           selectedItem = selectedContainer:getFirstTypeEval(ingredient, predicateNotRotten)          
           if selectedItem then
              table.insert(result, selectedItem)
              k = 1 
           else
              print("Mod_rasFarming_Warning: Something wrong in grabIngredients(), Utils, client")
           end
       end

       -- select enough remaining items; prioritize selecting from player inventory
       if k < n then
               local items = playerInv:getAllTypeEval(ingredient, predicateNotRotten)
               for j = 1,items:size() do
                    local item = items:get(j-1)
                    if item ~= selectedItem then -- selectedItem is nil or already in our list
                       table.insert(result, item)
                       k = k + 1
                    end 
                    if k == n then break; end
               end

               if k < n then  -- grab items from remaining containers
                    local containerList = ISInventoryPaneContextMenu.getContainers(playerObj)
                    for i=1,containerList:size() do
                          local container = containerList:get(i-1)
                          if container ~= playerInv then
                                 local items = container:getAllTypeEval(ingredient, predicateNotRotten)
                                 for j=1,items:size() do
                                       local item = items:get(j-1)
                                       if item ~= selectedItem then
                                           table.insert(result, item)
                                           k = k + 1
                                       end
                                       if k == n then break; end  
                                 end 
                          end
                          if k == n then break; end
                    end
               end
       end
 
       return {items = result, number = k}
end






--here are the main functions; can be called via require("RasFarmingClientUtils") in other luas
local clientUtils = {}

-- try getting all berries from surrounding containers needed for berry jam and put them to player inventory; in case we have
-- a selected item, use this as well; if we have a previous action, append the new actions to it
function clientUtils.transferAvailableBerriesNeeded(playerObj, selectedItem, previousAction)

       local inv = playerObj:getInventory()              
       local selectedContainer = nil
       if selectedItem then
           if selectedItem:getFullType() == "Base.RasHiddenBerry" then
                   local selectedItemData = selectedItem:getModData()
                   if selectedItemData.RasFarming then    
                      selectedContainer = selectedItemData.RasFarming.selectedContainer -- the container from which the food item has been chosen
                      selectedItemData.RasFarming = nil
                   end
           end      
       end
       local n = rasSharedData.FixedValues.RequiredBerries             
       local ingredients = grabBerries(n, playerObj, inv, selectedContainer) -- grab berries from surrounding containers

       if ingredients.number < n then -- in case we didn't find enough berries, update player inventory accordingly so that the recipe is not executed
               inv:RemoveAll("RasHiddenBerry")  
               if previousAction then
                    return previousAction
               end
       else
           if previousAction then
               for _,item in pairs(ingredients.items) do
                     if item:getContainer() ~= inv then
                         local action = ISInventoryTransferAction:new(playerObj, item, item:getContainer(), inv, nil) 
                         if not action.ignoreAction then
                                 ISTimedActionQueue.addAfter(previousAction, action) -- transfer to player inventory
				                 previousAction = action
                         end  
                     end                 
               end
               return previousAction
           else
               for _,item in pairs(ingredients.items) do
                     if item:getContainer() ~= inv then
                         ISTimedActionQueue.add(ISInventoryTransferAction:new(playerObj, item, item:getContainer(), inv, nil)) -- transfer to player inventory
                     end
               end    
           end
       end
end


-- try getting non-berry ingredients from surrounding containers needed for jar recipes
function clientUtils.transferAvailableIngredientsNeeded(playerObj, result, selectedItem, previousAction)

           local inv = playerObj:getInventory()   
           local selectedContainer = nil
           if selectedItem then
               if rasFarmingTables.HiddenFoodItems[selectedItem:getFullType()] then
                     local selectedItemData = selectedItem:getModData()
                     if selectedItemData.RasFarming then    
                        selectedContainer = selectedItemData.RasFarming.selectedContainer -- the container from which the food item has been chosen
                        selectedItemData.RasFarming = nil
                     end
               end      
           end           
           local name = string.gsub(result, "Base.", "") 
           local n = rasFarmingTables["Recipes"][name]["number"]
           local ingredient = rasFarmingTables["Recipes"][name]["ingredient"]             
           local ingredients = grabIngredients(n, ingredient, playerObj, inv, selectedContainer) -- grab ingredients from surrounding containers

           if ingredients.number < n then
                  local hiddenItem = rasFarmingTables.PreservableFood[ingredient]
                  local hiddenItemName = string.gsub(hiddenItem, "Base.", "") 
                  inv:RemoveAll(hiddenItemName)
                  if previousAction then
                        return previousAction
                  end
           else
               if previousAction then
                       for _,item in pairs(ingredients.items) do
                             if item:getContainer() ~= inv then
                                 local action = ISInventoryTransferAction:new(playerObj, item, item:getContainer(), inv, nil)
                                 if not action.ignoreAction then
                                     ISTimedActionQueue.addAfter(previousAction, action)
		                             previousAction = action
                                 end 
                             end                 
                       end
                       return previousAction 
               else
                       for _,item in pairs(ingredients.items) do
                         if item:getContainer() ~= inv then
                             ISTimedActionQueue.add(ISInventoryTransferAction:new(playerObj, item, item:getContainer(), inv, nil))
                         end                 
                   end 
               end 
          end
end


-- checks how many food items are present in surrounding containers and adds the same number of hidden food items to player inventory
function clientUtils.addHiddenItems(playerInv, containerList)
             
      for i=1,containerList:size() do 
          local container = containerList:get(i-1)
          for hiddenItem,_ in pairs(rasFarmingTables.HiddenFoodItems) do
                 if hiddenItem ~= "Base.RasHiddenBerry" then -- berries get special treatment below
                      local foodItem = rasFarmingTables.HiddenFoodItems[hiddenItem] 
                      local n = container:getAllTypeEval(foodItem, predicateNotRotten):size()
                      local name = string.gsub(hiddenItem, "Base.", "")
                      container:RemoveAll(name)  -- remove hidden items we may have added previously
                      playerInv:AddItems(hiddenItem, n)
                 else 
                      local n = 0
                      for berry,_ in pairs(rasFarmingTables.Berries) do
                           n = n + container:getAllTypeEval(berry, predicateNotRotten):size()
                      end  
                      container:RemoveAll("RasHiddenBerry")  -- remove hidden items we may have added previously
                      playerInv:AddItems("Base.RasHiddenBerry", n)
                 end
          end   
      end
end




-- transfers player's knowledge about poison from a poisonous item to a new item ("Data" are modData of the objects)
function clientUtils.transferPoisonKnowledge(player, playerData, item, itemData, newItem, newData)

            if itemData.RasFarming then
                   if itemData.RasFarming.KnowsAboutPoison then
                        if itemData.RasFarming.KnowsAboutPoison[playerData.RasFarming.PlayerID] then
                               if not newData.RasFarming then
                                    newData.RasFarming = {}
                                    newData.RasFarming.KnowsAboutPoison = {}
                                    newData.RasFarming.KnowsAboutPoison[playerData.RasFarming.PlayerID] = true
                                    return
                               elseif not newData.RasFarming.KnowsAboutPoison then
                                    newData.RasFarming.KnowsAboutPoison = {}
                                    newData.RasFarming.KnowsAboutPoison[playerData.RasFarming.PlayerID] = true
                                    return
                               else
                                    newData.RasFarming.KnowsAboutPoison[playerData.RasFarming.PlayerID] = true
                                    return
                               end
                        end
                   end
            end
 
            if player and item then -- in case item is poisonous berry/mushroom
                local herbType = item:getHerbalistType()
                if (herbType == "Berry" or herbType == "Mushroom") and player:isRecipeKnown("Herbalist") then
                       if not newData.RasFarming then
                            newData.RasFarming = {}
                            newData.RasFarming.KnowsAboutPoison = {}
                            newData.RasFarming.KnowsAboutPoison[playerData.RasFarming.PlayerID] = true
                       elseif not newData.RasFarming.KnowsAboutPoison then
                            newData.RasFarming.KnowsAboutPoison = {}
                            newData.RasFarming.KnowsAboutPoison[playerData.RasFarming.PlayerID] = true
                       else
                            newData.RasFarming.KnowsAboutPoison[playerData.RasFarming.PlayerID] = true
                       end
                end 
            end
end




return clientUtils




