-- various tables and data which are used elsewhere in the code; accessible via require("RasFarmingSharedData")
--
--
-- by razab






local rasFarmingData = {}

rasFarmingData.FixedValues = {}

rasFarmingData.FixedValues.startMonth = 3 -- growing season starts in april (note: month and days are counted starting with 0)
rasFarmingData.FixedValues.endMonth = 9 -- growing season ends in october

rasFarmingData.FixedValues.RequiredBerries = 5 -- number of foraged berries required for making berry jam (note: must be changed here when recipe is changed!)




rasFarmingData.Tables = {}

-- table of "hidden" food items; they are not visible for the player and are used to 1. fix buggy vanilla behavior related to rotten food and 2. realize the fruit jams made out of
-- foraged berries (allow different berry types for one and the same recipe)
rasFarmingData.Tables.HiddenFoodItems = {}
rasFarmingData.Tables.HiddenFoodItems["Base.RasHiddenRedRadish"] = "farming.RedRadish"
rasFarmingData.Tables.HiddenFoodItems["Base.RasHiddenTomato"] = "farming.Tomato"
rasFarmingData.Tables.HiddenFoodItems["Base.RasHiddenPotato"] = "farming.Potato"
rasFarmingData.Tables.HiddenFoodItems["Base.RasHiddenCabbage"] = "farming.Cabbage"
rasFarmingData.Tables.HiddenFoodItems["Base.RasHiddenEggplant"] = "Base.Eggplant"
rasFarmingData.Tables.HiddenFoodItems["Base.RasHiddenLeek"] = "Base.Leek"
rasFarmingData.Tables.HiddenFoodItems["Base.RasHiddenBellPepper"] = "Base.BellPepper"
rasFarmingData.Tables.HiddenFoodItems["Base.RasHiddenCarrots"] = "Base.Carrots"
rasFarmingData.Tables.HiddenFoodItems["Base.RasHiddenBroccoli"] = "Base.Broccoli"

rasFarmingData.Tables.HiddenFoodItems["Base.RasHiddenStrewberrie"] = "farming.Strewberrie"
rasFarmingData.Tables.HiddenFoodItems["Base.RasHiddenBerry"] = true 




-- table of preservable food associated to their "hidden" versions
rasFarmingData.Tables.PreservableFood = {}
rasFarmingData.Tables.PreservableFood["Base.Broccoli"] = "Base.RasHiddenBroccoli"
rasFarmingData.Tables.PreservableFood["farming.Tomato"] = "Base.RasHiddenTomato"
rasFarmingData.Tables.PreservableFood["Base.Carrots"] = "Base.RasHiddenCarrots"
rasFarmingData.Tables.PreservableFood["farming.Potato"] = "Base.RasHiddenPotato"
rasFarmingData.Tables.PreservableFood["Base.Eggplant"] = "Base.RasHiddenEggplant"
rasFarmingData.Tables.PreservableFood["Base.Leek"] = "Base.RasHiddenLeek"
rasFarmingData.Tables.PreservableFood["farming.RedRadish"] = "Base.RasHiddenRedRadish"
rasFarmingData.Tables.PreservableFood["Base.BellPepper"] = "Base.RasHiddenBellPepper"
rasFarmingData.Tables.PreservableFood["farming.Cabbage"] = "Base.RasHiddenCabbage"
  
rasFarmingData.Tables.PreservableFood["farming.Strewberrie"] = "Base.RasHiddenStrewberrie"

