-- add an option to the composter context menu which allows the player to add rotten food from jars; modifies the vanilla function ISWorldObjectContextMenu.handleCompost from vanilla's client folder, ISUI
--
--
-- by razab



local rasSharedData = require("RasFarmingSharedData")
local rasFarmingTables = rasSharedData.Tables



local function predicateIsRotten(item)
   return (item:isRotten())
end


-- auxiliary function: checks whether container contains a jar with rotten food;
local function checkContainerForRottenJars(container)
  
      local typesOfJars = {"JarsOpen", "PickledJarsOpen", "JamsOpen", "VanillaJarsOpen", "Jars", "PickledJars", "Jams", "VanillaCraftedJars"}

      for _,jarType in pairs(typesOfJars) do
          for v,_ in pairs(rasFarmingTables[jarType]) do
                  local item = container:getFirstTypeEval(v, predicateIsRotten)
                  if item then
                        return true
                  end 
          end 
      end
           
      return false
end




-- auxiliary function: checks whether player carries a container which contains a jar with rotten food; 
local function checkForRottenJars(player)
      
      -- check palyer inventory for rotten jars
      local inv = player:getInventory()       
      if checkContainerForRottenJars(inv) then
            return true
      end

      -- check backpacks/fanny packs for rotten jars
      local locationList = {"Back", "FannyPackFront", "FannyPackBack"}
      for _,location in pairs(locationList) do
              local bag = player:getWornItem(location)
              if bag and instanceof(bag, "InventoryContainer") then
                    local container = bag:getInventory()
                    if checkContainerForRottenJars(container) then
                         return true
                    end
              end
      end

       -- check equipped bags for rotten jars
      local itemA = player:getPrimaryHandItem()
      local itemB = player:getSecondaryHandItem()
      local itemList = {itemA, itemB}
      for _,item in pairs(itemList) do
              if item and instanceof(item, "InventoryContainer") then
                    local container = item:getInventory()
                    if checkContainerForRottenJars(container) then
                         return true
                    end
              end
      end


      return false
end




-- auxiliary function: collect jars with rotten food from container and write them into table
local function collectJarsFromContainer(container, openOrClosed)

       local rottenJars = { }

       local typesOfJars = {"JarsOpen", "PickledJarsOpen", "JamsOpen", "VanillaJarsOpen"}
       if openOrClosed == "closed" then
           typesOfJars = {"Jars", "PickledJars", "Jams", "VanillaCraftedJars"} -- note: crafted jars from vanilla game are always closed!
       end

       for _,jarType in pairs(typesOfJars) do           
           for v,_ in pairs(rasFarmingTables[jarType]) do
                   local jarsInContainer = container:getAllTypeEval(v, predicateIsRotten)
                   for i=1,jarsInContainer:size() do
                          local item = jarsInContainer:get(i-1)
                          table.insert(rottenJars,item)
                   end               
           end
       end
      
       return rottenJars
end



-- when option has been clicked, add all content from rotten jars to composter 
local openJarToCompostAction = require("TimedActions/RasFarmingOpenJarToCompostAction")
local closedJarToCompostAction = require("TimedActions/RasFarmingClosedJarToCompostAction")
local function onAddJarToComposter(player, composter)
       
       if not composter:getSquare() or not luautils.walkAdj(player, composter:getSquare(), true) then
		  return
       end
              
       local inv = player:getInventory()       
           
       local closedJars = collectJarsFromContainer(inv, "closed")
       local openJars = collectJarsFromContainer(inv, "open")
       
       -- add timed actions to queue
       for _,v in pairs(closedJars) do
             ISTimedActionQueue.add(closedJarToCompostAction:new(player, composter, v)) -- for closed jars
       end
       for _,v in pairs(openJars) do
             ISTimedActionQueue.add(openJarToCompostAction:new(player, composter, v)) -- for opened jars
       end

       -- for rotten jars in backpacks/fanny packs
       local locationList = {"Back", "FannyPackFront", "FannyPackBack"}
       for _,location in pairs(locationList) do
               local bag = player:getWornItem(location)
               if bag and instanceof(bag, "InventoryContainer") then
                    local container = bag:getInventory()
                    local closedJars = collectJarsFromContainer(container, "closed")
                    local openJars = collectJarsFromContainer(container, "open")

                    for _,v in pairs(closedJars) do
                        --ISInventoryPaneContextMenu.transferIfNeeded(player, v)
                        ISTimedActionQueue.add(ISInventoryTransferAction:new(player, v, container, inv))
                        ISTimedActionQueue.add(closedJarToCompostAction:new(player, composter, v)) -- for closed jars
                    end
                    for _,v in pairs(openJars) do
                        --ISInventoryPaneContextMenu.transferIfNeeded(player, v)
                        ISTimedActionQueue.add(ISInventoryTransferAction:new(player, v, container, inv))
                        ISTimedActionQueue.add(openJarToCompostAction:new(player, composter, v)) -- for opened jars
                    end
                    
               end
       end

       -- for bags equipped in hands
       local itemA = player:getPrimaryHandItem()
       local itemB = player:getSecondaryHandItem()
       local itemList = {itemA, itemB}
       for _,item in pairs(itemList) do
               if item and instanceof(item, "InventoryContainer") then
                    local container = item:getInventory()
                    local closedJars = collectJarsFromContainer(container, "closed")
                    local openJars = collectJarsFromContainer(container, "open")

                    for _,v in pairs(closedJars) do
                        --ISInventoryPaneContextMenu.transferIfNeeded(player, v)
                        ISTimedActionQueue.add(ISInventoryTransferAction:new(player, v, container, inv))
                        ISTimedActionQueue.add(closedJarToCompostAction:new(player, composter, v)) -- for closed jars
                    end
                    for _,v in pairs(openJars) do
                        --ISInventoryPaneContextMenu.transferIfNeeded(player, v)
                        ISTimedActionQueue.add(ISInventoryTransferAction:new(player, v, container, inv))
                        ISTimedActionQueue.add(openJarToCompostAction:new(player, composter, v)) -- for opened jars
                    end
                    
               end
       end

end




-- add new option to composter's world context menu
local vanilla_handleCompost = ISWorldObjectContextMenu.handleCompost
function ISWorldObjectContextMenu.handleCompost(test, context, worldobjects, playerObj, playerInv, ...)

           vanilla_handleCompost(test, context, worldobjects, playerObj, playerInv, ...) -- execute vanilla code
           if test == true then
              return true
           end           
             
       
           if checkForRottenJars(playerObj) then
              context:addOption(getText("UI_rasFarming_AddRottenFood"), playerObj, onAddJarToComposter, compost)
           end
           
           return false

end



