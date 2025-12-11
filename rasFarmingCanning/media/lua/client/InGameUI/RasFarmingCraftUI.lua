-- we manipulate the craft ui menu so that the recipes for jars are displayed correctly and crafting jars is possible via this menu; also makes it so that some vanilla items peanut or marinara 
-- cannot be used for recipes when they are not opened; modifies functions from lua lua/client/ISUI/ISCraftingUI.lua
--
--
-- by razab




local rasSharedData = require("RasFarmingSharedData")
local rasFarmingTables = rasSharedData.Tables


local rasUtils = require("RasFarmingClientUtils")



-- is needed to update the availability of a recipe when player moves; whenever players move, update the number
-- of hidden items in their inventory
local function updateOnMove(player)

       local containerList = ISInventoryPaneContextMenu.getContainers(player)
       local inv = player:getInventory()

       rasUtils.addHiddenItems(inv, containerList) 
end



-- make the recipes for jars executebale from craft menu; we need to add HiddenItems to surrounding containers for this; also temporarily remove closed peanut butter, marinara etc. so that the evolved recipes
-- for them is not exectuable when they are still closed (vanilla game would make them executable otherwise)

local IN_GAME = false -- will be true after game has started
local vanilla_populateRecipesList = ISCraftingUI.populateRecipesList
function ISCraftingUI.populateRecipesList(self, ...)

     if IN_GAME then
        Events.OnPlayerMove.Add(updateOnMove) -- is needed to update the availability of a recipe when player moves; will be remove from events when craft menu is closed
     end

     self:getContainers()
     local containerList = self.containerList
     
     local backUpListPeanut = {}
     local backUpListJam = {}
     local backUpListMarmalade = {}
     local backUpListMarinara = {}

     if containerList then       

        local inv = self.character:getInventory()
        rasUtils.addHiddenItems(inv, containerList) -- add hidden items to player inventory

        for i=1,containerList:size() do -- temporarily remove peanut butter etc.
              local container = containerList:get(i-1)
              backUpListPeanut[i]  = container:getAllTypeRecurse("Base.PeanutButter")
              backUpListJam[i]  = container:getAllTypeRecurse("Base.JamFruit")
              backUpListMarmalade[i]  = container:getAllTypeRecurse("Base.JamMarmalade")
              backUpListMarinara[i]  = container:getAllTypeRecurse("Base.Marinara")              
              container:RemoveAll("PeanutButter")
              container:RemoveAll("JamFruit")
              container:RemoveAll("JamMarmalade")
              container:RemoveAll("Marinara")
         end
     end

    vanilla_populateRecipesList(self, ...) -- execute vanilla code

    if containerList then  -- put peanut butter, marinara etc. back           
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

end


-- remove the updateOnMove() function from events when crafting menu is closed
local vanilla_close = ISCraftingUI.close
function ISCraftingUI.close(self, ...)
     Events.OnPlayerMove.Remove(updateOnMove) -- remove event
     vanilla_close(self, ...) -- execute vanilla code
end



-- when craft option for jars is selected, we manually transfer the required food ingredients to player inventory since the
-- actual recipe uses the "hidden items" for crafting and the game does not transfer the actual food (similar as in RasFarmingInvContext.lua)
local vanilla_craft = ISCraftingUI.craft
function ISCraftingUI.craft(self, button, all, ...)

              
        --collect the actual food items from surrounding containers and put them to player inventory
       local recipeListBox = self:getRecipeListBox()
       local recipe = recipeListBox.items[recipeListBox.selected].item.recipe
       local result = recipe:getResult():getFullType()
       if result == "Base.RasDefaultBerryJam" then 
               
             rasUtils.transferAvailableBerriesNeeded(self.character, nil, nil) -- tranfer berries to inventory

       elseif rasFarmingTables.Jars[result] or rasFarmingTables.PickledJars[result] or rasFarmingTables.Jams[result] then
               
             rasUtils.transferAvailableIngredientsNeeded(self.character, result, nil, nil) -- tranfer ingredients to inventory
 
       end

       vanilla_craft(self, button, all, ...) -- execute vanilla code

end


-- this function is called when crafting more than 1 item (select "all" in the menu); as above, transfer food items to inventory
local vanilla_onCraftComplete = ISCraftingUI.onCraftComplete
function ISCraftingUI.onCraftComplete(self, completedAction, recipe, container, containers)

      local result = recipe:getResult():getFullType()
      if result == "Base.RasDefaultBerryJam" then 
           
         local action = rasUtils.transferAvailableBerriesNeeded(self.character, nil, completedAction) -- tranfer berries to inventory
         completedAction = action

      elseif rasFarmingTables.Jars[result] or rasFarmingTables.PickledJars[result] or rasFarmingTables.Jams[result] then
           
         local action = rasUtils.transferAvailableIngredientsNeeded(self.character, result, nil, completedAction) -- tranfer ingredients to inventory
         completedAction = action

      end

      vanilla_onCraftComplete(self, completedAction, recipe, container, containers) -- execute vanilla code

end


-- correct recipe display
local vanilla_drawNonEvolvedIngredient = ISCraftingUI.drawNonEvolvedIngredient
function ISCraftingUI.drawNonEvolvedIngredient(self, y, item, alt, ...)

   if rasFarmingTables.DisplayName[item.text] then
       local oldText = item.text
       item.text = getText(rasFarmingTables.DisplayName[oldText])
   end

   return vanilla_drawNonEvolvedIngredient(self, y, item, alt, ...) -- execute vanilla code

end





-- we use this to correctly trigger the updateOnMove() function above; it should only be added to the event library when
-- game is actually running; we check this by making sure the first tick has occured 
local function onFirstTick(tick)
     IN_GAME = true
     Events.OnTick.Remove(onFirstTick) -- remove after first tick
end

Events.OnTick.Add(onFirstTick)