rasFarmingData.Tables.PreservableFood["Base.BerryGeneric1"] = "Base.RasHiddenBerry"
rasFarmingData.Tables.PreservableFood["Base.BerryGeneric2"] = "Base.RasHiddenBerry"
rasFarmingData.Tables.PreservableFood["Base.BerryGeneric3"] = "Base.RasHiddenBerry"
rasFarmingData.Tables.PreservableFood["Base.BerryGeneric4"] = "Base.RasHiddenBerry"
rasFarmingData.Tables.PreservableFood["Base.BerryGeneric5"] = "Base.RasHiddenBerry"
rasFarmingData.Tables.PreservableFood["Base.BerryBlack"] = "Base.RasHiddenBerry"
rasFarmingData.Tables.PreservableFood["Base.BerryBlue"] = "Base.RasHiddenBerry"
rasFarmingData.Tables.PreservableFood["Base.BerryPoisonIvy"] = "Base.RasHiddenBerry"
rasFarmingData.Tables.PreservableFood["Base.BeautyBerry"] = "Base.RasHiddenBerry"
rasFarmingData.Tables.PreservableFood["Base.HollyBerry"] = "Base.RasHiddenBerry"
rasFarmingData.Tables.PreservableFood["Base.WinterBerry"] = "Base.RasHiddenBerry"






-- table of foraged berries
rasFarmingData.Tables.Berries = {}
rasFarmingData.Tables.Berries["Base.BerryGeneric1"] = true
rasFarmingData.Tables.Berries["Base.BerryGeneric2"] = true
rasFarmingData.Tables.Berries["Base.BerryGeneric3"] = true
rasFarmingData.Tables.Berries["Base.BerryGeneric4"] = true
rasFarmingData.Tables.Berries["Base.BerryGeneric5"] = true
rasFarmingData.Tables.Berries["Base.BerryBlack"] = true
rasFarmingData.Tables.Berries["Base.BerryBlue"] = true
rasFarmingData.Tables.Berries["Base.BerryPoisonIvy"] = true
rasFarmingData.Tables.Berries["Base.BeautyBerry"] = true
rasFarmingData.Tables.Berries["Base.HollyBerry"] = true
rasFarmingData.Tables.Berries["Base.WinterBerry"] = true






-- table of basic jars
rasFarmingData.Tables.Jars = {}
rasFarmingData.Tables.Jars["Base.RasCannedBellPepper"] = true     
rasFarmingData.Tables.Jars["Base.RasCannedBroccoli"] = true 
rasFarmingData.Tables.Jars["Base.RasCannedCabbage"] = true 
rasFarmingData.Tables.Jars["Base.RasCannedCarrots"] = true
rasFarmingData.Tables.Jars["Base.RasCannedEggplant"] = true                    
rasFarmingData.Tables.Jars["Base.RasCannedLeek"] = true 
rasFarmingData.Tables.Jars["Base.RasCannedPotato"] = true
rasFarmingData.Tables.Jars["Base.RasCannedRedRadish"] = true 
rasFarmingData.Tables.Jars["Base.RasCannedTomato"] = true   

rasFarmingData.Tables.JarsOpen = {}
rasFarmingData.Tables.JarsOpen["Base.RasCannedBellPepperOpen"] = true     
rasFarmingData.Tables.JarsOpen["Base.RasCannedBroccoliOpen"] = true 
rasFarmingData.Tables.JarsOpen["Base.RasCannedCabbageOpen"] = true 
rasFarmingData.Tables.JarsOpen["Base.RasCannedCarrotsOpen"] = true
rasFarmingData.Tables.JarsOpen["Base.RasCannedEggplantOpen"] = true                    
rasFarmingData.Tables.JarsOpen["Base.RasCannedLeekOpen"] = true 
rasFarmingData.Tables.JarsOpen["Base.RasCannedPotatoOpen"] = true
rasFarmingData.Tables.JarsOpen["Base.RasCannedRedRadishOpen"] = true 
rasFarmingData.Tables.JarsOpen["Base.RasCannedTomatoOpen"] = true  



-- table of pickled jars
rasFarmingData.Tables.PickledJars = {}
rasFarmingData.Tables.PickledJars["Base.RasCannedPickledBellPepper"] = true     
rasFarmingData.Tables.PickledJars["Base.RasCannedPickledBroccoli"] = true 
rasFarmingData.Tables.PickledJars["Base.RasCannedPickledCabbage"] = true 
rasFarmingData.Tables.PickledJars["Base.RasCannedPickledCarrots"] = true
rasFarmingData.Tables.PickledJars["Base.RasCannedPickledEggplant"] = true                    
rasFarmingData.Tables.PickledJars["Base.RasCannedPickledLeek"] = true 
rasFarmingData.Tables.PickledJars["Base.RasCannedPickledPotato"] = true
rasFarmingData.Tables.PickledJars["Base.RasCannedPickledRadish"] = true 
rasFarmingData.Tables.PickledJars["Base.RasCannedPickledTomato"] = true

