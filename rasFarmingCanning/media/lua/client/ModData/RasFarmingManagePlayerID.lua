-- give each player a unique ID to keep track of the player's knowledge about poisonous food (i.e. when players create food with poisonous ingredients and know they are poisonous, they should see in game that 
-- the resulting food is poisonous; should only apply to the creator of the food; other players can only see this with higher cooking skill, as in vanilla); the ID consists of the player's user name and the date when they 
-- logged into game for the first time; when players die, they get a new ID
--
--
-- by razab 




local function managePlayerIDInit(player, square) -- initialize player ID when new game starts

                local data = player:getModData()
                if not data.RasFarming then
                     data.RasFarming = {}
                end

                local userName = "Bob"
                if isClient() then
                    userName = player:getUsername() -- in mp, use the player's username
                else
                    local desc =  player:getDescriptor()
                    userName = desc:getForename() .. desc:getSurname() -- in sp, take the character's name
                end          
                local time = GameTime:getInstance()           
                local hour = time:getHour()
                local minute = time:getMinutes()
                local day = time:getDay()
                local month = time:getMonth()
                local year = time:getYear()
           

                local date = tostring(hour) .. tostring(minute) .. tostring(day) .. tostring(month) .. tostring(year) 
                data.RasFarming.PlayerID = userName .. "-" .. date
                data.RasFarming.GameStartDate = {}
                data.RasFarming.GameStartDate.Month = month -- store start month & year (this is for the farming xp fix when farming speed is set to slow or very slow)
                data.RasFarming.GameStartDate.Year = year
end



local function managePlayerIDOnLoad() -- when is game is loaded, check whether player has an ID and generate one if not (only needed when mod is added to existing game)
   
           local player = getPlayer()
           local data = player:getModData()

           if data.RasFarmingPlayerID then -- transfer modData from pre 1.1 version to the new modData
                if not data.RasFarming then
                      data.RasFarming = {}
                end
                data.RasFarming.PlayerID = data.RasFarmingPlayerID
                data.RasFarming.GameStartDate = {}
                data.RasFarming.GameStartDate.Month = data.RasFarmingPlayerStartMonth 
                data.RasFarming.GameStartDate.Year = data.RasFarmingPlayerStartYear 

                data.RasFarmingPlayerID = nil -- delete old mod data   
                data.RasFarmingPlayerStartMonth = nil
                data.RasFarmingPlayerStartYear = nil            
           end


           if not data.RasFarming then
               managePlayerIDInit(player, nil)
           elseif not data.RasFarming.PlayerID then 
               managePlayerIDInit(player, nil)
           end  
           
end



Events.OnGameStart.Add(managePlayerIDOnLoad) -- load game
Events.OnNewGame.Add(managePlayerIDInit) -- new game





