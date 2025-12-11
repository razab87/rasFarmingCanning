-- "fix" a vanilla mechanic: when farming speed is set to slow or very slow, player will get more xp when harvesting
--
--
-- by razab




local vanilla_gainXP = CFarmingSystem.gainXp
function CFarmingSystem.gainXp(self, player, luaObject, ...)
	
    vanilla_gainXP(self, player, luaObject, ...) -- execute vanilla code
   
    local time = GameTime:getInstance()
    local month = time:getMonth()
    local year = time:getYear()
    local playerData = player:getModData()
    local farmingSpeed = SandboxVars.Farming

    if playerData.RasFarming.GameStartDate.Year and playerData.RasFarming.GameStartDate.Month then
            if (farmingSpeed == 4 or farmingSpeed == 5) 
               and ((year > playerData.RasFarming.GameStartDate.Year) or (year == playerData.RasFarming.GameStartDate.Year and month > playerData.RasFarming.GameStartDate.Month)) then -- only when players are long enough in game

                 local xp = luaObject.health / 2
	             if luaObject.badCare == true then
		             xp = xp - 15
	             else
		             xp = xp + 25
	             end
	             if xp > 100 then
		             xp = 100
	             elseif xp < 0 then
		             xp = 0
	             end         

                 -- add additional skill points if farming speed set to slow or very slow
                 if farmingSpeed == 4 then -- slow farming speed (1.5*normal time -> give player 1.5 times the XP)
                     player:getXp():AddXP(Perks.Farming, xp * 0.5) 
                 elseif farmingSpeed == 5 then -- very slow farming speed (3*normal time -> give player 3 times the XP)
                     player:getXp():AddXP(Perks.Farming, xp * 2)
                 end
           end
   end
end