rasFarmingData.Tables.PickledJarsOpen = {}
rasFarmingData.Tables.PickledJarsOpen["Base.RasCannedPickledBellPepperOpen"] = true     
rasFarmingData.Tables.PickledJarsOpen["Base.RasCannedPickledBroccoliOpen"] = true 
rasFarmingData.Tables.PickledJarsOpen["Base.RasCannedPickledCabbageOpen"] = true 
rasFarmingData.Tables.PickledJarsOpen["Base.RasCannedPickledCarrotsOpen"] = true
rasFarmingData.Tables.PickledJarsOpen["Base.RasCannedPickledEggplantOpen"] = true                    
rasFarmingData.Tables.PickledJarsOpen["Base.RasCannedPickledLeekOpen"] = true 
rasFarmingData.Tables.PickledJarsOpen["Base.RasCannedPickledPotatoOpen"] = true
rasFarmingData.Tables.PickledJarsOpen["Base.RasCannedPickledRadishOpen"] = true 
rasFarmingData.Tables.PickledJarsOpen["Base.RasCannedPickledTomatoOpen"] = true




-- table of fruit jams (only the ones introduced by the mod)
rasFarmingData.Tables.Jams = {}
rasFarmingData.Tables.Jams["Base.RasStrawberryJam"] = true
rasFarmingData.Tables.Jams["Base.RasRedBerryJam"] = true
rasFarmingData.Tables.Jams["Base.RasBlueBerryJam"] = true
rasFarmingData.Tables.Jams["Base.RasOrangeBerryJam"] = true


rasFarmingData.Tables.JamsOpen = {}
rasFarmingData.Tables.JamsOpen["Base.RasStrawberryJamOpen"] = true
rasFarmingData.Tables.JamsOpen["Base.RasRedBerryJamOpen"] = true
rasFarmingData.Tables.JamsOpen["Base.RasBlueBerryJamOpen"] = true
rasFarmingData.Tables.JamsOpen["Base.RasOrangeBerryJamOpen"] = true




-- table of vanilla jars/jams
rasFarmingData.Tables.VanillaJars = {}
rasFarmingData.Tables.VanillaJars["Base.JamFruit"] = true
rasFarmingData.Tables.VanillaJars["Base.JamMarmalade"] = true
rasFarmingData.Tables.VanillaJars["Base.Marinara"] = true
rasFarmingData.Tables.VanillaJars["Base.PeanutButter"] = true


rasFarmingData.Tables.VanillaJarsOpen = {}
rasFarmingData.Tables.VanillaJarsOpen["Base.RasVanillaFruitJamOpen"] = true
rasFarmingData.Tables.VanillaJarsOpen["Base.RasVanillaMarmaladeOpen"] = true
rasFarmingData.Tables.VanillaJarsOpen["Base.RasVanillaMarinaraOpen"] = true
rasFarmingData.Tables.VanillaJarsOpen["Base.RasVanillaPeanutButterOpen"] = true






-- this table stores closed jars and associates them to their opened versions
rasFarmingData.Tables.ClosedToOpen = {}
rasFarmingData.Tables.ClosedToOpen["Base.RasCannedBellPepper"] = "Base.RasCannedBellPepperOpen"     
rasFarmingData.Tables.ClosedToOpen["Base.RasCannedBroccoli"] = "Base.RasCannedBroccoliOpen" 
rasFarmingData.Tables.ClosedToOpen["Base.RasCannedCabbage"] = "Base.RasCannedCabbageOpen" 
rasFarmingData.Tables.ClosedToOpen["Base.RasCannedCarrots"] = "Base.RasCannedCarrotsOpen"
rasFarmingData.Tables.ClosedToOpen["Base.RasCannedEggplant"] = "Base.RasCannedEggplantOpen"                    
rasFarmingData.Tables.ClosedToOpen["Base.RasCannedLeek"] = "Base.RasCannedLeekOpen"
rasFarmingData.Tables.ClosedToOpen["Base.RasCannedPotato"] = "Base.RasCannedPotatoOpen"
rasFarmingData.Tables.ClosedToOpen["Base.RasCannedRedRadish"] = "Base.RasCannedRedRadishOpen"
rasFarmingData.Tables.ClosedToOpen["Base.RasCannedTomato"] = "Base.RasCannedTomatoOpen"

