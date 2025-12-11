-- apply some changes to vanilla item "Box of Jars" (it will contain 9 instead of 6 jars and lids, so we change weight and icon) and hide the vanilla recipe "Open Jar of ..." from the craft menu; the mod introduce its own
-- "Open Jar" function so the vanilla recipe isn't needed anymore
--
--
-- by razab




local function modifyJarBox()

  local name = "Base.BoxOfJars"
  local item = ScriptManager.instance:getItem(name)

  if item then
     item:DoParam("Icon = RasJarBox")
     item:DoParam("Weight = 2.7")
  end
end



local function removeOpenJarRecipes()

    local recipeNames = {"Open Jar of Broccoli", "Open Jar of Bell Peppers", "Open Jar of Cabbage", "Open Jar of Carrots", "Open Jar of Eggplants", "Open Jar of Leeks",
                         "Open Jar of Potatoes", "Open Jar of Red Radishes", "Open Jar of Tomatoes"}
    for _,v in pairs(recipeNames) do
       local recipe = getScriptManager():getRecipe(v) 
       if recipe then            
          recipe:setIsHidden(true)
       end
    end

end

	
Events.OnGameBoot.Add(modifyJarBox)
Events.OnGameBoot.Add(removeOpenJarRecipes)
	
	
