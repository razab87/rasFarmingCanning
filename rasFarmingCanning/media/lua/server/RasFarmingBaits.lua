-- add new type of baits to the trapping system; content of open jars can be used as baits provided that the same content can also be used as bait in the vanilla game
--
--
-- by razab





local function addBaits()

   for _,v in pairs(Animals) do
         if v.type == "rabbit" then
             v.baits["Base.RasCannedCarrotsOpen"] = 45
             v.baits["Base.RasCannedBellPepperOpen"] = 40 
             v.baits["Base.RasCannedCabbageOpen"] = 40 
             v.baits["Base.RasCannedPotatoOpen"] = 35
             v.baits["Base.RasCannedTomatoOpen"] = 35

             v.baits["Base.RasCarrotsBait"] = 45
             v.baits["Base.RasBellPepperBait"] = 40 
             v.baits["Base.RasCabbageBait"] = 40 
             v.baits["Base.RasPotatoBait"] = 35
             v.baits["Base.RasTomatoBait"] = 35
         elseif v.type == "squirrel" then
             v.baits["Base.RasVanillaPeanutButterOpen"] = 45
             v.baits["Base.RasCannedBellPepperOpen"] = 30

             v.baits["Base.RasBellPepperBait"] = 30
             v.baits["Base.RasPeanutButterBait"] = 45
         elseif v.type == "mouse" then
             v.baits["Base.RasVanillaPeanutButterOpen"] = 40
             v.baits["Base.RasCannedTomatoOpen"] = 35

             v.baits["Base.RasTomatoBait"] = 35
             v.baits["Base.RasPeanutButterBait"] = 40
         elseif v.type == "rat" then
             v.baits["Base.RasVanillaPeanutButterOpen"] = 40
             v.baits["Base.RasCannedTomatoOpen"] = 35

             v.baits["Base.RasTomatoBait"] = 35
             v.baits["Base.RasPeanutButterBait"] = 40
         end
   end

end





-- add above data when new game starts or when game is loaded
Events.OnGameStart.Add(addBaits)

Events.OnServerStarted.Add(addBaits) -- in multiplayer, function must be executed here (note: OnGameStart code seems not to be run on server??)