rasFarmingData.Tables.ClosedToOpen["Base.RasCannedPickledBellPepper"] = "Base.RasCannedPickledBellPepperOpen"     
rasFarmingData.Tables.ClosedToOpen["Base.RasCannedPickledBroccoli"] = "Base.RasCannedPickledBroccoliOpen"
rasFarmingData.Tables.ClosedToOpen["Base.RasCannedPickledCabbage"] = "Base.RasCannedPickledCabbageOpen" 
rasFarmingData.Tables.ClosedToOpen["Base.RasCannedPickledCarrots"] = "Base.RasCannedPickledCarrotsOpen"
rasFarmingData.Tables.ClosedToOpen["Base.RasCannedPickledEggplant"] = "Base.RasCannedPickledEggplantOpen"                    
rasFarmingData.Tables.ClosedToOpen["Base.RasCannedPickledLeek"] = "Base.RasCannedPickledLeekOpen" 
rasFarmingData.Tables.ClosedToOpen["Base.RasCannedPickledPotato"] = "Base.RasCannedPickledPotatoOpen"
rasFarmingData.Tables.ClosedToOpen["Base.RasCannedPickledRadish"] = "Base.RasCannedPickledRadishOpen"
rasFarmingData.Tables.ClosedToOpen["Base.RasCannedPickledTomato"] = "Base.RasCannedPickledTomatoOpen"

rasFarmingData.Tables.ClosedToOpen["Base.RasStrawberryJam"] = "Base.RasStrawberryJamOpen"
rasFarmingData.Tables.ClosedToOpen["Base.RasRedBerryJam"] = "Base.RasRedBerryJamOpen"
rasFarmingData.Tables.ClosedToOpen["Base.RasBlueBerryJam"] = "Base.RasBlueBerryJamOpen"
rasFarmingData.Tables.ClosedToOpen["Base.RasOrangeBerryJam"] = "Base.RasOrangeBerryJamOpen"

rasFarmingData.Tables.ClosedToOpen["Base.JamFruit"] = "Base.RasVanillaFruitJamOpen"
rasFarmingData.Tables.ClosedToOpen["Base.JamMarmalade"] = "Base.RasVanillaMarmaladeOpen"
rasFarmingData.Tables.ClosedToOpen["Base.Marinara"] = "Base.RasVanillaMarinaraOpen"
rasFarmingData.Tables.ClosedToOpen["Base.PeanutButter"] = "Base.RasVanillaPeanutButterOpen"


-- also for the crafted vanilla jars:
rasFarmingData.Tables.ClosedToOpen["Base.CannedBellPepper"] = "Base.RasCannedBellPepperOpen"     
rasFarmingData.Tables.ClosedToOpen["Base.CannedBroccoli"] = "Base.RasCannedBroccoliOpen" 
rasFarmingData.Tables.ClosedToOpen["Base.CannedCabbage"] = "Base.RasCannedCabbageOpen" 
rasFarmingData.Tables.ClosedToOpen["Base.CannedCarrots"] = "Base.RasCannedCarrotsOpen"
rasFarmingData.Tables.ClosedToOpen["Base.CannedEggplant"] = "Base.RasCannedEggplantOpen"                    
rasFarmingData.Tables.ClosedToOpen["Base.CannedLeek"] = "Base.RasCannedLeekOpen"
rasFarmingData.Tables.ClosedToOpen["Base.CannedPotato"] = "Base.RasCannedPotatoOpen"
rasFarmingData.Tables.ClosedToOpen["Base.CannedRedRadish"] = "Base.RasCannedRedRadishOpen"
rasFarmingData.Tables.ClosedToOpen["Base.CannedTomato"] = "Base.RasCannedTomatoOpen"




                 
 

