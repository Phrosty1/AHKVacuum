function KeybindsSave()
	local logTextArr = {}
	local saveTable = {}
	saveTable.BindTable = {}
	local layers = GetNumActionLayers()
	for layer = 1, layers, 1 do
		layerName,numcat = GetActionLayerInfo(layer)
		-- d(layer..":"..name..":  " ..numcat)
		saveTable.BindTable[layer] = {}
		saveTable.BindTable[layer].Name = layerName
		saveTable.BindTable[layer].LayerNumber = layer
		saveTable.BindTable[layer].NumberOfCategories= numcat
		saveTable.BindTable[layer].Category = {}
		for cat = 1, numcat, 1 do
			catName, numactions = GetActionLayerCategoryInfo(layer,cat)
			-- d(name..":"..catName..":  "..numactions)
			saveTable.BindTable[layer].Category[cat] = {}
			saveTable.BindTable[layer].Category[cat].Name = catName
			saveTable.BindTable[layer].Category[cat].NumActions = numactions
			saveTable.BindTable[layer].Category[cat].Actions = {}
			for action = 1, numactions, 1 do
				actionName, isRebindable, isHidden = GetActionInfo(layer,cat,action)
				-- d(actionName..":  "..tostring(isRebindable).." | "..tostring(isHidden))
				saveTable.BindTable[layer].Category[cat].Actions[action] = {}
				saveTable.BindTable[layer].Category[cat].Actions[action].Name = actionName
				saveTable.BindTable[layer].Category[cat].Actions[action].isRebindable = isRebindable
				saveTable.BindTable[layer].Category[cat].Actions[action].isHidden = isHidden
				saveTable.BindTable[layer].Category[cat].Actions[action].Keys = {}
				for index = 1, 4 do
					keycode, keymod1, keymod2, keymod3, keymod4 = GetActionBindingInfo(layer,cat,action,index)
					saveTable.BindTable[layer].Category[cat].Actions[action].Keys[index] = {}
					saveTable.BindTable[layer].Category[cat].Actions[action].Keys[index].KeyCode = keycode
					saveTable.BindTable[layer].Category[cat].Actions[action].Keys[index].KeyMod1 = keymod1
					saveTable.BindTable[layer].Category[cat].Actions[action].Keys[index].KeyMod2 = keymod2
					saveTable.BindTable[layer].Category[cat].Actions[action].Keys[index].KeyMod3 = keymod3
					saveTable.BindTable[layer].Category[cat].Actions[action].Keys[index].KeyMod4 = keymod4
					--logTextArr[tostring(layer)..","..tostring(cat)..","..tostring(action)..","..tostring(index)]
					--	 = tostring(keycode)..","..tostring(keymod1)..","..tostring(keymod2)..","..tostring(keymod3)..","..tostring(keymod4)
					--		..","..tostring(layerName)..","..tostring(catName)..","..tostring(actionName)..","..tostring(isRebindable)..","..tostring(isHidden)
					local arrIdx = "CallSecureProtected(BindKeyToAction, "..tostring(layer)..","..tostring(cat)..","..tostring(action)..","..tostring(index)..", "..tostring(keycode)..","..tostring(keymod1)..","..tostring(keymod2)..","..tostring(keymod3)..","..tostring(keymod4)..")"
					if not isRebindable then arrIdx = "--"..arrIdx end
					logTextArr[arrIdx]
						= tostring(layer)..","..tostring(cat)..","..tostring(action)..","..tostring(index)
							..","..tostring(keycode)..","..tostring(keymod1)..","..tostring(keymod2)..","..tostring(keymod3)..","..tostring(keymod4)
							..","..tostring(layerName)..","..tostring(catName)..","..tostring(actionName)..","..tostring(isRebindable)..","..tostring(isHidden)
				end
			end
		end
	end
	--logTextArr["layer"..",".."cat"..",".."action"..",".."index"]
	--	 = "keycode"..",".."keymod1"..",".."keymod2"..",".."keymod3"..",".."keymod4"
	--		..",".."layerName"..",".."catName"..",".."actionName"..",".."isRebindable"..",".."isHidden"
	--CallSecureProtected("BindKeyToAction", layer, cat, action, index, keycode, keymod1, keymod2, keymod3, keymod4) -- LayerIndex,CategoryIndex,ActionIndex,BindIndex(1-4),KeyCode,Modx4
	AHKVacuum.savedVars.logText = logTextArr
end

--CallSecureProtected("BindKeyToAction", 1,15,4,4, 0,0,0,0,0) -- 1,15,4,4,0,0,0,0,0,General,Vacuum Shop,VACUUM_DOWN,true,false
--CallSecureProtected("BindKeyToAction", 1,15,4,3, 0,0,0,0,0) -- 1,15,4,3,0,0,0,0,0,General,Vacuum Shop,VACUUM_DOWN,true,false
--CallSecureProtected("BindKeyToAction", 1,15,4,1, 113,0,0,0,0) -- 1,15,4,1,113,0,0,0,0,General,Vacuum Shop,VACUUM_DOWN,true,false
--CallSecureProtected("BindKeyToAction", 1,15,4,2, 0,0,0,0,0) -- 1,15,4,2,0,0,0,0,0,General,Vacuum Shop,VACUUM_DOWN,true,false

function KeybindsReset()
	CallSecureProtected("BindKeyToAction", 1,20,7,4, 0,0,0,0,0) -- 1,20,7,4,0,0,0,0,0,General,|c3366FFBank|r Manager |c990000Revived|r,BMR_PROFILE7,true,false
	CallSecureProtected("BindKeyToAction", 3,4,1,2, 0,0,0,0,0) -- 3,4,1,2,0,0,0,0,0,User Interface Shortcuts,WritWorthy,WRIT_WORTHY_ACCEPT_QUESTS,true,false
	--CallSecureProtected("BindKeyToAction", 8,1,2,1, 119,0,0,0,0) -- 8,1,2,1,119,0,0,0,0,MouseUIMode,,LEFT_AND_RIGHT_MOUSE_IN_WORLD,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,6,2, 127,0,0,0,0) -- 2,1,6,2,127,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,2,9,3, 0,0,0,0,0) -- 1,2,9,3,0,0,0,0,0,General,Combat,SPECIAL_MOVE_WEAPON_SWAP_TO_SET_2,true,false
	CallSecureProtected("BindKeyToAction", 1,21,3,2, 0,0,0,0,0) -- 1,21,3,2,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_NEXT_SET,true,false
	--CallSecureProtected("BindKeyToAction", 13,1,9,4, 0,0,0,0,0) -- 13,1,9,4,0,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_9,false,true
	CallSecureProtected("BindKeyToAction", 3,1,2,4, 0,0,0,0,0) -- 3,1,2,4,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_SECONDARY,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,21,1, 105,0,0,0,0) -- 2,1,21,1,105,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,2,12,4, 0,0,0,0,0) -- 1,2,12,4,0,0,0,0,0,General,Combat,ACTION_BUTTON_5,true,false
	--CallSecureProtected("BindKeyToAction", 26,1,4,4, 0,0,0,0,0) -- 26,1,4,4,0,0,0,0,0,BattlegroundScoreboard,,BATTLEGROUND_SCOREBOARD_NEXT,false,true
	--CallSecureProtected("BindKeyToAction", 9,1,7,2, 65,0,0,0,0) -- 9,1,7,2,65,0,0,0,0,Conversation,,CONVERSATION_OPTION_7,false,true
	CallSecureProtected("BindKeyToAction", 1,2,22,3, 0,0,0,0,0) -- 1,2,22,3,0,0,0,0,0,General,Combat,GAMEPAD_ACTION_BUTTON_7,true,true
	CallSecureProtected("BindKeyToAction", 1,7,5,2, 0,0,0,0,0) -- 1,7,5,2,0,0,0,0,0,General,Mini Map,VOTANS_TOGGLE_MAP_ZOOM_IN,true,false
	CallSecureProtected("BindKeyToAction", 1,6,2,1, 20,0,0,0,0) -- 1,6,2,1,20,0,0,0,0,General,User Interface,TAKE_SCREENSHOT,true,false
	CallSecureProtected("BindKeyToAction", 1,18,13,4, 0,0,0,0,0) -- 1,18,13,4,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMACRAFTTOGGLE,true,false
	CallSecureProtected("BindKeyToAction", 1,26,8,3, 0,0,0,0,0) -- 1,26,8,3,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_GROUP_LEADER,true,false
	CallSecureProtected("BindKeyToAction", 1,20,4,2, 0,0,0,0,0) -- 1,20,4,2,0,0,0,0,0,General,|c3366FFBank|r Manager |c990000Revived|r,BMR_PROFILE4,true,false
	CallSecureProtected("BindKeyToAction", 1,25,5,1, 0,0,0,0,0) -- 1,25,5,1,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_4,true,false
	CallSecureProtected("BindKeyToAction", 1,29,1,2, 0,0,0,0,0) -- 1,29,1,2,0,0,0,0,0,General,Assist Rapid Riding,ARR_SWITCH,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,17,3, 0,0,0,0,0) -- 10,1,17,3,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_MAIL,false,true
	CallSecureProtected("BindKeyToAction", 1,2,3,4, 0,0,0,0,0) -- 1,2,3,4,0,0,0,0,0,General,Combat,SPECIAL_MOVE_SPRINT,true,false
	CallSecureProtected("BindKeyToAction", 1,6,32,3, 0,0,0,0,0) -- 1,6,32,3,0,0,0,0,0,General,User Interface,RETICLE_BRIGHTNESS_INCREASE,true,false
	--CallSecureProtected("BindKeyToAction", 13,1,7,4, 0,0,0,0,0) -- 13,1,7,4,0,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_7,false,true
	--CallSecureProtected("BindKeyToAction", 9,1,6,2, 64,0,0,0,0) -- 9,1,6,2,64,0,0,0,0,Conversation,,CONVERSATION_OPTION_6,false,true
	CallSecureProtected("BindKeyToAction", 1,18,2,4, 0,0,0,0,0) -- 1,18,2,4,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMAMODECHANGE,true,false
	CallSecureProtected("BindKeyToAction", 1,12,4,2, 0,0,0,0,0) -- 1,12,4,2,0,0,0,0,0,General,Foundry Tactical Combat,REFRESH_FRAMES,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,22,2, 0,0,0,0,0) -- 2,1,22,2,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,2,24,3, 0,0,0,0,0) -- 1,2,24,3,0,0,0,0,0,General,Combat,ACTION_BUTTON_9,true,false
	--CallSecureProtected("BindKeyToAction", 31,1,2,4, 0,0,0,0,0) -- 31,1,2,4,0,0,0,0,0,ScryingActions,,,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,2,2, 165,0,0,0,0) -- 2,1,2,2,165,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 12,1,4,4, 0,0,0,0,0) -- 12,1,4,4,0,0,0,0,0,Guild,,GUILD_4,false,true
	CallSecureProtected("BindKeyToAction", 1,18,14,1, 0,0,0,0,0) -- 1,18,14,1,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMATRIALTOGGLE,true,false
	CallSecureProtected("BindKeyToAction", 1,12,2,1, 0,0,0,0,0) -- 1,12,2,1,0,0,0,0,0,General,Foundry Tactical Combat,DISPLAY_DAMAGE_REPORT,true,false
	CallSecureProtected("BindKeyToAction", 1,25,6,2, 0,0,0,0,0) -- 1,25,6,2,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_5,true,false
	CallSecureProtected("BindKeyToAction", 1,1,8,2, 0,0,0,0,0) -- 1,1,8,2,0,0,0,0,0,General,Movement,ROLL_DODGE,true,false
	CallSecureProtected("BindKeyToAction", 1,6,33,2, 0,0,0,0,0) -- 1,6,33,2,0,0,0,0,0,General,User Interface,RETICLE_BRIGHTNESS_DECREASE,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,17,2, 0,0,0,0,0) -- 28,1,17,2,0,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 27,1,3,2, 127,0,0,0,0) -- 27,1,3,2,127,0,0,0,0,ScreenshotMode,,SCREENSHOT_MODE_EXIT,false,true
	CallSecureProtected("BindKeyToAction", 1,6,27,2, 0,0,0,0,0) -- 1,6,27,2,0,0,0,0,0,General,User Interface,TOGGLE_FIRST_PERSON,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,10,2, 0,0,0,0,0) -- 10,1,10,2,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_JOURNAL,false,true
	CallSecureProtected("BindKeyToAction", 4,1,2,3, 0,0,0,0,0) -- 4,1,2,3,0,0,0,0,0,Siege,,SIEGE_RELEASE,true,false
	--CallSecureProtected("BindKeyToAction", 12,1,2,3, 0,0,0,0,0) -- 12,1,2,3,0,0,0,0,0,Guild,,GUILD_2,false,true
	CallSecureProtected("BindKeyToAction", 1,7,2,4, 0,0,0,0,0) -- 1,7,2,4,0,0,0,0,0,General,Mini Map,VOTANS_TOGGLE_MAP_SHOW_HUD,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,9,2, 0,0,0,0,0) -- 2,1,9,2,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,8,2,2, 0,0,0,0,0) -- 1,8,2,2,0,0,0,0,0,General,HarvestMap,TOGGLE_WORLDPINS,true,false
	CallSecureProtected("BindKeyToAction", 1,6,11,4, 0,0,0,0,0) -- 1,6,11,4,0,0,0,0,0,General,User Interface,TOGGLE_SKILLS,true,false
	CallSecureProtected("BindKeyToAction", 4,1,2,4, 0,0,0,0,0) -- 4,1,2,4,0,0,0,0,0,Siege,,SIEGE_RELEASE,true,false
	--CallSecureProtected("BindKeyToAction", 12,1,1,1, 23,0,0,0,0) -- 12,1,1,1,23,0,0,0,0,Guild,,GUILD_1,false,true
	CallSecureProtected("BindKeyToAction", 1,6,24,2, 0,0,0,0,0) -- 1,6,24,2,0,0,0,0,0,General,User Interface,TOGGLE_HELP,true,false
	CallSecureProtected("BindKeyToAction", 22,1,2,3, 0,0,0,0,0) -- 22,1,2,3,0,0,0,0,0,ScreenAdjustActions,,SCREEN_ADJUST_SHRINK,true,true
	CallSecureProtected("BindKeyToAction", 3,1,4,2, 172,0,0,0,0) -- 3,1,4,2,172,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_QUATERNARY,true,false
	CallSecureProtected("BindKeyToAction", 1,4,1,3, 0,0,0,0,0) -- 1,4,1,3,0,0,0,0,0,General,Camera,CAMERA_ZOOM_OUT,true,false
	CallSecureProtected("BindKeyToAction", 3,3,1,2, 0,0,0,0,0) -- 3,3,1,2,0,0,0,0,0,User Interface Shortcuts,Fish Fillet,VOTANS_FISH_FILLET_ALL_STACKS,true,false
	CallSecureProtected("BindKeyToAction", 1,21,18,3, 0,0,0,0,0) -- 1,21,18,3,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_13,true,false
	CallSecureProtected("BindKeyToAction", 1,6,26,1, 0,0,0,0,0) -- 1,6,26,1,0,0,0,0,0,General,User Interface,ASSIST_NEXT_TRACKED_QUEST,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,21,4, 0,0,0,0,0) -- 28,1,21,4,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,26,8,1, 43,7,0,0,0) -- 1,26,8,1,43,7,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_GROUP_LEADER,true,false
	CallSecureProtected("BindKeyToAction", 1,6,23,2, 0,0,0,0,0) -- 1,6,23,2,0,0,0,0,0,General,User Interface,TOGGLE_CROWN_CRATES,true,false
	CallSecureProtected("BindKeyToAction", 1,6,34,1, 0,0,0,0,0) -- 1,6,34,1,0,0,0,0,0,General,User Interface,POTIONMAKER,true,false
	CallSecureProtected("BindKeyToAction", 1,26,10,4, 0,0,0,0,0) -- 1,26,10,4,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_GUILD_HOUSE,true,false
	CallSecureProtected("BindKeyToAction", 1,11,7,1, 0,0,0,0,0) -- 1,11,7,1,0,0,0,0,0,General,CombatMetrics,CMX_RESET_FIGHT,true,false
	CallSecureProtected("BindKeyToAction", 1,18,6,2, 0,0,0,0,0) -- 1,18,6,2,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMACHATPOSTTD,true,false
	CallSecureProtected("BindKeyToAction", 30,1,1,1, 181,0,0,0,0) -- 30,1,1,1,181,0,0,0,0,SpecialToggleHelp,,GAMEPAD_SPECIAL_TOGGLE_HELP,true,false
	CallSecureProtected("BindKeyToAction", 1,21,3,4, 0,0,0,0,0) -- 1,21,3,4,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_NEXT_SET,true,false
	CallSecureProtected("BindKeyToAction", 3,1,4,1, 51,0,0,0,0) -- 3,1,4,1,51,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_QUATERNARY,true,false
	CallSecureProtected("BindKeyToAction", 1,18,10,1, 0,0,0,0,0) -- 1,18,10,1,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMAWRBTOGGLE,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,13,1, 120,0,0,0,0) -- 28,1,13,1,120,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,5,3, 0,0,0,0,0) -- 2,1,5,3,0,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 27,1,2,1, 124,0,0,0,0) -- 27,1,2,1,124,0,0,0,0,ScreenshotMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,23,3,4, 0,0,0,0,0) -- 1,23,3,4,0,0,0,0,0,General,Mail Looter,MAILLOOTER_QUICK_LOOT_FILTERED,true,false
	CallSecureProtected("BindKeyToAction", 1,2,13,4, 0,0,0,0,0) -- 1,2,13,4,0,0,0,0,0,General,Combat,ACTION_BUTTON_6,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,3,4, 0,0,0,0,0) -- 2,1,3,4,0,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 22,1,4,1, 55,0,0,0,0) -- 22,1,4,1,55,0,0,0,0,ScreenAdjustActions,,SCREEN_ADJUST_CANCEL,false,true
	CallSecureProtected("BindKeyToAction", 1,25,4,4, 0,0,0,0,0) -- 1,25,4,4,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_3,true,false
	--CallSecureProtected("BindKeyToAction", 3,1,15,1, 125,0,0,0,0) -- 3,1,15,1,125,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_INPUT_LEFT,false,true
	CallSecureProtected("BindKeyToAction", 3,1,6,4, 0,0,0,0,0) -- 3,1,6,4,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_REPORT_PLAYER,true,false
	CallSecureProtected("BindKeyToAction", 29,1,9,2, 138,0,0,0,0) -- 29,1,9,2,138,0,0,0,0,Housing Editor Placement Mode,,HOUSING_EDITOR_PUSH_FORWARD,true,false
	--CallSecureProtected("BindKeyToAction", 3,1,10,2, 127,0,0,0,0) -- 3,1,10,2,127,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_EXIT,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,24,1, 5,0,0,0,0) -- 28,1,24,1,5,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 27,1,1,4, 0,0,0,0,0) -- 27,1,1,4,0,0,0,0,0,ScreenshotMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,2,6,4, 0,0,0,0,0) -- 1,2,6,4,0,0,0,0,0,General,Combat,USE_SYNERGY,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,10,1, 129,0,0,0,0) -- 28,1,10,1,129,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,4,3, 141,0,0,0,0) -- 28,1,4,3,141,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 26,1,5,2, 0,0,0,0,0) -- 26,1,5,2,0,0,0,0,0,BattlegroundScoreboard,,BATTLEGROUND_SCOREBOARD_PLAYER_OPTIONS,false,true
	CallSecureProtected("BindKeyToAction", 1,22,1,1, 0,0,0,0,0) -- 1,22,1,1,0,0,0,0,0,General,Roomba,RUN_ROOMBA,true,false
	CallSecureProtected("BindKeyToAction", 1,18,20,1, 0,0,0,0,0) -- 1,18,20,1,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMARGLASTP,true,false
	CallSecureProtected("BindKeyToAction", 1,26,11,3, 0,0,0,0,0) -- 1,26,11,3,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_ZONE_1,true,false
	CallSecureProtected("BindKeyToAction", 1,6,16,4, 0,0,0,0,0) -- 1,6,16,4,0,0,0,0,0,General,User Interface,TOGGLE_GROUP,true,false
	--CallSecureProtected("BindKeyToAction", 12,1,2,4, 0,0,0,0,0) -- 12,1,2,4,0,0,0,0,0,Guild,,GUILD_2,false,true
	CallSecureProtected("BindKeyToAction", 1,19,3,4, 0,0,0,0,0) -- 1,19,3,4,0,0,0,0,0,General,Dustman,DUSTMAN_DESTROY,true,false
	--CallSecureProtected("BindKeyToAction", 11,1,4,1, 109,0,0,0,0) -- 11,1,4,1,109,0,0,0,0,PreviewInterceptLayer,,INTERCEPT_SPECIAL_WEAPON_SWAP,false,true
	--CallSecureProtected("BindKeyToAction", 11,1,1,4, 0,0,0,0,0) -- 11,1,1,4,0,0,0,0,0,PreviewInterceptLayer,,INTERCEPT_SHEATHE_WEAPON_TOGGLE,false,true
	CallSecureProtected("BindKeyToAction", 1,26,16,4, 0,0,0,0,0) -- 1,26,16,4,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_PLAYER_1,true,false
	CallSecureProtected("BindKeyToAction", 1,18,8,4, 0,0,0,0,0) -- 1,18,8,4,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMACHARTOGGLE,true,false
	CallSecureProtected("BindKeyToAction", 1,1,1,4, 0,0,0,0,0) -- 1,1,1,4,0,0,0,0,0,General,Movement,MOVE_FORWARD,true,false
	--CallSecureProtected("BindKeyToAction", 17,1,3,2, 127,0,0,0,0) -- 17,1,3,2,127,0,0,0,0,GamepadChatSystem,,EXIT_CHAT,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,27,3, 0,0,0,0,0) -- 28,1,27,3,0,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 21,1,1,1, 36,0,0,0,0) -- 21,1,1,1,36,0,0,0,0,OptionsWindow,,OPTIONS_APPLY_CHANGES,false,true
	--CallSecureProtected("BindKeyToAction", 17,1,4,1, 3,0,0,0,0) -- 17,1,4,1,3,0,0,0,0,GamepadChatSystem,,,false,true
	--CallSecureProtected("BindKeyToAction", 9,1,9,3, 0,0,0,0,0) -- 9,1,9,3,0,0,0,0,0,Conversation,,CONVERSATION_OPTION_9,false,true
	CallSecureProtected("BindKeyToAction", 1,15,4,4, 0,0,0,0,0) -- 1,15,4,4,0,0,0,0,0,General,Vacuum Shop,VACUUM_DOWN,true,false
	CallSecureProtected("BindKeyToAction", 1,6,19,2, 0,0,0,0,0) -- 1,6,19,2,0,0,0,0,0,General,User Interface,TOGGLE_ALLIANCE_WAR,true,false
	CallSecureProtected("BindKeyToAction", 1,6,20,3, 0,0,0,0,0) -- 1,6,20,3,0,0,0,0,0,General,User Interface,TOGGLE_MAIL,true,false
	CallSecureProtected("BindKeyToAction", 1,25,6,4, 0,0,0,0,0) -- 1,25,6,4,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_5,true,false
	--CallSecureProtected("BindKeyToAction", 9,1,12,4, 0,0,0,0,0) -- 9,1,12,4,0,0,0,0,0,Conversation,,CONVERSATION_OPTION_NEGATIVE,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,4,2, 0,0,0,0,0) -- 2,1,4,2,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,1,4,2, 0,0,0,0,0) -- 1,1,4,2,0,0,0,0,0,General,Movement,TURN_LEFT,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,17,4, 0,0,0,0,0) -- 2,1,17,4,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,2,21,4, 0,0,0,0,0) -- 1,2,21,4,0,0,0,0,0,General,Combat,GAMEPAD_ACTION_BUTTON_6,true,true
	CallSecureProtected("BindKeyToAction", 3,2,1,3, 0,0,0,0,0) -- 3,2,1,3,0,0,0,0,0,User Interface Shortcuts,Dolgubon's Lazy Writ Crafter,WRIT_CRAFTER_CRAFT_ITEMS,true,false
	CallSecureProtected("BindKeyToAction", 1,6,3,4, 0,0,0,0,0) -- 1,6,3,4,0,0,0,0,0,General,User Interface,START_CHAT_ENTER,true,false
	--CallSecureProtected("BindKeyToAction", 16,1,1,1, 36,0,0,0,0) -- 16,1,1,1,36,0,0,0,0,Loot,,LOOT_ITEM,false,true
	--CallSecureProtected("BindKeyToAction", 3,1,16,3, 0,0,0,0,0) -- 3,1,16,3,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_INPUT_RIGHT,false,true
	CallSecureProtected("BindKeyToAction", 34,1,2,2, 0,0,0,0,0) -- 34,1,2,2,0,0,0,0,0,Potion Maker,User Interface,POTIONMAKER_SEARCH_WRITS,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,6,3, 0,0,0,0,0) -- 2,1,6,3,0,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 3,1,13,2, 0,0,0,0,0) -- 3,1,13,2,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_RIGHT_SHOULDER,false,true
	CallSecureProtected("BindKeyToAction", 1,11,1,3, 0,0,0,0,0) -- 1,11,1,3,0,0,0,0,0,General,CombatMetrics,CMX_REPORT_TOGGLE,true,false
	CallSecureProtected("BindKeyToAction", 1,7,3,3, 0,0,0,0,0) -- 1,7,3,3,0,0,0,0,0,General,Mini Map,VOTANS_TOGGLE_MAP_SHOW_COMBAT,true,false
	CallSecureProtected("BindKeyToAction", 1,21,20,1, 0,0,0,0,0) -- 1,21,20,1,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_15,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,38,3, 0,0,0,0,0) -- 28,1,38,3,0,0,0,0,0,Housing Editor,,DISABLE_HOUSING_EDITOR,false,true
	CallSecureProtected("BindKeyToAction", 1,18,23,1, 0,0,0,0,0) -- 1,18,23,1,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMALFGP,true,false
	CallSecureProtected("BindKeyToAction", 1,26,1,3, 0,0,0,0,0) -- 1,26,1,3,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_TOGGLE_MAIN,true,false
	CallSecureProtected("BindKeyToAction", 1,6,21,4, 0,0,0,0,0) -- 1,6,21,4,0,0,0,0,0,General,User Interface,TOGGLE_NOTIFICATIONS,true,false
	CallSecureProtected("BindKeyToAction", 1,6,10,4, 0,0,0,0,0) -- 1,6,10,4,0,0,0,0,0,General,User Interface,TOGGLE_CHARACTER,true,false
	CallSecureProtected("BindKeyToAction", 22,1,1,1, 54,0,0,0,0) -- 22,1,1,1,54,0,0,0,0,ScreenAdjustActions,,SCREEN_ADJUST_GROW,true,true
	CallSecureProtected("BindKeyToAction", 1,2,26,2, 178,0,0,0,0) -- 1,2,26,2,178,0,0,0,0,General,Combat,SHEATHE_WEAPON_TOGGLE,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,11,2, 0,0,0,0,0) -- 2,1,11,2,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,17,1,1, 28,0,0,0,0) -- 1,17,1,1,28,0,0,0,0,General,Rapid Fire,RF_FIRING,true,false
	CallSecureProtected("BindKeyToAction", 4,1,2,2, 134,0,0,0,0) -- 4,1,2,2,134,0,0,0,0,Siege,,SIEGE_RELEASE,true,false
	--CallSecureProtected("BindKeyToAction", 4,2,2,4, 0,0,0,0,0) -- 4,2,2,4,0,0,0,0,0,Siege,Mini Map,VOTANS_TOGGLE_MAP_ZOOM_OUT_SIEGE,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,16,2, 128,0,0,0,0) -- 2,1,16,2,128,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,6,27,1, 53,0,0,0,0) -- 1,6,27,1,53,0,0,0,0,General,User Interface,TOGGLE_FIRST_PERSON,true,false
	CallSecureProtected("BindKeyToAction", 1,2,16,3, 0,0,0,0,0) -- 1,2,16,3,0,0,0,0,0,General,Combat,GAMEPAD_SPECIAL_MOVE_SPRINT,true,true
	CallSecureProtected("BindKeyToAction", 1,18,22,1, 0,0,0,0,0) -- 1,18,22,1,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMARGLASHR,true,false
	--CallSecureProtected("BindKeyToAction", 26,1,5,1, 135,0,0,0,0) -- 26,1,5,1,135,0,0,0,0,BattlegroundScoreboard,,BATTLEGROUND_SCOREBOARD_PLAYER_OPTIONS,false,true
	--CallSecureProtected("BindKeyToAction", 10,1,1,3, 128,0,0,0,0) -- 10,1,1,3,128,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_UI_SHORTCUT_EXIT,false,true
	CallSecureProtected("BindKeyToAction", 1,21,21,3, 0,0,0,0,0) -- 1,21,21,3,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_16,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,3,3, 0,0,0,0,0) -- 2,1,3,3,0,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 20,1,1,4, 0,0,0,0,0) -- 20,1,1,4,0,0,0,0,0,Addons,,ADDONS_PANEL_MULTI_BUTTON,false,true
	CallSecureProtected("BindKeyToAction", 1,21,19,1, 0,0,0,0,0) -- 1,21,19,1,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_14,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,16,4, 0,0,0,0,0) -- 2,1,16,4,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,20,3,3, 0,0,0,0,0) -- 1,20,3,3,0,0,0,0,0,General,|c3366FFBank|r Manager |c990000Revived|r,BMR_PROFILE3,true,false
	CallSecureProtected("BindKeyToAction", 1,21,10,4, 0,0,0,0,0) -- 1,21,10,4,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_5,true,false
	CallSecureProtected("BindKeyToAction", 1,8,4,1, 0,0,0,0,0) -- 1,8,4,1,0,0,0,0,0,General,HarvestMap,HARVEST_SHOW_PANEL,true,false
	CallSecureProtected("BindKeyToAction", 1,20,3,2, 0,0,0,0,0) -- 1,20,3,2,0,0,0,0,0,General,|c3366FFBank|r Manager |c990000Revived|r,BMR_PROFILE3,true,false
	CallSecureProtected("BindKeyToAction", 1,21,2,1, 0,0,0,0,0) -- 1,21,2,1,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_UNDRESS,true,false
	--CallSecureProtected("BindKeyToAction", 5,1,9,1, 20,0,0,0,0) -- 5,1,9,1,20,0,0,0,0,Dialogs,,,false,true
	--CallSecureProtected("BindKeyToAction", 1,6,25,2, 0,0,0,0,0) -- 1,6,25,2,0,0,0,0,0,General,User Interface,TOGGLE_SYSTEM,false,false
	--CallSecureProtected("BindKeyToAction", 28,1,9,2, 0,0,0,0,0) -- 28,1,9,2,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,18,8,3, 0,0,0,0,0) -- 1,18,8,3,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMACHARTOGGLE,true,false
	CallSecureProtected("BindKeyToAction", 1,3,2,3, 0,0,0,0,0) -- 1,3,2,3,0,0,0,0,0,General,Targeting,CLEAR_PREFERRED_ENEMY_TARGET,true,false
	CallSecureProtected("BindKeyToAction", 1,1,4,4, 0,0,0,0,0) -- 1,1,4,4,0,0,0,0,0,General,Movement,TURN_LEFT,true,false
	--CallSecureProtected("BindKeyToAction", 5,1,7,4, 0,0,0,0,0) -- 5,1,7,4,0,0,0,0,0,Dialogs,,,false,true
	CallSecureProtected("BindKeyToAction", 1,25,7,2, 0,0,0,0,0) -- 1,25,7,2,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_6,true,false
	CallSecureProtected("BindKeyToAction", 4,1,1,2, 138,0,0,0,0) -- 4,1,1,2,138,0,0,0,0,Siege,,SIEGE_FIRE,true,false
	CallSecureProtected("BindKeyToAction", 23,1,1,2, 167,0,0,0,0) -- 23,1,1,2,167,0,0,0,0,Housing HUD,,SHOW_HOUSING_PANEL,true,false
	CallSecureProtected("BindKeyToAction", 1,21,11,3, 0,0,0,0,0) -- 1,21,11,3,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_6,true,false
	CallSecureProtected("BindKeyToAction", 1,1,9,1, 39,0,0,0,0) -- 1,1,9,1,39,0,0,0,0,General,Movement,TOGGLE_MOUNT,true,false
	CallSecureProtected("BindKeyToAction", 1,4,2,1, 121,0,0,0,0) -- 1,4,2,1,121,0,0,0,0,General,Camera,CAMERA_ZOOM_IN,true,false
	CallSecureProtected("BindKeyToAction", 1,12,3,1, 0,0,0,0,0) -- 1,12,3,1,0,0,0,0,0,General,Foundry Tactical Combat,POST_DAMAGE_RESULTS,true,false
	--CallSecureProtected("BindKeyToAction", 22,1,3,4, 0,0,0,0,0) -- 22,1,3,4,0,0,0,0,0,ScreenAdjustActions,,SCREEN_ADJUST_SAVE,false,true
	CallSecureProtected("BindKeyToAction", 1,6,30,4, 0,0,0,0,0) -- 1,6,30,4,0,0,0,0,0,General,User Interface,TOGGLE_NAMEPLATES,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,17,4, 0,0,0,0,0) -- 28,1,17,4,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,11,1,2, 0,0,0,0,0) -- 1,11,1,2,0,0,0,0,0,General,CombatMetrics,CMX_REPORT_TOGGLE,true,false
	CallSecureProtected("BindKeyToAction", 1,21,6,4, 0,0,0,0,0) -- 1,21,6,4,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_1,true,false
	CallSecureProtected("BindKeyToAction", 1,25,4,2, 0,0,0,0,0) -- 1,25,4,2,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_3,true,false
	CallSecureProtected("BindKeyToAction", 1,26,9,4, 0,0,0,0,0) -- 1,26,9,4,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_PRIMARY_RESIDENCE,true,false
	CallSecureProtected("BindKeyToAction", 1,25,5,2, 0,0,0,0,0) -- 1,25,5,2,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_4,true,false
	CallSecureProtected("BindKeyToAction", 1,26,19,2, 0,0,0,0,0) -- 1,26,19,2,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_PLAYER_4,true,false
	--CallSecureProtected("BindKeyToAction", 9,1,3,1, 25,0,0,0,0) -- 9,1,3,1,25,0,0,0,0,Conversation,,CONVERSATION_OPTION_3,false,true
	CallSecureProtected("BindKeyToAction", 1,5,2,3, 0,0,0,0,0) -- 1,5,2,3,0,0,0,0,0,General,Interaction,PLAYER_TO_PLAYER_INTERACT,true,false
	CallSecureProtected("BindKeyToAction", 1,6,13,2, 0,0,0,0,0) -- 1,6,13,2,0,0,0,0,0,General,User Interface,TOGGLE_JOURNAL,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,28,4, 0,0,0,0,0) -- 2,1,28,4,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,6,33,1, 0,0,0,0,0) -- 1,6,33,1,0,0,0,0,0,General,User Interface,RETICLE_BRIGHTNESS_DECREASE,true,false
	CallSecureProtected("BindKeyToAction", 1,6,20,1, 105,0,0,0,0) -- 1,6,20,1,105,0,0,0,0,General,User Interface,TOGGLE_MAIL,true,false
	CallSecureProtected("BindKeyToAction", 1,18,15,2, 0,0,0,0,0) -- 1,18,15,2,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMARNDTOGGLE,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,7,4, 0,0,0,0,0) -- 10,1,7,4,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_CHARACTER,false,true
	--CallSecureProtected("BindKeyToAction", 9,1,12,2, 134,0,0,0,0) -- 9,1,12,2,134,0,0,0,0,Conversation,,CONVERSATION_OPTION_NEGATIVE,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,20,4, 0,0,0,0,0) -- 2,1,20,4,0,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,16,3, 0,0,0,0,0) -- 2,1,16,3,0,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 3,1,15,4, 0,0,0,0,0) -- 3,1,15,4,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_INPUT_LEFT,false,true
	CallSecureProtected("BindKeyToAction", 1,16,1,4, 0,0,0,0,0) -- 1,16,1,4,0,0,0,0,0,General,|cFFFF00Minceraft's Binds|r,RELOAD,true,false
	CallSecureProtected("BindKeyToAction", 1,26,3,3, 0,0,0,0,0) -- 1,26,3,3,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_TOGGLE_MAIN_RELATED_ITEMS,true,false
	--CallSecureProtected("BindKeyToAction", 4,1,5,2, 0,0,0,0,0) -- 4,1,5,2,0,0,0,0,0,Siege,,,false,true
	CallSecureProtected("BindKeyToAction", 1,6,11,1, 42,0,0,0,0) -- 1,6,11,1,42,0,0,0,0,General,User Interface,TOGGLE_SKILLS,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,12,1, 0,0,0,0,0) -- 28,1,12,1,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,26,11,1, 42,7,0,0,0) -- 1,26,11,1,42,7,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_ZONE_1,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,2,1, 3,0,0,0,0) -- 2,1,2,1,3,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,21,1,3, 0,0,0,0,0) -- 1,21,1,3,0,0,0,0,0,General,|cFFAA33AlphaGear|r,SHOW_AG_WINDOW,true,false
	CallSecureProtected("BindKeyToAction", 1,6,34,3, 0,0,0,0,0) -- 1,6,34,3,0,0,0,0,0,General,User Interface,POTIONMAKER,true,false
	CallSecureProtected("BindKeyToAction", 1,6,26,3, 0,0,0,0,0) -- 1,6,26,3,0,0,0,0,0,General,User Interface,ASSIST_NEXT_TRACKED_QUEST,true,false
	--CallSecureProtected("BindKeyToAction", 8,1,2,3, 0,0,0,0,0) -- 8,1,2,3,0,0,0,0,0,MouseUIMode,,LEFT_AND_RIGHT_MOUSE_IN_WORLD,false,true
	CallSecureProtected("BindKeyToAction", 1,16,1,2, 0,0,0,0,0) -- 1,16,1,2,0,0,0,0,0,General,|cFFFF00Minceraft's Binds|r,RELOAD,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,10,2, 0,0,0,0,0) -- 2,1,10,2,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,8,3,1, 0,0,0,0,0) -- 1,8,3,1,0,0,0,0,0,General,HarvestMap,TOGGLE_MAPPINS,true,false
	--CallSecureProtected("BindKeyToAction", 4,1,9,1, 3,0,0,0,0) -- 4,1,9,1,3,0,0,0,0,Siege,,,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,4,1, 107,0,0,0,0) -- 2,1,4,1,107,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 10,1,14,3, 0,0,0,0,0) -- 10,1,14,3,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_CONTACTS,false,true
	CallSecureProtected("BindKeyToAction", 1,20,1,1, 45,7,0,0,0) -- 1,20,1,1,45,7,0,0,0,General,|c3366FFBank|r Manager |c990000Revived|r,BMR_PROFILE1,true,false
	--CallSecureProtected("BindKeyToAction", 11,1,3,2, 130,0,0,0,0) -- 11,1,3,2,130,0,0,0,0,PreviewInterceptLayer,,INTERCEPT_SPECIAL_MOVE_CROUCH,false,true
	--CallSecureProtected("BindKeyToAction", 12,1,5,4, 0,0,0,0,0) -- 12,1,5,4,0,0,0,0,0,Guild,,GUILD_5,false,true
	CallSecureProtected("BindKeyToAction", 1,2,24,4, 0,0,0,0,0) -- 1,2,24,4,0,0,0,0,0,General,Combat,ACTION_BUTTON_9,true,false
	--CallSecureProtected("BindKeyToAction", 15,1,2,3, 0,0,0,0,0) -- 15,1,2,3,0,0,0,0,0,Death,,DEATH_SECONDARY,false,true
	CallSecureProtected("BindKeyToAction", 1,26,17,3, 0,0,0,0,0) -- 1,26,17,3,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_PLAYER_2,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,5,1, 12,0,0,0,0) -- 2,1,5,1,12,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,2,4,1, 4,0,0,0,0) -- 1,2,4,1,4,0,0,0,0,General,Combat,SPECIAL_MOVE_CROUCH,true,false
	CallSecureProtected("BindKeyToAction", 1,25,9,3, 0,0,0,0,0) -- 1,25,9,3,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_8,true,false
	--CallSecureProtected("BindKeyToAction", 3,1,17,4, 0,0,0,0,0) -- 3,1,17,4,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_INPUT_UP,false,true
	CallSecureProtected("BindKeyToAction", 1,24,1,2, 0,0,0,0,0) -- 1,24,1,2,0,0,0,0,0,General,CraftStore,SHOW_CRAFTSTOREFIXED_WINDOW,true,false
	CallSecureProtected("BindKeyToAction", 1,18,18,1, 0,0,0,0,0) -- 1,18,18,1,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMARGLA,true,false
	--CallSecureProtected("BindKeyToAction", 13,1,4,4, 0,0,0,0,0) -- 13,1,4,4,0,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_4,false,true
	CallSecureProtected("BindKeyToAction", 1,11,8,1, 0,0,0,0,0) -- 1,11,8,1,0,0,0,0,0,General,CombatMetrics,CMX_LIVEREPORT_TOGGLE,true,false
	--CallSecureProtected("BindKeyToAction", 15,1,5,3, 0,0,0,0,0) -- 15,1,5,3,0,0,0,0,0,Death,,DEATH_RECAP_TOGGLE,false,true
	--CallSecureProtected("BindKeyToAction", 25,1,1,1, 79,0,0,0,0) -- 25,1,1,1,79,0,0,0,0,BattlegroundHud,,SHOW_BATTLEGROUND_SCOREBOARD,false,true
	--CallSecureProtected("BindKeyToAction", 13,1,8,2, 66,0,0,0,0) -- 13,1,8,2,66,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_8,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,20,3, 0,0,0,0,0) -- 2,1,20,3,0,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,1,1, 128,0,0,0,0) -- 2,1,1,1,128,0,0,0,0,GamepadUIMode,,GAMEPAD_UI_EXIT,false,true
	--CallSecureProtected("BindKeyToAction", 9,1,2,1, 24,0,0,0,0) -- 9,1,2,1,24,0,0,0,0,Conversation,,CONVERSATION_OPTION_2,false,true
	CallSecureProtected("BindKeyToAction", 1,8,2,1, 0,0,0,0,0) -- 1,8,2,1,0,0,0,0,0,General,HarvestMap,TOGGLE_WORLDPINS,true,false
	CallSecureProtected("BindKeyToAction", 22,1,1,3, 0,0,0,0,0) -- 22,1,1,3,0,0,0,0,0,ScreenAdjustActions,,SCREEN_ADJUST_GROW,true,true
	--CallSecureProtected("BindKeyToAction", 29,1,2,4, 0,0,0,0,0) -- 29,1,2,4,0,0,0,0,0,Housing Editor Placement Mode,,,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,28,2, 0,0,0,0,0) -- 2,1,28,2,0,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,14,2, 0,0,0,0,0) -- 2,1,14,2,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,1,9,4, 0,0,0,0,0) -- 1,1,9,4,0,0,0,0,0,General,Movement,TOGGLE_MOUNT,true,false
	--CallSecureProtected("BindKeyToAction", 3,1,16,4, 0,0,0,0,0) -- 3,1,16,4,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_INPUT_RIGHT,false,true
	CallSecureProtected("BindKeyToAction", 28,1,31,1, 49,0,0,0,0) -- 28,1,31,1,49,0,0,0,0,Housing Editor,,HOUSING_EDITOR_SECONDARY_ACTION,true,false
	CallSecureProtected("BindKeyToAction", 28,1,39,4, 0,0,0,0,0) -- 28,1,39,4,0,0,0,0,0,Housing Editor,,HOUSING_EDITOR_UNDO_ACTION,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,15,2, 0,0,0,0,0) -- 2,1,15,2,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,25,1,2, 0,0,0,0,0) -- 1,25,1,2,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_OPEN,true,false
	CallSecureProtected("BindKeyToAction", 28,1,41,4, 0,0,0,0,0) -- 28,1,41,4,0,0,0,0,0,Housing Editor,,HOUSING_EDITOR_BEGIN_FURNITURE_LINKING,true,false
	CallSecureProtected("BindKeyToAction", 1,6,31,3, 0,0,0,0,0) -- 1,6,31,3,0,0,0,0,0,General,User Interface,TOGGLE_HEALTHBARS,true,false
	CallSecureProtected("BindKeyToAction", 1,8,4,3, 0,0,0,0,0) -- 1,8,4,3,0,0,0,0,0,General,HarvestMap,HARVEST_SHOW_PANEL,true,false
	CallSecureProtected("BindKeyToAction", 1,28,1,3, 0,0,0,0,0) -- 1,28,1,3,0,0,0,0,0,General,LFG Auto Accept,LFGAA_1,true,false
	CallSecureProtected("BindKeyToAction", 1,2,21,2, 0,0,0,0,0) -- 1,2,21,2,0,0,0,0,0,General,Combat,GAMEPAD_ACTION_BUTTON_6,true,true
	--CallSecureProtected("BindKeyToAction", 2,1,17,2, 0,0,0,0,0) -- 2,1,17,2,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,21,13,1, 0,0,0,0,0) -- 1,21,13,1,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_8,true,false
	CallSecureProtected("BindKeyToAction", 1,2,13,2, 0,0,0,0,0) -- 1,2,13,2,0,0,0,0,0,General,Combat,ACTION_BUTTON_6,true,false
	CallSecureProtected("BindKeyToAction", 1,19,4,2, 0,0,0,0,0) -- 1,19,4,2,0,0,0,0,0,General,Dustman,DUSTMAN_RESCAN,true,false
	CallSecureProtected("BindKeyToAction", 1,26,13,3, 0,0,0,0,0) -- 1,26,13,3,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_ZONE_3,true,false
	--CallSecureProtected("BindKeyToAction", 9,1,11,1, 36,0,0,0,0) -- 9,1,11,1,36,0,0,0,0,Conversation,,CONVERSATION_OPTION_PRIMARY,false,true
	CallSecureProtected("BindKeyToAction", 1,27,1,1, 31,0,0,0,0) -- 1,27,1,1,31,0,0,0,0,General,Mementos,HOLIDAY_MEMENTO,true,false
	CallSecureProtected("BindKeyToAction", 1,11,3,4, 0,0,0,0,0) -- 1,11,3,4,0,0,0,0,0,General,CombatMetrics,CMX_POST_DPS_SMART,true,false
	CallSecureProtected("BindKeyToAction", 1,6,19,3, 0,0,0,0,0) -- 1,6,19,3,0,0,0,0,0,General,User Interface,TOGGLE_ALLIANCE_WAR,true,false
	CallSecureProtected("BindKeyToAction", 1,6,14,3, 0,0,0,0,0) -- 1,6,14,3,0,0,0,0,0,General,User Interface,TOGGLE_COLLECTIONS_BOOK,true,false
	CallSecureProtected("BindKeyToAction", 1,6,9,1, 40,0,0,0,0) -- 1,6,9,1,40,0,0,0,0,General,User Interface,TOGGLE_INVENTORY,true,false
	CallSecureProtected("BindKeyToAction", 24,1,3,4, 0,0,0,0,0) -- 24,1,3,4,0,0,0,0,0,Battlegrounds,,BATTLEGROUND_SCOREBOARD_PREVIOUS_DUMMY,true,false
	CallSecureProtected("BindKeyToAction", 1,2,8,3, 0,0,0,0,0) -- 1,2,8,3,0,0,0,0,0,General,Combat,SPECIAL_MOVE_WEAPON_SWAP_TO_SET_1,true,false
	CallSecureProtected("BindKeyToAction", 1,20,9,1, 0,0,0,0,0) -- 1,20,9,1,0,0,0,0,0,General,|c3366FFBank|r Manager |c990000Revived|r,BMR_PROFILE9,true,false
	CallSecureProtected("BindKeyToAction", 1,26,13,1, 0,0,0,0,0) -- 1,26,13,1,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_ZONE_3,true,false
	CallSecureProtected("BindKeyToAction", 1,26,16,2, 0,0,0,0,0) -- 1,26,16,2,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_PLAYER_1,true,false
	CallSecureProtected("BindKeyToAction", 1,26,12,4, 0,0,0,0,0) -- 1,26,12,4,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_ZONE_2,true,false
	CallSecureProtected("BindKeyToAction", 1,15,3,2, 0,0,0,0,0) -- 1,15,3,2,0,0,0,0,0,General,Vacuum Shop,VACUUM_UP,true,false
	CallSecureProtected("BindKeyToAction", 1,25,9,1, 0,0,0,0,0) -- 1,25,9,1,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_8,true,false
	CallSecureProtected("BindKeyToAction", 1,18,20,4, 0,0,0,0,0) -- 1,18,20,4,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMARGLASTP,true,false
	CallSecureProtected("BindKeyToAction", 1,21,5,1, 0,0,0,0,0) -- 1,21,5,1,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_TOGGLE_SET,true,false
	CallSecureProtected("BindKeyToAction", 1,21,3,3, 0,0,0,0,0) -- 1,21,3,3,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_NEXT_SET,true,false
	--CallSecureProtected("BindKeyToAction", 11,1,1,2, 178,0,0,0,0) -- 11,1,1,2,178,0,0,0,0,PreviewInterceptLayer,,INTERCEPT_SHEATHE_WEAPON_TOGGLE,false,true
	CallSecureProtected("BindKeyToAction", 1,5,1,2, 0,0,0,0,0) -- 1,5,1,2,0,0,0,0,0,General,Interaction,GAME_CAMERA_INTERACT,true,false
	CallSecureProtected("BindKeyToAction", 1,7,2,2, 0,0,0,0,0) -- 1,7,2,2,0,0,0,0,0,General,Mini Map,VOTANS_TOGGLE_MAP_SHOW_HUD,true,false
	CallSecureProtected("BindKeyToAction", 1,2,26,1, 0,0,0,0,0) -- 1,2,26,1,0,0,0,0,0,General,Combat,SHEATHE_WEAPON_TOGGLE,true,false
	CallSecureProtected("BindKeyToAction", 1,2,7,4, 0,0,0,0,0) -- 1,2,7,4,0,0,0,0,0,General,Combat,SPECIAL_MOVE_WEAPON_SWAP,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,4,4, 0,0,0,0,0) -- 2,1,4,4,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,18,6,4, 0,0,0,0,0) -- 1,18,6,4,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMACHATPOSTTD,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,4,1, 5,0,0,0,0) -- 10,1,4,1,5,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_GAME_CAMERA_UI_MODE,false,true
	--CallSecureProtected("BindKeyToAction", 8,1,3,3, 0,0,0,0,0) -- 8,1,3,3,0,0,0,0,0,MouseUIMode,,RIGHT_MOUSE_IN_WORLD,false,true
	--CallSecureProtected("BindKeyToAction", 10,1,11,4, 0,0,0,0,0) -- 10,1,11,4,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_COLLECTIONS_BOOK,false,true
	--CallSecureProtected("BindKeyToAction", 11,1,6,1, 0,0,0,0,0) -- 11,1,6,1,0,0,0,0,0,PreviewInterceptLayer,,INTERCEPT_SPECIAL_WEAPON_SWAP_TO_SET_2,false,true
	CallSecureProtected("BindKeyToAction", 1,21,7,3, 0,0,0,0,0) -- 1,21,7,3,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_2,true,false
	CallSecureProtected("BindKeyToAction", 1,21,9,4, 0,0,0,0,0) -- 1,21,9,4,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_4,true,false
	CallSecureProtected("BindKeyToAction", 1,15,3,4, 0,0,0,0,0) -- 1,15,3,4,0,0,0,0,0,General,Vacuum Shop,VACUUM_UP,true,false
	CallSecureProtected("BindKeyToAction", 1,18,3,1, 0,0,0,0,0) -- 1,18,3,1,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMATABCHANGE,true,false
	CallSecureProtected("BindKeyToAction", 1,26,1,2, 0,0,0,0,0) -- 1,26,1,2,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_TOGGLE_MAIN,true,false
	CallSecureProtected("BindKeyToAction", 1,26,13,2, 0,0,0,0,0) -- 1,26,13,2,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_ZONE_3,true,false
	--CallSecureProtected("BindKeyToAction", 9,1,7,3, 0,0,0,0,0) -- 9,1,7,3,0,0,0,0,0,Conversation,,CONVERSATION_OPTION_7,false,true
	CallSecureProtected("BindKeyToAction", 1,20,5,1, 0,0,0,0,0) -- 1,20,5,1,0,0,0,0,0,General,|c3366FFBank|r Manager |c990000Revived|r,BMR_PROFILE5,true,false
	--CallSecureProtected("BindKeyToAction", 3,1,13,1, 132,0,0,0,0) -- 3,1,13,1,132,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_RIGHT_SHOULDER,false,true
	CallSecureProtected("BindKeyToAction", 1,18,12,4, 0,0,0,0,0) -- 1,18,12,4,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMACLGLTOGGLE,true,false
	--CallSecureProtected("BindKeyToAction", 22,1,4,2, 134,0,0,0,0) -- 22,1,4,2,134,0,0,0,0,ScreenAdjustActions,,SCREEN_ADJUST_CANCEL,false,true
	CallSecureProtected("BindKeyToAction", 1,2,23,3, 0,0,0,0,0) -- 1,2,23,3,0,0,0,0,0,General,Combat,GAMEPAD_ACTION_BUTTON_8,true,true
	--CallSecureProtected("BindKeyToAction", 10,1,2,4, 0,0,0,0,0) -- 10,1,2,4,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_UI_SHORTCUT_NEGATIVE,false,true
	CallSecureProtected("BindKeyToAction", 1,2,6,3, 0,0,0,0,0) -- 1,2,6,3,0,0,0,0,0,General,Combat,USE_SYNERGY,true,false
	CallSecureProtected("BindKeyToAction", 1,5,1,4, 0,0,0,0,0) -- 1,5,1,4,0,0,0,0,0,General,Interaction,GAME_CAMERA_INTERACT,true,false
	--CallSecureProtected("BindKeyToAction", 13,1,3,4, 0,0,0,0,0) -- 13,1,3,4,0,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_3,false,true
	CallSecureProtected("BindKeyToAction", 1,26,7,2, 0,0,0,0,0) -- 1,26,7,2,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_REFRESH,true,false
	CallSecureProtected("BindKeyToAction", 29,1,6,1, 26,0,0,0,0) -- 29,1,6,1,26,0,0,0,0,Housing Editor Placement Mode,,HOUSING_EDITOR_PITCH_BACKWARD,true,false
	CallSecureProtected("BindKeyToAction", 1,21,8,3, 0,0,0,0,0) -- 1,21,8,3,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_3,true,false
	CallSecureProtected("BindKeyToAction", 1,10,1,1, 0,0,0,0,0) -- 1,10,1,1,0,0,0,0,0,General,Rare Fish Tracker,RARE_FISH_TRACKER_TOGGLE,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,20,2, 0,0,0,0,0) -- 2,1,20,2,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,12,2,2, 0,0,0,0,0) -- 1,12,2,2,0,0,0,0,0,General,Foundry Tactical Combat,DISPLAY_DAMAGE_REPORT,true,false
	CallSecureProtected("BindKeyToAction", 1,26,1,4, 0,0,0,0,0) -- 1,26,1,4,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_TOGGLE_MAIN,true,false
	CallSecureProtected("BindKeyToAction", 1,18,1,2, 0,0,0,0,0) -- 1,18,1,2,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMAWINDOWTOGGLE,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,26,4, 0,0,0,0,0) -- 28,1,26,4,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,25,3,2, 0,0,0,0,0) -- 1,25,3,2,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_2,true,false
	CallSecureProtected("BindKeyToAction", 1,11,4,2, 0,0,0,0,0) -- 1,11,4,2,0,0,0,0,0,General,CombatMetrics,CMX_POST_DPS_SINGLE,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,11,2, 0,0,0,0,0) -- 10,1,11,2,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_COLLECTIONS_BOOK,false,true
	CallSecureProtected("BindKeyToAction", 1,11,2,1, 0,0,0,0,0) -- 1,11,2,1,0,0,0,0,0,General,CombatMetrics,CMX_POST_DPS,true,false
	CallSecureProtected("BindKeyToAction", 1,2,21,1, 131,0,0,0,0) -- 1,2,21,1,131,0,0,0,0,General,Combat,GAMEPAD_ACTION_BUTTON_6,true,true
	--CallSecureProtected("BindKeyToAction", 4,1,11,4, 0,0,0,0,0) -- 4,1,11,4,0,0,0,0,0,Siege,,,false,true
	CallSecureProtected("BindKeyToAction", 1,2,7,3, 125,0,0,0,0) -- 1,2,7,3,125,0,0,0,0,General,Combat,SPECIAL_MOVE_WEAPON_SWAP,true,false
	CallSecureProtected("BindKeyToAction", 28,1,34,3, 0,0,0,0,0) -- 28,1,34,3,0,0,0,0,0,Housing Editor,,HOUSING_EDITOR_QUINARY_ACTION,true,false
	CallSecureProtected("BindKeyToAction", 24,1,1,1, 79,0,0,0,0) -- 24,1,1,1,79,0,0,0,0,Battlegrounds,,TOGGLE_BATTLEGROUND_SCOREBOARD_DUMMY,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,24,3, 0,0,0,0,0) -- 2,1,24,3,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,7,1,1, 0,0,0,0,0) -- 1,7,1,1,0,0,0,0,0,General,Mini Map,VOTANS_TOGGLE_MAP_SHOW,true,false
	CallSecureProtected("BindKeyToAction", 1,18,7,3, 0,0,0,0,0) -- 1,18,7,3,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMACHATPOSTTDCL,true,false
	CallSecureProtected("BindKeyToAction", 1,21,9,2, 0,0,0,0,0) -- 1,21,9,2,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_4,true,false
	CallSecureProtected("BindKeyToAction", 1,6,7,1, 5,0,0,0,0) -- 1,6,7,1,5,0,0,0,0,General,User Interface,TOGGLE_GAME_CAMERA_UI_MODE,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,13,3, 0,0,0,0,0) -- 28,1,13,3,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,2,15,4, 0,0,0,0,0) -- 1,2,15,4,0,0,0,0,0,General,Combat,ACTION_BUTTON_8,true,false
	CallSecureProtected("BindKeyToAction", 1,23,1,4, 0,0,0,0,0) -- 1,23,1,4,0,0,0,0,0,General,Mail Looter,MAILLOOTER_OPEN,true,false
	CallSecureProtected("BindKeyToAction", 1,19,3,3, 0,0,0,0,0) -- 1,19,3,3,0,0,0,0,0,General,Dustman,DUSTMAN_DESTROY,true,false
	CallSecureProtected("BindKeyToAction", 28,1,40,2, 132,0,0,0,0) -- 28,1,40,2,132,0,0,0,0,Housing Editor,,HOUSING_EDITOR_REDO_ACTION,true,false
	CallSecureProtected("BindKeyToAction", 1,18,19,4, 0,0,0,0,0) -- 1,18,19,4,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMARGLASRT,true,false
	CallSecureProtected("BindKeyToAction", 1,26,19,1, 0,0,0,0,0) -- 1,26,19,1,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_PLAYER_4,true,false
	--CallSecureProtected("BindKeyToAction", 1,6,25,3, 0,0,0,0,0) -- 1,6,25,3,0,0,0,0,0,General,User Interface,TOGGLE_SYSTEM,false,false
	--CallSecureProtected("BindKeyToAction", 12,1,1,4, 0,0,0,0,0) -- 12,1,1,4,0,0,0,0,0,Guild,,GUILD_1,false,true
	CallSecureProtected("BindKeyToAction", 1,21,20,2, 0,0,0,0,0) -- 1,21,20,2,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_15,true,false
	CallSecureProtected("BindKeyToAction", 34,1,3,4, 0,0,0,0,0) -- 34,1,3,4,0,0,0,0,0,Potion Maker,User Interface,POTIONMAKER_SEARCH_FAVORITS,true,false
	CallSecureProtected("BindKeyToAction", 34,1,3,3, 0,0,0,0,0) -- 34,1,3,3,0,0,0,0,0,Potion Maker,User Interface,POTIONMAKER_SEARCH_FAVORITS,true,false
	CallSecureProtected("BindKeyToAction", 1,2,26,3, 0,0,0,0,0) -- 1,2,26,3,0,0,0,0,0,General,Combat,SHEATHE_WEAPON_TOGGLE,true,false
	CallSecureProtected("BindKeyToAction", 1,6,22,1, 0,0,0,0,0) -- 1,6,22,1,0,0,0,0,0,General,User Interface,TOGGLE_ACTIVITY_FINDER,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,8,3, 0,0,0,0,0) -- 2,1,8,3,0,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,28,1, 75,0,0,0,0) -- 28,1,28,1,75,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,3,2,1, 0,0,0,0,0) -- 1,3,2,1,0,0,0,0,0,General,Targeting,CLEAR_PREFERRED_ENEMY_TARGET,true,false
	CallSecureProtected("BindKeyToAction", 28,1,32,3, 0,0,0,0,0) -- 28,1,32,3,0,0,0,0,0,Housing Editor,,HOUSING_EDITOR_TERTIARY_ACTION,true,false
	CallSecureProtected("BindKeyToAction", 1,23,3,2, 0,0,0,0,0) -- 1,23,3,2,0,0,0,0,0,General,Mail Looter,MAILLOOTER_QUICK_LOOT_FILTERED,true,false
	CallSecureProtected("BindKeyToAction", 34,1,2,4, 0,0,0,0,0) -- 34,1,2,4,0,0,0,0,0,Potion Maker,User Interface,POTIONMAKER_SEARCH_WRITS,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,7,4, 0,0,0,0,0) -- 28,1,7,4,0,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 4,2,5,3, 0,0,0,0,0) -- 4,2,5,3,0,0,0,0,0,Siege,Mini Map,VOTANS_TOGGLE_MAP_ZOOM_MINUS_SIEGE,false,true
	CallSecureProtected("BindKeyToAction", 24,1,5,4, 0,0,0,0,0) -- 24,1,5,4,0,0,0,0,0,Battlegrounds,,BATTLEGROUND_SCOREBOARD_PLAYER_OPTIONS_DUMMY,true,false
	CallSecureProtected("BindKeyToAction", 1,6,1,3, 0,0,0,0,0) -- 1,6,1,3,0,0,0,0,0,General,User Interface,TOGGLE_FULLSCREEN,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,26,2, 0,0,0,0,0) -- 28,1,26,2,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 34,1,1,3, 0,0,0,0,0) -- 34,1,1,3,0,0,0,0,0,Potion Maker,User Interface,POTIONMAKER_SEARCH,true,false
	CallSecureProtected("BindKeyToAction", 1,6,5,3, 0,0,0,0,0) -- 1,6,5,3,0,0,0,0,0,General,User Interface,CHAT_REPLY_TO_LAST_WHISPER,true,false
	--CallSecureProtected("BindKeyToAction", 18,1,1,2, 127,0,0,0,0) -- 18,1,1,2,127,0,0,0,0,GameMenu,,GAME_MENU_DO_NOTHING,false,true
	CallSecureProtected("BindKeyToAction", 34,1,1,1, 71,0,0,0,0) -- 34,1,1,1,71,0,0,0,0,Potion Maker,User Interface,POTIONMAKER_SEARCH,true,false
	--CallSecureProtected("BindKeyToAction", 33,1,1,4, 0,0,0,0,0) -- 33,1,1,4,0,0,0,0,0,PathNodeRotationBlockCrouchLayer,,,false,true
	--CallSecureProtected("BindKeyToAction", 13,1,9,3, 0,0,0,0,0) -- 13,1,9,3,0,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_9,false,true
	--CallSecureProtected("BindKeyToAction", 10,1,7,2, 0,0,0,0,0) -- 10,1,7,2,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_CHARACTER,false,true
	CallSecureProtected("BindKeyToAction", 1,26,9,2, 0,0,0,0,0) -- 1,26,9,2,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_PRIMARY_RESIDENCE,true,false
	--CallSecureProtected("BindKeyToAction", 4,1,13,1, 124,0,0,0,0) -- 4,1,13,1,124,0,0,0,0,Siege,,,false,true
	CallSecureProtected("BindKeyToAction", 1,20,5,2, 0,0,0,0,0) -- 1,20,5,2,0,0,0,0,0,General,|c3366FFBank|r Manager |c990000Revived|r,BMR_PROFILE5,true,false
	--CallSecureProtected("BindKeyToAction", 33,1,1,2, 130,0,0,0,0) -- 33,1,1,2,130,0,0,0,0,PathNodeRotationBlockCrouchLayer,,,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,25,1, 30,0,0,0,0) -- 2,1,25,1,30,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,26,13,4, 0,0,0,0,0) -- 1,26,13,4,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_ZONE_3,true,false
	CallSecureProtected("BindKeyToAction", 1,6,14,2, 0,0,0,0,0) -- 1,6,14,2,0,0,0,0,0,General,User Interface,TOGGLE_COLLECTIONS_BOOK,true,false
	CallSecureProtected("BindKeyToAction", 1,20,8,4, 0,0,0,0,0) -- 1,20,8,4,0,0,0,0,0,General,|c3366FFBank|r Manager |c990000Revived|r,BMR_PROFILE8,true,false
	CallSecureProtected("BindKeyToAction", 1,6,16,3, 0,0,0,0,0) -- 1,6,16,3,0,0,0,0,0,General,User Interface,TOGGLE_GROUP,true,false
	CallSecureProtected("BindKeyToAction", 22,1,1,4, 0,0,0,0,0) -- 22,1,1,4,0,0,0,0,0,ScreenAdjustActions,,SCREEN_ADJUST_GROW,true,true
	CallSecureProtected("BindKeyToAction", 1,6,1,2, 0,0,0,0,0) -- 1,6,1,2,0,0,0,0,0,General,User Interface,TOGGLE_FULLSCREEN,true,false
	CallSecureProtected("BindKeyToAction", 1,2,27,3, 0,0,0,0,0) -- 1,2,27,3,0,0,0,0,0,General,Combat,COMMAND_PET,true,false
	CallSecureProtected("BindKeyToAction", 29,1,7,4, 0,0,0,0,0) -- 29,1,7,4,0,0,0,0,0,Housing Editor Placement Mode,,HOUSING_EDITOR_ROLL_LEFT,true,false
	CallSecureProtected("BindKeyToAction", 32,1,1,4, 0,0,0,0,0) -- 32,1,1,4,0,0,0,0,0,AntiquityDiggingActions,,ANTIQUITY_DIGGING_MORE_INFO,true,false
	CallSecureProtected("BindKeyToAction", 1,18,20,3, 0,0,0,0,0) -- 1,18,20,3,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMARGLASTP,true,false
	CallSecureProtected("BindKeyToAction", 1,20,2,1, 44,7,0,0,0) -- 1,20,2,1,44,7,0,0,0,General,|c3366FFBank|r Manager |c990000Revived|r,BMR_PROFILE2,true,false
	CallSecureProtected("BindKeyToAction", 1,1,10,2, 0,0,0,0,0) -- 1,1,10,2,0,0,0,0,0,General,Movement,GAMEPAD_JUMP_OR_INTERACT,true,true
	CallSecureProtected("BindKeyToAction", 28,1,37,4, 0,0,0,0,0) -- 28,1,37,4,0,0,0,0,0,Housing Editor,,HOUSING_EDITOR_JUMP_TO_SAFE_LOC,true,false
	CallSecureProtected("BindKeyToAction", 32,1,1,3, 0,0,0,0,0) -- 32,1,1,3,0,0,0,0,0,AntiquityDiggingActions,,ANTIQUITY_DIGGING_MORE_INFO,true,false
	CallSecureProtected("BindKeyToAction", 1,18,15,3, 0,0,0,0,0) -- 1,18,15,3,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMARNDTOGGLE,true,false
	CallSecureProtected("BindKeyToAction", 3,3,1,4, 0,0,0,0,0) -- 3,3,1,4,0,0,0,0,0,User Interface Shortcuts,Fish Fillet,VOTANS_FISH_FILLET_ALL_STACKS,true,false
	CallSecureProtected("BindKeyToAction", 5,1,6,1, 55,0,0,0,0) -- 5,1,6,1,55,0,0,0,0,Dialogs,,DIALOG_RESET,true,false
	--CallSecureProtected("BindKeyToAction", 15,1,3,4, 0,0,0,0,0) -- 15,1,3,4,0,0,0,0,0,Death,,DEATH_TERTIARY,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,13,1, 100,0,0,0,0) -- 2,1,13,1,100,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 12,1,4,3, 0,0,0,0,0) -- 12,1,4,3,0,0,0,0,0,Guild,,GUILD_4,false,true
	--CallSecureProtected("BindKeyToAction", 31,1,5,3, 0,0,0,0,0) -- 31,1,5,3,0,0,0,0,0,ScryingActions,,,false,true
	--CallSecureProtected("BindKeyToAction", 31,1,5,2, 0,0,0,0,0) -- 31,1,5,2,0,0,0,0,0,ScryingActions,,,false,true
	--CallSecureProtected("BindKeyToAction", 31,1,5,1, 124,0,0,0,0) -- 31,1,5,1,124,0,0,0,0,ScryingActions,,,false,true
	--CallSecureProtected("BindKeyToAction", 31,1,4,4, 0,0,0,0,0) -- 31,1,4,4,0,0,0,0,0,ScryingActions,,,false,true
	--CallSecureProtected("BindKeyToAction", 31,1,4,3, 0,0,0,0,0) -- 31,1,4,3,0,0,0,0,0,ScryingActions,,,false,true
	CallSecureProtected("BindKeyToAction", 3,2,1,1, 0,0,0,0,0) -- 3,2,1,1,0,0,0,0,0,User Interface Shortcuts,Dolgubon's Lazy Writ Crafter,WRIT_CRAFTER_CRAFT_ITEMS,true,false
	CallSecureProtected("BindKeyToAction", 22,1,1,2, 0,0,0,0,0) -- 22,1,1,2,0,0,0,0,0,ScreenAdjustActions,,SCREEN_ADJUST_GROW,true,true
	--CallSecureProtected("BindKeyToAction", 10,1,4,3, 128,0,0,0,0) -- 10,1,4,3,128,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_GAME_CAMERA_UI_MODE,false,true
	--CallSecureProtected("BindKeyToAction", 31,1,3,4, 0,0,0,0,0) -- 31,1,3,4,0,0,0,0,0,ScryingActions,,,false,true
	--CallSecureProtected("BindKeyToAction", 31,1,3,3, 0,0,0,0,0) -- 31,1,3,3,0,0,0,0,0,ScryingActions,,,false,true
	--CallSecureProtected("BindKeyToAction", 31,1,3,2, 137,0,0,0,0) -- 31,1,3,2,137,0,0,0,0,ScryingActions,,,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,11,2, 130,0,0,0,0) -- 28,1,11,2,130,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 29,1,4,1, 24,0,0,0,0) -- 29,1,4,1,24,0,0,0,0,Housing Editor Placement Mode,,HOUSING_EDITOR_YAW_RIGHT,true,false
	--CallSecureProtected("BindKeyToAction", 31,1,2,3, 0,0,0,0,0) -- 31,1,2,3,0,0,0,0,0,ScryingActions,,,false,true
	CallSecureProtected("BindKeyToAction", 1,25,3,3, 0,0,0,0,0) -- 1,25,3,3,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_2,true,false
	--CallSecureProtected("BindKeyToAction", 26,1,2,2, 167,0,0,0,0) -- 26,1,2,2,167,0,0,0,0,BattlegroundScoreboard,,HIDE_BATTLEGROUND_SCOREBOARD,false,true
	--CallSecureProtected("BindKeyToAction", 9,1,6,1, 28,0,0,0,0) -- 9,1,6,1,28,0,0,0,0,Conversation,,CONVERSATION_OPTION_6,false,true
	CallSecureProtected("BindKeyToAction", 1,3,2,4, 0,0,0,0,0) -- 1,3,2,4,0,0,0,0,0,General,Targeting,CLEAR_PREFERRED_ENEMY_TARGET,true,false
	CallSecureProtected("BindKeyToAction", 1,6,21,3, 0,0,0,0,0) -- 1,6,21,3,0,0,0,0,0,General,User Interface,TOGGLE_NOTIFICATIONS,true,false
	--CallSecureProtected("BindKeyToAction", 31,1,2,2, 138,0,0,0,0) -- 31,1,2,2,138,0,0,0,0,ScryingActions,,,false,true
	--CallSecureProtected("BindKeyToAction", 31,1,2,1, 114,0,0,0,0) -- 31,1,2,1,114,0,0,0,0,ScryingActions,,,false,true
	--CallSecureProtected("BindKeyToAction", 27,1,4,2, 136,0,0,0,0) -- 27,1,4,2,136,0,0,0,0,ScreenshotMode,,SCREENSHOT_MODE_SHOW_UI_1,false,true
	--CallSecureProtected("BindKeyToAction", 31,1,1,3, 0,0,0,0,0) -- 31,1,1,3,0,0,0,0,0,ScryingActions,,,false,true
	--CallSecureProtected("BindKeyToAction", 31,1,1,2, 130,0,0,0,0) -- 31,1,1,2,130,0,0,0,0,ScryingActions,,,false,true
	CallSecureProtected("BindKeyToAction", 1,2,19,3, 0,0,0,0,0) -- 1,2,19,3,0,0,0,0,0,General,Combat,GAMEPAD_ACTION_BUTTON_4,true,true
	CallSecureProtected("BindKeyToAction", 1,19,3,1, 29,0,0,0,0) -- 1,19,3,1,29,0,0,0,0,General,Dustman,DUSTMAN_DESTROY,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,1,2, 127,0,0,0,0) -- 10,1,1,2,127,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_UI_SHORTCUT_EXIT,false,true
	CallSecureProtected("BindKeyToAction", 30,1,1,4, 0,0,0,0,0) -- 30,1,1,4,0,0,0,0,0,SpecialToggleHelp,,GAMEPAD_SPECIAL_TOGGLE_HELP,true,false
	CallSecureProtected("BindKeyToAction", 30,1,1,3, 0,0,0,0,0) -- 30,1,1,3,0,0,0,0,0,SpecialToggleHelp,,GAMEPAD_SPECIAL_TOGGLE_HELP,true,false
	CallSecureProtected("BindKeyToAction", 1,2,3,2, 0,0,0,0,0) -- 1,2,3,2,0,0,0,0,0,General,Combat,SPECIAL_MOVE_SPRINT,true,false
	CallSecureProtected("BindKeyToAction", 3,1,2,2, 135,0,0,0,0) -- 3,1,2,2,135,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_SECONDARY,true,false
	CallSecureProtected("BindKeyToAction", 5,1,5,2, 127,0,0,0,0) -- 5,1,5,2,127,0,0,0,0,Dialogs,,DIALOG_CLOSE,true,false
	CallSecureProtected("BindKeyToAction", 30,1,1,2, 0,0,0,0,0) -- 30,1,1,2,0,0,0,0,0,SpecialToggleHelp,,GAMEPAD_SPECIAL_TOGGLE_HELP,true,false
	CallSecureProtected("BindKeyToAction", 1,14,1,1, 101,0,0,0,0) -- 1,14,1,1,101,0,0,0,0,General,Urich's Skill Point Finder,USPF_TOGGLE,true,false
	CallSecureProtected("BindKeyToAction", 1,18,14,2, 0,0,0,0,0) -- 1,18,14,2,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMATRIALTOGGLE,true,false
	CallSecureProtected("BindKeyToAction", 29,1,11,3, 0,0,0,0,0) -- 29,1,11,3,0,0,0,0,0,Housing Editor Placement Mode,,HOUSING_EDITOR_ALIGN_TO_SURFACE,true,false
	CallSecureProtected("BindKeyToAction", 6,1,1,1, 37,0,0,0,0) -- 6,1,1,1,37,0,0,0,0,Notifications,,PLAYER_TO_PLAYER_INTERACT_ACCEPT,true,false
	CallSecureProtected("BindKeyToAction", 29,1,11,2, 129,0,0,0,0) -- 29,1,11,2,129,0,0,0,0,Housing Editor Placement Mode,,HOUSING_EDITOR_ALIGN_TO_SURFACE,true,false
	CallSecureProtected("BindKeyToAction", 1,2,4,4, 0,0,0,0,0) -- 1,2,4,4,0,0,0,0,0,General,Combat,SPECIAL_MOVE_CROUCH,true,false
	--CallSecureProtected("BindKeyToAction", 29,1,2,3, 0,0,0,0,0) -- 29,1,2,3,0,0,0,0,0,Housing Editor Placement Mode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,25,1,1, 0,0,0,0,0) -- 1,25,1,1,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_OPEN,true,false
	CallSecureProtected("BindKeyToAction", 1,1,10,1, 133,0,0,0,0) -- 1,1,10,1,133,0,0,0,0,General,Movement,GAMEPAD_JUMP_OR_INTERACT,true,true
	CallSecureProtected("BindKeyToAction", 1,26,15,3, 0,0,0,0,0) -- 1,26,15,3,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_ZONE_5,true,false
	CallSecureProtected("BindKeyToAction", 1,25,11,4, 0,0,0,0,0) -- 1,25,11,4,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_10,true,false
	CallSecureProtected("BindKeyToAction", 1,1,5,3, 142,0,0,0,0) -- 1,1,5,3,142,0,0,0,0,General,Movement,TURN_RIGHT,true,false
	CallSecureProtected("BindKeyToAction", 1,26,9,1, 0,0,0,0,0) -- 1,26,9,1,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_PRIMARY_RESIDENCE,true,false
	CallSecureProtected("BindKeyToAction", 29,1,10,4, 0,0,0,0,0) -- 29,1,10,4,0,0,0,0,0,Housing Editor Placement Mode,,HOUSING_EDITOR_PULL_BACKWARD,true,false
	CallSecureProtected("BindKeyToAction", 3,1,9,1, 0,0,0,0,0) -- 3,1,9,1,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_STACK_ALL,true,false
	CallSecureProtected("BindKeyToAction", 1,21,10,3, 0,0,0,0,0) -- 1,21,10,3,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_5,true,false
	CallSecureProtected("BindKeyToAction", 1,8,3,3, 0,0,0,0,0) -- 1,8,3,3,0,0,0,0,0,General,HarvestMap,TOGGLE_MAPPINS,true,false
	--CallSecureProtected("BindKeyToAction", 27,1,5,2, 132,0,0,0,0) -- 27,1,5,2,132,0,0,0,0,ScreenshotMode,,SCREENSHOT_MODE_SHOW_UI_2,false,true
	CallSecureProtected("BindKeyToAction", 1,23,2,2, 0,0,0,0,0) -- 1,23,2,2,0,0,0,0,0,General,Mail Looter,MAILLOOTER_QUICK_LOOT_ALL,true,false
	CallSecureProtected("BindKeyToAction", 29,1,10,2, 137,0,0,0,0) -- 29,1,10,2,137,0,0,0,0,Housing Editor Placement Mode,,HOUSING_EDITOR_PULL_BACKWARD,true,false
	CallSecureProtected("BindKeyToAction", 1,18,7,2, 0,0,0,0,0) -- 1,18,7,2,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMACHATPOSTTDCL,true,false
	CallSecureProtected("BindKeyToAction", 1,9,2,3, 0,0,0,0,0) -- 1,9,2,3,0,0,0,0,0,General,|cFF6A00Mass Deconstructor|r,MD_DECONSTRUCTOR_REFINE_ALL,true,false
	CallSecureProtected("BindKeyToAction", 1,6,5,1, 0,0,0,0,0) -- 1,6,5,1,0,0,0,0,0,General,User Interface,CHAT_REPLY_TO_LAST_WHISPER,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,1,2, 0,0,0,0,0) -- 28,1,1,2,0,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 27,1,5,3, 128,0,0,0,0) -- 27,1,5,3,128,0,0,0,0,ScreenshotMode,,SCREENSHOT_MODE_SHOW_UI_2,false,true
	--CallSecureProtected("BindKeyToAction", 12,1,2,2, 60,0,0,0,0) -- 12,1,2,2,60,0,0,0,0,Guild,,GUILD_2,false,true
	CallSecureProtected("BindKeyToAction", 29,1,9,3, 0,0,0,0,0) -- 29,1,9,3,0,0,0,0,0,Housing Editor Placement Mode,,HOUSING_EDITOR_PUSH_FORWARD,true,false
	CallSecureProtected("BindKeyToAction", 1,7,4,2, 0,0,0,0,0) -- 1,7,4,2,0,0,0,0,0,General,Mini Map,VOTANS_TOGGLE_MAP_ZOOM_OUT,true,false
	CallSecureProtected("BindKeyToAction", 29,1,9,1, 121,0,0,0,0) -- 29,1,9,1,121,0,0,0,0,Housing Editor Placement Mode,,HOUSING_EDITOR_PUSH_FORWARD,true,false
	CallSecureProtected("BindKeyToAction", 1,7,2,3, 0,0,0,0,0) -- 1,7,2,3,0,0,0,0,0,General,Mini Map,VOTANS_TOGGLE_MAP_SHOW_HUD,true,false
	CallSecureProtected("BindKeyToAction", 1,2,3,3, 0,0,0,0,0) -- 1,2,3,3,0,0,0,0,0,General,Combat,SPECIAL_MOVE_SPRINT,true,false
	CallSecureProtected("BindKeyToAction", 29,1,8,4, 0,0,0,0,0) -- 29,1,8,4,0,0,0,0,0,Housing Editor Placement Mode,,HOUSING_EDITOR_ROLL_RIGHT,true,false
	--CallSecureProtected("BindKeyToAction", 12,1,4,1, 26,0,0,0,0) -- 12,1,4,1,26,0,0,0,0,Guild,,GUILD_4,false,true
	CallSecureProtected("BindKeyToAction", 1,18,18,3, 0,0,0,0,0) -- 1,18,18,3,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMARGLA,true,false
	--CallSecureProtected("BindKeyToAction", 15,1,1,4, 0,0,0,0,0) -- 15,1,1,4,0,0,0,0,0,Death,,DEATH_PRIMARY,false,true
	CallSecureProtected("BindKeyToAction", 1,20,5,3, 0,0,0,0,0) -- 1,20,5,3,0,0,0,0,0,General,|c3366FFBank|r Manager |c990000Revived|r,BMR_PROFILE5,true,false
	CallSecureProtected("BindKeyToAction", 28,1,32,2, 136,0,0,0,0) -- 28,1,32,2,136,0,0,0,0,Housing Editor,,HOUSING_EDITOR_TERTIARY_ACTION,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,5,2, 0,0,0,0,0) -- 28,1,5,2,0,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,9,3, 0,0,0,0,0) -- 28,1,9,3,0,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,23,3, 0,0,0,0,0) -- 28,1,23,3,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,20,6,1, 0,0,0,0,0) -- 1,20,6,1,0,0,0,0,0,General,|c3366FFBank|r Manager |c990000Revived|r,BMR_PROFILE6,true,false
	CallSecureProtected("BindKeyToAction", 1,8,4,2, 0,0,0,0,0) -- 1,8,4,2,0,0,0,0,0,General,HarvestMap,HARVEST_SHOW_PANEL,true,false
	CallSecureProtected("BindKeyToAction", 1,21,15,1, 0,0,0,0,0) -- 1,21,15,1,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_10,true,false
	CallSecureProtected("BindKeyToAction", 1,6,4,2, 0,0,0,0,0) -- 1,6,4,2,0,0,0,0,0,General,User Interface,START_CHAT_SLASH,true,false
	CallSecureProtected("BindKeyToAction", 1,19,1,4, 0,0,0,0,0) -- 1,19,1,4,0,0,0,0,0,General,Dustman,DUSTMAN_JUNK,true,false
	CallSecureProtected("BindKeyToAction", 1,29,1,1, 0,0,0,0,0) -- 1,29,1,1,0,0,0,0,0,General,Assist Rapid Riding,ARR_SWITCH,true,false
	CallSecureProtected("BindKeyToAction", 5,1,2,4, 0,0,0,0,0) -- 5,1,2,4,0,0,0,0,0,Dialogs,,DIALOG_SECONDARY,true,false
	CallSecureProtected("BindKeyToAction", 29,1,6,4, 0,0,0,0,0) -- 29,1,6,4,0,0,0,0,0,Housing Editor Placement Mode,,HOUSING_EDITOR_PITCH_BACKWARD,true,false
	CallSecureProtected("BindKeyToAction", 29,1,6,3, 0,0,0,0,0) -- 29,1,6,3,0,0,0,0,0,Housing Editor Placement Mode,,HOUSING_EDITOR_PITCH_BACKWARD,true,false
	--CallSecureProtected("BindKeyToAction", 26,1,5,4, 0,0,0,0,0) -- 26,1,5,4,0,0,0,0,0,BattlegroundScoreboard,,BATTLEGROUND_SCOREBOARD_PLAYER_OPTIONS,false,true
	CallSecureProtected("BindKeyToAction", 1,18,22,4, 0,0,0,0,0) -- 1,18,22,4,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMARGLASHR,true,false
	CallSecureProtected("BindKeyToAction", 1,2,9,2, 0,0,0,0,0) -- 1,2,9,2,0,0,0,0,0,General,Combat,SPECIAL_MOVE_WEAPON_SWAP_TO_SET_2,true,false
	CallSecureProtected("BindKeyToAction", 1,15,1,4, 0,0,0,0,0) -- 1,15,1,4,0,0,0,0,0,General,Vacuum Shop,VACUUM_RIGHT,true,false
	CallSecureProtected("BindKeyToAction", 29,1,5,4, 0,0,0,0,0) -- 29,1,5,4,0,0,0,0,0,Housing Editor Placement Mode,,HOUSING_EDITOR_PITCH_FORWARD,true,false
	--CallSecureProtected("BindKeyToAction", 3,1,20,1, 130,0,0,0,0) -- 3,1,20,1,130,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_RIGHT_STICK,false,true
	CallSecureProtected("BindKeyToAction", 29,1,5,3, 0,0,0,0,0) -- 29,1,5,3,0,0,0,0,0,Housing Editor Placement Mode,,HOUSING_EDITOR_PITCH_FORWARD,true,false
	CallSecureProtected("BindKeyToAction", 29,1,5,2, 123,0,0,0,0) -- 29,1,5,2,123,0,0,0,0,Housing Editor Placement Mode,,HOUSING_EDITOR_PITCH_FORWARD,true,false
	--CallSecureProtected("BindKeyToAction", 9,1,5,4, 0,0,0,0,0) -- 9,1,5,4,0,0,0,0,0,Conversation,,CONVERSATION_OPTION_5,false,true
	CallSecureProtected("BindKeyToAction", 29,1,5,1, 25,0,0,0,0) -- 29,1,5,1,25,0,0,0,0,Housing Editor Placement Mode,,HOUSING_EDITOR_PITCH_FORWARD,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,24,4, 0,0,0,0,0) -- 28,1,24,4,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,6,22,3, 0,0,0,0,0) -- 1,6,22,3,0,0,0,0,0,General,User Interface,TOGGLE_ACTIVITY_FINDER,true,false
	--CallSecureProtected("BindKeyToAction", 4,2,4,3, 0,0,0,0,0) -- 4,2,4,3,0,0,0,0,0,Siege,Mini Map,VOTANS_TOGGLE_MAP_ZOOM_PLUS_SIEGE,false,true
	CallSecureProtected("BindKeyToAction", 29,1,4,3, 0,0,0,0,0) -- 29,1,4,3,0,0,0,0,0,Housing Editor Placement Mode,,HOUSING_EDITOR_YAW_RIGHT,true,false
	CallSecureProtected("BindKeyToAction", 1,25,3,4, 0,0,0,0,0) -- 1,25,3,4,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_2,true,false
	CallSecureProtected("BindKeyToAction", 1,18,4,1, 0,0,0,0,0) -- 1,18,4,1,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMAFAVRADMENU,true,false
	CallSecureProtected("BindKeyToAction", 1,7,6,1, 0,0,0,0,0) -- 1,7,6,1,0,0,0,0,0,General,Mini Map,VOTANS_TOGGLE_MAP_ZOOM_PLUS,true,false
	CallSecureProtected("BindKeyToAction", 29,1,4,2, 126,0,0,0,0) -- 29,1,4,2,126,0,0,0,0,Housing Editor Placement Mode,,HOUSING_EDITOR_YAW_RIGHT,true,false
	CallSecureProtected("BindKeyToAction", 4,1,1,3, 0,0,0,0,0) -- 4,1,1,3,0,0,0,0,0,Siege,,SIEGE_FIRE,true,false
	CallSecureProtected("BindKeyToAction", 29,1,3,3, 0,0,0,0,0) -- 29,1,3,3,0,0,0,0,0,Housing Editor Placement Mode,,HOUSING_EDITOR_YAW_LEFT,true,false
	CallSecureProtected("BindKeyToAction", 1,25,4,3, 0,0,0,0,0) -- 1,25,4,3,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_3,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,8,1, 133,0,0,0,0) -- 28,1,8,1,133,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,2,15,1, 49,0,0,0,0) -- 1,2,15,1,49,0,0,0,0,General,Combat,ACTION_BUTTON_8,true,false
	CallSecureProtected("BindKeyToAction", 1,18,6,3, 0,0,0,0,0) -- 1,18,6,3,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMACHATPOSTTD,true,false
	CallSecureProtected("BindKeyToAction", 3,1,3,2, 136,0,0,0,0) -- 3,1,3,2,136,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_TERTIARY,true,false
	CallSecureProtected("BindKeyToAction", 1,13,1,4, 0,0,0,0,0) -- 1,13,1,4,0,0,0,0,0,General,|c4B8BFETimer,IP_TIMER_START,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,22,4, 0,0,0,0,0) -- 2,1,22,4,0,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,8,3, 0,0,0,0,0) -- 28,1,8,3,0,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 25,1,1,3, 0,0,0,0,0) -- 25,1,1,3,0,0,0,0,0,BattlegroundHud,,SHOW_BATTLEGROUND_SCOREBOARD,false,true
	CallSecureProtected("BindKeyToAction", 1,26,11,4, 0,0,0,0,0) -- 1,26,11,4,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_ZONE_1,true,false
	--CallSecureProtected("BindKeyToAction", 9,1,3,3, 0,0,0,0,0) -- 9,1,3,3,0,0,0,0,0,Conversation,,CONVERSATION_OPTION_3,false,true
	CallSecureProtected("BindKeyToAction", 29,1,3,2, 125,0,0,0,0) -- 29,1,3,2,125,0,0,0,0,Housing Editor Placement Mode,,HOUSING_EDITOR_YAW_LEFT,true,false
	CallSecureProtected("BindKeyToAction", 29,1,3,1, 23,0,0,0,0) -- 29,1,3,1,23,0,0,0,0,Housing Editor Placement Mode,,HOUSING_EDITOR_YAW_LEFT,true,false
	--CallSecureProtected("BindKeyToAction", 29,1,2,2, 167,0,0,0,0) -- 29,1,2,2,167,0,0,0,0,Housing Editor Placement Mode,,,false,true
	--CallSecureProtected("BindKeyToAction", 29,1,2,1, 79,0,0,0,0) -- 29,1,2,1,79,0,0,0,0,Housing Editor Placement Mode,,,false,true
	--CallSecureProtected("BindKeyToAction", 29,1,1,4, 0,0,0,0,0) -- 29,1,1,4,0,0,0,0,0,Housing Editor Placement Mode,,,false,true
	--CallSecureProtected("BindKeyToAction", 26,1,5,3, 0,0,0,0,0) -- 26,1,5,3,0,0,0,0,0,BattlegroundScoreboard,,BATTLEGROUND_SCOREBOARD_PLAYER_OPTIONS,false,true
	CallSecureProtected("BindKeyToAction", 1,7,4,4, 0,0,0,0,0) -- 1,7,4,4,0,0,0,0,0,General,Mini Map,VOTANS_TOGGLE_MAP_ZOOM_OUT,true,false
	--CallSecureProtected("BindKeyToAction", 9,1,11,3, 0,0,0,0,0) -- 9,1,11,3,0,0,0,0,0,Conversation,,CONVERSATION_OPTION_PRIMARY,false,true
	CallSecureProtected("BindKeyToAction", 1,8,2,4, 0,0,0,0,0) -- 1,8,2,4,0,0,0,0,0,General,HarvestMap,TOGGLE_WORLDPINS,true,false
	--CallSecureProtected("BindKeyToAction", 12,1,3,1, 25,0,0,0,0) -- 12,1,3,1,25,0,0,0,0,Guild,,GUILD_3,false,true
	--CallSecureProtected("BindKeyToAction", 27,1,1,3, 0,0,0,0,0) -- 27,1,1,3,0,0,0,0,0,ScreenshotMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 10,1,12,2, 128,0,0,0,0) -- 10,1,12,2,128,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_MAP,false,true
	CallSecureProtected("BindKeyToAction", 1,6,28,4, 0,0,0,0,0) -- 1,6,28,4,0,0,0,0,0,General,User Interface,TOGGLE_HUD_UI,true,false
	--CallSecureProtected("BindKeyToAction", 29,1,1,1, 124,0,0,0,0) -- 29,1,1,1,124,0,0,0,0,Housing Editor Placement Mode,,,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,11,3, 0,0,0,0,0) -- 28,1,11,3,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 28,1,42,4, 0,0,0,0,0) -- 28,1,42,4,0,0,0,0,0,Housing Editor,,HOUSING_EDITOR_BEGIN_EDIT_PATH,true,false
	CallSecureProtected("BindKeyToAction", 28,1,42,3, 0,0,0,0,0) -- 28,1,42,3,0,0,0,0,0,Housing Editor,,HOUSING_EDITOR_BEGIN_EDIT_PATH,true,false
	CallSecureProtected("BindKeyToAction", 1,21,12,4, 0,0,0,0,0) -- 1,21,12,4,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_7,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,1,4, 0,0,0,0,0) -- 2,1,1,4,0,0,0,0,0,GamepadUIMode,,GAMEPAD_UI_EXIT,false,true
	CallSecureProtected("BindKeyToAction", 1,2,22,2, 0,0,0,0,0) -- 1,2,22,2,0,0,0,0,0,General,Combat,GAMEPAD_ACTION_BUTTON_7,true,true
	CallSecureProtected("BindKeyToAction", 28,1,42,1, 48,0,0,0,0) -- 28,1,42,1,48,0,0,0,0,Housing Editor,,HOUSING_EDITOR_BEGIN_EDIT_PATH,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,7,3, 0,0,0,0,0) -- 28,1,7,3,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 28,1,41,2, 129,0,0,0,0) -- 28,1,41,2,129,0,0,0,0,Housing Editor,,HOUSING_EDITOR_BEGIN_FURNITURE_LINKING,true,false
	CallSecureProtected("BindKeyToAction", 1,2,22,4, 0,0,0,0,0) -- 1,2,22,4,0,0,0,0,0,General,Combat,GAMEPAD_ACTION_BUTTON_7,true,true
	CallSecureProtected("BindKeyToAction", 1,21,16,1, 0,0,0,0,0) -- 1,21,16,1,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_11,true,false
	CallSecureProtected("BindKeyToAction", 28,1,41,1, 115,0,0,0,0) -- 28,1,41,1,115,0,0,0,0,Housing Editor,,HOUSING_EDITOR_BEGIN_FURNITURE_LINKING,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,15,4, 0,0,0,0,0) -- 2,1,15,4,0,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 10,1,9,4, 0,0,0,0,0) -- 10,1,9,4,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_CHAMPION,false,true
	CallSecureProtected("BindKeyToAction", 1,21,13,2, 0,0,0,0,0) -- 1,21,13,2,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_8,true,false
	CallSecureProtected("BindKeyToAction", 28,1,40,4, 0,0,0,0,0) -- 28,1,40,4,0,0,0,0,0,Housing Editor,,HOUSING_EDITOR_REDO_ACTION,true,false
	CallSecureProtected("BindKeyToAction", 1,26,8,2, 0,0,0,0,0) -- 1,26,8,2,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_GROUP_LEADER,true,false
	CallSecureProtected("BindKeyToAction", 28,1,40,3, 0,0,0,0,0) -- 28,1,40,3,0,0,0,0,0,Housing Editor,,HOUSING_EDITOR_REDO_ACTION,true,false
	CallSecureProtected("BindKeyToAction", 28,1,40,1, 56,0,0,0,0) -- 28,1,40,1,56,0,0,0,0,Housing Editor,,HOUSING_EDITOR_REDO_ACTION,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,13,2, 0,0,0,0,0) -- 2,1,13,2,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 28,1,39,3, 0,0,0,0,0) -- 28,1,39,3,0,0,0,0,0,Housing Editor,,HOUSING_EDITOR_UNDO_ACTION,true,false
	CallSecureProtected("BindKeyToAction", 28,1,39,2, 131,0,0,0,0) -- 28,1,39,2,131,0,0,0,0,Housing Editor,,HOUSING_EDITOR_UNDO_ACTION,true,false
	--CallSecureProtected("BindKeyToAction", 3,1,20,3, 0,0,0,0,0) -- 3,1,20,3,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_RIGHT_STICK,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,10,4, 0,0,0,0,0) -- 2,1,10,4,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 28,1,39,1, 57,0,0,0,0) -- 28,1,39,1,57,0,0,0,0,Housing Editor,,HOUSING_EDITOR_UNDO_ACTION,true,false
	CallSecureProtected("BindKeyToAction", 1,25,2,1, 0,0,0,0,0) -- 1,25,2,1,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_1,true,false
	--CallSecureProtected("BindKeyToAction", 21,1,2,2, 130,0,0,0,0) -- 21,1,2,2,130,0,0,0,0,OptionsWindow,,OPTIONS_LOAD_DEFAULTS,false,true
	--CallSecureProtected("BindKeyToAction", 9,1,12,3, 0,0,0,0,0) -- 9,1,12,3,0,0,0,0,0,Conversation,,CONVERSATION_OPTION_NEGATIVE,false,true
	--CallSecureProtected("BindKeyToAction", 10,1,5,4, 0,0,0,0,0) -- 10,1,5,4,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_MARKET,false,true
	CallSecureProtected("BindKeyToAction", 1,2,11,1, 24,0,0,0,0) -- 1,2,11,1,24,0,0,0,0,General,Combat,ACTION_BUTTON_4,true,false
	CallSecureProtected("BindKeyToAction", 1,4,2,4, 0,0,0,0,0) -- 1,4,2,4,0,0,0,0,0,General,Camera,CAMERA_ZOOM_IN,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,38,2, 167,0,0,0,0) -- 28,1,38,2,167,0,0,0,0,Housing Editor,,DISABLE_HOUSING_EDITOR,false,true
	CallSecureProtected("BindKeyToAction", 1,9,2,4, 0,0,0,0,0) -- 1,9,2,4,0,0,0,0,0,General,|cFF6A00Mass Deconstructor|r,MD_DECONSTRUCTOR_REFINE_ALL,true,false
	--CallSecureProtected("BindKeyToAction", 3,1,18,1, 124,0,0,0,0) -- 3,1,18,1,124,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_INPUT_DOWN,false,true
	CallSecureProtected("BindKeyToAction", 1,2,25,3, 0,0,0,0,0) -- 1,2,25,3,0,0,0,0,0,General,Combat,UI_SHORTCUT_EMOTES_QUICK_SLOTS,true,false
	CallSecureProtected("BindKeyToAction", 24,1,4,2, 132,0,0,0,0) -- 24,1,4,2,132,0,0,0,0,Battlegrounds,,BATTLEGROUND_SCOREBOARD_NEXT_DUMMY,true,false
	CallSecureProtected("BindKeyToAction", 28,1,37,2, 130,0,0,0,0) -- 28,1,37,2,130,0,0,0,0,Housing Editor,,HOUSING_EDITOR_JUMP_TO_SAFE_LOC,true,false
	--CallSecureProtected("BindKeyToAction", 16,1,1,2, 133,0,0,0,0) -- 16,1,1,2,133,0,0,0,0,Loot,,LOOT_ITEM,false,true
	CallSecureProtected("BindKeyToAction", 22,1,2,2, 0,0,0,0,0) -- 22,1,2,2,0,0,0,0,0,ScreenAdjustActions,,SCREEN_ADJUST_SHRINK,true,true
	--CallSecureProtected("BindKeyToAction", 28,1,1,3, 139,0,0,0,0) -- 28,1,1,3,139,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,21,15,4, 0,0,0,0,0) -- 1,21,15,4,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_10,true,false
	CallSecureProtected("BindKeyToAction", 1,6,11,2, 0,0,0,0,0) -- 1,6,11,2,0,0,0,0,0,General,User Interface,TOGGLE_SKILLS,true,false
	CallSecureProtected("BindKeyToAction", 28,1,37,1, 39,0,0,0,0) -- 28,1,37,1,39,0,0,0,0,Housing Editor,,HOUSING_EDITOR_JUMP_TO_SAFE_LOC,true,false
	CallSecureProtected("BindKeyToAction", 1,6,8,4, 0,0,0,0,0) -- 1,6,8,4,0,0,0,0,0,General,User Interface,TOGGLE_MARKET,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,28,3, 0,0,0,0,0) -- 2,1,28,3,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 28,1,36,3, 0,0,0,0,0) -- 28,1,36,3,0,0,0,0,0,Housing Editor,,HOUSING_EDITOR_TOGGLE_NODE_DELAY,true,false
	CallSecureProtected("BindKeyToAction", 28,1,36,2, 0,0,0,0,0) -- 28,1,36,2,0,0,0,0,0,Housing Editor,,HOUSING_EDITOR_TOGGLE_NODE_DELAY,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,27,2, 0,0,0,0,0) -- 2,1,27,2,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 28,1,35,4, 0,0,0,0,0) -- 28,1,35,4,0,0,0,0,0,Housing Editor,,HOUSING_EDITOR_TOGGLE_NODE_SPEED,true,false
	CallSecureProtected("BindKeyToAction", 28,1,35,3, 0,0,0,0,0) -- 28,1,35,3,0,0,0,0,0,Housing Editor,,HOUSING_EDITOR_TOGGLE_NODE_SPEED,true,false
	CallSecureProtected("BindKeyToAction", 1,1,5,4, 0,0,0,0,0) -- 1,1,5,4,0,0,0,0,0,General,Movement,TURN_RIGHT,true,false
	CallSecureProtected("BindKeyToAction", 1,6,31,1, 0,0,0,0,0) -- 1,6,31,1,0,0,0,0,0,General,User Interface,TOGGLE_HEALTHBARS,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,6,2, 0,0,0,0,0) -- 28,1,6,2,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 28,1,35,1, 52,0,0,0,0) -- 28,1,35,1,52,0,0,0,0,Housing Editor,,HOUSING_EDITOR_TOGGLE_NODE_SPEED,true,false
	CallSecureProtected("BindKeyToAction", 1,26,19,3, 0,0,0,0,0) -- 1,26,19,3,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_PLAYER_4,true,false
	CallSecureProtected("BindKeyToAction", 1,26,8,4, 0,0,0,0,0) -- 1,26,8,4,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_GROUP_LEADER,true,false
	--CallSecureProtected("BindKeyToAction", 18,1,1,4, 0,0,0,0,0) -- 18,1,1,4,0,0,0,0,0,GameMenu,,GAME_MENU_DO_NOTHING,false,true
	CallSecureProtected("BindKeyToAction", 1,6,28,2, 0,0,0,0,0) -- 1,6,28,2,0,0,0,0,0,General,User Interface,TOGGLE_HUD_UI,true,false
	--CallSecureProtected("BindKeyToAction", 27,1,5,1, 131,0,0,0,0) -- 27,1,5,1,131,0,0,0,0,ScreenshotMode,,SCREENSHOT_MODE_SHOW_UI_2,false,true
	CallSecureProtected("BindKeyToAction", 28,1,33,4, 0,0,0,0,0) -- 28,1,33,4,0,0,0,0,0,Housing Editor,,HOUSING_EDITOR_QUATERNARY_ACTION,true,false
	CallSecureProtected("BindKeyToAction", 28,1,33,3, 0,0,0,0,0) -- 28,1,33,3,0,0,0,0,0,Housing Editor,,HOUSING_EDITOR_QUATERNARY_ACTION,true,false
	--CallSecureProtected("BindKeyToAction", 13,1,6,3, 0,0,0,0,0) -- 13,1,6,3,0,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_6,false,true
	CallSecureProtected("BindKeyToAction", 1,18,2,3, 0,0,0,0,0) -- 1,18,2,3,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMAMODECHANGE,true,false
	--CallSecureProtected("BindKeyToAction", 3,1,20,2, 0,0,0,0,0) -- 3,1,20,2,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_RIGHT_STICK,false,true
	--CallSecureProtected("BindKeyToAction", 10,1,18,3, 0,0,0,0,0) -- 10,1,18,3,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_NOTIFICATIONS,false,true
	CallSecureProtected("BindKeyToAction", 28,1,32,4, 0,0,0,0,0) -- 28,1,32,4,0,0,0,0,0,Housing Editor,,HOUSING_EDITOR_TERTIARY_ACTION,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,21,3, 0,0,0,0,0) -- 2,1,21,3,0,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 4,2,5,1, 0,0,0,0,0) -- 4,2,5,1,0,0,0,0,0,Siege,Mini Map,VOTANS_TOGGLE_MAP_ZOOM_MINUS_SIEGE,false,true
	CallSecureProtected("BindKeyToAction", 1,7,5,3, 0,0,0,0,0) -- 1,7,5,3,0,0,0,0,0,General,Mini Map,VOTANS_TOGGLE_MAP_ZOOM_IN,true,false
	CallSecureProtected("BindKeyToAction", 1,26,15,4, 0,0,0,0,0) -- 1,26,15,4,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_ZONE_5,true,false
	CallSecureProtected("BindKeyToAction", 34,1,3,1, 0,0,0,0,0) -- 34,1,3,1,0,0,0,0,0,Potion Maker,User Interface,POTIONMAKER_SEARCH_FAVORITS,true,false
	CallSecureProtected("BindKeyToAction", 28,1,32,1, 37,0,0,0,0) -- 28,1,32,1,37,0,0,0,0,Housing Editor,,HOUSING_EDITOR_TERTIARY_ACTION,true,false
	CallSecureProtected("BindKeyToAction", 28,1,31,4, 0,0,0,0,0) -- 28,1,31,4,0,0,0,0,0,Housing Editor,,HOUSING_EDITOR_SECONDARY_ACTION,true,false
	CallSecureProtected("BindKeyToAction", 22,1,2,1, 50,0,0,0,0) -- 22,1,2,1,50,0,0,0,0,ScreenAdjustActions,,SCREEN_ADJUST_SHRINK,true,true
	CallSecureProtected("BindKeyToAction", 28,1,31,3, 0,0,0,0,0) -- 28,1,31,3,0,0,0,0,0,Housing Editor,,HOUSING_EDITOR_SECONDARY_ACTION,true,false
	CallSecureProtected("BindKeyToAction", 3,3,1,3, 0,0,0,0,0) -- 3,3,1,3,0,0,0,0,0,User Interface Shortcuts,Fish Fillet,VOTANS_FISH_FILLET_ALL_STACKS,true,false
	CallSecureProtected("BindKeyToAction", 1,2,4,3, 0,0,0,0,0) -- 1,2,4,3,0,0,0,0,0,General,Combat,SPECIAL_MOVE_CROUCH,true,false
	CallSecureProtected("BindKeyToAction", 28,1,31,2, 135,0,0,0,0) -- 28,1,31,2,135,0,0,0,0,Housing Editor,,HOUSING_EDITOR_SECONDARY_ACTION,true,false
	CallSecureProtected("BindKeyToAction", 28,1,30,4, 0,0,0,0,0) -- 28,1,30,4,0,0,0,0,0,Housing Editor,,HOUSING_EDITOR_NEGATIVE_ACTION,true,false
	CallSecureProtected("BindKeyToAction", 28,1,30,3, 0,0,0,0,0) -- 28,1,30,3,0,0,0,0,0,Housing Editor,,HOUSING_EDITOR_NEGATIVE_ACTION,true,false
	CallSecureProtected("BindKeyToAction", 1,6,23,4, 0,0,0,0,0) -- 1,6,23,4,0,0,0,0,0,General,User Interface,TOGGLE_CROWN_CRATES,true,false
	CallSecureProtected("BindKeyToAction", 1,18,10,2, 0,0,0,0,0) -- 1,18,10,2,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMAWRBTOGGLE,true,false
	CallSecureProtected("BindKeyToAction", 1,2,21,3, 0,0,0,0,0) -- 1,2,21,3,0,0,0,0,0,General,Combat,GAMEPAD_ACTION_BUTTON_6,true,true
	--CallSecureProtected("BindKeyToAction", 28,1,8,2, 0,0,0,0,0) -- 28,1,8,2,0,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 10,1,12,1, 44,0,0,0,0) -- 10,1,12,1,44,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_MAP,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,11,1, 4,0,0,0,0) -- 28,1,11,1,4,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 28,1,30,2, 134,0,0,0,0) -- 28,1,30,2,134,0,0,0,0,Housing Editor,,HOUSING_EDITOR_NEGATIVE_ACTION,true,false
	CallSecureProtected("BindKeyToAction", 1,6,12,2, 0,0,0,0,0) -- 1,6,12,2,0,0,0,0,0,General,User Interface,TOGGLE_CHAMPION,true,false
	--CallSecureProtected("BindKeyToAction", 5,1,8,3, 0,0,0,0,0) -- 5,1,8,3,0,0,0,0,0,Dialogs,,,false,true
	CallSecureProtected("BindKeyToAction", 1,6,30,2, 0,0,0,0,0) -- 1,6,30,2,0,0,0,0,0,General,User Interface,TOGGLE_NAMEPLATES,true,false
	CallSecureProtected("BindKeyToAction", 1,18,21,1, 0,0,0,0,0) -- 1,18,21,1,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMARGLAPST,true,false
	CallSecureProtected("BindKeyToAction", 28,1,33,1, 51,0,0,0,0) -- 28,1,33,1,51,0,0,0,0,Housing Editor,,HOUSING_EDITOR_QUATERNARY_ACTION,true,false
	CallSecureProtected("BindKeyToAction", 28,1,29,3, 133,0,0,0,0) -- 28,1,29,3,133,0,0,0,0,Housing Editor,,HOUSING_EDITOR_PRIMARY_ACTION,true,false
	CallSecureProtected("BindKeyToAction", 29,1,7,1, 27,0,0,0,0) -- 29,1,7,1,27,0,0,0,0,Housing Editor Placement Mode,,HOUSING_EDITOR_ROLL_LEFT,true,false
	CallSecureProtected("BindKeyToAction", 28,1,29,1, 114,0,0,0,0) -- 28,1,29,1,114,0,0,0,0,Housing Editor,,HOUSING_EDITOR_PRIMARY_ACTION,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,28,4, 0,0,0,0,0) -- 28,1,28,4,0,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,28,3, 0,0,0,0,0) -- 28,1,28,3,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,18,12,1, 0,0,0,0,0) -- 1,18,12,1,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMACLGLTOGGLE,true,false
	CallSecureProtected("BindKeyToAction", 1,1,6,2, 0,0,0,0,0) -- 1,1,6,2,0,0,0,0,0,General,Movement,MOVE_JUMPASCEND,true,false
	CallSecureProtected("BindKeyToAction", 1,18,16,3, 0,0,0,0,0) -- 1,18,16,3,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMAGUILDTOGGLE,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,28,2, 0,0,0,0,0) -- 28,1,28,2,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,19,1,2, 0,0,0,0,0) -- 1,19,1,2,0,0,0,0,0,General,Dustman,DUSTMAN_JUNK,true,false
	CallSecureProtected("BindKeyToAction", 34,1,3,2, 0,0,0,0,0) -- 34,1,3,2,0,0,0,0,0,Potion Maker,User Interface,POTIONMAKER_SEARCH_FAVORITS,true,false
	CallSecureProtected("BindKeyToAction", 1,26,2,4, 0,0,0,0,0) -- 1,26,2,4,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_TOGGLE_MAIN_ACTIVE_QUESTS,true,false
	--CallSecureProtected("BindKeyToAction", 11,1,3,1, 4,0,0,0,0) -- 11,1,3,1,4,0,0,0,0,PreviewInterceptLayer,,INTERCEPT_SPECIAL_MOVE_CROUCH,false,true
	CallSecureProtected("BindKeyToAction", 1,2,17,3, 0,0,0,0,0) -- 1,2,17,3,0,0,0,0,0,General,Combat,GAMEPAD_MOVE_JUMPASCEND,true,true
	CallSecureProtected("BindKeyToAction", 1,19,2,4, 0,0,0,0,0) -- 1,19,2,4,0,0,0,0,0,General,Dustman,DUSTMAN_SET,true,false
	CallSecureProtected("BindKeyToAction", 3,1,8,3, 0,0,0,0,0) -- 3,1,8,3,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_SHOW_QUEST_ON_MAP,true,false
	CallSecureProtected("BindKeyToAction", 1,12,3,4, 0,0,0,0,0) -- 1,12,3,4,0,0,0,0,0,General,Foundry Tactical Combat,POST_DAMAGE_RESULTS,true,false
	CallSecureProtected("BindKeyToAction", 1,12,1,1, 0,0,0,0,0) -- 1,12,1,1,0,0,0,0,0,General,Foundry Tactical Combat,TOGGLE_COMBAT_LOG,true,false
	CallSecureProtected("BindKeyToAction", 1,6,32,1, 0,0,0,0,0) -- 1,6,32,1,0,0,0,0,0,General,User Interface,RETICLE_BRIGHTNESS_INCREASE,true,false
	--CallSecureProtected("BindKeyToAction", 4,1,7,4, 0,0,0,0,0) -- 4,1,7,4,0,0,0,0,0,Siege,,,false,true
	CallSecureProtected("BindKeyToAction", 1,6,26,4, 0,0,0,0,0) -- 1,6,26,4,0,0,0,0,0,General,User Interface,ASSIST_NEXT_TRACKED_QUEST,true,false
	CallSecureProtected("BindKeyToAction", 4,1,2,1, 5,0,0,0,0) -- 4,1,2,1,5,0,0,0,0,Siege,,SIEGE_RELEASE,true,false
	--CallSecureProtected("BindKeyToAction", 9,1,9,4, 0,0,0,0,0) -- 9,1,9,4,0,0,0,0,0,Conversation,,CONVERSATION_OPTION_9,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,27,1, 0,0,0,0,0) -- 28,1,27,1,0,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,26,3, 0,0,0,0,0) -- 28,1,26,3,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 3,1,3,1, 37,0,0,0,0) -- 3,1,3,1,37,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_TERTIARY,true,false
	CallSecureProtected("BindKeyToAction", 1,12,1,4, 0,0,0,0,0) -- 1,12,1,4,0,0,0,0,0,General,Foundry Tactical Combat,TOGGLE_COMBAT_LOG,true,false
	CallSecureProtected("BindKeyToAction", 34,1,1,4, 0,0,0,0,0) -- 34,1,1,4,0,0,0,0,0,Potion Maker,User Interface,POTIONMAKER_SEARCH,true,false
	CallSecureProtected("BindKeyToAction", 1,2,16,1, 129,0,0,0,0) -- 1,2,16,1,129,0,0,0,0,General,Combat,GAMEPAD_SPECIAL_MOVE_SPRINT,true,true
	--CallSecureProtected("BindKeyToAction", 28,1,26,1, 107,0,0,0,0) -- 28,1,26,1,107,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,1,8,3, 0,0,0,0,0) -- 1,1,8,3,0,0,0,0,0,General,Movement,ROLL_DODGE,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,16,1, 44,0,0,0,0) -- 2,1,16,1,44,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 4,1,4,3, 0,0,0,0,0) -- 4,1,4,3,0,0,0,0,0,Siege,,SIEGE_ESCAPE,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,24,2, 0,0,0,0,0) -- 2,1,24,2,0,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 4,1,5,1, 120,0,0,0,0) -- 4,1,5,1,120,0,0,0,0,Siege,,,false,true
	--CallSecureProtected("BindKeyToAction", 10,1,21,3, 0,0,0,0,0) -- 10,1,21,3,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_HELP,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,25,3, 0,0,0,0,0) -- 28,1,25,3,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,11,7,4, 0,0,0,0,0) -- 1,11,7,4,0,0,0,0,0,General,CombatMetrics,CMX_RESET_FIGHT,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,25,2, 0,0,0,0,0) -- 28,1,25,2,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,20,2,3, 0,0,0,0,0) -- 1,20,2,3,0,0,0,0,0,General,|c3366FFBank|r Manager |c990000Revived|r,BMR_PROFILE2,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,25,1, 12,0,0,0,0) -- 28,1,25,1,12,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 29,1,4,4, 0,0,0,0,0) -- 29,1,4,4,0,0,0,0,0,Housing Editor Placement Mode,,HOUSING_EDITOR_YAW_RIGHT,true,false
	CallSecureProtected("BindKeyToAction", 1,7,2,1, 0,0,0,0,0) -- 1,7,2,1,0,0,0,0,0,General,Mini Map,VOTANS_TOGGLE_MAP_SHOW_HUD,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,24,3, 128,0,0,0,0) -- 28,1,24,3,128,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,24,2, 127,0,0,0,0) -- 28,1,24,2,127,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,20,8,2, 0,0,0,0,0) -- 1,20,8,2,0,0,0,0,0,General,|c3366FFBank|r Manager |c990000Revived|r,BMR_PROFILE8,true,false
	CallSecureProtected("BindKeyToAction", 1,6,20,2, 0,0,0,0,0) -- 1,6,20,2,0,0,0,0,0,General,User Interface,TOGGLE_MAIL,true,false
	CallSecureProtected("BindKeyToAction", 1,20,9,4, 0,0,0,0,0) -- 1,20,9,4,0,0,0,0,0,General,|c3366FFBank|r Manager |c990000Revived|r,BMR_PROFILE9,true,false
	CallSecureProtected("BindKeyToAction", 1,21,19,2, 0,0,0,0,0) -- 1,21,19,2,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_14,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,28,1, 28,7,0,0,0) -- 2,1,28,1,28,7,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,2,7,2, 118,0,0,0,0) -- 1,2,7,2,118,0,0,0,0,General,Combat,SPECIAL_MOVE_WEAPON_SWAP,true,false
	CallSecureProtected("BindKeyToAction", 24,1,5,3, 0,0,0,0,0) -- 24,1,5,3,0,0,0,0,0,Battlegrounds,,BATTLEGROUND_SCOREBOARD_PLAYER_OPTIONS_DUMMY,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,23,4, 0,0,0,0,0) -- 28,1,23,4,0,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,1,2, 186,0,0,0,0) -- 2,1,1,2,186,0,0,0,0,GamepadUIMode,,GAMEPAD_UI_EXIT,false,true
	CallSecureProtected("BindKeyToAction", 1,6,16,2, 0,0,0,0,0) -- 1,6,16,2,0,0,0,0,0,General,User Interface,TOGGLE_GROUP,true,false
	CallSecureProtected("BindKeyToAction", 29,1,8,1, 28,0,0,0,0) -- 29,1,8,1,28,0,0,0,0,Housing Editor Placement Mode,,HOUSING_EDITOR_ROLL_RIGHT,true,false
	CallSecureProtected("BindKeyToAction", 1,16,1,1, 99,0,0,0,0) -- 1,16,1,1,99,0,0,0,0,General,|cFFFF00Minceraft's Binds|r,RELOAD,true,false
	CallSecureProtected("BindKeyToAction", 1,21,7,2, 0,0,0,0,0) -- 1,21,7,2,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_2,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,5,2, 0,0,0,0,0) -- 2,1,5,2,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 5,1,4,1, 5,0,0,0,0) -- 5,1,4,1,5,0,0,0,0,Dialogs,,DIALOG_NEGATIVE,true,false
	--CallSecureProtected("BindKeyToAction", 13,1,8,1, 30,0,0,0,0) -- 13,1,8,1,30,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_8,false,true
	CallSecureProtected("BindKeyToAction", 1,2,12,1, 25,0,0,0,0) -- 1,2,12,1,25,0,0,0,0,General,Combat,ACTION_BUTTON_5,true,false
	CallSecureProtected("BindKeyToAction", 1,1,7,1, 51,0,0,0,0) -- 1,1,7,1,51,0,0,0,0,General,Movement,AUTORUN,true,false
	CallSecureProtected("BindKeyToAction", 1,26,4,4, 0,0,0,0,0) -- 1,26,4,4,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_TOGGLE_MAIN_CURRENT_ZONE,true,false
	CallSecureProtected("BindKeyToAction", 6,1,1,3, 0,0,0,0,0) -- 6,1,1,3,0,0,0,0,0,Notifications,,PLAYER_TO_PLAYER_INTERACT_ACCEPT,true,false
	CallSecureProtected("BindKeyToAction", 1,6,6,3, 0,0,0,0,0) -- 1,6,6,3,0,0,0,0,0,General,User Interface,TOGGLE_SHOW_INGAME_GUI,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,15,4, 0,0,0,0,0) -- 10,1,15,4,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_GUILDS,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,22,1, 3,5,0,0,0) -- 28,1,22,1,3,5,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,2,27,1, 56,0,0,0,0) -- 1,2,27,1,56,0,0,0,0,General,Combat,COMMAND_PET,true,false
	CallSecureProtected("BindKeyToAction", 1,12,3,2, 0,0,0,0,0) -- 1,12,3,2,0,0,0,0,0,General,Foundry Tactical Combat,POST_DAMAGE_RESULTS,true,false
	CallSecureProtected("BindKeyToAction", 3,4,1,1, 0,0,0,0,0) -- 3,4,1,1,0,0,0,0,0,User Interface Shortcuts,WritWorthy,WRIT_WORTHY_ACCEPT_QUESTS,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,10,3, 0,0,0,0,0) -- 10,1,10,3,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_JOURNAL,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,11,4, 0,0,0,0,0) -- 2,1,11,4,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,18,24,2, 0,0,0,0,0) -- 1,18,24,2,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMALFGPMODE,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,21,2, 0,0,0,0,0) -- 28,1,21,2,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,7,8,4, 0,0,0,0,0) -- 1,7,8,4,0,0,0,0,0,General,Mini Map,VOTANS_TOGGLE_MAP_OFFSET_FIX,true,false
	CallSecureProtected("BindKeyToAction", 5,1,1,2, 133,0,0,0,0) -- 5,1,1,2,133,0,0,0,0,Dialogs,,DIALOG_PRIMARY,true,false
	CallSecureProtected("BindKeyToAction", 1,5,2,4, 0,0,0,0,0) -- 1,5,2,4,0,0,0,0,0,General,Interaction,PLAYER_TO_PLAYER_INTERACT,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,20,3, 0,0,0,0,0) -- 28,1,20,3,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,18,9,1, 103,0,0,0,0) -- 1,18,9,1,103,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMACLNDTOGGLE,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,20,1, 77,0,0,0,0) -- 10,1,20,1,77,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_CROWN_CRATES,false,true
	CallSecureProtected("BindKeyToAction", 1,17,1,2, 0,0,0,0,0) -- 1,17,1,2,0,0,0,0,0,General,Rapid Fire,RF_FIRING,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,20,1, 0,0,0,0,0) -- 28,1,20,1,0,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,19,4, 0,0,0,0,0) -- 28,1,19,4,0,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,19,3, 0,0,0,0,0) -- 28,1,19,3,0,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,19,2, 0,0,0,0,0) -- 28,1,19,2,0,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,19,1, 108,0,0,0,0) -- 28,1,19,1,108,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,21,18,4, 0,0,0,0,0) -- 1,21,18,4,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_13,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,18,3, 0,0,0,0,0) -- 28,1,18,3,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,21,16,3, 0,0,0,0,0) -- 1,21,16,3,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_11,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,18,2, 165,0,0,0,0) -- 28,1,18,2,165,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,25,2,2, 0,0,0,0,0) -- 1,25,2,2,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_1,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,18,1, 3,0,0,0,0) -- 28,1,18,1,3,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,1,9,2, 181,0,0,0,0) -- 1,1,9,2,181,0,0,0,0,General,Movement,TOGGLE_MOUNT,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,17,3, 0,0,0,0,0) -- 28,1,17,3,0,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,17,1, 53,0,0,0,0) -- 28,1,17,1,53,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,11,4,1, 0,0,0,0,0) -- 1,11,4,1,0,0,0,0,0,General,CombatMetrics,CMX_POST_DPS_SINGLE,true,false
	--CallSecureProtected("BindKeyToAction", 16,1,2,2, 135,0,0,0,0) -- 16,1,2,2,135,0,0,0,0,Loot,,LOOT_ALL,false,true
	CallSecureProtected("BindKeyToAction", 1,18,6,1, 0,0,0,0,0) -- 1,18,6,1,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMACHATPOSTTD,true,false
	CallSecureProtected("BindKeyToAction", 3,1,1,1, 36,0,0,0,0) -- 3,1,1,1,36,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_PRIMARY,true,false
	CallSecureProtected("BindKeyToAction", 1,2,23,1, 147,0,0,0,0) -- 1,2,23,1,147,0,0,0,0,General,Combat,GAMEPAD_ACTION_BUTTON_8,true,true
	--CallSecureProtected("BindKeyToAction", 28,1,16,3, 0,0,0,0,0) -- 28,1,16,3,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,22,1,4, 0,0,0,0,0) -- 1,22,1,4,0,0,0,0,0,General,Roomba,RUN_ROOMBA,true,false
	CallSecureProtected("BindKeyToAction", 24,1,2,4, 0,0,0,0,0) -- 24,1,2,4,0,0,0,0,0,Battlegrounds,,LEAVE_BATTLEGROUND_DUMMY,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,16,1, 124,0,0,0,0) -- 28,1,16,1,124,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 5,1,7,3, 0,0,0,0,0) -- 5,1,7,3,0,0,0,0,0,Dialogs,,,false,true
	--CallSecureProtected("BindKeyToAction", 12,1,2,1, 24,0,0,0,0) -- 12,1,2,1,24,0,0,0,0,Guild,,GUILD_2,false,true
	--CallSecureProtected("BindKeyToAction", 3,1,18,4, 0,0,0,0,0) -- 3,1,18,4,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_INPUT_DOWN,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,15,3, 0,0,0,0,0) -- 28,1,15,3,0,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,15,2, 0,0,0,0,0) -- 28,1,15,2,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,11,1,4, 0,0,0,0,0) -- 1,11,1,4,0,0,0,0,0,General,CombatMetrics,CMX_REPORT_TOGGLE,true,false
	--CallSecureProtected("BindKeyToAction", 31,1,3,1, 115,0,0,0,0) -- 31,1,3,1,115,0,0,0,0,ScryingActions,,,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,15,4, 0,0,0,0,0) -- 28,1,15,4,0,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 15,1,5,2, 126,0,0,0,0) -- 15,1,5,2,126,0,0,0,0,Death,,DEATH_RECAP_TOGGLE,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,14,3, 0,0,0,0,0) -- 28,1,14,3,0,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,14,2, 0,0,0,0,0) -- 28,1,14,2,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 34,1,1,2, 0,0,0,0,0) -- 34,1,1,2,0,0,0,0,0,Potion Maker,User Interface,POTIONMAKER_SEARCH,true,false
	--CallSecureProtected("BindKeyToAction", 22,1,3,2, 133,0,0,0,0) -- 22,1,3,2,133,0,0,0,0,ScreenAdjustActions,,SCREEN_ADJUST_SAVE,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,13,4, 0,0,0,0,0) -- 28,1,13,4,0,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 16,1,1,3, 0,0,0,0,0) -- 16,1,1,3,0,0,0,0,0,Loot,,LOOT_ITEM,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,13,2, 0,0,0,0,0) -- 28,1,13,2,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 4,1,3,4, 0,0,0,0,0) -- 4,1,3,4,0,0,0,0,0,Siege,,SIEGE_PACK_UP,true,false
	CallSecureProtected("BindKeyToAction", 1,20,8,3, 0,0,0,0,0) -- 1,20,8,3,0,0,0,0,0,General,|c3366FFBank|r Manager |c990000Revived|r,BMR_PROFILE8,true,false
	--CallSecureProtected("BindKeyToAction", 15,1,3,1, 37,0,0,0,0) -- 15,1,3,1,37,0,0,0,0,Death,,DEATH_TERTIARY,false,true
	CallSecureProtected("BindKeyToAction", 1,11,5,4, 0,0,0,0,0) -- 1,11,5,4,0,0,0,0,0,General,CombatMetrics,CMX_POST_DPS_MULTI,true,false
	CallSecureProtected("BindKeyToAction", 1,6,17,1, 46,0,0,0,0) -- 1,6,17,1,46,0,0,0,0,General,User Interface,TOGGLE_CONTACTS,true,false
	--CallSecureProtected("BindKeyToAction", 27,1,3,4, 0,0,0,0,0) -- 27,1,3,4,0,0,0,0,0,ScreenshotMode,,SCREENSHOT_MODE_EXIT,false,true
	CallSecureProtected("BindKeyToAction", 3,1,9,4, 0,0,0,0,0) -- 3,1,9,4,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_STACK_ALL,true,false
	CallSecureProtected("BindKeyToAction", 1,6,7,4, 0,0,0,0,0) -- 1,6,7,4,0,0,0,0,0,General,User Interface,TOGGLE_GAME_CAMERA_UI_MODE,true,false
	CallSecureProtected("BindKeyToAction", 1,6,33,3, 0,0,0,0,0) -- 1,6,33,3,0,0,0,0,0,General,User Interface,RETICLE_BRIGHTNESS_DECREASE,true,false
	--CallSecureProtected("BindKeyToAction", 13,1,10,2, 58,0,0,0,0) -- 13,1,10,2,58,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_10,false,true
	--CallSecureProtected("BindKeyToAction", 26,1,3,1, 121,0,0,0,0) -- 26,1,3,1,121,0,0,0,0,BattlegroundScoreboard,,BATTLEGROUND_SCOREBOARD_PREVIOUS,false,true
	CallSecureProtected("BindKeyToAction", 24,1,5,2, 0,0,0,0,0) -- 24,1,5,2,0,0,0,0,0,Battlegrounds,,BATTLEGROUND_SCOREBOARD_PLAYER_OPTIONS_DUMMY,true,false
	--CallSecureProtected("BindKeyToAction", 5,1,10,1, 3,5,0,0,0) -- 5,1,10,1,3,5,0,0,0,Dialogs,,,false,true
	--CallSecureProtected("BindKeyToAction", 10,1,17,2, 0,0,0,0,0) -- 10,1,17,2,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_MAIL,false,true
	CallSecureProtected("BindKeyToAction", 1,2,4,2, 130,0,0,0,0) -- 1,2,4,2,130,0,0,0,0,General,Combat,SPECIAL_MOVE_CROUCH,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,11,4, 0,0,0,0,0) -- 28,1,11,4,0,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 3,1,13,4, 0,0,0,0,0) -- 3,1,13,4,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_RIGHT_SHOULDER,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,6,4, 0,0,0,0,0) -- 2,1,6,4,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,25,10,4, 0,0,0,0,0) -- 1,25,10,4,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_9,true,false
	CallSecureProtected("BindKeyToAction", 1,21,8,1, 25,7,0,0,0) -- 1,21,8,1,25,7,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_3,true,false
	CallSecureProtected("BindKeyToAction", 1,6,19,1, 0,0,0,0,0) -- 1,6,19,1,0,0,0,0,0,General,User Interface,TOGGLE_ALLIANCE_WAR,true,false
	CallSecureProtected("BindKeyToAction", 1,21,12,2, 0,0,0,0,0) -- 1,21,12,2,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_7,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,15,1, 0,0,0,0,0) -- 28,1,15,1,0,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,10,4, 0,0,0,0,0) -- 28,1,10,4,0,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 16,1,1,4, 0,0,0,0,0) -- 16,1,1,4,0,0,0,0,0,Loot,,LOOT_ITEM,false,true
	--CallSecureProtected("BindKeyToAction", 5,1,9,2, 0,0,0,0,0) -- 5,1,9,2,0,0,0,0,0,Dialogs,,,false,true
	CallSecureProtected("BindKeyToAction", 1,18,15,1, 0,0,0,0,0) -- 1,18,15,1,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMARNDTOGGLE,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,10,2, 0,0,0,0,0) -- 28,1,10,2,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,2,6,1, 55,0,0,0,0) -- 1,2,6,1,55,0,0,0,0,General,Combat,USE_SYNERGY,true,false
	--CallSecureProtected("BindKeyToAction", 5,1,10,3, 0,0,0,0,0) -- 5,1,10,3,0,0,0,0,0,Dialogs,,,false,true
	--CallSecureProtected("BindKeyToAction", 9,1,1,4, 0,0,0,0,0) -- 9,1,1,4,0,0,0,0,0,Conversation,,CONVERSATION_OPTION_1,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,9,4, 0,0,0,0,0) -- 28,1,9,4,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,21,7,1, 24,7,0,0,0) -- 1,21,7,1,24,7,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_2,true,false
	CallSecureProtected("BindKeyToAction", 1,11,5,2, 0,0,0,0,0) -- 1,11,5,2,0,0,0,0,0,General,CombatMetrics,CMX_POST_DPS_MULTI,true,false
	CallSecureProtected("BindKeyToAction", 1,5,3,2, 0,0,0,0,0) -- 1,5,3,2,0,0,0,0,0,General,Interaction,TEAMFORMATION,true,false
	CallSecureProtected("BindKeyToAction", 1,9,1,3, 0,0,0,0,0) -- 1,9,1,3,0,0,0,0,0,General,|cFF6A00Mass Deconstructor|r,MD_DECONSTRUCTOR_DECON_ALL,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,2,1, 50,0,0,0,0) -- 28,1,2,1,50,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 29,1,8,2, 132,0,0,0,0) -- 29,1,8,2,132,0,0,0,0,Housing Editor Placement Mode,,HOUSING_EDITOR_ROLL_RIGHT,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,9,1, 7,0,0,0,0) -- 28,1,9,1,7,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,8,4, 0,0,0,0,0) -- 28,1,8,4,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,18,1,1, 0,0,0,0,0) -- 1,18,1,1,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMAWINDOWTOGGLE,true,false
	CallSecureProtected("BindKeyToAction", 34,1,2,3, 0,0,0,0,0) -- 34,1,2,3,0,0,0,0,0,Potion Maker,User Interface,POTIONMAKER_SEARCH_WRITS,true,false
	CallSecureProtected("BindKeyToAction", 5,1,2,1, 49,0,0,0,0) -- 5,1,2,1,49,0,0,0,0,Dialogs,,DIALOG_SECONDARY,true,false
	CallSecureProtected("BindKeyToAction", 3,1,5,1, 55,0,0,0,0) -- 3,1,5,1,55,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_NEGATIVE,true,false
	CallSecureProtected("BindKeyToAction", 28,1,41,3, 0,0,0,0,0) -- 28,1,41,3,0,0,0,0,0,Housing Editor,,HOUSING_EDITOR_BEGIN_FURNITURE_LINKING,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,7,2, 116,0,0,0,0) -- 28,1,7,2,116,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,7,1, 51,0,0,0,0) -- 28,1,7,1,51,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,11,5,3, 0,0,0,0,0) -- 1,11,5,3,0,0,0,0,0,General,CombatMetrics,CMX_POST_DPS_MULTI,true,false
	--CallSecureProtected("BindKeyToAction", 16,1,3,2, 127,0,0,0,0) -- 16,1,3,2,127,0,0,0,0,Loot,,LOOT_EXIT,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,6,3, 0,0,0,0,0) -- 28,1,6,3,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 28,1,35,2, 0,0,0,0,0) -- 28,1,35,2,0,0,0,0,0,Housing Editor,,HOUSING_EDITOR_TOGGLE_NODE_SPEED,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,6,1, 13,0,0,0,0) -- 28,1,6,1,13,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 13,1,4,3, 0,0,0,0,0) -- 13,1,4,3,0,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_4,false,true
	CallSecureProtected("BindKeyToAction", 1,18,18,4, 0,0,0,0,0) -- 1,18,18,4,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMARGLA,true,false
	--CallSecureProtected("BindKeyToAction", 11,1,4,4, 0,0,0,0,0) -- 11,1,4,4,0,0,0,0,0,PreviewInterceptLayer,,INTERCEPT_SPECIAL_WEAPON_SWAP,false,true
	CallSecureProtected("BindKeyToAction", 1,26,6,1, 0,0,0,0,0) -- 1,26,6,1,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_WAYSHRINE_UNLOCK,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,5,4, 0,0,0,0,0) -- 28,1,5,4,0,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,9,1, 0,0,0,0,0) -- 2,1,9,1,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,6,9,4, 0,0,0,0,0) -- 1,6,9,4,0,0,0,0,0,General,User Interface,TOGGLE_INVENTORY,true,false
	CallSecureProtected("BindKeyToAction", 1,18,4,2, 0,0,0,0,0) -- 1,18,4,2,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMAFAVRADMENU,true,false
	CallSecureProtected("BindKeyToAction", 3,1,1,3, 0,0,0,0,0) -- 3,1,1,3,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_PRIMARY,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,5,1, 35,0,0,0,0) -- 28,1,5,1,35,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,20,8,1, 0,0,0,0,0) -- 1,20,8,1,0,0,0,0,0,General,|c3366FFBank|r Manager |c990000Revived|r,BMR_PROFILE8,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,4,4, 0,0,0,0,0) -- 28,1,4,4,0,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,4,2, 0,0,0,0,0) -- 28,1,4,2,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 23,1,1,4, 0,0,0,0,0) -- 23,1,1,4,0,0,0,0,0,Housing HUD,,SHOW_HOUSING_PANEL,true,false
	--CallSecureProtected("BindKeyToAction", 11,1,6,4, 0,0,0,0,0) -- 11,1,6,4,0,0,0,0,0,PreviewInterceptLayer,,INTERCEPT_SPECIAL_WEAPON_SWAP_TO_SET_2,false,true
	CallSecureProtected("BindKeyToAction", 1,19,4,4, 0,0,0,0,0) -- 1,19,4,4,0,0,0,0,0,General,Dustman,DUSTMAN_RESCAN,true,false
	CallSecureProtected("BindKeyToAction", 1,21,2,3, 0,0,0,0,0) -- 1,21,2,3,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_UNDRESS,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,3,4, 0,0,0,0,0) -- 28,1,3,4,0,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 4,1,8,4, 0,0,0,0,0) -- 4,1,8,4,0,0,0,0,0,Siege,,,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,20,1, 0,0,0,0,0) -- 2,1,20,1,0,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,3,3, 0,0,0,0,0) -- 28,1,3,3,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,25,9,4, 0,0,0,0,0) -- 1,25,9,4,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_8,true,false
	CallSecureProtected("BindKeyToAction", 1,6,18,3, 0,0,0,0,0) -- 1,6,18,3,0,0,0,0,0,General,User Interface,TOGGLE_GUILDS,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,3,2, 0,0,0,0,0) -- 28,1,3,2,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,9,1,4, 0,0,0,0,0) -- 1,9,1,4,0,0,0,0,0,General,|cFF6A00Mass Deconstructor|r,MD_DECONSTRUCTOR_DECON_ALL,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,3,1, 11,0,0,0,0) -- 28,1,3,1,11,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 31,1,4,1, 53,0,0,0,0) -- 31,1,4,1,53,0,0,0,0,ScryingActions,,,false,true
	--CallSecureProtected("BindKeyToAction", 4,1,5,3, 0,0,0,0,0) -- 4,1,5,3,0,0,0,0,0,Siege,,,false,true
	CallSecureProtected("BindKeyToAction", 1,18,1,4, 0,0,0,0,0) -- 1,18,1,4,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMAWINDOWTOGGLE,true,false
	CallSecureProtected("BindKeyToAction", 1,6,19,4, 0,0,0,0,0) -- 1,6,19,4,0,0,0,0,0,General,User Interface,TOGGLE_ALLIANCE_WAR,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,24,4, 0,0,0,0,0) -- 2,1,24,4,0,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,2,2, 0,0,0,0,0) -- 28,1,2,2,0,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 4,2,4,4, 0,0,0,0,0) -- 4,2,4,4,0,0,0,0,0,Siege,Mini Map,VOTANS_TOGGLE_MAP_ZOOM_PLUS_SIEGE,false,true
	--CallSecureProtected("BindKeyToAction", 15,1,4,2, 134,0,0,0,0) -- 15,1,4,2,134,0,0,0,0,Death,,DEATH_DECLINE,false,true
	CallSecureProtected("BindKeyToAction", 1,29,1,4, 0,0,0,0,0) -- 1,29,1,4,0,0,0,0,0,General,Assist Rapid Riding,ARR_SWITCH,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,5,3, 0,0,0,0,0) -- 10,1,5,3,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_MARKET,false,true
	--CallSecureProtected("BindKeyToAction", 17,1,2,1, 55,0,0,0,0) -- 17,1,2,1,55,0,0,0,0,GamepadChatSystem,,CANCEL_CHAT,false,true
	CallSecureProtected("BindKeyToAction", 29,1,9,4, 0,0,0,0,0) -- 29,1,9,4,0,0,0,0,0,Housing Editor Placement Mode,,HOUSING_EDITOR_PUSH_FORWARD,true,false
	CallSecureProtected("BindKeyToAction", 1,11,5,1, 0,0,0,0,0) -- 1,11,5,1,0,0,0,0,0,General,CombatMetrics,CMX_POST_DPS_MULTI,true,false
	CallSecureProtected("BindKeyToAction", 1,2,13,3, 0,0,0,0,0) -- 1,2,13,3,0,0,0,0,0,General,Combat,ACTION_BUTTON_6,true,false
	--CallSecureProtected("BindKeyToAction", 9,1,9,2, 67,0,0,0,0) -- 9,1,9,2,67,0,0,0,0,Conversation,,CONVERSATION_OPTION_9,false,true
	CallSecureProtected("BindKeyToAction", 1,20,2,2, 0,0,0,0,0) -- 1,20,2,2,0,0,0,0,0,General,|c3366FFBank|r Manager |c990000Revived|r,BMR_PROFILE2,true,false
	--CallSecureProtected("BindKeyToAction", 11,1,3,3, 0,0,0,0,0) -- 11,1,3,3,0,0,0,0,0,PreviewInterceptLayer,,INTERCEPT_SPECIAL_MOVE_CROUCH,false,true
	--CallSecureProtected("BindKeyToAction", 11,1,1,3, 0,0,0,0,0) -- 11,1,1,3,0,0,0,0,0,PreviewInterceptLayer,,INTERCEPT_SHEATHE_WEAPON_TOGGLE,false,true
	--CallSecureProtected("BindKeyToAction", 17,1,3,4, 0,0,0,0,0) -- 17,1,3,4,0,0,0,0,0,GamepadChatSystem,,EXIT_CHAT,false,true
	CallSecureProtected("BindKeyToAction", 28,1,34,1, 137,0,0,0,0) -- 28,1,34,1,137,0,0,0,0,Housing Editor,,HOUSING_EDITOR_QUINARY_ACTION,true,false
	--CallSecureProtected("BindKeyToAction", 27,1,4,4, 138,0,0,0,0) -- 27,1,4,4,138,0,0,0,0,ScreenshotMode,,SCREENSHOT_MODE_SHOW_UI_1,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,10,3, 0,0,0,0,0) -- 2,1,10,3,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,8,1,2, 0,0,0,0,0) -- 1,8,1,2,0,0,0,0,0,General,HarvestMap,SKIP_TARGET,true,false
	--CallSecureProtected("BindKeyToAction", 12,1,1,3, 0,0,0,0,0) -- 12,1,1,3,0,0,0,0,0,Guild,,GUILD_1,false,true
	CallSecureProtected("BindKeyToAction", 1,6,2,2, 0,0,0,0,0) -- 1,6,2,2,0,0,0,0,0,General,User Interface,TAKE_SCREENSHOT,true,false
	--CallSecureProtected("BindKeyToAction", 27,1,4,3, 137,0,0,0,0) -- 27,1,4,3,137,0,0,0,0,ScreenshotMode,,SCREENSHOT_MODE_SHOW_UI_1,false,true
	--CallSecureProtected("BindKeyToAction", 31,1,1,4, 0,0,0,0,0) -- 31,1,1,4,0,0,0,0,0,ScryingActions,,,false,true
	CallSecureProtected("BindKeyToAction", 1,19,1,1, 30,0,0,0,0) -- 1,19,1,1,30,0,0,0,0,General,Dustman,DUSTMAN_JUNK,true,false
	CallSecureProtected("BindKeyToAction", 1,21,18,1, 0,0,0,0,0) -- 1,21,18,1,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_13,true,false
	CallSecureProtected("BindKeyToAction", 1,23,1,2, 0,0,0,0,0) -- 1,23,1,2,0,0,0,0,0,General,Mail Looter,MAILLOOTER_OPEN,true,false
	CallSecureProtected("BindKeyToAction", 24,1,3,3, 0,0,0,0,0) -- 24,1,3,3,0,0,0,0,0,Battlegrounds,,BATTLEGROUND_SCOREBOARD_PREVIOUS_DUMMY,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,25,4, 0,0,0,0,0) -- 2,1,25,4,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,2,1,4, 0,0,0,0,0) -- 1,2,1,4,0,0,0,0,0,General,Combat,SPECIAL_MOVE_ATTACK,true,false
	--CallSecureProtected("BindKeyToAction", 27,1,3,1, 134,0,0,0,0) -- 27,1,3,1,134,0,0,0,0,ScreenshotMode,,SCREENSHOT_MODE_EXIT,false,true
	--CallSecureProtected("BindKeyToAction", 27,1,2,4, 0,0,0,0,0) -- 27,1,2,4,0,0,0,0,0,ScreenshotMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,8,1,1, 0,0,0,0,0) -- 1,8,1,1,0,0,0,0,0,General,HarvestMap,SKIP_TARGET,true,false
	--CallSecureProtected("BindKeyToAction", 27,1,2,3, 0,0,0,0,0) -- 27,1,2,3,0,0,0,0,0,ScreenshotMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,18,3,4, 0,0,0,0,0) -- 1,18,3,4,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMATABCHANGE,true,false
	CallSecureProtected("BindKeyToAction", 1,25,7,3, 0,0,0,0,0) -- 1,25,7,3,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_6,true,false
	CallSecureProtected("BindKeyToAction", 1,25,11,2, 0,0,0,0,0) -- 1,25,11,2,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_10,true,false
	--CallSecureProtected("BindKeyToAction", 27,1,1,1, 133,0,0,0,0) -- 27,1,1,1,133,0,0,0,0,ScreenshotMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 29,1,1,3, 0,0,0,0,0) -- 29,1,1,3,0,0,0,0,0,Housing Editor Placement Mode,,,false,true
	--CallSecureProtected("BindKeyToAction", 26,1,4,3, 0,0,0,0,0) -- 26,1,4,3,0,0,0,0,0,BattlegroundScoreboard,,BATTLEGROUND_SCOREBOARD_NEXT,false,true
	--CallSecureProtected("BindKeyToAction", 26,1,4,2, 132,0,0,0,0) -- 26,1,4,2,132,0,0,0,0,BattlegroundScoreboard,,BATTLEGROUND_SCOREBOARD_NEXT,false,true
	CallSecureProtected("BindKeyToAction", 1,21,17,3, 0,0,0,0,0) -- 1,21,17,3,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_12,true,false
	CallSecureProtected("BindKeyToAction", 1,6,4,3, 0,0,0,0,0) -- 1,6,4,3,0,0,0,0,0,General,User Interface,START_CHAT_SLASH,true,false
	CallSecureProtected("BindKeyToAction", 1,8,1,4, 0,0,0,0,0) -- 1,8,1,4,0,0,0,0,0,General,HarvestMap,SKIP_TARGET,true,false
	--CallSecureProtected("BindKeyToAction", 4,2,3,1, 0,0,0,0,0) -- 4,2,3,1,0,0,0,0,0,Siege,Mini Map,VOTANS_TOGGLE_MAP_ZOOM_IN_SIEGE,false,true
	CallSecureProtected("BindKeyToAction", 1,26,6,4, 0,0,0,0,0) -- 1,26,6,4,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_WAYSHRINE_UNLOCK,true,false
	--CallSecureProtected("BindKeyToAction", 9,1,10,4, 0,0,0,0,0) -- 9,1,10,4,0,0,0,0,0,Conversation,,CONVERSATION_OPTION_10,false,true
	--CallSecureProtected("BindKeyToAction", 26,1,3,3, 0,0,0,0,0) -- 26,1,3,3,0,0,0,0,0,BattlegroundScoreboard,,BATTLEGROUND_SCOREBOARD_PREVIOUS,false,true
	--CallSecureProtected("BindKeyToAction", 26,1,3,2, 131,0,0,0,0) -- 26,1,3,2,131,0,0,0,0,BattlegroundScoreboard,,BATTLEGROUND_SCOREBOARD_PREVIOUS,false,true
	--CallSecureProtected("BindKeyToAction", 26,1,2,4, 0,0,0,0,0) -- 26,1,2,4,0,0,0,0,0,BattlegroundScoreboard,,HIDE_BATTLEGROUND_SCOREBOARD,false,true
	CallSecureProtected("BindKeyToAction", 1,26,18,4, 0,0,0,0,0) -- 1,26,18,4,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_PLAYER_3,true,false
	--CallSecureProtected("BindKeyToAction", 13,1,6,2, 64,0,0,0,0) -- 13,1,6,2,64,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_6,false,true
	CallSecureProtected("BindKeyToAction", 1,30,1,4, 0,0,0,0,0) -- 1,30,1,4,0,0,0,0,0,General,WritWorthy,WritWorthyUI_ToggleUI,true,false
	--CallSecureProtected("BindKeyToAction", 3,1,11,4, 0,0,0,0,0) -- 3,1,11,4,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_RIGHT_TRIGGER,false,true
	CallSecureProtected("BindKeyToAction", 1,6,13,1, 41,0,0,0,0) -- 1,6,13,1,41,0,0,0,0,General,User Interface,TOGGLE_JOURNAL,true,false
	--CallSecureProtected("BindKeyToAction", 26,1,2,1, 79,0,0,0,0) -- 26,1,2,1,79,0,0,0,0,BattlegroundScoreboard,,HIDE_BATTLEGROUND_SCOREBOARD,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,29,2, 0,0,0,0,0) -- 2,1,29,2,0,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,19,4, 0,0,0,0,0) -- 2,1,19,4,0,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 4,1,12,3, 0,0,0,0,0) -- 4,1,12,3,0,0,0,0,0,Siege,,,false,true
	CallSecureProtected("BindKeyToAction", 1,13,1,2, 0,0,0,0,0) -- 1,13,1,2,0,0,0,0,0,General,|c4B8BFETimer,IP_TIMER_START,true,false
	--CallSecureProtected("BindKeyToAction", 26,1,1,4, 0,0,0,0,0) -- 26,1,1,4,0,0,0,0,0,BattlegroundScoreboard,,LEAVE_BATTLEGROUND,false,true
	--CallSecureProtected("BindKeyToAction", 26,1,1,3, 0,0,0,0,0) -- 26,1,1,3,0,0,0,0,0,BattlegroundScoreboard,,LEAVE_BATTLEGROUND,false,true
	CallSecureProtected("BindKeyToAction", 1,26,17,2, 0,0,0,0,0) -- 1,26,17,2,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_PLAYER_2,true,false
	--CallSecureProtected("BindKeyToAction", 26,1,1,2, 136,0,0,0,0) -- 26,1,1,2,136,0,0,0,0,BattlegroundScoreboard,,LEAVE_BATTLEGROUND,false,true
	--CallSecureProtected("BindKeyToAction", 26,1,1,1, 37,0,0,0,0) -- 26,1,1,1,37,0,0,0,0,BattlegroundScoreboard,,LEAVE_BATTLEGROUND,false,true
	--CallSecureProtected("BindKeyToAction", 25,1,1,4, 0,0,0,0,0) -- 25,1,1,4,0,0,0,0,0,BattlegroundHud,,SHOW_BATTLEGROUND_SCOREBOARD,false,true
	CallSecureProtected("BindKeyToAction", 1,13,2,2, 0,0,0,0,0) -- 1,13,2,2,0,0,0,0,0,General,|c4B8BFETimer,IP_TIMER_STOP,true,false
	CallSecureProtected("BindKeyToAction", 1,25,2,3, 0,0,0,0,0) -- 1,25,2,3,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_1,true,false
	CallSecureProtected("BindKeyToAction", 1,26,12,3, 0,0,0,0,0) -- 1,26,12,3,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_ZONE_2,true,false
	CallSecureProtected("BindKeyToAction", 1,7,4,3, 0,0,0,0,0) -- 1,7,4,3,0,0,0,0,0,General,Mini Map,VOTANS_TOGGLE_MAP_ZOOM_OUT,true,false
	--CallSecureProtected("BindKeyToAction", 13,1,2,1, 24,0,0,0,0) -- 13,1,2,1,24,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_2,false,true
	CallSecureProtected("BindKeyToAction", 1,6,17,3, 0,0,0,0,0) -- 1,6,17,3,0,0,0,0,0,General,User Interface,TOGGLE_CONTACTS,true,false
	CallSecureProtected("BindKeyToAction", 1,21,13,3, 0,0,0,0,0) -- 1,21,13,3,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_8,true,false
	--CallSecureProtected("BindKeyToAction", 25,1,1,2, 167,0,0,0,0) -- 25,1,1,2,167,0,0,0,0,BattlegroundHud,,SHOW_BATTLEGROUND_SCOREBOARD,false,true
	CallSecureProtected("BindKeyToAction", 34,1,2,1, 0,0,0,0,0) -- 34,1,2,1,0,0,0,0,0,Potion Maker,User Interface,POTIONMAKER_SEARCH_WRITS,true,false
	CallSecureProtected("BindKeyToAction", 24,1,5,1, 135,0,0,0,0) -- 24,1,5,1,135,0,0,0,0,Battlegrounds,,BATTLEGROUND_SCOREBOARD_PLAYER_OPTIONS_DUMMY,true,false
	CallSecureProtected("BindKeyToAction", 24,1,4,4, 0,0,0,0,0) -- 24,1,4,4,0,0,0,0,0,Battlegrounds,,BATTLEGROUND_SCOREBOARD_NEXT_DUMMY,true,false
	--CallSecureProtected("BindKeyToAction", 9,1,11,4, 0,0,0,0,0) -- 9,1,11,4,0,0,0,0,0,Conversation,,CONVERSATION_OPTION_PRIMARY,false,true
	--CallSecureProtected("BindKeyToAction", 11,1,5,1, 0,0,0,0,0) -- 11,1,5,1,0,0,0,0,0,PreviewInterceptLayer,,INTERCEPT_SPECIAL_WEAPON_SWAP_TO_SET_1,false,true
	CallSecureProtected("BindKeyToAction", 24,1,4,3, 0,0,0,0,0) -- 24,1,4,3,0,0,0,0,0,Battlegrounds,,BATTLEGROUND_SCOREBOARD_NEXT_DUMMY,true,false
	CallSecureProtected("BindKeyToAction", 28,1,37,3, 0,0,0,0,0) -- 28,1,37,3,0,0,0,0,0,Housing Editor,,HOUSING_EDITOR_JUMP_TO_SAFE_LOC,true,false
	CallSecureProtected("BindKeyToAction", 1,1,10,4, 0,0,0,0,0) -- 1,1,10,4,0,0,0,0,0,General,Movement,GAMEPAD_JUMP_OR_INTERACT,true,true
	CallSecureProtected("BindKeyToAction", 1,15,4,3, 0,0,0,0,0) -- 1,15,4,3,0,0,0,0,0,General,Vacuum Shop,VACUUM_DOWN,true,false
	CallSecureProtected("BindKeyToAction", 24,1,4,1, 120,0,0,0,0) -- 24,1,4,1,120,0,0,0,0,Battlegrounds,,BATTLEGROUND_SCOREBOARD_NEXT_DUMMY,true,false
	--CallSecureProtected("BindKeyToAction", 27,1,4,1, 135,0,0,0,0) -- 27,1,4,1,135,0,0,0,0,ScreenshotMode,,SCREENSHOT_MODE_SHOW_UI_1,false,true
	CallSecureProtected("BindKeyToAction", 24,1,3,2, 131,0,0,0,0) -- 24,1,3,2,131,0,0,0,0,Battlegrounds,,BATTLEGROUND_SCOREBOARD_PREVIOUS_DUMMY,true,false
	CallSecureProtected("BindKeyToAction", 1,20,6,3, 0,0,0,0,0) -- 1,20,6,3,0,0,0,0,0,General,|c3366FFBank|r Manager |c990000Revived|r,BMR_PROFILE6,true,false
	--CallSecureProtected("BindKeyToAction", 4,1,8,2, 0,0,0,0,0) -- 4,1,8,2,0,0,0,0,0,Siege,,,false,true
	CallSecureProtected("BindKeyToAction", 24,1,3,1, 121,0,0,0,0) -- 24,1,3,1,121,0,0,0,0,Battlegrounds,,BATTLEGROUND_SCOREBOARD_PREVIOUS_DUMMY,true,false
	CallSecureProtected("BindKeyToAction", 3,1,8,2, 0,0,0,0,0) -- 3,1,8,2,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_SHOW_QUEST_ON_MAP,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,16,2, 0,0,0,0,0) -- 28,1,16,2,0,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 10,1,4,2, 127,0,0,0,0) -- 10,1,4,2,127,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_GAME_CAMERA_UI_MODE,false,true
	CallSecureProtected("BindKeyToAction", 1,26,19,4, 0,0,0,0,0) -- 1,26,19,4,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_PLAYER_4,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,29,4, 0,0,0,0,0) -- 2,1,29,4,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,25,8,3, 0,0,0,0,0) -- 1,25,8,3,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_7,true,false
	CallSecureProtected("BindKeyToAction", 1,26,4,3, 0,0,0,0,0) -- 1,26,4,3,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_TOGGLE_MAIN_CURRENT_ZONE,true,false
	--CallSecureProtected("BindKeyToAction", 13,1,6,4, 0,0,0,0,0) -- 13,1,6,4,0,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_6,false,true
	CallSecureProtected("BindKeyToAction", 24,1,1,4, 0,0,0,0,0) -- 24,1,1,4,0,0,0,0,0,Battlegrounds,,TOGGLE_BATTLEGROUND_SCOREBOARD_DUMMY,true,false
	CallSecureProtected("BindKeyToAction", 24,1,1,3, 0,0,0,0,0) -- 24,1,1,3,0,0,0,0,0,Battlegrounds,,TOGGLE_BATTLEGROUND_SCOREBOARD_DUMMY,true,false
	CallSecureProtected("BindKeyToAction", 24,1,1,2, 167,0,0,0,0) -- 24,1,1,2,167,0,0,0,0,Battlegrounds,,TOGGLE_BATTLEGROUND_SCOREBOARD_DUMMY,true,false
	CallSecureProtected("BindKeyToAction", 1,6,24,4, 0,0,0,0,0) -- 1,6,24,4,0,0,0,0,0,General,User Interface,TOGGLE_HELP,true,false
	CallSecureProtected("BindKeyToAction", 1,7,5,4, 0,0,0,0,0) -- 1,7,5,4,0,0,0,0,0,General,Mini Map,VOTANS_TOGGLE_MAP_ZOOM_IN,true,false
	CallSecureProtected("BindKeyToAction", 1,2,17,2, 0,0,0,0,0) -- 1,2,17,2,0,0,0,0,0,General,Combat,GAMEPAD_MOVE_JUMPASCEND,true,true
	CallSecureProtected("BindKeyToAction", 1,3,1,3, 0,0,0,0,0) -- 1,3,1,3,0,0,0,0,0,General,Targeting,CYCLE_PREFERRED_ENEMY_TARGET,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,4,1, 32,0,0,0,0) -- 28,1,4,1,32,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 23,1,1,3, 0,0,0,0,0) -- 23,1,1,3,0,0,0,0,0,Housing HUD,,SHOW_HOUSING_PANEL,true,false
	CallSecureProtected("BindKeyToAction", 1,1,2,3, 140,0,0,0,0) -- 1,1,2,3,140,0,0,0,0,General,Movement,MOVE_BACKWARD,true,false
	--CallSecureProtected("BindKeyToAction", 13,1,4,1, 26,0,0,0,0) -- 13,1,4,1,26,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_4,false,true
	--CallSecureProtected("BindKeyToAction", 22,1,4,4, 0,0,0,0,0) -- 22,1,4,4,0,0,0,0,0,ScreenAdjustActions,,SCREEN_ADJUST_CANCEL,false,true
	--CallSecureProtected("BindKeyToAction", 22,1,4,3, 0,0,0,0,0) -- 22,1,4,3,0,0,0,0,0,ScreenAdjustActions,,SCREEN_ADJUST_CANCEL,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,22,3, 0,0,0,0,0) -- 2,1,22,3,0,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 22,1,3,3, 0,0,0,0,0) -- 22,1,3,3,0,0,0,0,0,ScreenAdjustActions,,SCREEN_ADJUST_SAVE,false,true
	CallSecureProtected("BindKeyToAction", 1,11,4,3, 0,0,0,0,0) -- 1,11,4,3,0,0,0,0,0,General,CombatMetrics,CMX_POST_DPS_SINGLE,true,false
	CallSecureProtected("BindKeyToAction", 1,8,4,4, 0,0,0,0,0) -- 1,8,4,4,0,0,0,0,0,General,HarvestMap,HARVEST_SHOW_PANEL,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,25,3, 0,0,0,0,0) -- 2,1,25,3,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,20,6,4, 0,0,0,0,0) -- 1,20,6,4,0,0,0,0,0,General,|c3366FFBank|r Manager |c990000Revived|r,BMR_PROFILE6,true,false
	--CallSecureProtected("BindKeyToAction", 22,1,3,1, 36,0,0,0,0) -- 22,1,3,1,36,0,0,0,0,ScreenAdjustActions,,SCREEN_ADJUST_SAVE,false,true
	CallSecureProtected("BindKeyToAction", 22,1,2,4, 0,0,0,0,0) -- 22,1,2,4,0,0,0,0,0,ScreenAdjustActions,,SCREEN_ADJUST_SHRINK,true,true
	CallSecureProtected("BindKeyToAction", 1,26,5,4, 0,0,0,0,0) -- 1,26,5,4,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_TOGGLE_MAIN_DELVES,true,false
	--CallSecureProtected("BindKeyToAction", 33,1,1,1, 4,0,0,0,0) -- 33,1,1,1,4,0,0,0,0,PathNodeRotationBlockCrouchLayer,,,false,true
	CallSecureProtected("BindKeyToAction", 1,4,3,2, 0,0,0,0,0) -- 1,4,3,2,0,0,0,0,0,General,Camera,GAME_CAMERA_MOUSE_FREE_LOOK,true,false
	CallSecureProtected("BindKeyToAction", 28,1,34,2, 0,0,0,0,0) -- 28,1,34,2,0,0,0,0,0,Housing Editor,,HOUSING_EDITOR_QUINARY_ACTION,true,false
	--CallSecureProtected("BindKeyToAction", 21,1,2,3, 0,0,0,0,0) -- 21,1,2,3,0,0,0,0,0,OptionsWindow,,OPTIONS_LOAD_DEFAULTS,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,38,4, 0,0,0,0,0) -- 28,1,38,4,0,0,0,0,0,Housing Editor,,DISABLE_HOUSING_EDITOR,false,true
	CallSecureProtected("BindKeyToAction", 1,11,3,3, 0,0,0,0,0) -- 1,11,3,3,0,0,0,0,0,General,CombatMetrics,CMX_POST_DPS_SMART,true,false
	--CallSecureProtected("BindKeyToAction", 21,1,2,1, 55,0,0,0,0) -- 21,1,2,1,55,0,0,0,0,OptionsWindow,,OPTIONS_LOAD_DEFAULTS,false,true
	CallSecureProtected("BindKeyToAction", 1,12,1,3, 0,0,0,0,0) -- 1,12,1,3,0,0,0,0,0,General,Foundry Tactical Combat,TOGGLE_COMBAT_LOG,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,12,4, 0,0,0,0,0) -- 2,1,12,4,0,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,17,3, 0,0,0,0,0) -- 2,1,17,3,0,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 21,1,1,4, 0,0,0,0,0) -- 21,1,1,4,0,0,0,0,0,OptionsWindow,,OPTIONS_APPLY_CHANGES,false,true
	--CallSecureProtected("BindKeyToAction", 21,1,1,3, 0,0,0,0,0) -- 21,1,1,3,0,0,0,0,0,OptionsWindow,,OPTIONS_APPLY_CHANGES,false,true
	--CallSecureProtected("BindKeyToAction", 21,1,1,2, 133,0,0,0,0) -- 21,1,1,2,133,0,0,0,0,OptionsWindow,,OPTIONS_APPLY_CHANGES,false,true
	--CallSecureProtected("BindKeyToAction", 20,1,1,3, 0,0,0,0,0) -- 20,1,1,3,0,0,0,0,0,Addons,,ADDONS_PANEL_MULTI_BUTTON,false,true
	CallSecureProtected("BindKeyToAction", 1,6,32,4, 0,0,0,0,0) -- 1,6,32,4,0,0,0,0,0,General,User Interface,RETICLE_BRIGHTNESS_INCREASE,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,5,4, 0,0,0,0,0) -- 2,1,5,4,0,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 20,1,1,2, 133,0,0,0,0) -- 20,1,1,2,133,0,0,0,0,Addons,,ADDONS_PANEL_MULTI_BUTTON,false,true
	--CallSecureProtected("BindKeyToAction", 20,1,1,1, 36,0,0,0,0) -- 20,1,1,1,36,0,0,0,0,Addons,,ADDONS_PANEL_MULTI_BUTTON,false,true
	--CallSecureProtected("BindKeyToAction", 19,1,2,4, 0,0,0,0,0) -- 19,1,2,4,0,0,0,0,0,KeybindWindow,,KEYBINDS_LOAD_GAMEPAD_DEFAULTS,false,true
	--CallSecureProtected("BindKeyToAction", 19,1,2,3, 0,0,0,0,0) -- 19,1,2,3,0,0,0,0,0,KeybindWindow,,KEYBINDS_LOAD_GAMEPAD_DEFAULTS,false,true
	CallSecureProtected("BindKeyToAction", 1,18,16,2, 0,0,0,0,0) -- 1,18,16,2,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMAGUILDTOGGLE,true,false
	CallSecureProtected("BindKeyToAction", 1,11,3,2, 0,0,0,0,0) -- 1,11,3,2,0,0,0,0,0,General,CombatMetrics,CMX_POST_DPS_SMART,true,false
	CallSecureProtected("BindKeyToAction", 1,2,24,2, 123,0,0,0,0) -- 1,2,24,2,123,0,0,0,0,General,Combat,ACTION_BUTTON_9,true,false
	--CallSecureProtected("BindKeyToAction", 19,1,2,2, 136,0,0,0,0) -- 19,1,2,2,136,0,0,0,0,KeybindWindow,,KEYBINDS_LOAD_GAMEPAD_DEFAULTS,false,true
	--CallSecureProtected("BindKeyToAction", 19,1,2,1, 37,0,0,0,0) -- 19,1,2,1,37,0,0,0,0,KeybindWindow,,KEYBINDS_LOAD_GAMEPAD_DEFAULTS,false,true
	--CallSecureProtected("BindKeyToAction", 10,1,16,2, 0,0,0,0,0) -- 10,1,16,2,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_ALLIANCE_WAR,false,true
	--CallSecureProtected("BindKeyToAction", 13,1,2,4, 0,0,0,0,0) -- 13,1,2,4,0,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_2,false,true
	--CallSecureProtected("BindKeyToAction", 19,1,1,3, 0,0,0,0,0) -- 19,1,1,3,0,0,0,0,0,KeybindWindow,,KEYBINDS_LOAD_KEYBOARD_DEFAULTS,false,true
	--CallSecureProtected("BindKeyToAction", 9,1,4,2, 62,0,0,0,0) -- 9,1,4,2,62,0,0,0,0,Conversation,,CONVERSATION_OPTION_4,false,true
	--CallSecureProtected("BindKeyToAction", 5,1,8,2, 0,0,0,0,0) -- 5,1,8,2,0,0,0,0,0,Dialogs,,,false,true
	CallSecureProtected("BindKeyToAction", 1,7,1,2, 0,0,0,0,0) -- 1,7,1,2,0,0,0,0,0,General,Mini Map,VOTANS_TOGGLE_MAP_SHOW,true,false
	CallSecureProtected("BindKeyToAction", 1,11,3,1, 0,0,0,0,0) -- 1,11,3,1,0,0,0,0,0,General,CombatMetrics,CMX_POST_DPS_SMART,true,false
	--CallSecureProtected("BindKeyToAction", 12,1,3,4, 0,0,0,0,0) -- 12,1,3,4,0,0,0,0,0,Guild,,GUILD_3,false,true
	CallSecureProtected("BindKeyToAction", 3,3,1,1, 31,0,0,0,0) -- 3,3,1,1,31,0,0,0,0,User Interface Shortcuts,Fish Fillet,VOTANS_FISH_FILLET_ALL_STACKS,true,false
	CallSecureProtected("BindKeyToAction", 1,2,5,2, 148,0,0,0,0) -- 1,2,5,2,148,0,0,0,0,General,Combat,SPECIAL_MOVE_INTERRUPT,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,4,3, 0,0,0,0,0) -- 2,1,4,3,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,11,2,2, 0,0,0,0,0) -- 1,11,2,2,0,0,0,0,0,General,CombatMetrics,CMX_POST_DPS,true,false
	CallSecureProtected("BindKeyToAction", 1,27,1,4, 0,0,0,0,0) -- 1,27,1,4,0,0,0,0,0,General,Mementos,HOLIDAY_MEMENTO,true,false
	--CallSecureProtected("BindKeyToAction", 21,1,2,4, 0,0,0,0,0) -- 21,1,2,4,0,0,0,0,0,OptionsWindow,,OPTIONS_LOAD_DEFAULTS,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,12,1, 42,0,0,0,0) -- 2,1,12,1,42,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 18,1,1,3, 128,0,0,0,0) -- 18,1,1,3,128,0,0,0,0,GameMenu,,GAME_MENU_DO_NOTHING,false,true
	--CallSecureProtected("BindKeyToAction", 10,1,1,1, 5,0,0,0,0) -- 10,1,1,1,5,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_UI_SHORTCUT_EXIT,false,true
	CallSecureProtected("BindKeyToAction", 1,6,13,4, 0,0,0,0,0) -- 1,6,13,4,0,0,0,0,0,General,User Interface,TOGGLE_JOURNAL,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,23,1, 0,0,0,0,0) -- 2,1,23,1,0,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,14,1, 121,0,0,0,0) -- 28,1,14,1,121,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 18,1,1,1, 5,0,0,0,0) -- 18,1,1,1,5,0,0,0,0,GameMenu,,GAME_MENU_DO_NOTHING,false,true
	--CallSecureProtected("BindKeyToAction", 4,1,13,4, 0,0,0,0,0) -- 4,1,13,4,0,0,0,0,0,Siege,,,false,true
	CallSecureProtected("BindKeyToAction", 1,18,15,4, 0,0,0,0,0) -- 1,18,15,4,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMARNDTOGGLE,true,false
	CallSecureProtected("BindKeyToAction", 1,21,12,3, 0,0,0,0,0) -- 1,21,12,3,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_7,true,false
	--CallSecureProtected("BindKeyToAction", 17,1,4,3, 0,0,0,0,0) -- 17,1,4,3,0,0,0,0,0,GamepadChatSystem,,,false,true
	--CallSecureProtected("BindKeyToAction", 9,1,12,1, 55,0,0,0,0) -- 9,1,12,1,55,0,0,0,0,Conversation,,CONVERSATION_OPTION_NEGATIVE,false,true
	--CallSecureProtected("BindKeyToAction", 27,1,5,4, 0,0,0,0,0) -- 27,1,5,4,0,0,0,0,0,ScreenshotMode,,SCREENSHOT_MODE_SHOW_UI_2,false,true
	CallSecureProtected("BindKeyToAction", 1,21,21,2, 0,0,0,0,0) -- 1,21,21,2,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_16,true,false
	--CallSecureProtected("BindKeyToAction", 17,1,3,3, 128,0,0,0,0) -- 17,1,3,3,128,0,0,0,0,GamepadChatSystem,,EXIT_CHAT,false,true
	--CallSecureProtected("BindKeyToAction", 17,1,3,1, 5,0,0,0,0) -- 17,1,3,1,5,0,0,0,0,GamepadChatSystem,,EXIT_CHAT,false,true
	--CallSecureProtected("BindKeyToAction", 10,1,12,4, 0,0,0,0,0) -- 10,1,12,4,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_MAP,false,true
	--CallSecureProtected("BindKeyToAction", 17,1,2,4, 0,0,0,0,0) -- 17,1,2,4,0,0,0,0,0,GamepadChatSystem,,CANCEL_CHAT,false,true
	CallSecureProtected("BindKeyToAction", 1,18,24,1, 0,0,0,0,0) -- 1,18,24,1,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMALFGPMODE,true,false
	CallSecureProtected("BindKeyToAction", 1,6,20,4, 0,0,0,0,0) -- 1,6,20,4,0,0,0,0,0,General,User Interface,TOGGLE_MAIL,true,false
	--CallSecureProtected("BindKeyToAction", 15,1,4,1, 55,0,0,0,0) -- 15,1,4,1,55,0,0,0,0,Death,,DEATH_DECLINE,false,true
	CallSecureProtected("BindKeyToAction", 1,20,4,3, 0,0,0,0,0) -- 1,20,4,3,0,0,0,0,0,General,|c3366FFBank|r Manager |c990000Revived|r,BMR_PROFILE4,true,false
	CallSecureProtected("BindKeyToAction", 1,6,23,1, 77,0,0,0,0) -- 1,6,23,1,77,0,0,0,0,General,User Interface,TOGGLE_CROWN_CRATES,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,16,4, 0,0,0,0,0) -- 28,1,16,4,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,26,2,2, 0,0,0,0,0) -- 1,26,2,2,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_TOGGLE_MAIN_ACTIVE_QUESTS,true,false
	--CallSecureProtected("BindKeyToAction", 17,1,1,4, 0,0,0,0,0) -- 17,1,1,4,0,0,0,0,0,GamepadChatSystem,,SUBMIT_CHAT,false,true
	--CallSecureProtected("BindKeyToAction", 17,1,1,3, 0,0,0,0,0) -- 17,1,1,3,0,0,0,0,0,GamepadChatSystem,,SUBMIT_CHAT,false,true
	--CallSecureProtected("BindKeyToAction", 9,1,1,3, 0,0,0,0,0) -- 9,1,1,3,0,0,0,0,0,Conversation,,CONVERSATION_OPTION_1,false,true
	--CallSecureProtected("BindKeyToAction", 17,1,1,1, 36,0,0,0,0) -- 17,1,1,1,36,0,0,0,0,GamepadChatSystem,,SUBMIT_CHAT,false,true
	--CallSecureProtected("BindKeyToAction", 16,1,3,4, 0,0,0,0,0) -- 16,1,3,4,0,0,0,0,0,Loot,,LOOT_EXIT,false,true
	--CallSecureProtected("BindKeyToAction", 16,1,3,3, 128,0,0,0,0) -- 16,1,3,3,128,0,0,0,0,Loot,,LOOT_EXIT,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,6,4, 0,0,0,0,0) -- 28,1,6,4,0,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 16,1,3,1, 5,0,0,0,0) -- 16,1,3,1,5,0,0,0,0,Loot,,LOOT_EXIT,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,9,3, 0,0,0,0,0) -- 2,1,9,3,0,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 4,1,4,2, 0,0,0,0,0) -- 4,1,4,2,0,0,0,0,0,Siege,,SIEGE_ESCAPE,false,true
	CallSecureProtected("BindKeyToAction", 1,2,8,4, 0,0,0,0,0) -- 1,2,8,4,0,0,0,0,0,General,Combat,SPECIAL_MOVE_WEAPON_SWAP_TO_SET_1,true,false
	--CallSecureProtected("BindKeyToAction", 16,1,2,4, 0,0,0,0,0) -- 16,1,2,4,0,0,0,0,0,Loot,,LOOT_ALL,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,17,1, 47,0,0,0,0) -- 2,1,17,1,47,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 16,1,2,3, 0,0,0,0,0) -- 16,1,2,3,0,0,0,0,0,Loot,,LOOT_ALL,false,true
	CallSecureProtected("BindKeyToAction", 1,18,10,3, 0,0,0,0,0) -- 1,18,10,3,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMAWRBTOGGLE,true,false
	--CallSecureProtected("BindKeyToAction", 15,1,6,4, 0,0,0,0,0) -- 15,1,6,4,0,0,0,0,0,Death,,DEATH_RECAP_HIDE,false,true
	CallSecureProtected("BindKeyToAction", 1,2,1,3, 0,0,0,0,0) -- 1,2,1,3,0,0,0,0,0,General,Combat,SPECIAL_MOVE_ATTACK,true,false
	CallSecureProtected("BindKeyToAction", 1,18,13,3, 0,0,0,0,0) -- 1,18,13,3,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMACRAFTTOGGLE,true,false
	--CallSecureProtected("BindKeyToAction", 4,1,12,1, 107,0,0,0,0) -- 4,1,12,1,107,0,0,0,0,Siege,,,false,true
	CallSecureProtected("BindKeyToAction", 1,26,4,1, 0,0,0,0,0) -- 1,26,4,1,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_TOGGLE_MAIN_CURRENT_ZONE,true,false
	CallSecureProtected("BindKeyToAction", 1,8,3,2, 0,0,0,0,0) -- 1,8,3,2,0,0,0,0,0,General,HarvestMap,TOGGLE_MAPPINS,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,23,4, 0,0,0,0,0) -- 2,1,23,4,0,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 15,1,6,1, 5,0,0,0,0) -- 15,1,6,1,5,0,0,0,0,Death,,DEATH_RECAP_HIDE,false,true
	CallSecureProtected("BindKeyToAction", 1,1,7,4, 0,0,0,0,0) -- 1,1,7,4,0,0,0,0,0,General,Movement,AUTORUN,true,false
	CallSecureProtected("BindKeyToAction", 1,21,12,1, 0,0,0,0,0) -- 1,21,12,1,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_7,true,false
	--CallSecureProtected("BindKeyToAction", 15,1,5,4, 0,0,0,0,0) -- 15,1,5,4,0,0,0,0,0,Death,,DEATH_RECAP_TOGGLE,false,true
	CallSecureProtected("BindKeyToAction", 1,26,7,3, 0,0,0,0,0) -- 1,26,7,3,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_REFRESH,true,false
	--CallSecureProtected("BindKeyToAction", 15,1,5,1, 0,0,0,0,0) -- 15,1,5,1,0,0,0,0,0,Death,,DEATH_RECAP_TOGGLE,false,true
	CallSecureProtected("BindKeyToAction", 1,2,23,4, 0,0,0,0,0) -- 1,2,23,4,0,0,0,0,0,General,Combat,GAMEPAD_ACTION_BUTTON_8,true,true
	--CallSecureProtected("BindKeyToAction", 4,1,13,2, 0,0,0,0,0) -- 4,1,13,2,0,0,0,0,0,Siege,,,false,true
	--CallSecureProtected("BindKeyToAction", 15,1,4,4, 0,0,0,0,0) -- 15,1,4,4,0,0,0,0,0,Death,,DEATH_DECLINE,false,true
	CallSecureProtected("BindKeyToAction", 1,5,2,2, 180,0,0,0,0) -- 1,5,2,2,180,0,0,0,0,General,Interaction,PLAYER_TO_PLAYER_INTERACT,true,false
	CallSecureProtected("BindKeyToAction", 1,4,3,4, 0,0,0,0,0) -- 1,4,3,4,0,0,0,0,0,General,Camera,GAME_CAMERA_MOUSE_FREE_LOOK,true,false
	--CallSecureProtected("BindKeyToAction", 17,1,2,3, 0,0,0,0,0) -- 17,1,2,3,0,0,0,0,0,GamepadChatSystem,,CANCEL_CHAT,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,12,2, 0,0,0,0,0) -- 2,1,12,2,0,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 8,1,2,4, 0,0,0,0,0) -- 8,1,2,4,0,0,0,0,0,MouseUIMode,,LEFT_AND_RIGHT_MOUSE_IN_WORLD,false,true
	--CallSecureProtected("BindKeyToAction", 31,1,5,4, 0,0,0,0,0) -- 31,1,5,4,0,0,0,0,0,ScryingActions,,,false,true
	CallSecureProtected("BindKeyToAction", 1,18,23,4, 0,0,0,0,0) -- 1,18,23,4,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMALFGP,true,false
	--CallSecureProtected("BindKeyToAction", 15,1,3,3, 0,0,0,0,0) -- 15,1,3,3,0,0,0,0,0,Death,,DEATH_TERTIARY,false,true
	CallSecureProtected("BindKeyToAction", 5,1,3,2, 136,0,0,0,0) -- 5,1,3,2,136,0,0,0,0,Dialogs,,DIALOG_TERTIARY,true,false
	--CallSecureProtected("BindKeyToAction", 15,1,3,2, 136,0,0,0,0) -- 15,1,3,2,136,0,0,0,0,Death,,DEATH_TERTIARY,false,true
	CallSecureProtected("BindKeyToAction", 1,26,3,1, 0,0,0,0,0) -- 1,26,3,1,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_TOGGLE_MAIN_RELATED_ITEMS,true,false
	--CallSecureProtected("BindKeyToAction", 15,1,2,4, 0,0,0,0,0) -- 15,1,2,4,0,0,0,0,0,Death,,DEATH_SECONDARY,false,true
	CallSecureProtected("BindKeyToAction", 4,1,3,3, 0,0,0,0,0) -- 4,1,3,3,0,0,0,0,0,Siege,,SIEGE_PACK_UP,true,false
	CallSecureProtected("BindKeyToAction", 1,4,1,1, 120,0,0,0,0) -- 1,4,1,1,120,0,0,0,0,General,Camera,CAMERA_ZOOM_OUT,true,false
	--CallSecureProtected("BindKeyToAction", 15,1,2,1, 49,0,0,0,0) -- 15,1,2,1,49,0,0,0,0,Death,,DEATH_SECONDARY,false,true
	CallSecureProtected("BindKeyToAction", 29,1,8,3, 0,0,0,0,0) -- 29,1,8,3,0,0,0,0,0,Housing Editor Placement Mode,,HOUSING_EDITOR_ROLL_RIGHT,true,false
	CallSecureProtected("BindKeyToAction", 1,6,13,3, 0,0,0,0,0) -- 1,6,13,3,0,0,0,0,0,General,User Interface,TOGGLE_JOURNAL,true,false
	CallSecureProtected("BindKeyToAction", 7,1,1,2, 134,0,0,0,0) -- 7,1,1,2,134,0,0,0,0,Instance Kick Warning,,INSTANCE_KICK_LEAVE_INSTANCE,true,false
	--CallSecureProtected("BindKeyToAction", 15,1,1,3, 0,0,0,0,0) -- 15,1,1,3,0,0,0,0,0,Death,,DEATH_PRIMARY,false,true
	--CallSecureProtected("BindKeyToAction", 15,1,1,2, 133,0,0,0,0) -- 15,1,1,2,133,0,0,0,0,Death,,DEATH_PRIMARY,false,true
	--CallSecureProtected("BindKeyToAction", 9,1,4,1, 26,0,0,0,0) -- 9,1,4,1,26,0,0,0,0,Conversation,,CONVERSATION_OPTION_4,false,true
	--CallSecureProtected("BindKeyToAction", 15,1,1,1, 36,0,0,0,0) -- 15,1,1,1,36,0,0,0,0,Death,,DEATH_PRIMARY,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,11,1, 34,0,0,0,0) -- 2,1,11,1,34,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 4,1,6,4, 0,0,0,0,0) -- 4,1,6,4,0,0,0,0,0,Siege,,,false,true
	CallSecureProtected("BindKeyToAction", 1,6,18,4, 0,0,0,0,0) -- 1,6,18,4,0,0,0,0,0,General,User Interface,TOGGLE_GUILDS,true,false
	CallSecureProtected("BindKeyToAction", 4,2,1,1, 0,0,0,0,0) -- 4,2,1,1,0,0,0,0,0,Siege,Mini Map,VOTANS_TOGGLE_MAP_SHOW_SIEGE_HUD,true,false
	--CallSecureProtected("BindKeyToAction", 13,1,10,3, 0,0,0,0,0) -- 13,1,10,3,0,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_10,false,true
	CallSecureProtected("BindKeyToAction", 1,6,7,3, 0,0,0,0,0) -- 1,6,7,3,0,0,0,0,0,General,User Interface,TOGGLE_GAME_CAMERA_UI_MODE,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,8,2, 0,0,0,0,0) -- 10,1,8,2,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_SKILLS,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,12,2, 0,0,0,0,0) -- 28,1,12,2,0,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 3,1,13,3, 0,0,0,0,0) -- 3,1,13,3,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_RIGHT_SHOULDER,false,true
	--CallSecureProtected("BindKeyToAction", 13,1,9,2, 67,0,0,0,0) -- 13,1,9,2,67,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_9,false,true
	CallSecureProtected("BindKeyToAction", 1,1,6,4, 0,0,0,0,0) -- 1,1,6,4,0,0,0,0,0,General,Movement,MOVE_JUMPASCEND,true,false
	CallSecureProtected("BindKeyToAction", 1,21,13,4, 0,0,0,0,0) -- 1,21,13,4,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_8,true,false
	CallSecureProtected("BindKeyToAction", 1,2,20,1, 134,0,0,0,0) -- 1,2,20,1,134,0,0,0,0,General,Combat,GAMEPAD_ACTION_BUTTON_5,true,true
	--CallSecureProtected("BindKeyToAction", 13,1,8,4, 0,0,0,0,0) -- 13,1,8,4,0,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_8,false,true
	CallSecureProtected("BindKeyToAction", 3,1,5,4, 0,0,0,0,0) -- 3,1,5,4,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_NEGATIVE,true,false
	--CallSecureProtected("BindKeyToAction", 13,1,8,3, 0,0,0,0,0) -- 13,1,8,3,0,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_8,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,23,1, 57,0,0,0,0) -- 28,1,23,1,57,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 13,1,7,3, 0,0,0,0,0) -- 13,1,7,3,0,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_7,false,true
	CallSecureProtected("BindKeyToAction", 1,18,4,3, 0,0,0,0,0) -- 1,18,4,3,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMAFAVRADMENU,true,false
	CallSecureProtected("BindKeyToAction", 1,5,3,4, 0,0,0,0,0) -- 1,5,3,4,0,0,0,0,0,General,Interaction,TEAMFORMATION,true,false
	CallSecureProtected("BindKeyToAction", 1,1,6,3, 0,0,0,0,0) -- 1,1,6,3,0,0,0,0,0,General,Movement,MOVE_JUMPASCEND,true,false
	--CallSecureProtected("BindKeyToAction", 13,1,7,1, 29,0,0,0,0) -- 13,1,7,1,29,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_7,false,true
	CallSecureProtected("BindKeyToAction", 1,20,1,2, 0,0,0,0,0) -- 1,20,1,2,0,0,0,0,0,General,|c3366FFBank|r Manager |c990000Revived|r,BMR_PROFILE1,true,false
	--CallSecureProtected("BindKeyToAction", 3,1,19,4, 0,0,0,0,0) -- 3,1,19,4,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_LEFT_STICK,false,true
	CallSecureProtected("BindKeyToAction", 24,1,2,1, 37,0,0,0,0) -- 24,1,2,1,37,0,0,0,0,Battlegrounds,,LEAVE_BATTLEGROUND_DUMMY,true,false
	CallSecureProtected("BindKeyToAction", 1,15,2,1, 110,0,0,0,0) -- 1,15,2,1,110,0,0,0,0,General,Vacuum Shop,VACUUM_LEFT,true,false
	CallSecureProtected("BindKeyToAction", 28,1,33,2, 138,0,0,0,0) -- 28,1,33,2,138,0,0,0,0,Housing Editor,,HOUSING_EDITOR_QUATERNARY_ACTION,true,false
	CallSecureProtected("BindKeyToAction", 1,21,19,3, 0,0,0,0,0) -- 1,21,19,3,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_14,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,7,2, 0,0,0,0,0) -- 2,1,7,2,0,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 9,1,10,2, 58,0,0,0,0) -- 9,1,10,2,58,0,0,0,0,Conversation,,CONVERSATION_OPTION_10,false,true
	CallSecureProtected("BindKeyToAction", 1,6,27,4, 0,0,0,0,0) -- 1,6,27,4,0,0,0,0,0,General,User Interface,TOGGLE_FIRST_PERSON,true,false
	--CallSecureProtected("BindKeyToAction", 13,1,5,4, 0,0,0,0,0) -- 13,1,5,4,0,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_5,false,true
	CallSecureProtected("BindKeyToAction", 1,6,29,1, 0,0,0,0,0) -- 1,6,29,1,0,0,0,0,0,General,User Interface,TOGGLE_GAMEPAD_MODE,true,false
	--CallSecureProtected("BindKeyToAction", 9,1,8,3, 0,0,0,0,0) -- 9,1,8,3,0,0,0,0,0,Conversation,,CONVERSATION_OPTION_8,false,true
	--CallSecureProtected("BindKeyToAction", 13,1,5,2, 63,0,0,0,0) -- 13,1,5,2,63,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_5,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,22,1, 0,0,0,0,0) -- 2,1,22,1,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,6,1,1, 3,5,0,0,0) -- 1,6,1,1,3,5,0,0,0,General,User Interface,TOGGLE_FULLSCREEN,true,false
	--CallSecureProtected("BindKeyToAction", 3,1,14,2, 0,0,0,0,0) -- 3,1,14,2,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_LEFT_SHOULDER,false,true
	CallSecureProtected("BindKeyToAction", 23,1,1,1, 79,0,0,0,0) -- 23,1,1,1,79,0,0,0,0,Housing HUD,,SHOW_HOUSING_PANEL,true,false
	--CallSecureProtected("BindKeyToAction", 3,1,10,4, 0,0,0,0,0) -- 3,1,10,4,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_EXIT,false,true
	CallSecureProtected("BindKeyToAction", 1,21,5,4, 0,0,0,0,0) -- 1,21,5,4,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_TOGGLE_SET,true,false
	CallSecureProtected("BindKeyToAction", 1,2,10,1, 23,0,0,0,0) -- 1,2,10,1,23,0,0,0,0,General,Combat,ACTION_BUTTON_3,true,false
	--CallSecureProtected("BindKeyToAction", 13,1,3,3, 0,0,0,0,0) -- 13,1,3,3,0,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_3,false,true
	CallSecureProtected("BindKeyToAction", 1,18,11,4, 0,0,0,0,0) -- 1,18,11,4,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMAINVTTOGGLE,true,false
	--CallSecureProtected("BindKeyToAction", 9,1,3,4, 0,0,0,0,0) -- 9,1,3,4,0,0,0,0,0,Conversation,,CONVERSATION_OPTION_3,false,true
	CallSecureProtected("BindKeyToAction", 1,21,1,1, 43,0,0,0,0) -- 1,21,1,1,43,0,0,0,0,General,|cFFAA33AlphaGear|r,SHOW_AG_WINDOW,true,false
	--CallSecureProtected("BindKeyToAction", 13,1,3,2, 61,0,0,0,0) -- 13,1,3,2,61,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_3,false,true
	CallSecureProtected("BindKeyToAction", 1,11,8,3, 0,0,0,0,0) -- 1,11,8,3,0,0,0,0,0,General,CombatMetrics,CMX_LIVEREPORT_TOGGLE,true,false
	CallSecureProtected("BindKeyToAction", 1,2,18,3, 0,0,0,0,0) -- 1,2,18,3,0,0,0,0,0,General,Combat,GAMEPAD_ACTION_BUTTON_3,true,true
	--CallSecureProtected("BindKeyToAction", 19,1,1,4, 0,0,0,0,0) -- 19,1,1,4,0,0,0,0,0,KeybindWindow,,KEYBINDS_LOAD_KEYBOARD_DEFAULTS,false,true
	--CallSecureProtected("BindKeyToAction", 13,1,2,3, 0,0,0,0,0) -- 13,1,2,3,0,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_2,false,true
	--CallSecureProtected("BindKeyToAction", 10,1,13,4, 0,0,0,0,0) -- 10,1,13,4,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_GROUP,false,true
	--CallSecureProtected("BindKeyToAction", 13,1,2,2, 60,0,0,0,0) -- 13,1,2,2,60,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_2,false,true
	CallSecureProtected("BindKeyToAction", 1,7,3,2, 0,0,0,0,0) -- 1,7,3,2,0,0,0,0,0,General,Mini Map,VOTANS_TOGGLE_MAP_SHOW_COMBAT,true,false
	--CallSecureProtected("BindKeyToAction", 4,2,5,2, 0,0,0,0,0) -- 4,2,5,2,0,0,0,0,0,Siege,Mini Map,VOTANS_TOGGLE_MAP_ZOOM_MINUS_SIEGE,false,true
	--CallSecureProtected("BindKeyToAction", 3,1,11,1, 138,0,0,0,0) -- 3,1,11,1,138,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_RIGHT_TRIGGER,false,true
	--CallSecureProtected("BindKeyToAction", 10,1,21,2, 0,0,0,0,0) -- 10,1,21,2,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_HELP,false,true
	--CallSecureProtected("BindKeyToAction", 3,1,10,3, 128,0,0,0,0) -- 3,1,10,3,128,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_EXIT,false,true
	--CallSecureProtected("BindKeyToAction", 13,1,1,2, 59,0,0,0,0) -- 13,1,1,2,59,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_1,false,true
	CallSecureProtected("BindKeyToAction", 1,18,13,1, 0,0,0,0,0) -- 1,18,13,1,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMACRAFTTOGGLE,true,false
	CallSecureProtected("BindKeyToAction", 1,24,1,3, 0,0,0,0,0) -- 1,24,1,3,0,0,0,0,0,General,CraftStore,SHOW_CRAFTSTOREFIXED_WINDOW,true,false
	CallSecureProtected("BindKeyToAction", 1,25,6,1, 0,0,0,0,0) -- 1,25,6,1,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_5,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,16,1, 0,0,0,0,0) -- 10,1,16,1,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_ALLIANCE_WAR,false,true
	CallSecureProtected("BindKeyToAction", 1,18,4,4, 0,0,0,0,0) -- 1,18,4,4,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMAFAVRADMENU,true,false
	CallSecureProtected("BindKeyToAction", 28,1,29,4, 0,0,0,0,0) -- 28,1,29,4,0,0,0,0,0,Housing Editor,,HOUSING_EDITOR_PRIMARY_ACTION,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,20,2, 0,0,0,0,0) -- 10,1,20,2,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_CROWN_CRATES,false,true
	CallSecureProtected("BindKeyToAction", 1,20,6,2, 0,0,0,0,0) -- 1,20,6,2,0,0,0,0,0,General,|c3366FFBank|r Manager |c990000Revived|r,BMR_PROFILE6,true,false
	--CallSecureProtected("BindKeyToAction", 3,1,15,2, 141,0,0,0,0) -- 3,1,15,2,141,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_INPUT_LEFT,false,true
	--CallSecureProtected("BindKeyToAction", 12,1,5,2, 63,0,0,0,0) -- 12,1,5,2,63,0,0,0,0,Guild,,GUILD_5,false,true
	--CallSecureProtected("BindKeyToAction", 11,1,5,4, 0,0,0,0,0) -- 11,1,5,4,0,0,0,0,0,PreviewInterceptLayer,,INTERCEPT_SPECIAL_WEAPON_SWAP_TO_SET_1,false,true
	CallSecureProtected("BindKeyToAction", 1,20,4,1, 0,0,0,0,0) -- 1,20,4,1,0,0,0,0,0,General,|c3366FFBank|r Manager |c990000Revived|r,BMR_PROFILE4,true,false
	--CallSecureProtected("BindKeyToAction", 12,1,5,1, 27,0,0,0,0) -- 12,1,5,1,27,0,0,0,0,Guild,,GUILD_5,false,true
	CallSecureProtected("BindKeyToAction", 1,11,7,2, 0,0,0,0,0) -- 1,11,7,2,0,0,0,0,0,General,CombatMetrics,CMX_RESET_FIGHT,true,false
	CallSecureProtected("BindKeyToAction", 28,1,34,4, 0,0,0,0,0) -- 28,1,34,4,0,0,0,0,0,Housing Editor,,HOUSING_EDITOR_QUINARY_ACTION,true,false
	CallSecureProtected("BindKeyToAction", 29,1,11,1, 115,0,0,0,0) -- 29,1,11,1,115,0,0,0,0,Housing Editor Placement Mode,,HOUSING_EDITOR_ALIGN_TO_SURFACE,true,false
	CallSecureProtected("BindKeyToAction", 3,1,6,3, 0,0,0,0,0) -- 3,1,6,3,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_REPORT_PLAYER,true,false
	--CallSecureProtected("BindKeyToAction", 12,1,3,2, 61,0,0,0,0) -- 12,1,3,2,61,0,0,0,0,Guild,,GUILD_3,false,true
	--CallSecureProtected("BindKeyToAction", 12,1,1,2, 59,0,0,0,0) -- 12,1,1,2,59,0,0,0,0,Guild,,GUILD_1,false,true
	--CallSecureProtected("BindKeyToAction", 11,1,6,3, 0,0,0,0,0) -- 11,1,6,3,0,0,0,0,0,PreviewInterceptLayer,,INTERCEPT_SPECIAL_WEAPON_SWAP_TO_SET_2,false,true
	CallSecureProtected("BindKeyToAction", 1,18,22,3, 0,0,0,0,0) -- 1,18,22,3,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMARGLASHR,true,false
	--CallSecureProtected("BindKeyToAction", 11,1,6,2, 0,0,0,0,0) -- 11,1,6,2,0,0,0,0,0,PreviewInterceptLayer,,INTERCEPT_SPECIAL_WEAPON_SWAP_TO_SET_2,false,true
	--CallSecureProtected("BindKeyToAction", 11,1,5,3, 0,0,0,0,0) -- 11,1,5,3,0,0,0,0,0,PreviewInterceptLayer,,INTERCEPT_SPECIAL_WEAPON_SWAP_TO_SET_1,false,true
	--CallSecureProtected("BindKeyToAction", 3,1,18,2, 140,0,0,0,0) -- 3,1,18,2,140,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_INPUT_DOWN,false,true
	CallSecureProtected("BindKeyToAction", 1,25,11,3, 0,0,0,0,0) -- 1,25,11,3,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_10,true,false
	CallSecureProtected("BindKeyToAction", 1,18,24,3, 0,0,0,0,0) -- 1,18,24,3,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMALFGPMODE,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,9,4, 0,0,0,0,0) -- 2,1,9,4,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,23,1,1, 0,0,0,0,0) -- 1,23,1,1,0,0,0,0,0,General,Mail Looter,MAILLOOTER_OPEN,true,false
	CallSecureProtected("BindKeyToAction", 1,2,10,2, 0,0,0,0,0) -- 1,2,10,2,0,0,0,0,0,General,Combat,ACTION_BUTTON_3,true,false
	CallSecureProtected("BindKeyToAction", 1,7,1,3, 0,0,0,0,0) -- 1,7,1,3,0,0,0,0,0,General,Mini Map,VOTANS_TOGGLE_MAP_SHOW,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,15,3, 0,0,0,0,0) -- 2,1,15,3,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,18,17,1, 0,0,0,0,0) -- 1,18,17,1,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMACYRODIILTOGGLE,true,false
	--CallSecureProtected("BindKeyToAction", 4,2,2,2, 0,0,0,0,0) -- 4,2,2,2,0,0,0,0,0,Siege,Mini Map,VOTANS_TOGGLE_MAP_ZOOM_OUT_SIEGE,false,true
	--CallSecureProtected("BindKeyToAction", 11,1,4,3, 125,0,0,0,0) -- 11,1,4,3,125,0,0,0,0,PreviewInterceptLayer,,INTERCEPT_SPECIAL_WEAPON_SWAP,false,true
	--CallSecureProtected("BindKeyToAction", 11,1,4,2, 118,0,0,0,0) -- 11,1,4,2,118,0,0,0,0,PreviewInterceptLayer,,INTERCEPT_SPECIAL_WEAPON_SWAP,false,true
	--CallSecureProtected("BindKeyToAction", 11,1,3,4, 0,0,0,0,0) -- 11,1,3,4,0,0,0,0,0,PreviewInterceptLayer,,INTERCEPT_SPECIAL_MOVE_CROUCH,false,true
	CallSecureProtected("BindKeyToAction", 1,21,15,2, 0,0,0,0,0) -- 1,21,15,2,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_10,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,23,2, 0,0,0,0,0) -- 28,1,23,2,0,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,26,4, 0,0,0,0,0) -- 2,1,26,4,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,21,4,4, 0,0,0,0,0) -- 1,21,4,4,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_PREVIOUS_SET,true,false
	CallSecureProtected("BindKeyToAction", 1,26,3,2, 0,0,0,0,0) -- 1,26,3,2,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_TOGGLE_MAIN_RELATED_ITEMS,true,false
	--CallSecureProtected("BindKeyToAction", 11,1,2,2, 116,0,0,0,0) -- 11,1,2,2,116,0,0,0,0,PreviewInterceptLayer,,INTERCEPT_AUTORUN,false,true
	--CallSecureProtected("BindKeyToAction", 11,1,2,1, 51,0,0,0,0) -- 11,1,2,1,51,0,0,0,0,PreviewInterceptLayer,,INTERCEPT_AUTORUN,false,true
	CallSecureProtected("BindKeyToAction", 1,6,33,4, 0,0,0,0,0) -- 1,6,33,4,0,0,0,0,0,General,User Interface,RETICLE_BRIGHTNESS_DECREASE,true,false
	CallSecureProtected("BindKeyToAction", 3,2,1,2, 0,0,0,0,0) -- 3,2,1,2,0,0,0,0,0,User Interface Shortcuts,Dolgubon's Lazy Writ Crafter,WRIT_CRAFTER_CRAFT_ITEMS,true,false
	CallSecureProtected("BindKeyToAction", 1,13,1,3, 0,0,0,0,0) -- 1,13,1,3,0,0,0,0,0,General,|c4B8BFETimer,IP_TIMER_START,true,false
	CallSecureProtected("BindKeyToAction", 1,1,1,1, 54,0,0,0,0) -- 1,1,1,1,54,0,0,0,0,General,Movement,MOVE_FORWARD,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,1,1, 54,0,0,0,0) -- 28,1,1,1,54,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 11,1,1,1, 0,0,0,0,0) -- 11,1,1,1,0,0,0,0,0,PreviewInterceptLayer,,INTERCEPT_SHEATHE_WEAPON_TOGGLE,false,true
	--CallSecureProtected("BindKeyToAction", 10,1,21,4, 0,0,0,0,0) -- 10,1,21,4,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_HELP,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,25,4, 0,0,0,0,0) -- 28,1,25,4,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,9,1,1, 49,7,0,0,0) -- 1,9,1,1,49,7,0,0,0,General,|cFF6A00Mass Deconstructor|r,MD_DECONSTRUCTOR_DECON_ALL,true,false
	--CallSecureProtected("BindKeyToAction", 4,1,10,1, 108,0,0,0,0) -- 4,1,10,1,108,0,0,0,0,Siege,,,false,true
	CallSecureProtected("BindKeyToAction", 6,1,2,3, 0,0,0,0,0) -- 6,1,2,3,0,0,0,0,0,Notifications,,PLAYER_TO_PLAYER_INTERACT_DECLINE,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,21,1, 75,0,0,0,0) -- 10,1,21,1,75,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_HELP,false,true
	CallSecureProtected("BindKeyToAction", 1,25,1,3, 0,0,0,0,0) -- 1,25,1,3,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_OPEN,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,20,4, 0,0,0,0,0) -- 10,1,20,4,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_CROWN_CRATES,false,true
	--CallSecureProtected("BindKeyToAction", 10,1,20,3, 0,0,0,0,0) -- 10,1,20,3,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_CROWN_CRATES,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,20,2, 0,0,0,0,0) -- 28,1,20,2,0,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 10,1,19,4, 0,0,0,0,0) -- 10,1,19,4,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_ACTIVITY_FINDER,false,true
	--CallSecureProtected("BindKeyToAction", 10,1,9,1, 100,0,0,0,0) -- 10,1,9,1,100,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_CHAMPION,false,true
	CallSecureProtected("BindKeyToAction", 1,21,17,4, 0,0,0,0,0) -- 1,21,17,4,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_12,true,false
	CallSecureProtected("BindKeyToAction", 1,30,1,3, 0,0,0,0,0) -- 1,30,1,3,0,0,0,0,0,General,WritWorthy,WritWorthyUI_ToggleUI,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,19,3, 0,0,0,0,0) -- 10,1,19,3,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_ACTIVITY_FINDER,false,true
	CallSecureProtected("BindKeyToAction", 1,2,18,2, 0,0,0,0,0) -- 1,2,18,2,0,0,0,0,0,General,Combat,GAMEPAD_ACTION_BUTTON_3,true,true
	CallSecureProtected("BindKeyToAction", 1,21,5,3, 0,0,0,0,0) -- 1,21,5,3,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_TOGGLE_SET,true,false
	CallSecureProtected("BindKeyToAction", 1,20,5,4, 0,0,0,0,0) -- 1,20,5,4,0,0,0,0,0,General,|c3366FFBank|r Manager |c990000Revived|r,BMR_PROFILE5,true,false
	CallSecureProtected("BindKeyToAction", 1,3,2,2, 0,0,0,0,0) -- 1,3,2,2,0,0,0,0,0,General,Targeting,CLEAR_PREFERRED_ENEMY_TARGET,true,false
	CallSecureProtected("BindKeyToAction", 1,21,9,1, 26,7,0,0,0) -- 1,21,9,1,26,7,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_4,true,false
	CallSecureProtected("BindKeyToAction", 1,21,21,1, 0,0,0,0,0) -- 1,21,21,1,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_16,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,22,4, 0,0,0,0,0) -- 28,1,22,4,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 4,1,3,1, 55,0,0,0,0) -- 4,1,3,1,55,0,0,0,0,Siege,,SIEGE_PACK_UP,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,19,1, 0,0,0,0,0) -- 10,1,19,1,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_ACTIVITY_FINDER,false,true
	--CallSecureProtected("BindKeyToAction", 10,1,18,4, 0,0,0,0,0) -- 10,1,18,4,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_NOTIFICATIONS,false,true
	CallSecureProtected("BindKeyToAction", 1,26,14,2, 0,0,0,0,0) -- 1,26,14,2,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_ZONE_4,true,false
	--CallSecureProtected("BindKeyToAction", 12,1,5,3, 0,0,0,0,0) -- 12,1,5,3,0,0,0,0,0,Guild,,GUILD_5,false,true
	CallSecureProtected("BindKeyToAction", 1,17,1,4, 0,0,0,0,0) -- 1,17,1,4,0,0,0,0,0,General,Rapid Fire,RF_FIRING,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,18,2, 0,0,0,0,0) -- 10,1,18,2,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_NOTIFICATIONS,false,true
	CallSecureProtected("BindKeyToAction", 1,18,8,1, 0,0,0,0,0) -- 1,18,8,1,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMACHARTOGGLE,true,false
	CallSecureProtected("BindKeyToAction", 1,11,8,4, 0,0,0,0,0) -- 1,11,8,4,0,0,0,0,0,General,CombatMetrics,CMX_LIVEREPORT_TOGGLE,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,18,1, 0,0,0,0,0) -- 10,1,18,1,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_NOTIFICATIONS,false,true
	--CallSecureProtected("BindKeyToAction", 4,2,3,2, 0,0,0,0,0) -- 4,2,3,2,0,0,0,0,0,Siege,Mini Map,VOTANS_TOGGLE_MAP_ZOOM_IN_SIEGE,false,true
	CallSecureProtected("BindKeyToAction", 1,15,4,1, 113,0,0,0,0) -- 1,15,4,1,113,0,0,0,0,General,Vacuum Shop,VACUUM_DOWN,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,16,4, 0,0,0,0,0) -- 10,1,16,4,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_ALLIANCE_WAR,false,true
	--CallSecureProtected("BindKeyToAction", 3,1,15,3, 0,0,0,0,0) -- 3,1,15,3,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_INPUT_LEFT,false,true
	CallSecureProtected("BindKeyToAction", 1,21,11,2, 0,0,0,0,0) -- 1,21,11,2,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_6,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,16,3, 0,0,0,0,0) -- 10,1,16,3,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_ALLIANCE_WAR,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,22,2, 0,0,0,0,0) -- 28,1,22,2,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,1,6,1, 13,0,0,0,0) -- 1,1,6,1,13,0,0,0,0,General,Movement,MOVE_JUMPASCEND,true,false
	CallSecureProtected("BindKeyToAction", 1,7,7,3, 0,0,0,0,0) -- 1,7,7,3,0,0,0,0,0,General,Mini Map,VOTANS_TOGGLE_MAP_ZOOM_MINUS,true,false
	CallSecureProtected("BindKeyToAction", 1,18,21,2, 0,0,0,0,0) -- 1,18,21,2,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMARGLAPST,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,15,2, 0,0,0,0,0) -- 10,1,15,2,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_GUILDS,false,true
	CallSecureProtected("BindKeyToAction", 1,20,9,2, 0,0,0,0,0) -- 1,20,9,2,0,0,0,0,0,General,|c3366FFBank|r Manager |c990000Revived|r,BMR_PROFILE9,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,15,1, 38,0,0,0,0) -- 10,1,15,1,38,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_GUILDS,false,true
	CallSecureProtected("BindKeyToAction", 1,6,29,4, 0,0,0,0,0) -- 1,6,29,4,0,0,0,0,0,General,User Interface,TOGGLE_GAMEPAD_MODE,true,false
	CallSecureProtected("BindKeyToAction", 3,1,7,2, 176,0,0,0,0) -- 3,1,7,2,176,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_QUICK_SLOTS,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,14,2, 0,0,0,0,0) -- 10,1,14,2,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_CONTACTS,false,true
	--CallSecureProtected("BindKeyToAction", 10,1,14,1, 46,0,0,0,0) -- 10,1,14,1,46,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_CONTACTS,false,true
	--CallSecureProtected("BindKeyToAction", 3,1,12,2, 0,0,0,0,0) -- 3,1,12,2,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_LEFT_TRIGGER,false,true
	--CallSecureProtected("BindKeyToAction", 10,1,13,2, 0,0,0,0,0) -- 10,1,13,2,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_GROUP,false,true
	--CallSecureProtected("BindKeyToAction", 10,1,13,1, 47,0,0,0,0) -- 10,1,13,1,47,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_GROUP,false,true
	CallSecureProtected("BindKeyToAction", 1,6,26,2, 126,0,0,0,0) -- 1,6,26,2,126,0,0,0,0,General,User Interface,ASSIST_NEXT_TRACKED_QUEST,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,6,1, 40,0,0,0,0) -- 10,1,6,1,40,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_INVENTORY,false,true
	CallSecureProtected("BindKeyToAction", 1,2,1,2, 138,0,0,0,0) -- 1,2,1,2,138,0,0,0,0,General,Combat,SPECIAL_MOVE_ATTACK,true,false
	CallSecureProtected("BindKeyToAction", 1,21,10,1, 27,7,0,0,0) -- 1,21,10,1,27,7,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_5,true,false
	CallSecureProtected("BindKeyToAction", 1,27,1,2, 0,0,0,0,0) -- 1,27,1,2,0,0,0,0,0,General,Mementos,HOLIDAY_MEMENTO,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,12,3, 0,0,0,0,0) -- 10,1,12,3,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_MAP,false,true
	--CallSecureProtected("BindKeyToAction", 10,1,11,3, 0,0,0,0,0) -- 10,1,11,3,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_COLLECTIONS_BOOK,false,true
	--CallSecureProtected("BindKeyToAction", 10,1,11,1, 52,0,0,0,0) -- 10,1,11,1,52,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_COLLECTIONS_BOOK,false,true
	--CallSecureProtected("BindKeyToAction", 10,1,10,4, 0,0,0,0,0) -- 10,1,10,4,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_JOURNAL,false,true
	CallSecureProtected("BindKeyToAction", 1,2,16,2, 0,0,0,0,0) -- 1,2,16,2,0,0,0,0,0,General,Combat,GAMEPAD_SPECIAL_MOVE_SPRINT,true,true
	--CallSecureProtected("BindKeyToAction", 28,1,21,3, 0,0,0,0,0) -- 28,1,21,3,0,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 10,1,10,1, 41,0,0,0,0) -- 10,1,10,1,41,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_JOURNAL,false,true
	CallSecureProtected("BindKeyToAction", 3,1,9,3, 0,0,0,0,0) -- 3,1,9,3,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_STACK_ALL,true,false
	CallSecureProtected("BindKeyToAction", 1,18,19,1, 0,0,0,0,0) -- 1,18,19,1,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMARGLASRT,true,false
	CallSecureProtected("BindKeyToAction", 1,6,32,2, 0,0,0,0,0) -- 1,6,32,2,0,0,0,0,0,General,User Interface,RETICLE_BRIGHTNESS_INCREASE,true,false
	CallSecureProtected("BindKeyToAction", 1,13,2,4, 0,0,0,0,0) -- 1,13,2,4,0,0,0,0,0,General,|c4B8BFETimer,IP_TIMER_STOP,true,false
	CallSecureProtected("BindKeyToAction", 1,21,11,1, 0,0,0,0,0) -- 1,21,11,1,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_6,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,9,3, 0,0,0,0,0) -- 10,1,9,3,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_CHAMPION,false,true
	CallSecureProtected("BindKeyToAction", 1,12,4,3, 0,0,0,0,0) -- 1,12,4,3,0,0,0,0,0,General,Foundry Tactical Combat,REFRESH_FRAMES,true,false
	CallSecureProtected("BindKeyToAction", 1,21,10,2, 0,0,0,0,0) -- 1,21,10,2,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_5,true,false
	CallSecureProtected("BindKeyToAction", 1,25,1,4, 0,0,0,0,0) -- 1,25,1,4,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_OPEN,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,2,2, 134,0,0,0,0) -- 10,1,2,2,134,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_UI_SHORTCUT_NEGATIVE,false,true
	CallSecureProtected("BindKeyToAction", 1,2,8,1, 0,0,0,0,0) -- 1,2,8,1,0,0,0,0,0,General,Combat,SPECIAL_MOVE_WEAPON_SWAP_TO_SET_1,true,false
	CallSecureProtected("BindKeyToAction", 1,26,2,1, 41,7,0,0,0) -- 1,26,2,1,41,7,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_TOGGLE_MAIN_ACTIVE_QUESTS,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,8,4, 0,0,0,0,0) -- 10,1,8,4,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_SKILLS,false,true
	--CallSecureProtected("BindKeyToAction", 9,1,7,1, 29,0,0,0,0) -- 9,1,7,1,29,0,0,0,0,Conversation,,CONVERSATION_OPTION_7,false,true
	CallSecureProtected("BindKeyToAction", 1,3,1,1, 2,0,0,0,0) -- 1,3,1,1,2,0,0,0,0,General,Targeting,CYCLE_PREFERRED_ENEMY_TARGET,true,false
	CallSecureProtected("BindKeyToAction", 1,6,23,3, 0,0,0,0,0) -- 1,6,23,3,0,0,0,0,0,General,User Interface,TOGGLE_CROWN_CRATES,true,false
	CallSecureProtected("BindKeyToAction", 1,17,1,3, 0,0,0,0,0) -- 1,17,1,3,0,0,0,0,0,General,Rapid Fire,RF_FIRING,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,8,1, 42,0,0,0,0) -- 10,1,8,1,42,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_SKILLS,false,true
	CallSecureProtected("BindKeyToAction", 1,5,3,3, 0,0,0,0,0) -- 1,5,3,3,0,0,0,0,0,General,Interaction,TEAMFORMATION,true,false
	--CallSecureProtected("BindKeyToAction", 33,1,1,3, 0,0,0,0,0) -- 33,1,1,3,0,0,0,0,0,PathNodeRotationBlockCrouchLayer,,,false,true
	--CallSecureProtected("BindKeyToAction", 10,1,7,1, 34,0,0,0,0) -- 10,1,7,1,34,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_CHARACTER,false,true
	CallSecureProtected("BindKeyToAction", 6,1,2,2, 134,0,0,0,0) -- 6,1,2,2,134,0,0,0,0,Notifications,,PLAYER_TO_PLAYER_INTERACT_DECLINE,true,false
	CallSecureProtected("BindKeyToAction", 1,18,14,4, 0,0,0,0,0) -- 1,18,14,4,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMATRIALTOGGLE,true,false
	--CallSecureProtected("BindKeyToAction", 4,1,11,3, 0,0,0,0,0) -- 4,1,11,3,0,0,0,0,0,Siege,,,false,true
	CallSecureProtected("BindKeyToAction", 1,6,12,1, 100,0,0,0,0) -- 1,6,12,1,100,0,0,0,0,General,User Interface,TOGGLE_CHAMPION,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,6,3, 0,0,0,0,0) -- 10,1,6,3,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_INVENTORY,false,true
	CallSecureProtected("BindKeyToAction", 1,1,5,1, 35,0,0,0,0) -- 1,1,5,1,35,0,0,0,0,General,Movement,TURN_RIGHT,true,false
	CallSecureProtected("BindKeyToAction", 1,23,2,4, 0,0,0,0,0) -- 1,23,2,4,0,0,0,0,0,General,Mail Looter,MAILLOOTER_QUICK_LOOT_ALL,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,23,3, 0,0,0,0,0) -- 2,1,23,3,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,6,5,4, 0,0,0,0,0) -- 1,6,5,4,0,0,0,0,0,General,User Interface,CHAT_REPLY_TO_LAST_WHISPER,true,false
	CallSecureProtected("BindKeyToAction", 1,2,14,3, 0,0,0,0,0) -- 1,2,14,3,0,0,0,0,0,General,Combat,ACTION_BUTTON_7,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,5,2, 0,0,0,0,0) -- 10,1,5,2,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_MARKET,false,true
	CallSecureProtected("BindKeyToAction", 1,19,1,3, 0,0,0,0,0) -- 1,19,1,3,0,0,0,0,0,General,Dustman,DUSTMAN_JUNK,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,4,4, 0,0,0,0,0) -- 10,1,4,4,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_GAME_CAMERA_UI_MODE,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,2,4, 0,0,0,0,0) -- 28,1,2,4,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,18,22,2, 0,0,0,0,0) -- 1,18,22,2,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMARGLASHR,true,false
	--CallSecureProtected("BindKeyToAction", 8,1,1,4, 0,0,0,0,0) -- 8,1,1,4,0,0,0,0,0,MouseUIMode,,LEFT_MOUSE_IN_WORLD,false,true
	--CallSecureProtected("BindKeyToAction", 10,1,15,3, 0,0,0,0,0) -- 10,1,15,3,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_GUILDS,false,true
	CallSecureProtected("BindKeyToAction", 1,1,10,3, 0,0,0,0,0) -- 1,1,10,3,0,0,0,0,0,General,Movement,GAMEPAD_JUMP_OR_INTERACT,true,true
	CallSecureProtected("BindKeyToAction", 1,6,27,3, 0,0,0,0,0) -- 1,6,27,3,0,0,0,0,0,General,User Interface,TOGGLE_FIRST_PERSON,true,false
	CallSecureProtected("BindKeyToAction", 1,11,7,3, 0,0,0,0,0) -- 1,11,7,3,0,0,0,0,0,General,CombatMetrics,CMX_RESET_FIGHT,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,3,2, 0,0,0,0,0) -- 10,1,3,2,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_SYSTEM,false,true
	CallSecureProtected("BindKeyToAction", 1,6,16,1, 47,0,0,0,0) -- 1,6,16,1,47,0,0,0,0,General,User Interface,TOGGLE_GROUP,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,3,1, 12,0,0,0,0) -- 10,1,3,1,12,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_SYSTEM,false,true
	CallSecureProtected("BindKeyToAction", 1,6,17,4, 0,0,0,0,0) -- 1,6,17,4,0,0,0,0,0,General,User Interface,TOGGLE_CONTACTS,true,false
	CallSecureProtected("BindKeyToAction", 1,6,9,2, 0,0,0,0,0) -- 1,6,9,2,0,0,0,0,0,General,User Interface,TOGGLE_INVENTORY,true,false
	CallSecureProtected("BindKeyToAction", 1,25,3,1, 0,0,0,0,0) -- 1,25,3,1,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_2,true,false
	CallSecureProtected("BindKeyToAction", 1,15,3,1, 112,0,0,0,0) -- 1,15,3,1,112,0,0,0,0,General,Vacuum Shop,VACUUM_UP,true,false
	--CallSecureProtected("BindKeyToAction", 15,1,6,2, 127,0,0,0,0) -- 15,1,6,2,127,0,0,0,0,Death,,DEATH_RECAP_HIDE,false,true
	--CallSecureProtected("BindKeyToAction", 17,1,4,2, 165,0,0,0,0) -- 17,1,4,2,165,0,0,0,0,GamepadChatSystem,,,false,true
	--CallSecureProtected("BindKeyToAction", 8,1,3,4, 0,0,0,0,0) -- 8,1,3,4,0,0,0,0,0,MouseUIMode,,RIGHT_MOUSE_IN_WORLD,false,true
	--CallSecureProtected("BindKeyToAction", 29,1,1,2, 0,0,0,0,0) -- 29,1,1,2,0,0,0,0,0,Housing Editor Placement Mode,,,false,true
	--CallSecureProtected("BindKeyToAction", 9,1,11,2, 133,0,0,0,0) -- 9,1,11,2,133,0,0,0,0,Conversation,,CONVERSATION_OPTION_PRIMARY,false,true
	CallSecureProtected("BindKeyToAction", 1,21,5,2, 0,0,0,0,0) -- 1,21,5,2,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_TOGGLE_SET,true,false
	--CallSecureProtected("BindKeyToAction", 26,1,3,4, 0,0,0,0,0) -- 26,1,3,4,0,0,0,0,0,BattlegroundScoreboard,,BATTLEGROUND_SCOREBOARD_PREVIOUS,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,10,1, 40,0,0,0,0) -- 2,1,10,1,40,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,18,9,4, 0,0,0,0,0) -- 1,18,9,4,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMACLNDTOGGLE,true,false
	--CallSecureProtected("BindKeyToAction", 9,1,10,3, 0,0,0,0,0) -- 9,1,10,3,0,0,0,0,0,Conversation,,CONVERSATION_OPTION_10,false,true
	--CallSecureProtected("BindKeyToAction", 9,1,10,1, 22,0,0,0,0) -- 9,1,10,1,22,0,0,0,0,Conversation,,CONVERSATION_OPTION_10,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,7,3, 0,0,0,0,0) -- 2,1,7,3,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,6,3,2, 165,0,0,0,0) -- 1,6,3,2,165,0,0,0,0,General,User Interface,START_CHAT_ENTER,true,false
	CallSecureProtected("BindKeyToAction", 1,21,15,3, 0,0,0,0,0) -- 1,21,15,3,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_10,true,false
	--CallSecureProtected("BindKeyToAction", 9,1,9,1, 31,0,0,0,0) -- 9,1,9,1,31,0,0,0,0,Conversation,,CONVERSATION_OPTION_9,false,true
	--CallSecureProtected("BindKeyToAction", 9,1,8,4, 0,0,0,0,0) -- 9,1,8,4,0,0,0,0,0,Conversation,,CONVERSATION_OPTION_8,false,true
	--CallSecureProtected("BindKeyToAction", 13,1,5,3, 0,0,0,0,0) -- 13,1,5,3,0,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_5,false,true
	CallSecureProtected("BindKeyToAction", 1,6,34,2, 0,0,0,0,0) -- 1,6,34,2,0,0,0,0,0,General,User Interface,POTIONMAKER,true,false
	CallSecureProtected("BindKeyToAction", 1,20,1,3, 0,0,0,0,0) -- 1,20,1,3,0,0,0,0,0,General,|c3366FFBank|r Manager |c990000Revived|r,BMR_PROFILE1,true,false
	CallSecureProtected("BindKeyToAction", 1,26,6,2, 0,0,0,0,0) -- 1,26,6,2,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_WAYSHRINE_UNLOCK,true,false
	CallSecureProtected("BindKeyToAction", 3,4,1,3, 0,0,0,0,0) -- 3,4,1,3,0,0,0,0,0,User Interface Shortcuts,WritWorthy,WRIT_WORTHY_ACCEPT_QUESTS,true,false
	--CallSecureProtected("BindKeyToAction", 9,1,8,1, 30,0,0,0,0) -- 9,1,8,1,30,0,0,0,0,Conversation,,CONVERSATION_OPTION_8,false,true
	--CallSecureProtected("BindKeyToAction", 9,1,7,4, 0,0,0,0,0) -- 9,1,7,4,0,0,0,0,0,Conversation,,CONVERSATION_OPTION_7,false,true
	CallSecureProtected("BindKeyToAction", 1,18,18,2, 0,0,0,0,0) -- 1,18,18,2,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMARGLA,true,false
	CallSecureProtected("BindKeyToAction", 1,18,17,3, 0,0,0,0,0) -- 1,18,17,3,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMACYRODIILTOGGLE,true,false
	CallSecureProtected("BindKeyToAction", 1,6,14,1, 52,0,0,0,0) -- 1,6,14,1,52,0,0,0,0,General,User Interface,TOGGLE_COLLECTIONS_BOOK,true,false
	--CallSecureProtected("BindKeyToAction", 9,1,6,4, 0,0,0,0,0) -- 9,1,6,4,0,0,0,0,0,Conversation,,CONVERSATION_OPTION_6,false,true
	--CallSecureProtected("BindKeyToAction", 9,1,6,3, 0,0,0,0,0) -- 9,1,6,3,0,0,0,0,0,Conversation,,CONVERSATION_OPTION_6,false,true
	--CallSecureProtected("BindKeyToAction", 9,1,5,3, 0,0,0,0,0) -- 9,1,5,3,0,0,0,0,0,Conversation,,CONVERSATION_OPTION_5,false,true
	--CallSecureProtected("BindKeyToAction", 9,1,5,2, 63,0,0,0,0) -- 9,1,5,2,63,0,0,0,0,Conversation,,CONVERSATION_OPTION_5,false,true
	CallSecureProtected("BindKeyToAction", 1,26,7,4, 0,0,0,0,0) -- 1,26,7,4,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_REFRESH,true,false
	CallSecureProtected("BindKeyToAction", 1,21,4,3, 0,0,0,0,0) -- 1,21,4,3,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_PREVIOUS_SET,true,false
	CallSecureProtected("BindKeyToAction", 1,18,1,3, 0,0,0,0,0) -- 1,18,1,3,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMAWINDOWTOGGLE,true,false
	--CallSecureProtected("BindKeyToAction", 9,1,5,1, 27,0,0,0,0) -- 9,1,5,1,27,0,0,0,0,Conversation,,CONVERSATION_OPTION_5,false,true
	--CallSecureProtected("BindKeyToAction", 9,1,4,4, 0,0,0,0,0) -- 9,1,4,4,0,0,0,0,0,Conversation,,CONVERSATION_OPTION_4,false,true
	--CallSecureProtected("BindKeyToAction", 9,1,4,3, 0,0,0,0,0) -- 9,1,4,3,0,0,0,0,0,Conversation,,CONVERSATION_OPTION_4,false,true
	CallSecureProtected("BindKeyToAction", 1,25,8,4, 0,0,0,0,0) -- 1,25,8,4,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_7,true,false
	--CallSecureProtected("BindKeyToAction", 9,1,3,2, 61,0,0,0,0) -- 9,1,3,2,61,0,0,0,0,Conversation,,CONVERSATION_OPTION_3,false,true
	CallSecureProtected("BindKeyToAction", 5,1,6,3, 0,0,0,0,0) -- 5,1,6,3,0,0,0,0,0,Dialogs,,DIALOG_RESET,true,false
	--CallSecureProtected("BindKeyToAction", 9,1,2,4, 0,0,0,0,0) -- 9,1,2,4,0,0,0,0,0,Conversation,,CONVERSATION_OPTION_2,false,true
	CallSecureProtected("BindKeyToAction", 1,25,2,4, 0,0,0,0,0) -- 1,25,2,4,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_1,true,false
	CallSecureProtected("BindKeyToAction", 1,13,2,3, 0,0,0,0,0) -- 1,13,2,3,0,0,0,0,0,General,|c4B8BFETimer,IP_TIMER_STOP,true,false
	CallSecureProtected("BindKeyToAction", 1,12,3,3, 0,0,0,0,0) -- 1,12,3,3,0,0,0,0,0,General,Foundry Tactical Combat,POST_DAMAGE_RESULTS,true,false
	--CallSecureProtected("BindKeyToAction", 17,1,1,2, 133,0,0,0,0) -- 17,1,1,2,133,0,0,0,0,GamepadChatSystem,,SUBMIT_CHAT,false,true
	CallSecureProtected("BindKeyToAction", 1,4,2,2, 0,0,0,0,0) -- 1,4,2,2,0,0,0,0,0,General,Camera,CAMERA_ZOOM_IN,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,19,2, 0,0,0,0,0) -- 10,1,19,2,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_ACTIVITY_FINDER,false,true
	CallSecureProtected("BindKeyToAction", 1,7,5,1, 0,0,0,0,0) -- 1,7,5,1,0,0,0,0,0,General,Mini Map,VOTANS_TOGGLE_MAP_ZOOM_IN,true,false
	CallSecureProtected("BindKeyToAction", 1,2,16,4, 0,0,0,0,0) -- 1,2,16,4,0,0,0,0,0,General,Combat,GAMEPAD_SPECIAL_MOVE_SPRINT,true,true
	--CallSecureProtected("BindKeyToAction", 2,1,25,2, 0,0,0,0,0) -- 2,1,25,2,0,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 8,1,3,2, 0,0,0,0,0) -- 8,1,3,2,0,0,0,0,0,MouseUIMode,,RIGHT_MOUSE_IN_WORLD,false,true
	--CallSecureProtected("BindKeyToAction", 8,1,3,1, 115,0,0,0,0) -- 8,1,3,1,115,0,0,0,0,MouseUIMode,,RIGHT_MOUSE_IN_WORLD,false,true
	CallSecureProtected("BindKeyToAction", 1,26,20,3, 0,0,0,0,0) -- 1,26,20,3,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_PLAYER_5,true,false
	--CallSecureProtected("BindKeyToAction", 8,1,2,2, 0,0,0,0,0) -- 8,1,2,2,0,0,0,0,0,MouseUIMode,,LEFT_AND_RIGHT_MOUSE_IN_WORLD,false,true
	CallSecureProtected("BindKeyToAction", 1,24,1,4, 0,0,0,0,0) -- 1,24,1,4,0,0,0,0,0,General,CraftStore,SHOW_CRAFTSTOREFIXED_WINDOW,true,false
	CallSecureProtected("BindKeyToAction", 1,6,24,3, 0,0,0,0,0) -- 1,6,24,3,0,0,0,0,0,General,User Interface,TOGGLE_HELP,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,3,4, 0,0,0,0,0) -- 10,1,3,4,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_SYSTEM,false,true
	CallSecureProtected("BindKeyToAction", 1,6,6,2, 0,0,0,0,0) -- 1,6,6,2,0,0,0,0,0,General,User Interface,TOGGLE_SHOW_INGAME_GUI,true,false
	--CallSecureProtected("BindKeyToAction", 4,1,10,3, 0,0,0,0,0) -- 4,1,10,3,0,0,0,0,0,Siege,,,false,true
	CallSecureProtected("BindKeyToAction", 1,26,20,4, 0,0,0,0,0) -- 1,26,20,4,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_PLAYER_5,true,false
	--CallSecureProtected("BindKeyToAction", 8,1,1,3, 0,0,0,0,0) -- 8,1,1,3,0,0,0,0,0,MouseUIMode,,LEFT_MOUSE_IN_WORLD,false,true
	--CallSecureProtected("BindKeyToAction", 8,1,1,2, 0,0,0,0,0) -- 8,1,1,2,0,0,0,0,0,MouseUIMode,,LEFT_MOUSE_IN_WORLD,false,true
	CallSecureProtected("BindKeyToAction", 1,21,14,3, 0,0,0,0,0) -- 1,21,14,3,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_9,true,false
	--CallSecureProtected("BindKeyToAction", 8,1,1,1, 114,0,0,0,0) -- 8,1,1,1,114,0,0,0,0,MouseUIMode,,LEFT_MOUSE_IN_WORLD,false,true
	CallSecureProtected("BindKeyToAction", 7,1,1,4, 0,0,0,0,0) -- 7,1,1,4,0,0,0,0,0,Instance Kick Warning,,INSTANCE_KICK_LEAVE_INSTANCE,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,14,1, 41,0,0,0,0) -- 2,1,14,1,41,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,7,7,1, 0,0,0,0,0) -- 1,7,7,1,0,0,0,0,0,General,Mini Map,VOTANS_TOGGLE_MAP_ZOOM_MINUS,true,false
	CallSecureProtected("BindKeyToAction", 7,1,1,3, 0,0,0,0,0) -- 7,1,1,3,0,0,0,0,0,Instance Kick Warning,,INSTANCE_KICK_LEAVE_INSTANCE,true,false
	CallSecureProtected("BindKeyToAction", 1,2,12,2, 0,0,0,0,0) -- 1,2,12,2,0,0,0,0,0,General,Combat,ACTION_BUTTON_5,true,false
	CallSecureProtected("BindKeyToAction", 1,13,1,1, 0,0,0,0,0) -- 1,13,1,1,0,0,0,0,0,General,|c4B8BFETimer,IP_TIMER_START,true,false
	CallSecureProtected("BindKeyToAction", 7,1,1,1, 55,0,0,0,0) -- 7,1,1,1,55,0,0,0,0,Instance Kick Warning,,INSTANCE_KICK_LEAVE_INSTANCE,true,false
	CallSecureProtected("BindKeyToAction", 6,1,2,4, 0,0,0,0,0) -- 6,1,2,4,0,0,0,0,0,Notifications,,PLAYER_TO_PLAYER_INTERACT_DECLINE,true,false
	CallSecureProtected("BindKeyToAction", 3,1,5,3, 0,0,0,0,0) -- 3,1,5,3,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_NEGATIVE,true,false
	CallSecureProtected("BindKeyToAction", 1,4,4,1, 124,0,0,0,0) -- 1,4,4,1,124,0,0,0,0,General,Camera,GAME_CAMERA_GAMEPAD_ZOOM,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,22,3, 0,0,0,0,0) -- 28,1,22,3,0,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 13,1,10,1, 22,0,0,0,0) -- 13,1,10,1,22,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_10,false,true
	--CallSecureProtected("BindKeyToAction", 5,1,10,4, 0,0,0,0,0) -- 5,1,10,4,0,0,0,0,0,Dialogs,,,false,true
	--CallSecureProtected("BindKeyToAction", 13,1,9,1, 31,0,0,0,0) -- 13,1,9,1,31,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_9,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,14,4, 0,0,0,0,0) -- 2,1,14,4,0,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 5,1,9,4, 0,0,0,0,0) -- 5,1,9,4,0,0,0,0,0,Dialogs,,,false,true
	--CallSecureProtected("BindKeyToAction", 5,1,9,3, 0,0,0,0,0) -- 5,1,9,3,0,0,0,0,0,Dialogs,,,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,10,3, 0,0,0,0,0) -- 28,1,10,3,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,1,2,1, 50,0,0,0,0) -- 1,1,2,1,50,0,0,0,0,General,Movement,MOVE_BACKWARD,true,false
	--CallSecureProtected("BindKeyToAction", 5,1,8,4, 0,0,0,0,0) -- 5,1,8,4,0,0,0,0,0,Dialogs,,,false,true
	CallSecureProtected("BindKeyToAction", 28,1,30,1, 55,0,0,0,0) -- 28,1,30,1,55,0,0,0,0,Housing Editor,,HOUSING_EDITOR_NEGATIVE_ACTION,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,21,2, 0,0,0,0,0) -- 2,1,21,2,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,21,2,2, 0,0,0,0,0) -- 1,21,2,2,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_UNDRESS,true,false
	CallSecureProtected("BindKeyToAction", 1,25,4,1, 0,0,0,0,0) -- 1,25,4,1,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_3,true,false
	CallSecureProtected("BindKeyToAction", 1,4,3,1, 0,0,0,0,0) -- 1,4,3,1,0,0,0,0,0,General,Camera,GAME_CAMERA_MOUSE_FREE_LOOK,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,14,4, 0,0,0,0,0) -- 28,1,14,4,0,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 5,1,7,2, 165,0,0,0,0) -- 5,1,7,2,165,0,0,0,0,Dialogs,,,false,true
	--CallSecureProtected("BindKeyToAction", 5,1,7,1, 3,0,0,0,0) -- 5,1,7,1,3,0,0,0,0,Dialogs,,,false,true
	CallSecureProtected("BindKeyToAction", 29,1,7,2, 131,0,0,0,0) -- 29,1,7,2,131,0,0,0,0,Housing Editor Placement Mode,,HOUSING_EDITOR_ROLL_LEFT,true,false
	CallSecureProtected("BindKeyToAction", 5,1,6,2, 130,0,0,0,0) -- 5,1,6,2,130,0,0,0,0,Dialogs,,DIALOG_RESET,true,false
	CallSecureProtected("BindKeyToAction", 1,1,3,4, 0,0,0,0,0) -- 1,1,3,4,0,0,0,0,0,General,Movement,TOGGLE_WALK,true,false
	CallSecureProtected("BindKeyToAction", 1,18,19,3, 0,0,0,0,0) -- 1,18,19,3,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMARGLASRT,true,false
	CallSecureProtected("BindKeyToAction", 32,1,1,1, 2,0,0,0,0) -- 32,1,1,1,2,0,0,0,0,AntiquityDiggingActions,,ANTIQUITY_DIGGING_MORE_INFO,true,false
	--CallSecureProtected("BindKeyToAction", 3,1,17,1, 123,0,0,0,0) -- 3,1,17,1,123,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_INPUT_UP,false,true
	CallSecureProtected("BindKeyToAction", 1,11,6,2, 0,0,0,0,0) -- 1,11,6,2,0,0,0,0,0,General,CombatMetrics,CMX_POST_HPS,true,false
	CallSecureProtected("BindKeyToAction", 1,15,2,2, 0,0,0,0,0) -- 1,15,2,2,0,0,0,0,0,General,Vacuum Shop,VACUUM_LEFT,true,false
	CallSecureProtected("BindKeyToAction", 1,25,6,3, 0,0,0,0,0) -- 1,25,6,3,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_5,true,false
	CallSecureProtected("BindKeyToAction", 5,1,5,3, 128,0,0,0,0) -- 5,1,5,3,128,0,0,0,0,Dialogs,,DIALOG_CLOSE,true,false
	CallSecureProtected("BindKeyToAction", 1,26,2,3, 0,0,0,0,0) -- 1,26,2,3,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_TOGGLE_MAIN_ACTIVE_QUESTS,true,false
	CallSecureProtected("BindKeyToAction", 1,25,11,1, 0,0,0,0,0) -- 1,25,11,1,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_10,true,false
	CallSecureProtected("BindKeyToAction", 1,2,27,4, 0,0,0,0,0) -- 1,2,27,4,0,0,0,0,0,General,Combat,COMMAND_PET,true,false
	CallSecureProtected("BindKeyToAction", 1,6,1,4, 0,0,0,0,0) -- 1,6,1,4,0,0,0,0,0,General,User Interface,TOGGLE_FULLSCREEN,true,false
	CallSecureProtected("BindKeyToAction", 1,2,10,4, 0,0,0,0,0) -- 1,2,10,4,0,0,0,0,0,General,Combat,ACTION_BUTTON_3,true,false
	CallSecureProtected("BindKeyToAction", 1,2,2,3, 0,0,0,0,0) -- 1,2,2,3,0,0,0,0,0,General,Combat,SPECIAL_MOVE_BLOCK,true,false
	CallSecureProtected("BindKeyToAction", 1,1,1,3, 139,0,0,0,0) -- 1,1,1,3,139,0,0,0,0,General,Movement,MOVE_FORWARD,true,false
	CallSecureProtected("BindKeyToAction", 5,1,5,1, 12,0,0,0,0) -- 5,1,5,1,12,0,0,0,0,Dialogs,,DIALOG_CLOSE,true,false
	CallSecureProtected("BindKeyToAction", 5,1,4,4, 0,0,0,0,0) -- 5,1,4,4,0,0,0,0,0,Dialogs,,DIALOG_NEGATIVE,true,false
	CallSecureProtected("BindKeyToAction", 1,29,1,3, 0,0,0,0,0) -- 1,29,1,3,0,0,0,0,0,General,Assist Rapid Riding,ARR_SWITCH,true,false
	CallSecureProtected("BindKeyToAction", 5,1,4,3, 0,0,0,0,0) -- 5,1,4,3,0,0,0,0,0,Dialogs,,DIALOG_NEGATIVE,true,false
	CallSecureProtected("BindKeyToAction", 5,1,4,2, 134,0,0,0,0) -- 5,1,4,2,134,0,0,0,0,Dialogs,,DIALOG_NEGATIVE,true,false
	CallSecureProtected("BindKeyToAction", 1,6,4,4, 0,0,0,0,0) -- 1,6,4,4,0,0,0,0,0,General,User Interface,START_CHAT_SLASH,true,false
	CallSecureProtected("BindKeyToAction", 5,1,3,4, 0,0,0,0,0) -- 5,1,3,4,0,0,0,0,0,Dialogs,,DIALOG_TERTIARY,true,false
	CallSecureProtected("BindKeyToAction", 5,1,3,3, 0,0,0,0,0) -- 5,1,3,3,0,0,0,0,0,Dialogs,,DIALOG_TERTIARY,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,2,1, 55,0,0,0,0) -- 10,1,2,1,55,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_UI_SHORTCUT_NEGATIVE,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,8,4, 0,0,0,0,0) -- 2,1,8,4,0,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 4,1,10,4, 0,0,0,0,0) -- 4,1,10,4,0,0,0,0,0,Siege,,,false,true
	CallSecureProtected("BindKeyToAction", 3,1,1,2, 133,0,0,0,0) -- 3,1,1,2,133,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_PRIMARY,true,false
	CallSecureProtected("BindKeyToAction", 1,9,2,1, 0,0,0,0,0) -- 1,9,2,1,0,0,0,0,0,General,|cFF6A00Mass Deconstructor|r,MD_DECONSTRUCTOR_REFINE_ALL,true,false
	CallSecureProtected("BindKeyToAction", 28,1,29,2, 36,0,0,0,0) -- 28,1,29,2,36,0,0,0,0,Housing Editor,,HOUSING_EDITOR_PRIMARY_ACTION,true,false
	CallSecureProtected("BindKeyToAction", 5,1,2,3, 0,0,0,0,0) -- 5,1,2,3,0,0,0,0,0,Dialogs,,DIALOG_SECONDARY,true,false
	CallSecureProtected("BindKeyToAction", 1,7,4,1, 0,0,0,0,0) -- 1,7,4,1,0,0,0,0,0,General,Mini Map,VOTANS_TOGGLE_MAP_ZOOM_OUT,true,false
	CallSecureProtected("BindKeyToAction", 1,18,2,1, 0,0,0,0,0) -- 1,18,2,1,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMAMODECHANGE,true,false
	CallSecureProtected("BindKeyToAction", 1,20,7,1, 0,0,0,0,0) -- 1,20,7,1,0,0,0,0,0,General,|c3366FFBank|r Manager |c990000Revived|r,BMR_PROFILE7,true,false
	CallSecureProtected("BindKeyToAction", 1,7,8,2, 0,0,0,0,0) -- 1,7,8,2,0,0,0,0,0,General,Mini Map,VOTANS_TOGGLE_MAP_OFFSET_FIX,true,false
	CallSecureProtected("BindKeyToAction", 1,26,10,2, 0,0,0,0,0) -- 1,26,10,2,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_GUILD_HOUSE,true,false
	CallSecureProtected("BindKeyToAction", 1,2,11,2, 0,0,0,0,0) -- 1,2,11,2,0,0,0,0,0,General,Combat,ACTION_BUTTON_4,true,false
	CallSecureProtected("BindKeyToAction", 1,6,18,2, 0,0,0,0,0) -- 1,6,18,2,0,0,0,0,0,General,User Interface,TOGGLE_GUILDS,true,false
	CallSecureProtected("BindKeyToAction", 1,18,5,3, 0,0,0,0,0) -- 1,18,5,3,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMAALTMODECHANGE,true,false
	CallSecureProtected("BindKeyToAction", 1,7,6,4, 0,0,0,0,0) -- 1,7,6,4,0,0,0,0,0,General,Mini Map,VOTANS_TOGGLE_MAP_ZOOM_PLUS,true,false
	CallSecureProtected("BindKeyToAction", 5,1,1,4, 0,0,0,0,0) -- 5,1,1,4,0,0,0,0,0,Dialogs,,DIALOG_PRIMARY,true,false
	CallSecureProtected("BindKeyToAction", 5,1,1,3, 0,0,0,0,0) -- 5,1,1,3,0,0,0,0,0,Dialogs,,DIALOG_PRIMARY,true,false
	CallSecureProtected("BindKeyToAction", 1,2,5,3, 0,0,0,0,0) -- 1,2,5,3,0,0,0,0,0,General,Combat,SPECIAL_MOVE_INTERRUPT,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,20,4, 0,0,0,0,0) -- 28,1,20,4,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 5,1,1,1, 36,0,0,0,0) -- 5,1,1,1,36,0,0,0,0,Dialogs,,DIALOG_PRIMARY,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,29,3, 0,0,0,0,0) -- 2,1,29,3,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,18,23,2, 0,0,0,0,0) -- 1,18,23,2,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMALFGP,true,false
	--CallSecureProtected("BindKeyToAction", 4,2,5,4, 0,0,0,0,0) -- 4,2,5,4,0,0,0,0,0,Siege,Mini Map,VOTANS_TOGGLE_MAP_ZOOM_MINUS_SIEGE,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,1,4, 0,0,0,0,0) -- 28,1,1,4,0,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 4,2,4,2, 0,0,0,0,0) -- 4,2,4,2,0,0,0,0,0,Siege,Mini Map,VOTANS_TOGGLE_MAP_ZOOM_PLUS_SIEGE,false,true
	--CallSecureProtected("BindKeyToAction", 4,2,4,1, 0,0,0,0,0) -- 4,2,4,1,0,0,0,0,0,Siege,Mini Map,VOTANS_TOGGLE_MAP_ZOOM_PLUS_SIEGE,false,true
	--CallSecureProtected("BindKeyToAction", 4,2,3,4, 0,0,0,0,0) -- 4,2,3,4,0,0,0,0,0,Siege,Mini Map,VOTANS_TOGGLE_MAP_ZOOM_IN_SIEGE,false,true
	CallSecureProtected("BindKeyToAction", 1,4,1,4, 0,0,0,0,0) -- 1,4,1,4,0,0,0,0,0,General,Camera,CAMERA_ZOOM_OUT,true,false
	CallSecureProtected("BindKeyToAction", 1,18,19,2, 0,0,0,0,0) -- 1,18,19,2,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMARGLASRT,true,false
	--CallSecureProtected("BindKeyToAction", 4,2,3,3, 0,0,0,0,0) -- 4,2,3,3,0,0,0,0,0,Siege,Mini Map,VOTANS_TOGGLE_MAP_ZOOM_IN_SIEGE,false,true
	--CallSecureProtected("BindKeyToAction", 10,1,17,4, 0,0,0,0,0) -- 10,1,17,4,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_MAIL,false,true
	--CallSecureProtected("BindKeyToAction", 4,2,2,3, 0,0,0,0,0) -- 4,2,2,3,0,0,0,0,0,Siege,Mini Map,VOTANS_TOGGLE_MAP_ZOOM_OUT_SIEGE,false,true
	--CallSecureProtected("BindKeyToAction", 11,1,5,2, 0,0,0,0,0) -- 11,1,5,2,0,0,0,0,0,PreviewInterceptLayer,,INTERCEPT_SPECIAL_WEAPON_SWAP_TO_SET_1,false,true
	CallSecureProtected("BindKeyToAction", 1,21,4,1, 0,0,0,0,0) -- 1,21,4,1,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_PREVIOUS_SET,true,false
	CallSecureProtected("BindKeyToAction", 4,2,1,2, 0,0,0,0,0) -- 4,2,1,2,0,0,0,0,0,Siege,Mini Map,VOTANS_TOGGLE_MAP_SHOW_SIEGE_HUD,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,18,3, 0,0,0,0,0) -- 2,1,18,3,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 4,2,1,4, 0,0,0,0,0) -- 4,2,1,4,0,0,0,0,0,Siege,Mini Map,VOTANS_TOGGLE_MAP_SHOW_SIEGE_HUD,true,false
	CallSecureProtected("BindKeyToAction", 1,18,21,4, 0,0,0,0,0) -- 1,18,21,4,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMARGLAPST,true,false
	--CallSecureProtected("BindKeyToAction", 27,1,2,2, 0,0,0,0,0) -- 27,1,2,2,0,0,0,0,0,ScreenshotMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,21,21,4, 0,0,0,0,0) -- 1,21,21,4,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_16,true,false
	--CallSecureProtected("BindKeyToAction", 17,1,4,4, 0,0,0,0,0) -- 17,1,4,4,0,0,0,0,0,GamepadChatSystem,,,false,true
	--CallSecureProtected("BindKeyToAction", 4,1,13,3, 0,0,0,0,0) -- 4,1,13,3,0,0,0,0,0,Siege,,,false,true
	CallSecureProtected("BindKeyToAction", 1,26,14,3, 0,0,0,0,0) -- 1,26,14,3,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_ZONE_4,true,false
	--CallSecureProtected("BindKeyToAction", 4,1,12,4, 0,0,0,0,0) -- 4,1,12,4,0,0,0,0,0,Siege,,,false,true
	--CallSecureProtected("BindKeyToAction", 4,1,12,2, 0,0,0,0,0) -- 4,1,12,2,0,0,0,0,0,Siege,,,false,true
	--CallSecureProtected("BindKeyToAction", 15,1,6,3, 128,0,0,0,0) -- 15,1,6,3,128,0,0,0,0,Death,,DEATH_RECAP_HIDE,false,true
	--CallSecureProtected("BindKeyToAction", 10,1,6,4, 0,0,0,0,0) -- 10,1,6,4,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_INVENTORY,false,true
	--CallSecureProtected("BindKeyToAction", 3,1,14,4, 0,0,0,0,0) -- 3,1,14,4,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_LEFT_SHOULDER,false,true
	--CallSecureProtected("BindKeyToAction", 4,1,11,2, 0,0,0,0,0) -- 4,1,11,2,0,0,0,0,0,Siege,,,false,true
	CallSecureProtected("BindKeyToAction", 1,18,3,2, 0,0,0,0,0) -- 1,18,3,2,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMATABCHANGE,true,false
	--CallSecureProtected("BindKeyToAction", 4,1,11,1, 0,0,0,0,0) -- 4,1,11,1,0,0,0,0,0,Siege,,,false,true
	--CallSecureProtected("BindKeyToAction", 4,1,10,2, 0,0,0,0,0) -- 4,1,10,2,0,0,0,0,0,Siege,,,false,true
	--CallSecureProtected("BindKeyToAction", 4,1,9,4, 0,0,0,0,0) -- 4,1,9,4,0,0,0,0,0,Siege,,,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,21,1, 20,0,0,0,0) -- 28,1,21,1,20,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,2,10,3, 0,0,0,0,0) -- 1,2,10,3,0,0,0,0,0,General,Combat,ACTION_BUTTON_3,true,false
	CallSecureProtected("BindKeyToAction", 1,18,14,3, 0,0,0,0,0) -- 1,18,14,3,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMATRIALTOGGLE,true,false
	--CallSecureProtected("BindKeyToAction", 4,1,9,2, 165,0,0,0,0) -- 4,1,9,2,165,0,0,0,0,Siege,,,false,true
	--CallSecureProtected("BindKeyToAction", 4,1,8,3, 0,0,0,0,0) -- 4,1,8,3,0,0,0,0,0,Siege,,,false,true
	CallSecureProtected("BindKeyToAction", 1,21,8,2, 0,0,0,0,0) -- 1,21,8,2,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_3,true,false
	--CallSecureProtected("BindKeyToAction", 4,1,8,1, 20,0,0,0,0) -- 4,1,8,1,20,0,0,0,0,Siege,,,false,true
	--CallSecureProtected("BindKeyToAction", 4,1,7,3, 0,0,0,0,0) -- 4,1,7,3,0,0,0,0,0,Siege,,,false,true
	--CallSecureProtected("BindKeyToAction", 4,1,7,2, 0,0,0,0,0) -- 4,1,7,2,0,0,0,0,0,Siege,,,false,true
	--CallSecureProtected("BindKeyToAction", 4,1,7,1, 3,5,0,0,0) -- 4,1,7,1,3,5,0,0,0,Siege,,,false,true
	CallSecureProtected("BindKeyToAction", 1,18,21,3, 0,0,0,0,0) -- 1,18,21,3,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMARGLAPST,true,false
	CallSecureProtected("BindKeyToAction", 1,14,1,3, 0,0,0,0,0) -- 1,14,1,3,0,0,0,0,0,General,Urich's Skill Point Finder,USPF_TOGGLE,true,false
	CallSecureProtected("BindKeyToAction", 1,18,12,3, 0,0,0,0,0) -- 1,18,12,3,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMACLGLTOGGLE,true,false
	--CallSecureProtected("BindKeyToAction", 13,1,10,4, 0,0,0,0,0) -- 13,1,10,4,0,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_10,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,13,4, 0,0,0,0,0) -- 2,1,13,4,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,5,3,1, 0,0,0,0,0) -- 1,5,3,1,0,0,0,0,0,General,Interaction,TEAMFORMATION,true,false
	CallSecureProtected("BindKeyToAction", 1,10,1,2, 0,0,0,0,0) -- 1,10,1,2,0,0,0,0,0,General,Rare Fish Tracker,RARE_FISH_TRACKER_TOGGLE,true,false
	CallSecureProtected("BindKeyToAction", 1,26,5,2, 0,0,0,0,0) -- 1,26,5,2,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_TOGGLE_MAIN_DELVES,true,false
	CallSecureProtected("BindKeyToAction", 1,11,6,3, 0,0,0,0,0) -- 1,11,6,3,0,0,0,0,0,General,CombatMetrics,CMX_POST_HPS,true,false
	CallSecureProtected("BindKeyToAction", 1,21,4,2, 0,0,0,0,0) -- 1,21,4,2,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_PREVIOUS_SET,true,false
	--CallSecureProtected("BindKeyToAction", 4,1,6,2, 0,0,0,0,0) -- 4,1,6,2,0,0,0,0,0,Siege,,,false,true
	CallSecureProtected("BindKeyToAction", 1,21,16,2, 0,0,0,0,0) -- 1,21,16,2,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_11,true,false
	CallSecureProtected("BindKeyToAction", 1,8,2,3, 0,0,0,0,0) -- 1,8,2,3,0,0,0,0,0,General,HarvestMap,TOGGLE_WORLDPINS,true,false
	CallSecureProtected("BindKeyToAction", 1,6,14,4, 0,0,0,0,0) -- 1,6,14,4,0,0,0,0,0,General,User Interface,TOGGLE_COLLECTIONS_BOOK,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,2,4, 0,0,0,0,0) -- 2,1,2,4,0,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 3,1,11,2, 0,0,0,0,0) -- 3,1,11,2,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_RIGHT_TRIGGER,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,8,2, 0,0,0,0,0) -- 2,1,8,2,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,6,9,3, 0,0,0,0,0) -- 1,6,9,3,0,0,0,0,0,General,User Interface,TOGGLE_INVENTORY,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,12,4, 0,0,0,0,0) -- 28,1,12,4,0,0,0,0,0,Housing Editor,,,false,true
	--CallSecureProtected("BindKeyToAction", 15,1,2,2, 135,0,0,0,0) -- 15,1,2,2,135,0,0,0,0,Death,,DEATH_SECONDARY,false,true
	CallSecureProtected("BindKeyToAction", 1,8,3,4, 0,0,0,0,0) -- 1,8,3,4,0,0,0,0,0,General,HarvestMap,TOGGLE_MAPPINS,true,false
	CallSecureProtected("BindKeyToAction", 4,1,3,2, 136,0,0,0,0) -- 4,1,3,2,136,0,0,0,0,Siege,,SIEGE_PACK_UP,true,false
	CallSecureProtected("BindKeyToAction", 4,1,1,4, 0,0,0,0,0) -- 4,1,1,4,0,0,0,0,0,Siege,,SIEGE_FIRE,true,false
	CallSecureProtected("BindKeyToAction", 29,1,3,4, 0,0,0,0,0) -- 29,1,3,4,0,0,0,0,0,Housing Editor Placement Mode,,HOUSING_EDITOR_YAW_LEFT,true,false
	CallSecureProtected("BindKeyToAction", 1,26,18,3, 0,0,0,0,0) -- 1,26,18,3,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_PLAYER_3,true,false
	CallSecureProtected("BindKeyToAction", 4,1,1,1, 114,0,0,0,0) -- 4,1,1,1,114,0,0,0,0,Siege,,SIEGE_FIRE,true,false
	CallSecureProtected("BindKeyToAction", 3,4,1,4, 0,0,0,0,0) -- 3,4,1,4,0,0,0,0,0,User Interface Shortcuts,WritWorthy,WRIT_WORTHY_ACCEPT_QUESTS,true,false
	CallSecureProtected("BindKeyToAction", 32,1,1,2, 136,0,0,0,0) -- 32,1,1,2,136,0,0,0,0,AntiquityDiggingActions,,ANTIQUITY_DIGGING_MORE_INFO,true,false
	--CallSecureProtected("BindKeyToAction", 19,1,1,2, 135,0,0,0,0) -- 19,1,1,2,135,0,0,0,0,KeybindWindow,,KEYBINDS_LOAD_KEYBOARD_DEFAULTS,false,true
	CallSecureProtected("BindKeyToAction", 3,2,1,4, 0,0,0,0,0) -- 3,2,1,4,0,0,0,0,0,User Interface Shortcuts,Dolgubon's Lazy Writ Crafter,WRIT_CRAFTER_CRAFT_ITEMS,true,false
	--CallSecureProtected("BindKeyToAction", 31,1,4,2, 0,0,0,0,0) -- 31,1,4,2,0,0,0,0,0,ScryingActions,,,false,true
	--CallSecureProtected("BindKeyToAction", 3,1,20,4, 0,0,0,0,0) -- 3,1,20,4,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_RIGHT_STICK,false,true
	CallSecureProtected("BindKeyToAction", 1,2,14,2, 0,0,0,0,0) -- 1,2,14,2,0,0,0,0,0,General,Combat,ACTION_BUTTON_7,true,false
	CallSecureProtected("BindKeyToAction", 1,26,5,1, 0,0,0,0,0) -- 1,26,5,1,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_TOGGLE_MAIN_DELVES,true,false
	CallSecureProtected("BindKeyToAction", 1,9,1,2, 0,0,0,0,0) -- 1,9,1,2,0,0,0,0,0,General,|cFF6A00Mass Deconstructor|r,MD_DECONSTRUCTOR_DECON_ALL,true,false
	--CallSecureProtected("BindKeyToAction", 3,1,19,3, 0,0,0,0,0) -- 3,1,19,3,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_LEFT_STICK,false,true
	--CallSecureProtected("BindKeyToAction", 3,1,19,2, 0,0,0,0,0) -- 3,1,19,2,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_LEFT_STICK,false,true
	CallSecureProtected("BindKeyToAction", 3,1,8,4, 0,0,0,0,0) -- 3,1,8,4,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_SHOW_QUEST_ON_MAP,true,false
	CallSecureProtected("BindKeyToAction", 1,2,18,1, 135,0,0,0,0) -- 1,2,18,1,135,0,0,0,0,General,Combat,GAMEPAD_ACTION_BUTTON_3,true,true
	CallSecureProtected("BindKeyToAction", 1,18,11,3, 0,0,0,0,0) -- 1,18,11,3,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMAINVTTOGGLE,true,false
	--CallSecureProtected("BindKeyToAction", 3,1,18,3, 0,0,0,0,0) -- 3,1,18,3,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_INPUT_DOWN,false,true
	--CallSecureProtected("BindKeyToAction", 3,1,17,3, 0,0,0,0,0) -- 3,1,17,3,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_INPUT_UP,false,true
	--CallSecureProtected("BindKeyToAction", 3,1,17,2, 139,0,0,0,0) -- 3,1,17,2,139,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_INPUT_UP,false,true
	CallSecureProtected("BindKeyToAction", 1,18,16,4, 0,0,0,0,0) -- 1,18,16,4,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMAGUILDTOGGLE,true,false
	--CallSecureProtected("BindKeyToAction", 1,6,25,1, 12,0,0,0,0) -- 1,6,25,1,12,0,0,0,0,General,User Interface,TOGGLE_SYSTEM,false,false
	CallSecureProtected("BindKeyToAction", 5,1,5,4, 0,0,0,0,0) -- 5,1,5,4,0,0,0,0,0,Dialogs,,DIALOG_CLOSE,true,false
	--CallSecureProtected("BindKeyToAction", 3,1,16,2, 142,0,0,0,0) -- 3,1,16,2,142,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_INPUT_RIGHT,false,true
	--CallSecureProtected("BindKeyToAction", 3,1,14,1, 131,0,0,0,0) -- 3,1,14,1,131,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_LEFT_SHOULDER,false,true
	CallSecureProtected("BindKeyToAction", 1,18,7,4, 0,0,0,0,0) -- 1,18,7,4,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMACHATPOSTTDCL,true,false
	--CallSecureProtected("BindKeyToAction", 3,1,14,3, 0,0,0,0,0) -- 3,1,14,3,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_LEFT_SHOULDER,false,true
	--CallSecureProtected("BindKeyToAction", 13,1,4,2, 62,0,0,0,0) -- 13,1,4,2,62,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_4,false,true
	--CallSecureProtected("BindKeyToAction", 3,1,16,1, 126,0,0,0,0) -- 3,1,16,1,126,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_INPUT_RIGHT,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,27,4, 0,0,0,0,0) -- 2,1,27,4,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 29,1,11,4, 0,0,0,0,0) -- 29,1,11,4,0,0,0,0,0,Housing Editor Placement Mode,,HOUSING_EDITOR_ALIGN_TO_SURFACE,true,false
	CallSecureProtected("BindKeyToAction", 1,3,1,2, 183,0,0,0,0) -- 1,3,1,2,183,0,0,0,0,General,Targeting,CYCLE_PREFERRED_ENEMY_TARGET,true,false
	CallSecureProtected("BindKeyToAction", 1,21,8,4, 0,0,0,0,0) -- 1,21,8,4,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_3,true,false
	CallSecureProtected("BindKeyToAction", 5,1,3,1, 37,0,0,0,0) -- 5,1,3,1,37,0,0,0,0,Dialogs,,DIALOG_TERTIARY,true,false
	CallSecureProtected("BindKeyToAction", 6,1,1,2, 133,0,0,0,0) -- 6,1,1,2,133,0,0,0,0,Notifications,,PLAYER_TO_PLAYER_INTERACT_ACCEPT,true,false
	CallSecureProtected("BindKeyToAction", 5,1,2,2, 135,0,0,0,0) -- 5,1,2,2,135,0,0,0,0,Dialogs,,DIALOG_SECONDARY,true,false
	CallSecureProtected("BindKeyToAction", 1,18,12,2, 0,0,0,0,0) -- 1,18,12,2,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMACLGLTOGGLE,true,false
	CallSecureProtected("BindKeyToAction", 1,25,10,2, 0,0,0,0,0) -- 1,25,10,2,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_9,true,false
	--CallSecureProtected("BindKeyToAction", 3,1,12,4, 0,0,0,0,0) -- 3,1,12,4,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_LEFT_TRIGGER,false,true
	CallSecureProtected("BindKeyToAction", 1,18,2,2, 0,0,0,0,0) -- 1,18,2,2,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMAMODECHANGE,true,false
	CallSecureProtected("BindKeyToAction", 1,2,25,1, 179,0,0,0,0) -- 1,2,25,1,179,0,0,0,0,General,Combat,UI_SHORTCUT_EMOTES_QUICK_SLOTS,true,false
	CallSecureProtected("BindKeyToAction", 1,19,4,1, 28,7,0,0,0) -- 1,19,4,1,28,7,0,0,0,General,Dustman,DUSTMAN_RESCAN,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,13,3, 0,0,0,0,0) -- 10,1,13,3,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_GROUP,false,true
	CallSecureProtected("BindKeyToAction", 1,12,1,2, 0,0,0,0,0) -- 1,12,1,2,0,0,0,0,0,General,Foundry Tactical Combat,TOGGLE_COMBAT_LOG,true,false
	--CallSecureProtected("BindKeyToAction", 1,6,25,4, 0,0,0,0,0) -- 1,6,25,4,0,0,0,0,0,General,User Interface,TOGGLE_SYSTEM,false,false
	--CallSecureProtected("BindKeyToAction", 4,1,4,1, 12,0,0,0,0) -- 4,1,4,1,12,0,0,0,0,Siege,,SIEGE_ESCAPE,false,true
	--CallSecureProtected("BindKeyToAction", 3,1,12,1, 137,0,0,0,0) -- 3,1,12,1,137,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_LEFT_TRIGGER,false,true
	CallSecureProtected("BindKeyToAction", 1,18,10,4, 0,0,0,0,0) -- 1,18,10,4,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMAWRBTOGGLE,true,false
	--CallSecureProtected("BindKeyToAction", 16,1,2,1, 49,0,0,0,0) -- 16,1,2,1,49,0,0,0,0,Loot,,LOOT_ALL,false,true
	--CallSecureProtected("BindKeyToAction", 4,1,5,4, 0,0,0,0,0) -- 4,1,5,4,0,0,0,0,0,Siege,,,false,true
	CallSecureProtected("BindKeyToAction", 1,18,7,1, 0,0,0,0,0) -- 1,18,7,1,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMACHATPOSTTDCL,true,false
	--CallSecureProtected("BindKeyToAction", 13,1,1,4, 0,0,0,0,0) -- 13,1,1,4,0,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_1,false,true
	--CallSecureProtected("BindKeyToAction", 13,1,1,3, 0,0,0,0,0) -- 13,1,1,3,0,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_1,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,38,1, 79,0,0,0,0) -- 28,1,38,1,79,0,0,0,0,Housing Editor,,DISABLE_HOUSING_EDITOR,false,true
	--CallSecureProtected("BindKeyToAction", 3,1,10,1, 5,0,0,0,0) -- 3,1,10,1,5,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_EXIT,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,19,1, 38,0,0,0,0) -- 2,1,19,1,38,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,21,6,1, 23,7,0,0,0) -- 1,21,6,1,23,7,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_1,true,false
	CallSecureProtected("BindKeyToAction", 1,1,8,4, 0,0,0,0,0) -- 1,1,8,4,0,0,0,0,0,General,Movement,ROLL_DODGE,true,false
	CallSecureProtected("BindKeyToAction", 1,20,1,4, 0,0,0,0,0) -- 1,20,1,4,0,0,0,0,0,General,|c3366FFBank|r Manager |c990000Revived|r,BMR_PROFILE1,true,false
	CallSecureProtected("BindKeyToAction", 1,2,25,4, 0,0,0,0,0) -- 1,2,25,4,0,0,0,0,0,General,Combat,UI_SHORTCUT_EMOTES_QUICK_SLOTS,true,false
	CallSecureProtected("BindKeyToAction", 1,23,2,3, 0,0,0,0,0) -- 1,23,2,3,0,0,0,0,0,General,Mail Looter,MAILLOOTER_QUICK_LOOT_ALL,true,false
	CallSecureProtected("BindKeyToAction", 1,12,2,4, 0,0,0,0,0) -- 1,12,2,4,0,0,0,0,0,General,Foundry Tactical Combat,DISPLAY_DAMAGE_REPORT,true,false
	CallSecureProtected("BindKeyToAction", 1,2,7,1, 109,0,0,0,0) -- 1,2,7,1,109,0,0,0,0,General,Combat,SPECIAL_MOVE_WEAPON_SWAP,true,false
	CallSecureProtected("BindKeyToAction", 1,26,3,4, 0,0,0,0,0) -- 1,26,3,4,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_TOGGLE_MAIN_RELATED_ITEMS,true,false
	CallSecureProtected("BindKeyToAction", 1,19,2,1, 0,0,0,0,0) -- 1,19,2,1,0,0,0,0,0,General,Dustman,DUSTMAN_SET,true,false
	CallSecureProtected("BindKeyToAction", 1,15,1,3, 0,0,0,0,0) -- 1,15,1,3,0,0,0,0,0,General,Vacuum Shop,VACUUM_RIGHT,true,false
	CallSecureProtected("BindKeyToAction", 1,19,3,2, 0,0,0,0,0) -- 1,19,3,2,0,0,0,0,0,General,Dustman,DUSTMAN_DESTROY,true,false
	CallSecureProtected("BindKeyToAction", 1,6,12,3, 0,0,0,0,0) -- 1,6,12,3,0,0,0,0,0,General,User Interface,TOGGLE_CHAMPION,true,false
	CallSecureProtected("BindKeyToAction", 1,18,23,3, 0,0,0,0,0) -- 1,18,23,3,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMALFGP,true,false
	CallSecureProtected("BindKeyToAction", 1,6,18,1, 38,0,0,0,0) -- 1,6,18,1,38,0,0,0,0,General,User Interface,TOGGLE_GUILDS,true,false
	CallSecureProtected("BindKeyToAction", 1,28,1,1, 0,0,0,0,0) -- 1,28,1,1,0,0,0,0,0,General,LFG Auto Accept,LFGAA_1,true,false
	CallSecureProtected("BindKeyToAction", 3,1,9,2, 0,0,0,0,0) -- 3,1,9,2,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_STACK_ALL,true,false
	CallSecureProtected("BindKeyToAction", 1,1,3,2, 0,0,0,0,0) -- 1,1,3,2,0,0,0,0,0,General,Movement,TOGGLE_WALK,true,false
	CallSecureProtected("BindKeyToAction", 1,6,3,3, 0,0,0,0,0) -- 1,6,3,3,0,0,0,0,0,General,User Interface,START_CHAT_ENTER,true,false
	--CallSecureProtected("BindKeyToAction", 3,1,19,1, 129,0,0,0,0) -- 3,1,19,1,129,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_LEFT_STICK,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,27,4, 0,0,0,0,0) -- 28,1,27,4,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 3,1,7,4, 0,0,0,0,0) -- 3,1,7,4,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_QUICK_SLOTS,true,false
	CallSecureProtected("BindKeyToAction", 1,20,2,4, 0,0,0,0,0) -- 1,20,2,4,0,0,0,0,0,General,|c3366FFBank|r Manager |c990000Revived|r,BMR_PROFILE2,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,23,2, 0,0,0,0,0) -- 2,1,23,2,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 3,1,8,1, 44,0,0,0,0) -- 3,1,8,1,44,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_SHOW_QUEST_ON_MAP,true,false
	CallSecureProtected("BindKeyToAction", 1,2,20,2, 0,0,0,0,0) -- 1,2,20,2,0,0,0,0,0,General,Combat,GAMEPAD_ACTION_BUTTON_5,true,true
	CallSecureProtected("BindKeyToAction", 1,10,1,3, 0,0,0,0,0) -- 1,10,1,3,0,0,0,0,0,General,Rare Fish Tracker,RARE_FISH_TRACKER_TOGGLE,true,false
	CallSecureProtected("BindKeyToAction", 1,6,3,1, 3,0,0,0,0) -- 1,6,3,1,3,0,0,0,0,General,User Interface,START_CHAT_ENTER,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,14,4, 0,0,0,0,0) -- 10,1,14,4,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_CONTACTS,false,true
	CallSecureProtected("BindKeyToAction", 3,1,7,1, 48,0,0,0,0) -- 3,1,7,1,48,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_QUICK_SLOTS,true,false
	CallSecureProtected("BindKeyToAction", 1,26,14,4, 0,0,0,0,0) -- 1,26,14,4,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_ZONE_4,true,false
	CallSecureProtected("BindKeyToAction", 1,21,7,4, 0,0,0,0,0) -- 1,21,7,4,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_2,true,false
	CallSecureProtected("BindKeyToAction", 3,1,1,4, 0,0,0,0,0) -- 3,1,1,4,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_PRIMARY,true,false
	CallSecureProtected("BindKeyToAction", 1,14,1,4, 0,0,0,0,0) -- 1,14,1,4,0,0,0,0,0,General,Urich's Skill Point Finder,USPF_TOGGLE,true,false
	CallSecureProtected("BindKeyToAction", 1,25,5,3, 0,0,0,0,0) -- 1,25,5,3,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_4,true,false
	CallSecureProtected("BindKeyToAction", 3,1,6,1, 75,0,0,0,0) -- 3,1,6,1,75,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_REPORT_PLAYER,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,18,1, 46,0,0,0,0) -- 2,1,18,1,46,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 6,1,2,1, 55,0,0,0,0) -- 6,1,2,1,55,0,0,0,0,Notifications,,PLAYER_TO_PLAYER_INTERACT_DECLINE,true,false
	CallSecureProtected("BindKeyToAction", 3,1,5,2, 134,0,0,0,0) -- 3,1,5,2,134,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_NEGATIVE,true,false
	CallSecureProtected("BindKeyToAction", 1,21,19,4, 0,0,0,0,0) -- 1,21,19,4,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_14,true,false
	CallSecureProtected("BindKeyToAction", 1,19,2,2, 0,0,0,0,0) -- 1,19,2,2,0,0,0,0,0,General,Dustman,DUSTMAN_SET,true,false
	CallSecureProtected("BindKeyToAction", 1,4,4,3, 0,0,0,0,0) -- 1,4,4,3,0,0,0,0,0,General,Camera,GAME_CAMERA_GAMEPAD_ZOOM,true,false
	CallSecureProtected("BindKeyToAction", 1,22,1,3, 0,0,0,0,0) -- 1,22,1,3,0,0,0,0,0,General,Roomba,RUN_ROOMBA,true,false
	CallSecureProtected("BindKeyToAction", 1,1,3,1, 11,0,0,0,0) -- 1,1,3,1,11,0,0,0,0,General,Movement,TOGGLE_WALK,true,false
	CallSecureProtected("BindKeyToAction", 1,15,3,3, 0,0,0,0,0) -- 1,15,3,3,0,0,0,0,0,General,Vacuum Shop,VACUUM_UP,true,false
	CallSecureProtected("BindKeyToAction", 3,1,4,4, 0,0,0,0,0) -- 3,1,4,4,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_QUATERNARY,true,false
	CallSecureProtected("BindKeyToAction", 1,18,11,2, 0,0,0,0,0) -- 1,18,11,2,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMAINVTTOGGLE,true,false
	CallSecureProtected("BindKeyToAction", 1,30,1,2, 0,0,0,0,0) -- 1,30,1,2,0,0,0,0,0,General,WritWorthy,WritWorthyUI_ToggleUI,true,false
	CallSecureProtected("BindKeyToAction", 1,19,2,3, 0,0,0,0,0) -- 1,19,2,3,0,0,0,0,0,General,Dustman,DUSTMAN_SET,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,26,3, 0,0,0,0,0) -- 2,1,26,3,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 3,1,3,3, 0,0,0,0,0) -- 3,1,3,3,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_TERTIARY,true,false
	CallSecureProtected("BindKeyToAction", 29,1,7,3, 0,0,0,0,0) -- 29,1,7,3,0,0,0,0,0,Housing Editor Placement Mode,,HOUSING_EDITOR_ROLL_LEFT,true,false
	CallSecureProtected("BindKeyToAction", 1,6,12,4, 0,0,0,0,0) -- 1,6,12,4,0,0,0,0,0,General,User Interface,TOGGLE_CHAMPION,true,false
	CallSecureProtected("BindKeyToAction", 3,1,2,3, 0,0,0,0,0) -- 3,1,2,3,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_SECONDARY,true,false
	CallSecureProtected("BindKeyToAction", 1,23,3,1, 0,0,0,0,0) -- 1,23,3,1,0,0,0,0,0,General,Mail Looter,MAILLOOTER_QUICK_LOOT_FILTERED,true,false
	CallSecureProtected("BindKeyToAction", 3,1,2,1, 49,0,0,0,0) -- 3,1,2,1,49,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_SECONDARY,true,false
	CallSecureProtected("BindKeyToAction", 4,2,1,3, 0,0,0,0,0) -- 4,2,1,3,0,0,0,0,0,Siege,Mini Map,VOTANS_TOGGLE_MAP_SHOW_SIEGE_HUD,true,false
	CallSecureProtected("BindKeyToAction", 24,1,2,3, 0,0,0,0,0) -- 24,1,2,3,0,0,0,0,0,Battlegrounds,,LEAVE_BATTLEGROUND_DUMMY,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,29,1, 0,0,0,0,0) -- 2,1,29,1,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 28,1,36,4, 0,0,0,0,0) -- 28,1,36,4,0,0,0,0,0,Housing Editor,,HOUSING_EDITOR_TOGGLE_NODE_DELAY,true,false
	CallSecureProtected("BindKeyToAction", 1,30,1,1, 0,0,0,0,0) -- 1,30,1,1,0,0,0,0,0,General,WritWorthy,WritWorthyUI_ToggleUI,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,27,3, 0,0,0,0,0) -- 2,1,27,3,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,6,30,3, 0,0,0,0,0) -- 1,6,30,3,0,0,0,0,0,General,User Interface,TOGGLE_NAMEPLATES,true,false
	--CallSecureProtected("BindKeyToAction", 4,1,9,3, 0,0,0,0,0) -- 4,1,9,3,0,0,0,0,0,Siege,,,false,true
	CallSecureProtected("BindKeyToAction", 28,1,36,1, 40,0,0,0,0) -- 28,1,36,1,40,0,0,0,0,Housing Editor,,HOUSING_EDITOR_TOGGLE_NODE_DELAY,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,27,1, 29,0,0,0,0) -- 2,1,27,1,29,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 13,1,6,1, 28,0,0,0,0) -- 13,1,6,1,28,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_6,false,true
	CallSecureProtected("BindKeyToAction", 3,1,3,4, 0,0,0,0,0) -- 3,1,3,4,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_TERTIARY,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,26,2, 0,0,0,0,0) -- 2,1,26,2,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,23,2,1, 22,0,0,0,0) -- 1,23,2,1,22,0,0,0,0,General,Mail Looter,MAILLOOTER_QUICK_LOOT_ALL,true,false
	CallSecureProtected("BindKeyToAction", 1,2,1,1, 114,0,0,0,0) -- 1,2,1,1,114,0,0,0,0,General,Combat,SPECIAL_MOVE_ATTACK,true,false
	--CallSecureProtected("BindKeyToAction", 9,1,1,1, 23,0,0,0,0) -- 9,1,1,1,23,0,0,0,0,Conversation,,CONVERSATION_OPTION_1,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,18,4, 0,0,0,0,0) -- 2,1,18,4,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,1,1,2, 0,0,0,0,0) -- 1,1,1,2,0,0,0,0,0,General,Movement,MOVE_FORWARD,true,false
	CallSecureProtected("BindKeyToAction", 1,15,2,4, 0,0,0,0,0) -- 1,15,2,4,0,0,0,0,0,General,Vacuum Shop,VACUUM_LEFT,true,false
	CallSecureProtected("BindKeyToAction", 1,2,23,2, 0,0,0,0,0) -- 1,2,23,2,0,0,0,0,0,General,Combat,GAMEPAD_ACTION_BUTTON_8,true,true
	CallSecureProtected("BindKeyToAction", 1,26,10,1, 0,0,0,0,0) -- 1,26,10,1,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_GUILD_HOUSE,true,false
	--CallSecureProtected("BindKeyToAction", 3,1,12,3, 0,0,0,0,0) -- 3,1,12,3,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_LEFT_TRIGGER,false,true
	CallSecureProtected("BindKeyToAction", 1,2,9,1, 0,0,0,0,0) -- 1,2,9,1,0,0,0,0,0,General,Combat,SPECIAL_MOVE_WEAPON_SWAP_TO_SET_2,true,false
	--CallSecureProtected("BindKeyToAction", 27,1,3,3, 0,0,0,0,0) -- 27,1,3,3,0,0,0,0,0,ScreenshotMode,,SCREENSHOT_MODE_EXIT,false,true
	CallSecureProtected("BindKeyToAction", 1,4,1,2, 0,0,0,0,0) -- 1,4,1,2,0,0,0,0,0,General,Camera,CAMERA_ZOOM_OUT,true,false
	CallSecureProtected("BindKeyToAction", 1,7,6,2, 0,0,0,0,0) -- 1,7,6,2,0,0,0,0,0,General,Mini Map,VOTANS_TOGGLE_MAP_ZOOM_PLUS,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,24,1, 75,0,0,0,0) -- 2,1,24,1,75,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 10,1,1,4, 0,0,0,0,0) -- 10,1,1,4,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_UI_SHORTCUT_EXIT,false,true
	--CallSecureProtected("BindKeyToAction", 10,1,6,2, 0,0,0,0,0) -- 10,1,6,2,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_INVENTORY,false,true
	CallSecureProtected("BindKeyToAction", 29,1,10,1, 120,0,0,0,0) -- 29,1,10,1,120,0,0,0,0,Housing Editor Placement Mode,,HOUSING_EDITOR_PULL_BACKWARD,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,3,1, 108,0,0,0,0) -- 2,1,3,1,108,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 9,1,2,3, 0,0,0,0,0) -- 9,1,2,3,0,0,0,0,0,Conversation,,CONVERSATION_OPTION_2,false,true
	CallSecureProtected("BindKeyToAction", 1,2,14,1, 27,0,0,0,0) -- 1,2,14,1,27,0,0,0,0,General,Combat,ACTION_BUTTON_7,true,false
	CallSecureProtected("BindKeyToAction", 1,25,7,4, 0,0,0,0,0) -- 1,25,7,4,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_6,true,false
	--CallSecureProtected("BindKeyToAction", 13,1,5,1, 27,0,0,0,0) -- 13,1,5,1,27,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_5,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,21,4, 0,0,0,0,0) -- 2,1,21,4,0,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 5,1,8,1, 108,0,0,0,0) -- 5,1,8,1,108,0,0,0,0,Dialogs,,,false,true
	--CallSecureProtected("BindKeyToAction", 4,1,4,4, 0,0,0,0,0) -- 4,1,4,4,0,0,0,0,0,Siege,,SIEGE_ESCAPE,false,true
	CallSecureProtected("BindKeyToAction", 1,8,1,3, 0,0,0,0,0) -- 1,8,1,3,0,0,0,0,0,General,HarvestMap,SKIP_TARGET,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,19,3, 0,0,0,0,0) -- 2,1,19,3,0,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,19,2, 0,0,0,0,0) -- 2,1,19,2,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,28,1,2, 0,0,0,0,0) -- 1,28,1,2,0,0,0,0,0,General,LFG Auto Accept,LFGAA_1,true,false
	CallSecureProtected("BindKeyToAction", 1,18,11,1, 0,0,0,0,0) -- 1,18,11,1,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMAINVTTOGGLE,true,false
	--CallSecureProtected("BindKeyToAction", 4,2,2,1, 0,0,0,0,0) -- 4,2,2,1,0,0,0,0,0,Siege,Mini Map,VOTANS_TOGGLE_MAP_ZOOM_OUT_SIEGE,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,18,2, 0,0,0,0,0) -- 2,1,18,2,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,1,4,1, 32,0,0,0,0) -- 1,1,4,1,32,0,0,0,0,General,Movement,TURN_LEFT,true,false
	CallSecureProtected("BindKeyToAction", 1,5,1,1, 36,0,0,0,0) -- 1,5,1,1,36,0,0,0,0,General,Interaction,GAME_CAMERA_INTERACT,true,false
	CallSecureProtected("BindKeyToAction", 1,2,26,4, 0,0,0,0,0) -- 1,2,26,4,0,0,0,0,0,General,Combat,SHEATHE_WEAPON_TOGGLE,true,false
	CallSecureProtected("BindKeyToAction", 1,26,16,3, 0,0,0,0,0) -- 1,26,16,3,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_PLAYER_1,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,12,3, 0,0,0,0,0) -- 28,1,12,3,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 28,1,42,2, 0,0,0,0,0) -- 28,1,42,2,0,0,0,0,0,Housing Editor,,HOUSING_EDITOR_BEGIN_EDIT_PATH,true,false
	CallSecureProtected("BindKeyToAction", 1,11,6,4, 0,0,0,0,0) -- 1,11,6,4,0,0,0,0,0,General,CombatMetrics,CMX_POST_HPS,true,false
	CallSecureProtected("BindKeyToAction", 1,11,8,2, 0,0,0,0,0) -- 1,11,8,2,0,0,0,0,0,General,CombatMetrics,CMX_LIVEREPORT_TOGGLE,true,false
	CallSecureProtected("BindKeyToAction", 5,1,6,4, 0,0,0,0,0) -- 5,1,6,4,0,0,0,0,0,Dialogs,,DIALOG_RESET,true,false
	CallSecureProtected("BindKeyToAction", 1,2,6,2, 162,0,0,0,0) -- 1,2,6,2,162,0,0,0,0,General,Combat,USE_SYNERGY,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,15,1, 52,0,0,0,0) -- 2,1,15,1,52,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,6,24,1, 75,0,0,0,0) -- 1,6,24,1,75,0,0,0,0,General,User Interface,TOGGLE_HELP,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,6,1, 5,0,0,0,0) -- 2,1,6,1,5,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,10,1,4, 0,0,0,0,0) -- 1,10,1,4,0,0,0,0,0,General,Rare Fish Tracker,RARE_FISH_TRACKER_TOGGLE,true,false
	CallSecureProtected("BindKeyToAction", 1,26,5,3, 0,0,0,0,0) -- 1,26,5,3,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_TOGGLE_MAIN_DELVES,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,14,3, 0,0,0,0,0) -- 2,1,14,3,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,20,3,1, 106,7,0,0,0) -- 1,20,3,1,106,7,0,0,0,General,|c3366FFBank|r Manager |c990000Revived|r,BMR_PROFILE3,true,false
	CallSecureProtected("BindKeyToAction", 1,23,3,3, 0,0,0,0,0) -- 1,23,3,3,0,0,0,0,0,General,Mail Looter,MAILLOOTER_QUICK_LOOT_FILTERED,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,13,3, 0,0,0,0,0) -- 2,1,13,3,0,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,12,3, 0,0,0,0,0) -- 2,1,12,3,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,12,4,4, 0,0,0,0,0) -- 1,12,4,4,0,0,0,0,0,General,Foundry Tactical Combat,REFRESH_FRAMES,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,11,3, 0,0,0,0,0) -- 2,1,11,3,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,6,10,1, 34,0,0,0,0) -- 1,6,10,1,34,0,0,0,0,General,User Interface,TOGGLE_CHARACTER,true,false
	CallSecureProtected("BindKeyToAction", 1,2,17,1, 0,0,0,0,0) -- 1,2,17,1,0,0,0,0,0,General,Combat,GAMEPAD_MOVE_JUMPASCEND,true,true
	CallSecureProtected("BindKeyToAction", 1,19,4,3, 0,0,0,0,0) -- 1,19,4,3,0,0,0,0,0,General,Dustman,DUSTMAN_RESCAN,true,false
	CallSecureProtected("BindKeyToAction", 1,18,20,2, 0,0,0,0,0) -- 1,18,20,2,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMARGLASTP,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,18,4, 0,0,0,0,0) -- 28,1,18,4,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,6,29,2, 0,0,0,0,0) -- 1,6,29,2,0,0,0,0,0,General,User Interface,TOGGLE_GAMEPAD_MODE,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,2,3, 140,0,0,0,0) -- 28,1,2,3,140,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,6,11,3, 0,0,0,0,0) -- 1,6,11,3,0,0,0,0,0,General,User Interface,TOGGLE_SKILLS,true,false
	CallSecureProtected("BindKeyToAction", 1,2,2,4, 0,0,0,0,0) -- 1,2,2,4,0,0,0,0,0,General,Combat,SPECIAL_MOVE_BLOCK,true,false
	CallSecureProtected("BindKeyToAction", 1,6,10,3, 0,0,0,0,0) -- 1,6,10,3,0,0,0,0,0,General,User Interface,TOGGLE_CHARACTER,true,false
	CallSecureProtected("BindKeyToAction", 1,2,18,4, 0,0,0,0,0) -- 1,2,18,4,0,0,0,0,0,General,Combat,GAMEPAD_ACTION_BUTTON_3,true,true
	--CallSecureProtected("BindKeyToAction", 2,1,7,4, 0,0,0,0,0) -- 2,1,7,4,0,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,7,1, 20,0,0,0,0) -- 2,1,7,1,20,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,6,34,4, 0,0,0,0,0) -- 1,6,34,4,0,0,0,0,0,General,User Interface,POTIONMAKER,true,false
	CallSecureProtected("BindKeyToAction", 24,1,2,2, 136,0,0,0,0) -- 24,1,2,2,136,0,0,0,0,Battlegrounds,,LEAVE_BATTLEGROUND_DUMMY,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,26,1, 0,0,0,0,0) -- 2,1,26,1,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,2,19,1, 136,0,0,0,0) -- 1,2,19,1,136,0,0,0,0,General,Combat,GAMEPAD_ACTION_BUTTON_4,true,true
	--CallSecureProtected("BindKeyToAction", 11,1,2,3, 0,0,0,0,0) -- 11,1,2,3,0,0,0,0,0,PreviewInterceptLayer,,INTERCEPT_AUTORUN,false,true
	CallSecureProtected("BindKeyToAction", 1,15,4,2, 0,0,0,0,0) -- 1,15,4,2,0,0,0,0,0,General,Vacuum Shop,VACUUM_DOWN,true,false
	CallSecureProtected("BindKeyToAction", 1,2,12,3, 0,0,0,0,0) -- 1,2,12,3,0,0,0,0,0,General,Combat,ACTION_BUTTON_5,true,false
	--CallSecureProtected("BindKeyToAction", 19,1,1,1, 49,0,0,0,0) -- 19,1,1,1,49,0,0,0,0,KeybindWindow,,KEYBINDS_LOAD_KEYBOARD_DEFAULTS,false,true
	CallSecureProtected("BindKeyToAction", 1,7,8,1, 0,0,0,0,0) -- 1,7,8,1,0,0,0,0,0,General,Mini Map,VOTANS_TOGGLE_MAP_OFFSET_FIX,true,false
	CallSecureProtected("BindKeyToAction", 1,2,8,2, 0,0,0,0,0) -- 1,2,8,2,0,0,0,0,0,General,Combat,SPECIAL_MOVE_WEAPON_SWAP_TO_SET_1,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,17,1, 105,0,0,0,0) -- 10,1,17,1,105,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_MAIL,false,true
	--CallSecureProtected("BindKeyToAction", 2,1,3,2, 0,0,0,0,0) -- 2,1,3,2,0,0,0,0,0,GamepadUIMode,,,false,true
	--CallSecureProtected("BindKeyToAction", 10,1,5,1, 0,0,0,0,0) -- 10,1,5,1,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_MARKET,false,true
	CallSecureProtected("BindKeyToAction", 29,1,10,3, 0,0,0,0,0) -- 29,1,10,3,0,0,0,0,0,Housing Editor Placement Mode,,HOUSING_EDITOR_PULL_BACKWARD,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,2,3, 0,0,0,0,0) -- 2,1,2,3,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,20,9,3, 0,0,0,0,0) -- 1,20,9,3,0,0,0,0,0,General,|c3366FFBank|r Manager |c990000Revived|r,BMR_PROFILE9,true,false
	CallSecureProtected("BindKeyToAction", 1,21,17,2, 0,0,0,0,0) -- 1,21,17,2,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_12,true,false
	--CallSecureProtected("BindKeyToAction", 26,1,2,3, 0,0,0,0,0) -- 26,1,2,3,0,0,0,0,0,BattlegroundScoreboard,,HIDE_BATTLEGROUND_SCOREBOARD,false,true
	--CallSecureProtected("BindKeyToAction", 15,1,4,3, 0,0,0,0,0) -- 15,1,4,3,0,0,0,0,0,Death,,DEATH_DECLINE,false,true
	CallSecureProtected("BindKeyToAction", 1,7,6,3, 0,0,0,0,0) -- 1,7,6,3,0,0,0,0,0,General,Mini Map,VOTANS_TOGGLE_MAP_ZOOM_PLUS,true,false
	CallSecureProtected("BindKeyToAction", 1,2,15,3, 0,0,0,0,0) -- 1,2,15,3,0,0,0,0,0,General,Combat,ACTION_BUTTON_8,true,false
	CallSecureProtected("BindKeyToAction", 1,11,1,1, 45,0,0,0,0) -- 1,11,1,1,45,0,0,0,0,General,CombatMetrics,CMX_REPORT_TOGGLE,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,1,3, 0,0,0,0,0) -- 2,1,1,3,0,0,0,0,0,GamepadUIMode,,GAMEPAD_UI_EXIT,false,true
	CallSecureProtected("BindKeyToAction", 1,6,15,2, 128,0,0,0,0) -- 1,6,15,2,128,0,0,0,0,General,User Interface,TOGGLE_MAP,true,false
	CallSecureProtected("BindKeyToAction", 1,28,1,4, 0,0,0,0,0) -- 1,28,1,4,0,0,0,0,0,General,LFG Auto Accept,LFGAA_1,true,false
	CallSecureProtected("BindKeyToAction", 1,20,7,3, 0,0,0,0,0) -- 1,20,7,3,0,0,0,0,0,General,|c3366FFBank|r Manager |c990000Revived|r,BMR_PROFILE7,true,false
	CallSecureProtected("BindKeyToAction", 1,22,1,2, 0,0,0,0,0) -- 1,22,1,2,0,0,0,0,0,General,Roomba,RUN_ROOMBA,true,false
	CallSecureProtected("BindKeyToAction", 1,27,1,3, 0,0,0,0,0) -- 1,27,1,3,0,0,0,0,0,General,Mementos,HOLIDAY_MEMENTO,true,false
	CallSecureProtected("BindKeyToAction", 1,26,20,2, 0,0,0,0,0) -- 1,26,20,2,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_PLAYER_5,true,false
	CallSecureProtected("BindKeyToAction", 1,6,5,2, 0,0,0,0,0) -- 1,6,5,2,0,0,0,0,0,General,User Interface,CHAT_REPLY_TO_LAST_WHISPER,true,false
	CallSecureProtected("BindKeyToAction", 1,6,8,1, 0,0,0,0,0) -- 1,6,8,1,0,0,0,0,0,General,User Interface,TOGGLE_MARKET,true,false
	CallSecureProtected("BindKeyToAction", 1,7,8,3, 0,0,0,0,0) -- 1,7,8,3,0,0,0,0,0,General,Mini Map,VOTANS_TOGGLE_MAP_OFFSET_FIX,true,false
	CallSecureProtected("BindKeyToAction", 1,18,17,2, 0,0,0,0,0) -- 1,18,17,2,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMACYRODIILTOGGLE,true,false
	--CallSecureProtected("BindKeyToAction", 13,1,1,1, 23,0,0,0,0) -- 13,1,1,1,23,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_1,false,true
	CallSecureProtected("BindKeyToAction", 1,6,10,2, 0,0,0,0,0) -- 1,6,10,2,0,0,0,0,0,General,User Interface,TOGGLE_CHARACTER,true,false
	CallSecureProtected("BindKeyToAction", 1,21,14,1, 0,0,0,0,0) -- 1,21,14,1,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_9,true,false
	CallSecureProtected("BindKeyToAction", 1,26,20,1, 0,0,0,0,0) -- 1,26,20,1,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_PLAYER_5,true,false
	--CallSecureProtected("BindKeyToAction", 12,1,4,2, 62,0,0,0,0) -- 12,1,4,2,62,0,0,0,0,Guild,,GUILD_4,false,true
	CallSecureProtected("BindKeyToAction", 1,21,1,2, 0,0,0,0,0) -- 1,21,1,2,0,0,0,0,0,General,|cFFAA33AlphaGear|r,SHOW_AG_WINDOW,true,false
	CallSecureProtected("BindKeyToAction", 1,21,20,3, 0,0,0,0,0) -- 1,21,20,3,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_15,true,false
	CallSecureProtected("BindKeyToAction", 1,2,22,1, 132,0,0,0,0) -- 1,2,22,1,132,0,0,0,0,General,Combat,GAMEPAD_ACTION_BUTTON_7,true,true
	CallSecureProtected("BindKeyToAction", 1,6,28,1, 107,0,0,0,0) -- 1,6,28,1,107,0,0,0,0,General,User Interface,TOGGLE_HUD_UI,true,false
	CallSecureProtected("BindKeyToAction", 1,26,18,2, 0,0,0,0,0) -- 1,26,18,2,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_PLAYER_3,true,false
	CallSecureProtected("BindKeyToAction", 1,26,18,1, 0,0,0,0,0) -- 1,26,18,1,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_PLAYER_3,true,false
	CallSecureProtected("BindKeyToAction", 1,6,6,1, 57,0,0,0,0) -- 1,6,6,1,57,0,0,0,0,General,User Interface,TOGGLE_SHOW_INGAME_GUI,true,false
	CallSecureProtected("BindKeyToAction", 1,26,17,4, 0,0,0,0,0) -- 1,26,17,4,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_PLAYER_2,true,false
	--CallSecureProtected("BindKeyToAction", 3,1,11,3, 0,0,0,0,0) -- 3,1,11,3,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_RIGHT_TRIGGER,false,true
	CallSecureProtected("BindKeyToAction", 1,2,14,4, 0,0,0,0,0) -- 1,2,14,4,0,0,0,0,0,General,Combat,ACTION_BUTTON_7,true,false
	--CallSecureProtected("BindKeyToAction", 31,1,1,1, 4,0,0,0,0) -- 31,1,1,1,4,0,0,0,0,ScryingActions,,,false,true
	CallSecureProtected("BindKeyToAction", 1,3,1,4, 0,0,0,0,0) -- 1,3,1,4,0,0,0,0,0,General,Targeting,CYCLE_PREFERRED_ENEMY_TARGET,true,false
	CallSecureProtected("BindKeyToAction", 1,26,17,1, 0,0,0,0,0) -- 1,26,17,1,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_PLAYER_2,true,false
	CallSecureProtected("BindKeyToAction", 1,21,6,3, 0,0,0,0,0) -- 1,21,6,3,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_1,true,false
	CallSecureProtected("BindKeyToAction", 6,1,1,4, 0,0,0,0,0) -- 6,1,1,4,0,0,0,0,0,Notifications,,PLAYER_TO_PLAYER_INTERACT_ACCEPT,true,false
	CallSecureProtected("BindKeyToAction", 1,26,16,1, 0,0,0,0,0) -- 1,26,16,1,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_PLAYER_1,true,false
	CallSecureProtected("BindKeyToAction", 1,6,17,2, 0,0,0,0,0) -- 1,6,17,2,0,0,0,0,0,General,User Interface,TOGGLE_CONTACTS,true,false
	CallSecureProtected("BindKeyToAction", 1,1,9,3, 0,0,0,0,0) -- 1,1,9,3,0,0,0,0,0,General,Movement,TOGGLE_MOUNT,true,false
	CallSecureProtected("BindKeyToAction", 1,26,15,2, 0,0,0,0,0) -- 1,26,15,2,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_ZONE_5,true,false
	CallSecureProtected("BindKeyToAction", 1,6,15,3, 0,0,0,0,0) -- 1,6,15,3,0,0,0,0,0,General,User Interface,TOGGLE_MAP,true,false
	CallSecureProtected("BindKeyToAction", 1,26,15,1, 0,0,0,0,0) -- 1,26,15,1,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_ZONE_5,true,false
	CallSecureProtected("BindKeyToAction", 1,7,7,2, 0,0,0,0,0) -- 1,7,7,2,0,0,0,0,0,General,Mini Map,VOTANS_TOGGLE_MAP_ZOOM_MINUS,true,false
	CallSecureProtected("BindKeyToAction", 1,7,3,4, 0,0,0,0,0) -- 1,7,3,4,0,0,0,0,0,General,Mini Map,VOTANS_TOGGLE_MAP_SHOW_COMBAT,true,false
	CallSecureProtected("BindKeyToAction", 1,6,21,1, 0,0,0,0,0) -- 1,6,21,1,0,0,0,0,0,General,User Interface,TOGGLE_NOTIFICATIONS,true,false
	CallSecureProtected("BindKeyToAction", 1,2,2,2, 137,0,0,0,0) -- 1,2,2,2,137,0,0,0,0,General,Combat,SPECIAL_MOVE_BLOCK,true,false
	CallSecureProtected("BindKeyToAction", 1,6,15,1, 44,0,0,0,0) -- 1,6,15,1,44,0,0,0,0,General,User Interface,TOGGLE_MAP,true,false
	--CallSecureProtected("BindKeyToAction", 11,1,2,4, 0,0,0,0,0) -- 11,1,2,4,0,0,0,0,0,PreviewInterceptLayer,,INTERCEPT_AUTORUN,false,true
	CallSecureProtected("BindKeyToAction", 1,18,13,2, 0,0,0,0,0) -- 1,18,13,2,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMACRAFTTOGGLE,true,false
	CallSecureProtected("BindKeyToAction", 1,21,11,4, 0,0,0,0,0) -- 1,21,11,4,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_6,true,false
	CallSecureProtected("BindKeyToAction", 1,1,5,2, 0,0,0,0,0) -- 1,1,5,2,0,0,0,0,0,General,Movement,TURN_RIGHT,true,false
	CallSecureProtected("BindKeyToAction", 1,21,20,4, 0,0,0,0,0) -- 1,21,20,4,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_15,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,9,2, 0,0,0,0,0) -- 10,1,9,2,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_CHAMPION,false,true
	--CallSecureProtected("BindKeyToAction", 13,1,7,2, 65,0,0,0,0) -- 13,1,7,2,65,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_7,false,true
	CallSecureProtected("BindKeyToAction", 1,2,15,2, 0,0,0,0,0) -- 1,2,15,2,0,0,0,0,0,General,Combat,ACTION_BUTTON_8,true,false
	CallSecureProtected("BindKeyToAction", 1,26,12,1, 38,7,0,0,0) -- 1,26,12,1,38,7,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_ZONE_2,true,false
	CallSecureProtected("BindKeyToAction", 1,2,19,4, 0,0,0,0,0) -- 1,2,19,4,0,0,0,0,0,General,Combat,GAMEPAD_ACTION_BUTTON_4,true,true
	CallSecureProtected("BindKeyToAction", 1,26,10,3, 0,0,0,0,0) -- 1,26,10,3,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_GUILD_HOUSE,true,false
	CallSecureProtected("BindKeyToAction", 1,2,2,1, 115,0,0,0,0) -- 1,2,2,1,115,0,0,0,0,General,Combat,SPECIAL_MOVE_BLOCK,true,false
	CallSecureProtected("BindKeyToAction", 1,26,12,2, 0,0,0,0,0) -- 1,26,12,2,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_ZONE_2,true,false
	CallSecureProtected("BindKeyToAction", 1,2,25,2, 0,0,0,0,0) -- 1,2,25,2,0,0,0,0,0,General,Combat,UI_SHORTCUT_EMOTES_QUICK_SLOTS,true,false
	--CallSecureProtected("BindKeyToAction", 9,1,8,2, 66,0,0,0,0) -- 9,1,8,2,66,0,0,0,0,Conversation,,CONVERSATION_OPTION_8,false,true
	CallSecureProtected("BindKeyToAction", 1,26,9,3, 0,0,0,0,0) -- 1,26,9,3,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_PRIMARY_RESIDENCE,true,false
	CallSecureProtected("BindKeyToAction", 1,1,7,3, 0,0,0,0,0) -- 1,1,7,3,0,0,0,0,0,General,Movement,AUTORUN,true,false
	CallSecureProtected("BindKeyToAction", 1,6,30,1, 0,0,0,0,0) -- 1,6,30,1,0,0,0,0,0,General,User Interface,TOGGLE_NAMEPLATES,true,false
	CallSecureProtected("BindKeyToAction", 1,25,10,3, 0,0,0,0,0) -- 1,25,10,3,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_9,true,false
	CallSecureProtected("BindKeyToAction", 1,26,7,1, 0,0,0,0,0) -- 1,26,7,1,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_REFRESH,true,false
	CallSecureProtected("BindKeyToAction", 1,18,5,1, 0,0,0,0,0) -- 1,18,5,1,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMAALTMODECHANGE,true,false
	--CallSecureProtected("BindKeyToAction", 26,1,4,1, 120,0,0,0,0) -- 26,1,4,1,120,0,0,0,0,BattlegroundScoreboard,,BATTLEGROUND_SCOREBOARD_NEXT,false,true
	CallSecureProtected("BindKeyToAction", 1,26,6,3, 0,0,0,0,0) -- 1,26,6,3,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_WAYSHRINE_UNLOCK,true,false
	--CallSecureProtected("BindKeyToAction", 4,1,6,3, 0,0,0,0,0) -- 4,1,6,3,0,0,0,0,0,Siege,,,false,true
	CallSecureProtected("BindKeyToAction", 1,11,6,1, 0,0,0,0,0) -- 1,11,6,1,0,0,0,0,0,General,CombatMetrics,CMX_POST_HPS,true,false
	CallSecureProtected("BindKeyToAction", 1,7,3,1, 0,0,0,0,0) -- 1,7,3,1,0,0,0,0,0,General,Mini Map,VOTANS_TOGGLE_MAP_SHOW_COMBAT,true,false
	--CallSecureProtected("BindKeyToAction", 9,1,1,2, 59,0,0,0,0) -- 9,1,1,2,59,0,0,0,0,Conversation,,CONVERSATION_OPTION_1,false,true
	CallSecureProtected("BindKeyToAction", 1,6,2,3, 0,0,0,0,0) -- 1,6,2,3,0,0,0,0,0,General,User Interface,TAKE_SCREENSHOT,true,false
	--CallSecureProtected("BindKeyToAction", 9,1,2,2, 60,0,0,0,0) -- 9,1,2,2,60,0,0,0,0,Conversation,,CONVERSATION_OPTION_2,false,true
	CallSecureProtected("BindKeyToAction", 1,21,6,2, 0,0,0,0,0) -- 1,21,6,2,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_1,true,false
	CallSecureProtected("BindKeyToAction", 1,25,8,2, 0,0,0,0,0) -- 1,25,8,2,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_7,true,false
	CallSecureProtected("BindKeyToAction", 1,26,1,1, 0,0,0,0,0) -- 1,26,1,1,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_TOGGLE_MAIN,true,false
	--CallSecureProtected("BindKeyToAction", 12,1,3,3, 0,0,0,0,0) -- 12,1,3,3,0,0,0,0,0,Guild,,GUILD_3,false,true
	CallSecureProtected("BindKeyToAction", 1,6,8,3, 0,0,0,0,0) -- 1,6,8,3,0,0,0,0,0,General,User Interface,TOGGLE_MARKET,true,false
	CallSecureProtected("BindKeyToAction", 1,18,3,3, 0,0,0,0,0) -- 1,18,3,3,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMATABCHANGE,true,false
	CallSecureProtected("BindKeyToAction", 1,25,10,1, 0,0,0,0,0) -- 1,25,10,1,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_9,true,false
	CallSecureProtected("BindKeyToAction", 1,6,21,2, 0,0,0,0,0) -- 1,6,21,2,0,0,0,0,0,General,User Interface,TOGGLE_NOTIFICATIONS,true,false
	CallSecureProtected("BindKeyToAction", 1,2,11,3, 0,0,0,0,0) -- 1,2,11,3,0,0,0,0,0,General,Combat,ACTION_BUTTON_4,true,false
	CallSecureProtected("BindKeyToAction", 1,16,1,3, 0,0,0,0,0) -- 1,16,1,3,0,0,0,0,0,General,|cFFFF00Minceraft's Binds|r,RELOAD,true,false
	CallSecureProtected("BindKeyToAction", 1,25,9,2, 0,0,0,0,0) -- 1,25,9,2,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_8,true,false
	CallSecureProtected("BindKeyToAction", 1,20,3,4, 0,0,0,0,0) -- 1,20,3,4,0,0,0,0,0,General,|c3366FFBank|r Manager |c990000Revived|r,BMR_PROFILE3,true,false
	CallSecureProtected("BindKeyToAction", 1,5,1,3, 0,0,0,0,0) -- 1,5,1,3,0,0,0,0,0,General,Interaction,GAME_CAMERA_INTERACT,true,false
	CallSecureProtected("BindKeyToAction", 1,25,8,1, 0,0,0,0,0) -- 1,25,8,1,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_7,true,false
	--CallSecureProtected("BindKeyToAction", 27,1,1,2, 0,0,0,0,0) -- 27,1,1,2,0,0,0,0,0,ScreenshotMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,25,7,1, 0,0,0,0,0) -- 1,25,7,1,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_6,true,false
	CallSecureProtected("BindKeyToAction", 1,2,17,4, 0,0,0,0,0) -- 1,2,17,4,0,0,0,0,0,General,Combat,GAMEPAD_MOVE_JUMPASCEND,true,true
	CallSecureProtected("BindKeyToAction", 3,1,6,2, 0,0,0,0,0) -- 3,1,6,2,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_REPORT_PLAYER,true,false
	CallSecureProtected("BindKeyToAction", 1,6,29,3, 0,0,0,0,0) -- 1,6,29,3,0,0,0,0,0,General,User Interface,TOGGLE_GAMEPAD_MODE,true,false
	CallSecureProtected("BindKeyToAction", 1,26,11,2, 0,0,0,0,0) -- 1,26,11,2,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_ZONE_1,true,false
	CallSecureProtected("BindKeyToAction", 1,18,16,1, 0,0,0,0,0) -- 1,18,16,1,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMAGUILDTOGGLE,true,false
	CallSecureProtected("BindKeyToAction", 1,2,20,3, 0,0,0,0,0) -- 1,2,20,3,0,0,0,0,0,General,Combat,GAMEPAD_ACTION_BUTTON_5,true,true
	CallSecureProtected("BindKeyToAction", 1,18,5,2, 0,0,0,0,0) -- 1,18,5,2,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMAALTMODECHANGE,true,false
	CallSecureProtected("BindKeyToAction", 1,2,20,4, 0,0,0,0,0) -- 1,2,20,4,0,0,0,0,0,General,Combat,GAMEPAD_ACTION_BUTTON_5,true,true
	CallSecureProtected("BindKeyToAction", 1,7,1,4, 0,0,0,0,0) -- 1,7,1,4,0,0,0,0,0,General,Mini Map,VOTANS_TOGGLE_MAP_SHOW,true,false
	CallSecureProtected("BindKeyToAction", 1,24,1,1, 33,0,0,0,0) -- 1,24,1,1,33,0,0,0,0,General,CraftStore,SHOW_CRAFTSTOREFIXED_WINDOW,true,false
	CallSecureProtected("BindKeyToAction", 1,4,4,4, 0,0,0,0,0) -- 1,4,4,4,0,0,0,0,0,General,Camera,GAME_CAMERA_GAMEPAD_ZOOM,true,false
	CallSecureProtected("BindKeyToAction", 1,6,31,4, 0,0,0,0,0) -- 1,6,31,4,0,0,0,0,0,General,User Interface,TOGGLE_HEALTHBARS,true,false
	CallSecureProtected("BindKeyToAction", 1,4,2,3, 0,0,0,0,0) -- 1,4,2,3,0,0,0,0,0,General,Camera,CAMERA_ZOOM_IN,true,false
	CallSecureProtected("BindKeyToAction", 1,2,19,2, 0,0,0,0,0) -- 1,2,19,2,0,0,0,0,0,General,Combat,GAMEPAD_ACTION_BUTTON_4,true,true
	--CallSecureProtected("BindKeyToAction", 4,1,6,1, 121,0,0,0,0) -- 4,1,6,1,121,0,0,0,0,Siege,,,false,true
	CallSecureProtected("BindKeyToAction", 1,26,4,2, 0,0,0,0,0) -- 1,26,4,2,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_TOGGLE_MAIN_CURRENT_ZONE,true,false
	CallSecureProtected("BindKeyToAction", 1,18,9,2, 0,0,0,0,0) -- 1,18,9,2,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMACLNDTOGGLE,true,false
	CallSecureProtected("BindKeyToAction", 1,4,4,2, 0,0,0,0,0) -- 1,4,4,2,0,0,0,0,0,General,Camera,GAME_CAMERA_GAMEPAD_ZOOM,true,false
	CallSecureProtected("BindKeyToAction", 1,23,1,3, 0,0,0,0,0) -- 1,23,1,3,0,0,0,0,0,General,Mail Looter,MAILLOOTER_OPEN,true,false
	CallSecureProtected("BindKeyToAction", 29,1,6,2, 124,0,0,0,0) -- 29,1,6,2,124,0,0,0,0,Housing Editor Placement Mode,,HOUSING_EDITOR_PITCH_BACKWARD,true,false
	CallSecureProtected("BindKeyToAction", 1,18,8,2, 0,0,0,0,0) -- 1,18,8,2,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMACHARTOGGLE,true,false
	CallSecureProtected("BindKeyToAction", 1,15,2,3, 0,0,0,0,0) -- 1,15,2,3,0,0,0,0,0,General,Vacuum Shop,VACUUM_LEFT,true,false
	CallSecureProtected("BindKeyToAction", 1,9,2,2, 0,0,0,0,0) -- 1,9,2,2,0,0,0,0,0,General,|cFF6A00Mass Deconstructor|r,MD_DECONSTRUCTOR_REFINE_ALL,true,false
	CallSecureProtected("BindKeyToAction", 1,21,17,1, 0,0,0,0,0) -- 1,21,17,1,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_12,true,false
	CallSecureProtected("BindKeyToAction", 1,6,22,2, 0,0,0,0,0) -- 1,6,22,2,0,0,0,0,0,General,User Interface,TOGGLE_ACTIVITY_FINDER,true,false
	CallSecureProtected("BindKeyToAction", 1,21,16,4, 0,0,0,0,0) -- 1,21,16,4,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_11,true,false
	CallSecureProtected("BindKeyToAction", 1,13,2,1, 0,0,0,0,0) -- 1,13,2,1,0,0,0,0,0,General,|c4B8BFETimer,IP_TIMER_STOP,true,false
	CallSecureProtected("BindKeyToAction", 1,1,4,3, 141,0,0,0,0) -- 1,1,4,3,141,0,0,0,0,General,Movement,TURN_LEFT,true,false
	CallSecureProtected("BindKeyToAction", 1,20,7,2, 0,0,0,0,0) -- 1,20,7,2,0,0,0,0,0,General,|c3366FFBank|r Manager |c990000Revived|r,BMR_PROFILE7,true,false
	CallSecureProtected("BindKeyToAction", 1,2,9,4, 0,0,0,0,0) -- 1,2,9,4,0,0,0,0,0,General,Combat,SPECIAL_MOVE_WEAPON_SWAP_TO_SET_2,true,false
	CallSecureProtected("BindKeyToAction", 1,21,14,2, 0,0,0,0,0) -- 1,21,14,2,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_9,true,false
	CallSecureProtected("BindKeyToAction", 1,26,14,1, 0,0,0,0,0) -- 1,26,14,1,0,0,0,0,0,General,|cd5b526BeamMeUp|r - Teleporter,BMU_FAVORITE_ZONE_4,true,false
	CallSecureProtected("BindKeyToAction", 1,21,9,3, 0,0,0,0,0) -- 1,21,9,3,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_4,true,false
	--CallSecureProtected("BindKeyToAction", 28,1,27,2, 0,0,0,0,0) -- 28,1,27,2,0,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,21,3,1, 0,0,0,0,0) -- 1,21,3,1,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_NEXT_SET,true,false
	CallSecureProtected("BindKeyToAction", 1,21,14,4, 0,0,0,0,0) -- 1,21,14,4,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_9,true,false
	CallSecureProtected("BindKeyToAction", 1,12,2,3, 0,0,0,0,0) -- 1,12,2,3,0,0,0,0,0,General,Foundry Tactical Combat,DISPLAY_DAMAGE_REPORT,true,false
	CallSecureProtected("BindKeyToAction", 1,6,31,2, 0,0,0,0,0) -- 1,6,31,2,0,0,0,0,0,General,User Interface,TOGGLE_HEALTHBARS,true,false
	CallSecureProtected("BindKeyToAction", 1,21,2,4, 0,0,0,0,0) -- 1,21,2,4,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_UNDRESS,true,false
	CallSecureProtected("BindKeyToAction", 1,21,1,4, 0,0,0,0,0) -- 1,21,1,4,0,0,0,0,0,General,|cFFAA33AlphaGear|r,SHOW_AG_WINDOW,true,false
	CallSecureProtected("BindKeyToAction", 1,1,7,2, 116,0,0,0,0) -- 1,1,7,2,116,0,0,0,0,General,Movement,AUTORUN,true,false
	CallSecureProtected("BindKeyToAction", 1,11,2,3, 0,0,0,0,0) -- 1,11,2,3,0,0,0,0,0,General,CombatMetrics,CMX_POST_DPS,true,false
	CallSecureProtected("BindKeyToAction", 3,1,7,3, 0,0,0,0,0) -- 3,1,7,3,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_QUICK_SLOTS,true,false
	CallSecureProtected("BindKeyToAction", 1,1,2,2, 0,0,0,0,0) -- 1,1,2,2,0,0,0,0,0,General,Movement,MOVE_BACKWARD,true,false
	CallSecureProtected("BindKeyToAction", 1,7,7,4, 0,0,0,0,0) -- 1,7,7,4,0,0,0,0,0,General,Mini Map,VOTANS_TOGGLE_MAP_ZOOM_MINUS,true,false
	--CallSecureProtected("BindKeyToAction", 5,1,10,2, 0,0,0,0,0) -- 5,1,10,2,0,0,0,0,0,Dialogs,,,false,true
	CallSecureProtected("BindKeyToAction", 1,20,4,4, 0,0,0,0,0) -- 1,20,4,4,0,0,0,0,0,General,|c3366FFBank|r Manager |c990000Revived|r,BMR_PROFILE4,true,false
	CallSecureProtected("BindKeyToAction", 1,12,4,1, 0,0,0,0,0) -- 1,12,4,1,0,0,0,0,0,General,Foundry Tactical Combat,REFRESH_FRAMES,true,false
	CallSecureProtected("BindKeyToAction", 1,2,24,1, 48,0,0,0,0) -- 1,2,24,1,48,0,0,0,0,General,Combat,ACTION_BUTTON_9,true,false
	CallSecureProtected("BindKeyToAction", 1,2,3,1, 7,0,0,0,0) -- 1,2,3,1,7,0,0,0,0,General,Combat,SPECIAL_MOVE_SPRINT,true,false
	CallSecureProtected("BindKeyToAction", 1,18,24,4, 0,0,0,0,0) -- 1,18,24,4,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMALFGPMODE,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,3,3, 0,0,0,0,0) -- 10,1,3,3,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_SYSTEM,false,true
	CallSecureProtected("BindKeyToAction", 1,14,1,2, 0,0,0,0,0) -- 1,14,1,2,0,0,0,0,0,General,Urich's Skill Point Finder,USPF_TOGGLE,true,false
	CallSecureProtected("BindKeyToAction", 1,2,27,2, 0,0,0,0,0) -- 1,2,27,2,0,0,0,0,0,General,Combat,COMMAND_PET,true,false
	CallSecureProtected("BindKeyToAction", 1,6,7,2, 127,0,0,0,0) -- 1,6,7,2,127,0,0,0,0,General,User Interface,TOGGLE_GAME_CAMERA_UI_MODE,true,false
	CallSecureProtected("BindKeyToAction", 1,18,17,4, 0,0,0,0,0) -- 1,18,17,4,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMACYRODIILTOGGLE,true,false
	CallSecureProtected("BindKeyToAction", 1,25,5,4, 0,0,0,0,0) -- 1,25,5,4,0,0,0,0,0,General,Port to Friend's House,PORTTOFRIENDSHOUSE_FAV_4,true,false
	--CallSecureProtected("BindKeyToAction", 2,1,8,1, 0,0,0,0,0) -- 2,1,8,1,0,0,0,0,0,GamepadUIMode,,,false,true
	CallSecureProtected("BindKeyToAction", 1,21,18,2, 0,0,0,0,0) -- 1,21,18,2,0,0,0,0,0,General,|cFFAA33AlphaGear|r,AG_SET_13,true,false
	CallSecureProtected("BindKeyToAction", 1,5,2,1, 37,0,0,0,0) -- 1,5,2,1,37,0,0,0,0,General,Interaction,PLAYER_TO_PLAYER_INTERACT,true,false
	CallSecureProtected("BindKeyToAction", 1,6,8,2, 0,0,0,0,0) -- 1,6,8,2,0,0,0,0,0,General,User Interface,TOGGLE_MARKET,true,false
	CallSecureProtected("BindKeyToAction", 1,6,22,4, 0,0,0,0,0) -- 1,6,22,4,0,0,0,0,0,General,User Interface,TOGGLE_ACTIVITY_FINDER,true,false
	CallSecureProtected("BindKeyToAction", 1,18,9,3, 0,0,0,0,0) -- 1,18,9,3,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMACLNDTOGGLE,true,false
	CallSecureProtected("BindKeyToAction", 1,2,5,1, 119,0,0,0,0) -- 1,2,5,1,119,0,0,0,0,General,Combat,SPECIAL_MOVE_INTERRUPT,true,false
	CallSecureProtected("BindKeyToAction", 1,6,2,4, 0,0,0,0,0) -- 1,6,2,4,0,0,0,0,0,General,User Interface,TAKE_SCREENSHOT,true,false
	CallSecureProtected("BindKeyToAction", 1,1,8,1, 161,0,0,0,0) -- 1,1,8,1,161,0,0,0,0,General,Movement,ROLL_DODGE,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,7,3, 0,0,0,0,0) -- 10,1,7,3,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_CHARACTER,false,true
	--CallSecureProtected("BindKeyToAction", 28,1,5,3, 142,0,0,0,0) -- 28,1,5,3,142,0,0,0,0,Housing Editor,,,false,true
	CallSecureProtected("BindKeyToAction", 1,15,1,1, 111,0,0,0,0) -- 1,15,1,1,111,0,0,0,0,General,Vacuum Shop,VACUUM_RIGHT,true,false
	CallSecureProtected("BindKeyToAction", 1,1,3,3, 0,0,0,0,0) -- 1,1,3,3,0,0,0,0,0,General,Movement,TOGGLE_WALK,true,false
	CallSecureProtected("BindKeyToAction", 1,2,11,4, 0,0,0,0,0) -- 1,2,11,4,0,0,0,0,0,General,Combat,ACTION_BUTTON_4,true,false
	CallSecureProtected("BindKeyToAction", 1,2,13,1, 26,0,0,0,0) -- 1,2,13,1,26,0,0,0,0,General,Combat,ACTION_BUTTON_6,true,false
	--CallSecureProtected("BindKeyToAction", 17,1,2,2, 134,0,0,0,0) -- 17,1,2,2,134,0,0,0,0,GamepadChatSystem,,CANCEL_CHAT,false,true
	CallSecureProtected("BindKeyToAction", 1,18,5,4, 0,0,0,0,0) -- 1,18,5,4,0,0,0,0,0,General,|c779cffWPamA|r (What Pledges at my Alts),WPAMAALTMODECHANGE,true,false
	CallSecureProtected("BindKeyToAction", 1,6,15,4, 0,0,0,0,0) -- 1,6,15,4,0,0,0,0,0,General,User Interface,TOGGLE_MAP,true,false
	CallSecureProtected("BindKeyToAction", 1,11,2,4, 0,0,0,0,0) -- 1,11,2,4,0,0,0,0,0,General,CombatMetrics,CMX_POST_DPS,true,false
	CallSecureProtected("BindKeyToAction", 1,6,28,3, 0,0,0,0,0) -- 1,6,28,3,0,0,0,0,0,General,User Interface,TOGGLE_HUD_UI,true,false
	CallSecureProtected("BindKeyToAction", 1,11,4,4, 0,0,0,0,0) -- 1,11,4,4,0,0,0,0,0,General,CombatMetrics,CMX_POST_DPS_SINGLE,true,false
	CallSecureProtected("BindKeyToAction", 1,6,4,1, 108,0,0,0,0) -- 1,6,4,1,108,0,0,0,0,General,User Interface,START_CHAT_SLASH,true,false
	CallSecureProtected("BindKeyToAction", 3,1,4,3, 0,0,0,0,0) -- 3,1,4,3,0,0,0,0,0,User Interface Shortcuts,,UI_SHORTCUT_QUATERNARY,true,false
	CallSecureProtected("BindKeyToAction", 1,6,6,4, 0,0,0,0,0) -- 1,6,6,4,0,0,0,0,0,General,User Interface,TOGGLE_SHOW_INGAME_GUI,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,8,3, 0,0,0,0,0) -- 10,1,8,3,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_TOGGLE_SKILLS,false,true
	CallSecureProtected("BindKeyToAction", 1,4,3,3, 0,0,0,0,0) -- 1,4,3,3,0,0,0,0,0,General,Camera,GAME_CAMERA_MOUSE_FREE_LOOK,true,false
	--CallSecureProtected("BindKeyToAction", 10,1,2,3, 0,0,0,0,0) -- 10,1,2,3,0,0,0,0,0,SceneChangeInterceptLayer,,INTERCEPT_UI_SHORTCUT_NEGATIVE,false,true
	CallSecureProtected("BindKeyToAction", 1,1,2,4, 0,0,0,0,0) -- 1,1,2,4,0,0,0,0,0,General,Movement,MOVE_BACKWARD,true,false
	CallSecureProtected("BindKeyToAction", 1,15,1,2, 0,0,0,0,0) -- 1,15,1,2,0,0,0,0,0,General,Vacuum Shop,VACUUM_RIGHT,true,false
	CallSecureProtected("BindKeyToAction", 1,2,5,4, 0,0,0,0,0) -- 1,2,5,4,0,0,0,0,0,General,Combat,SPECIAL_MOVE_INTERRUPT,true,false
	--CallSecureProtected("BindKeyToAction", 13,1,3,1, 25,0,0,0,0) -- 13,1,3,1,25,0,0,0,0,SetGuildRankDialog,,SET_GUILD_RANK_3,false,true
end
