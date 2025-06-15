# rasFarmingCanning
The mod "ra's Farming & Canning" for the video game Project Zomboid (build 41 version of the game). Previous versions can be found in the "releases" section. The mod's workshop page on steam contains info about the mod's content: https://steamcommunity.com/sharedfiles/filedetails/?id=2951489608.

Release (steam): 24 Mar, 2023 <br>
Last updated: 18 Mar, 2024

Content:
- Changes to the farming system: The mod makes it so that farming is only possible during newly introduced growing seasons which last from April to Ocotber where the exact dates are randomized.
- It makes some changes to the game's food preservation options (adding new canning options and increasing durability of the jars depending on the player's cooking skill).

Technical:
- All coding is done in lua.
- To make the new farming system work in multiplayer, the mod includes some code for proper server-client communication.
- It implements various new UI elements which display new info about the crops and the growing season. There is also also some new functionality regarding the game's composting system which also required introduction of new UI elements.
- The game's canning system is completely overhauled. This is partly done on the scripting level since the game's native recipe and crafting infrastructure does not allow realization of all new features introduced by the mod.
- It adds some new textures and 3d models (created by me using the blender and gimp).

The mod is only available for the stable build 41 version of the game. It is not available for the unstable build 42 and I probably won't update it since some of the mods features are now integrated in the main game. Bugfixes and other minor for the build 41 version are still possible ofc.

When playing the game on steam, you can install the mod by simply subscribing to it in the workshop.

Manual installation:
1. Download the above .zip file (the most recent version of the mod).
2. Extract the .zip.
3. From the extracted file, copy the folder "rasFarmingCanning" from rasFarmingCanning_[version]/Contents/mods/ to your Zomboid/mods folder.