-- table of bait items; used when adding content from jars to composter
rasFarmingData.Tables.Baits = {}
rasFarmingData.Tables.Baits["Base.RasCannedBellPepperOpen"] = "Base.RasBellPepperBait"     
rasFarmingData.Tables.Baits["Base.RasCannedBroccoliOpen"] = "Base.RasBroccoliBait" 
rasFarmingData.Tables.Baits["Base.RasCannedCabbageOpen"] = "Base.RasCabbageBait" 
rasFarmingData.Tables.Baits["Base.RasCannedCarrotsOpen"] = "Base.RasCarrotsBait"
rasFarmingData.Tables.Baits["Base.RasCannedEggplantOpen"] = "Base.RasEggplantBait"                    
rasFarmingData.Tables.Baits["Base.RasCannedLeeksOpen"] = "Base.RasLeeksBait" 
rasFarmingData.Tables.Baits["Base.RasCannedPotatoOpen"] = "Base.RasPotatoBait"
rasFarmingData.Tables.Baits["Base.RasCannedRedRadishOpen"] = "Base.RasRadishBait" 
rasFarmingData.Tables.Baits["Base.RasCannedTomatoOpen"] = "Base.RasTomatoBait"  

rasFarmingData.Tables.Baits["Base.RasCannedPickledBellPepperOpen"] = "Base.RasPickledBellPepperBait"      
rasFarmingData.Tables.Baits["Base.RasCannedPickledBroccoliOpen"] = "Base.RasPickledBroccoliBait"
rasFarmingData.Tables.Baits["Base.RasCannedPickledCabbageOpen"] = "Base.RasPickledCabbageBait" 
rasFarmingData.Tables.Baits["Base.RasCannedPickledCarrotsOpen"] = "Base.RasPickledCarrotsBait"
rasFarmingData.Tables.Baits["Base.RasCannedPickledEggplantOpen"] = "Base.RasPickledEggplantBait"                   
rasFarmingData.Tables.Baits["Base.RasCannedPickledLeekOpen"] = "Base.RasPickledLeeksBait"
rasFarmingData.Tables.Baits["Base.RasCannedPickledPotatoOpen"] = "Base.RasPickledPotatoBait"
rasFarmingData.Tables.Baits["Base.RasCannedPickledRadishOpen"] = "Base.RasPickledRadishBait"
rasFarmingData.Tables.Baits["Base.RasCannedPickledTomatoOpen"] = "Base.RasPickledTomatoBait"

rasFarmingData.Tables.Baits["Base.RasStrawberryJamOpen"] = "Base.RasJamBaitRed"
rasFarmingData.Tables.Baits["Base.RasRedBerryJamOpen"] = "Base.RasJamBaitRed"
rasFarmingData.Tables.Baits["Base.RasBlueBerryJamOpen"] = "Base.RasJamBaitBlue"
rasFarmingData.Tables.Baits["Base.RasOrangeBerryJamOpen"] = "Base.RasJamBaitOrange"

rasFarmingData.Tables.Baits["Base.RasVanillaFruitJamOpen"] = "Base.RasJamBaitRed"
rasFarmingData.Tables.Baits["Base.RasVanillaMarmaladeOpen"] = "Base.RasJamBaitOrange"
rasFarmingData.Tables.Baits["Base.RasVanillaMarinaraOpen"] = "Base.RasMarinaraBait"
rasFarmingData.Tables.Baits["Base.RasVanillaPeanutButterOpen"] = "Base.RasPeanutButterBait"


