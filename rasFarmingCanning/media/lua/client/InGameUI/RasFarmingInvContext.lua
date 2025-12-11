-- this code introduces the options "Pour on Ground" and "Open Jar" for jars to their context menu and displays the recipe option for jars properly; the recipe menu is realized in a way so that the player cannot craft
-- jars from rotten food (cooking skill does not matter); for berries, it is possible to use different berry types in one the same jar; to realize all this, I add some 
-- "hidden food items" to player inventory which are not shown in the interface; the recipes are acutally defined for the hidden food items; when crafting, the player will still consume
-- the real food items (this is done via the code in the recipcode lua in this mod's server folder)
--
--
-- code modifies some vanilla functions from /lua/client/ISUI/ISInventoryPaneContextMenu.lua
--
--
-- by razab






local rasSharedData = require("RasFarmingSharedData")
local rasFarmingTables = rasSharedData.Tables

local rasUtils = require("RasFarmingClientUtils")





-- when pour a jar on ground has been clicked
local emptyJarAction = require("TimedActions/RasFarmingEmptyJarAction")
local function onEmptyJar(items, jar, player)
	if jar ~= nil then
		local playerObj = getSpecificPlayer(player)
		ISInventoryPaneContextMenu.transferIfNeeded(playerObj, jar)
		ISTimedActionQueue.add(emptyJarAction:new(playerObj, jar));
	end
end

-- when open jar has been clicked
local openJarAction = require("TimedActions/RasFarmingOpenJarAction")
local function onOpenJar(items, jar, player)
	if jar ~= nil then
		local playerObj = getSpecificPlayer(player)
		ISInventoryPaneContextMenu.transferIfNeeded(playerObj, jar)
		ISTimedActionQueue.add(openJarAction:new(playerObj, jar));
	end
end


-- add the options for opening jars etc. to right click menu
local vanilla_createMenu = ISInventoryPaneContextMenu.createMenu
function ISInventoryPaneContextMenu.createMenu(player, isInPlayerInventory, items, x, y, origin, ...)
       
        local playerObj = getSpecificPlayer(player)        
        local playerInv = playerObj:getInventory() 
        local playerData = playerObj:getModData()
        playerData.RasFarming.selectedContainer = nil -- must be nil by default; is used to store from which container player has selected a food item for crafting jars      

        local containerList = ISInventoryPaneContextMenu.getContainers(playerObj)
        rasUtils.addHiddenItems(playerInv, containerList) -- add hidden food items to inventory to trigger correct recipe display
 
        
        local context = vanilla_createMenu(player, isInPlayerInventory, items, x, y, origin, ...) -- execute vanilla code
  

        local openJar = nil 
        local closedJar = nil         
        local foodItem = nil
      
        local testItem = nil
        for i,v in ipairs(items) do
               testItem = v;        
               if not instanceof(v, "InventoryItem") then
                   testItem = v.items[1];
               end      
               local testItemType = testItem:getFullType()  


               if rasFarmingTables.PreservableFood[testItemType] then
                    if not testItem:isRotten() then --only non-rotten food can be used to make jars
                        foodItem = testItem
                    end


               elseif rasFarmingTables.JarsOpen[testItemType] or rasFarmingTables.PickledJarsOpen[testItemType] or rasFarmingTables.JamsOpen[testItemType] or rasFarmingTables.VanillaJarsOpen[testItemType] then
                       openJar = testItem


               elseif rasFarmingTables.Jars[testItemType] or rasFarmingTables.VanillaCraftedJars[testItemType] or rasFarmingTables.PickledJars[testItemType] or rasFarmingTables.Jams[testItemType] 
                      or rasFarmingTables.VanillaJars[testItemType] then
                        closedJar = testItem
               end                   
        end 


        if openJar then -- add pour-on-ground-option
           context:addOption(getText("ContextMenu_Pour_on_Ground"), items, onEmptyJar, openJar, player);
        end

        if closedJar then -- add open-jar-option
           context:addOption(getText("UI_rasFarming_OpenJar"), items, onOpenJar, closedJar, player);
        end
        
        if foodItem then -- add recipe option and tooltip for jarring to food items
               local hiddenFood = playerInv:getItemFromType( rasFarmingTables.PreservableFood[foodItem:getFullType()] ) -- get corresponding "hidden" food item from player inventory
               if hiddenFood then 
                   local hiddenFoodData = hiddenFood:getModData()
                   if not hiddenFoodData.RasFarming then 
                            hiddenFoodData.RasFarming = {}
                   end
                   hiddenFoodData.RasFarming.selectedContainer = foodItem:getContainer() -- keep track of the container the player has chosen food from             
                   local recipe = RecipeManager.getUniqueRecipeItems(hiddenFood, playerObj, containerList);
                   if recipe then
                        ISInventoryPaneContextMenu.addDynamicalContextMenu(hiddenFood, context, recipe, player, containerList);
                   end
               end
        end
                        
        return context       
end




-- next functions handle display and execution of the recipes for creating jars


-- when crafting a jar make sure to add enough food items from surrounding containers to player inventory; will not be done automatically by game
-- since the actual recipes are only defined for hidden food items
local vanilla_onCraft = ISInventoryPaneContextMenu.OnCraft
function ISInventoryPaneContextMenu.OnCraft(selectedItem, recipe, player, all, ...)
           
           --collect the actual food items from surrounding containers and put them into player inventory
           local result = recipe:getResult():getFullType()
           if result == "Base.RasDefaultBerryJam" then 

                   local playerObj = getSpecificPlayer(player)
                   rasUtils.transferAvailableBerriesNeeded(playerObj, selectedItem, nil) -- transfer required berries
 

           elseif rasFarmingTables.Jars[result] or rasFarmingTables.PickledJars[result] or rasFarmingTables.Jams[result] then

                   local playerObj = getSpecificPlayer(player)
                   rasUtils.transferAvailableIngredientsNeeded(playerObj, result, selectedItem, nil) -- transfer required ingredients

           end

           vanilla_onCraft(selectedItem, recipe, player, all, ...) -- execute Vanilla code
end



-- this function is called when player crafts more than 1 item (i.e. selects "all"); again, put food items from surrounding containers to player inventory
local vanilla_onCraftComplete = ISInventoryPaneContextMenu.OnCraftComplete
function ISInventoryPaneContextMenu.OnCraftComplete(completedAction, recipe, playerObj, container, containers, selectedItemType, selectedItemContainer)
        

           local result = recipe:getResult():getFullType()
           if result == "Base.RasDefaultBerryJam" then 
                   
                 local action = rasUtils.transferAvailableBerriesNeeded(playerObj, nil, completedAction)
                 completedAction = action 

           elseif rasFarmingTables.Jars[result] or rasFarmingTables.PickledJars[result] or rasFarmingTables.Jams[result] then
                    
                local action = rasUtils.transferAvailableIngredientsNeeded(playerObj, result, nil, completedAction) 
                completedAction = action             
 
           end

           vanilla_onCraftComplete(completedAction, recipe, playerObj, container, containers, selectedItemType, selectedItemContainer) -- execute vanilla code

end



-- modify vanilla function "CraftTooltip.addText" so that the hidden items are displayed correctly in the recipe tooltip (and not as "Base.RasHidden..."); this is necessary since the hidden
-- items don't have a display name because they shouldn't be displayed in the inventory
local vanilla_addText = ISRecipeTooltip.addText
function ISRecipeTooltip.addText(self, x, y, text, r, g, b, ...)
 
      if rasFarmingTables.DisplayName[text] then
           local oldText = text
           text = getText(rasFarmingTables.DisplayName[oldText])
      end

      vanilla_addText(self, x, y, text, r, g, b, ...)  -- execute vanilla code
end




-- modify the vanilla function which generates the options for evolved recipes so that vanilla items peanut butter, fruit jam,
-- marmalade and marinara cannot be used for the recipes anymore (they can only be used when opened)
local vanilla_doEvorecipeMenu = ISInventoryPaneContextMenu.doEvorecipeMenu
function ISInventoryPaneContextMenu.doEvorecipeMenu(context, items, player, evorecipe, baseItem, containerList, ...)


        -- temporarily remove the items from surrounding containers to suppress the recipe
        local backUpListPeanut = {}
        local backUpListJam = {}
        local backUpListMarmalade = {}
        local backUpListMarinara = {}
        for i=1,containerList:size() do
                 local container = containerList:get(i-1)
                 backUpListPeanut[i]  = container:getAllType("Base.PeanutButter")
                 backUpListJam[i]  = container:getAllType("Base.JamFruit")
                 backUpListMarmalade[i]  = container:getAllType("Base.JamMarmalade")
                 backUpListMarinara[i]  = container:getAllType("Base.Marinara")              
                 container:RemoveAll("PeanutButter")
                 container:RemoveAll("JamFruit")
                 container:RemoveAll("JamMarmalade")
                 container:RemoveAll("Marinara")
        end
 
        vanilla_doEvorecipeMenu(context, items, player, evorecipe, baseItem, containerList, ...) -- execute vanilla

        -- put the items back
        for i=1,containerList:size() do
              local container = containerList:get(i-1)
              local peanut = backUpListPeanut[i]
              for j=1,peanut:size() do
                   container:addItem(peanut:get(j-1))
              end
              local jam = backUpListJam[i]
              for j=1,jam:size() do
                   container:addItem(jam:get(j-1))
              end
              local marmalade = backUpListMarmalade[i]
              for j=1,marmalade:size() do
                   container:addItem(marmalade:get(j-1))
              end
              local marinara = backUpListMarinara[i]
              for j=1,marinara:size() do
                   container:addItem(marinara:get(j-1))
              end
        end
end




