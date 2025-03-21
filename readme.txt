


-------------------- FOR PLAYERS/GENERAL AUDIENCE ---------------------


This mod disables farming during winter. To compensate for more difficult food supply, the mod makes some changes to the food preservation system (jars will last longer, possible to make jars without vinegar or sugar etc.).

For a detailed description of the mod's content, see the mod's page on the steam workshop: https://steamcommunity.com/sharedfiles/filedetails/?id=2951489608


------------------------- UPDATE NOTES ---------------------------- 


- 1.0: release version
- 1.0.1: fixed food sometimes not consumed when crafting jars from equipped bags, backpacks etc.; fixed food items sometimes shown twice in tooltip of a bags containing the items; adjusted the time for actions
to make it more similar to vanilla action times
- 1.0.2: fixed a display bug which sometimes occured when players interact with traps
- 1.0.3: fixed bug which sometimes occured when players try to sow in mp; added transtaltion to Brazilian Portuguese (thanks to various steam users for contributing translations!) 
- 1.1: changes to the code to increase performance; fixed a bug when crafted jar of pickled radishes; removed possibility to craft from rotten food; removed vanilla recipes for opening a jar (vanilla jars can now be opened with the "Open Jar" option from the mod); added Russian translation (thanks to various steam users for contributing translations!) 
- 1.1.1 (current): fixed tooltip box when hovering over crop not transparent


------------------------- TECHNICAL/FOR MODDERS/MISC -------------------------


The mod contains a full overhaul of the vanilla canning system. It may conflict with any mod making changes to the canning system. Mods adding only new canning recipes should be fine but they will not be affected 
by the canning system introduced by this mod (they will use the vanilla system or whatever the modder has done instead). 

Farming system is also changed (not possible to farm in winter anymore). Mods adding new crop types will probably be compatible with this mod. New crop types will probably be affected by the mod's mechanics (i.e. die in winter etc.). Mods making deeper changes to the farming system may be incompatible.

Vanilla code is not overwritten. In some cases, vanilla functions and data are modified using contructions like

local old_vanillaFunction = vanillaFunction
function vanillaFunction(...)

         --[[ my new code]]--
         
         old_vanillaFunction(...) -- execute the vanilla function
         
         --[[ my new code ]]--
end
  
Some of the mod's features are also present in other mods (e.g. make jars last longer). The overall mechanics introduced by this mod is still quite different from other mods.

         
---------------------- LANGUAGE AND TRANSLATION ---------------------------------


This mod is available in several languages. Additional translations are welcome, in case you would like to make one. Feel free to ask in the comment section of the mod's workshop page.


----------------------- DISCLAIMER -------------------------------


I consider all my mods to be open source. As long as you do not publish a plain copy of them to the steam workshop, feel free to use any element of them, modify to your liking and share with the community! 


-----------------------


by razab, Mar 18, 2024