-- the rotten versions of the bait items
rasFarmingData.Tables.BaitsRotten = {}
rasFarmingData.Tables.BaitsRotten["Base.RasCannedBellPepperOpen"] = "Base.RasBellPepperBaitRotten"     
rasFarmingData.Tables.BaitsRotten["Base.RasCannedBroccoliOpen"] = "Base.RasBroccoliBaitRotten" 
rasFarmingData.Tables.BaitsRotten["Base.RasCannedCabbageOpen"] = "Base.RasCabbageBaitRotten" 
rasFarmingData.Tables.BaitsRotten["Base.RasCannedCarrotsOpen"] = "Base.RasCarrotsBaitRotten"
rasFarmingData.Tables.BaitsRotten["Base.RasCannedEggplantOpen"] = "Base.RasEggplantBaitRotten"                    
rasFarmingData.Tables.BaitsRotten["Base.RasCannedLeeksOpen"] = "Base.RasLeeksBaitRotten" 
rasFarmingData.Tables.BaitsRotten["Base.RasCannedPotatoOpen"] = "Base.RasPotatoBaitRotten"
rasFarmingData.Tables.BaitsRotten["Base.RasCannedRedRadishOpen"] = "Base.RasRadishBaitRotten" 
rasFarmingData.Tables.BaitsRotten["Base.RasCannedTomatoOpen"] = "Base.RasTomatoBaitRotten"  

rasFarmingData.Tables.BaitsRotten["Base.RasCannedPickledBellPepperOpen"] = "Base.RasPickledBellPepperBaitRotten"      
rasFarmingData.Tables.BaitsRotten["Base.RasCannedPickledBroccoliOpen"] = "Base.RasPickledBroccoliBaitRotten"
rasFarmingData.Tables.BaitsRotten["Base.RasCannedPickledCabbageOpen"] = "Base.RasPickledCabbageBaitRotten" 
rasFarmingData.Tables.BaitsRotten["Base.RasCannedPickledCarrotsOpen"] = "Base.RasPickledCarrotsBaitRotten"
rasFarmingData.Tables.BaitsRotten["Base.RasCannedPickledEggplantOpen"] = "Base.RasPickledEggplantBaitRotten"                   
rasFarmingData.Tables.BaitsRotten["Base.RasCannedPickledLeekOpen"] = "Base.RasPickledLeeksBaitRotten"
rasFarmingData.Tables.BaitsRotten["Base.RasCannedPickledPotatoOpen"] = "Base.RasPickledPotatoBaitRotten"
rasFarmingData.Tables.BaitsRotten["Base.RasCannedPickledRadishOpen"] = "Base.RasPickledRadishBaitRotten"
rasFarmingData.Tables.BaitsRotten["Base.RasCannedPickledTomatoOpen"] = "Base.RasPickledTomatoBaitRotten"

rasFarmingData.Tables.BaitsRotten["Base.RasStrawberryJamOpen"] = "Base.RasJamBaitRedRotten"
rasFarmingData.Tables.BaitsRotten["Base.RasRedBerryJamOpen"] = "Base.RasJamBaitRedRotten"
rasFarmingData.Tables.BaitsRotten["Base.RasBlueBerryJamOpen"] = "Base.RasJamBaitBlueRotten"
rasFarmingData.Tables.BaitsRotten["Base.RasOrangeBerryJamOpen"] = "Base.RasJamBaitOrangeRotten"

rasFarmingData.Tables.BaitsRotten["Base.RasVanillaFruitJamOpen"] = "Base.RasJamBaitRedRotten"
rasFarmingData.Tables.BaitsRotten["Base.RasVanillaMarmaladeOpen"] = "Base.RasJamBaitOrangeRotten"
rasFarmingData.Tables.BaitsRotten["Base.RasVanillaMarinaraOpen"] = "Base.RasMarinaraBaitRotten"
rasFarmingData.Tables.BaitsRotten["Base.RasVanillaPeanutButterOpen"] = "Base.RasPeanutButterBaitRotten"




-- the actual content of a jar (only used when adding to composter)
rasFarmingData.Tables.Content = { }

rasFarmingData.Tables.Content["Base.RasCannedBellPepperOpen"] = "Base.BellPepper"
rasFarmingData.Tables.Content["Base.RasCannedBroccoliOpen"] = "Base.Broccoli"
rasFarmingData.Tables.Content["Base.RasCannedCabbageOpen"] = "farming.Cabbage"
rasFarmingData.Tables.Content["Base.RasCannedCarrotsOpen"] = "Base.Carrots"
rasFarmingData.Tables.Content["Base.RasCannedEggplantOpen"] = "Base.Eggplant"
rasFarmingData.Tables.Content["Base.RasCannedLeekOpen"] = "Base.Leek"
rasFarmingData.Tables.Content["Base.RasCannedPotatoOpen"] = "farming.Potato" 
rasFarmingData.Tables.Content["Base.RasCannedRedRadishOpen"] = "farming.RedRadish"
rasFarmingData.Tables.Content["Base.RasCannedTomatoOpen"] = "farming.Tomato" 

rasFarmingData.Tables.Content["Base.RasCannedPickledBellPepperOpen"] = "Base.BellPepper"    
rasFarmingData.Tables.Content["Base.RasCannedPickledBroccoliOpen"] = "Base.Broccoli"
rasFarmingData.Tables.Content["Base.RasCannedPickledCabbageOpen"] = "farming.Cabbage"
rasFarmingData.Tables.Content["Base.RasCannedPickledCarrotsOpen"] = "Base.Carrots"
rasFarmingData.Tables.Content["Base.RasCannedPickledEggplantOpen"] = "Base.Eggplant"                   
rasFarmingData.Tables.Content["Base.RasCannedPickledLeekOpen"] = "Base.Leek" 
rasFarmingData.Tables.Content["Base.RasCannedPickledPotatoOpen"] = "farming.Potato" 
rasFarmingData.Tables.Content["Base.RasCannedPickledRadishOpen"] = "farming.RedRadish" 
rasFarmingData.Tables.Content["Base.RasCannedPickledTomatoOpen"] = "farming.Tomato" 

rasFarmingData.Tables.Content["Base.RasStrawberryJamOpen"] = "Base.RasBlobJamRed" 
rasFarmingData.Tables.Content["Base.RasRedBerryJamOpen"] = "Base.RasBlobJamRed"
rasFarmingData.Tables.Content["Base.RasBlueBerryJamOpen"] = "Base.RasBlobJamBlue"
rasFarmingData.Tables.Content["Base.RasOrangeBerryJamOpen"] = "Base.RasBlobJamOrange" 

rasFarmingData.Tables.Content["Base.RasVanillaFruitJamOpen"] = "Base.RasBlobJamRed" 
rasFarmingData.Tables.Content["Base.RasVanillaMarmaladeOpen"] = "Base.RasBlobJamOrange"
rasFarmingData.Tables.Content["Base.RasVanillaMarinaraOpen"] = "Base.RasBlobMarinara"
rasFarmingData.Tables.Content["Base.RasVanillaPeanutButterOpen"] = "Base.RasBlobPeanutButter"   





-- stores the farming speed for different seeds (this is used to fix a vanilla bug when displaying the growth time in a tooltip)
rasFarmingData.Tables.FarmingSpeed = { }

rasFarmingData.Tables.FarmingSpeed["Carrots"] = 53
rasFarmingData.Tables.FarmingSpeed["Broccoli"] = 112
rasFarmingData.Tables.FarmingSpeed["Radishes"] = 60
rasFarmingData.Tables.FarmingSpeed["Tomato"] = 98
rasFarmingData.Tables.FarmingSpeed["Potatoes"] = 98
rasFarmingData.Tables.FarmingSpeed["Cabbages"] = 98
rasFarmingData.Tables.FarmingSpeed["Strawberry plant"] = 120




-- store some recipe information (info for making jam out of foraged berries is stored above in FixedValues, not here)
rasFarmingData.Tables.Recipes = {
   RasCannedBroccoli = { ingredient = "Base.Broccoli", number = 5},
   RasCannedTomato = { ingredient = "farming.Tomato", number = 3},
   RasCannedCarrots = { ingredient = "Base.Carrots", number = 5},
   RasCannedPotato = { ingredient = "farming.Potato", number = 3},
   RasCannedEggplant = { ingredient = "Base.Eggplant", number = 3},
   RasCannedLeek = { ingredient = "Base.Leek", number = 3},
   RasCannedRedRadish = { ingredient = "farming.RedRadish", number = 10},
   RasCannedBellPepper = { ingredient = "Base.BellPepper", number = 5},
   RasCannedCabbage = { ingredient = "farming.Cabbage", number = 2 },

   RasCannedPickledBroccoli = { ingredient = "Base.Broccoli", number = 5},
   RasCannedPickledTomato = { ingredient = "farming.Tomato", number = 3},
   RasCannedPickledCarrots = { ingredient = "Base.Carrots", number = 5},
   RasCannedPickledPotato = { ingredient = "farming.Potato", number = 3},
   RasCannedPickledEggplant = { ingredient = "Base.Eggplant", number = 3},
   RasCannedPickledLeek = { ingredient = "Base.Leek", number = 3},
   RasCannedPickledRadish = { ingredient = "farming.RedRadish", number = 10},
   RasCannedPickledBellPepper = { ingredient = "Base.BellPepper", number = 5},
   RasCannedPickledCabbage = { ingredient = "farming.Cabbage", number = 2 },

   RasStrawberryJam = { ingredient = "farming.Strewberrie", number = 5 },
}


-- stores info used to display correct names for hidden food items; must be adjusted in case recipes are changed
rasFarmingData.Tables.DisplayName = { }

rasFarmingData.Tables.DisplayName["Base.RasHiddenBerry x 5"] = "UI_rasFarming_Berry_Ingredient"

rasFarmingData.Tables.DisplayName["Base.RasHiddenBroccoli x 5"] = "UI_rasFarming_Broccoli_Ingredient"
rasFarmingData.Tables.DisplayName["Base.RasHiddenTomato x 3"] = "UI_rasFarming_Tomato_Ingredient"
rasFarmingData.Tables.DisplayName["Base.RasHiddenCarrots x 5"] = "UI_rasFarming_Carrots_Ingredient"
rasFarmingData.Tables.DisplayName["Base.RasHiddenPotato x 3"] = "UI_rasFarming_Potato_Ingredient"
rasFarmingData.Tables.DisplayName["Base.RasHiddenEggplant x 3"] = "UI_rasFarming_Eggplant_Ingredient"
rasFarmingData.Tables.DisplayName["Base.RasHiddenLeek x 3"] = "UI_rasFarming_Leek_Ingredient"
rasFarmingData.Tables.DisplayName["Base.RasHiddenRedRadish x 10"] = "UI_rasFarming_RedRaddish_Ingredient"
rasFarmingData.Tables.DisplayName["Base.RasHiddenBellPepper x 5"] = "UI_rasFarming_BellPepper_Ingredient"
rasFarmingData.Tables.DisplayName["Base.RasHiddenCabbage x 2"] = "UI_rasFarming_Cabbage_Ingredient"

rasFarmingData.Tables.DisplayName["Base.RasHiddenStrewberrie x 5"] = "UI_rasFarming_Strewberry_Ingredient"




-- store crafted jars from the vanilla game; this is to make sure we can also open them with the "Open Jar" option introduced by the mod and that they also give "Open Jar of ..."
-- item
rasFarmingData.Tables.VanillaCraftedJars = {}
rasFarmingData.Tables.VanillaCraftedJars["Base.CannedBellPepper"] = "true"    
rasFarmingData.Tables.VanillaCraftedJars["Base.CannedBroccoli"] = "true"
rasFarmingData.Tables.VanillaCraftedJars["Base.CannedCabbage"] = "true" 
rasFarmingData.Tables.VanillaCraftedJars["Base.CannedCarrots"] = "true"
rasFarmingData.Tables.VanillaCraftedJars["Base.CannedEggplant"] = "true"                   
rasFarmingData.Tables.VanillaCraftedJars["Base.CannedLeek"] = "true"
rasFarmingData.Tables.VanillaCraftedJars["Base.CannedPotato"] = "true"
rasFarmingData.Tables.VanillaCraftedJars["Base.CannedRedRadish"] = "true" 
rasFarmingData.Tables.VanillaCraftedJars["Base.CannedTomato"] = "true"  



return rasFarmingData






