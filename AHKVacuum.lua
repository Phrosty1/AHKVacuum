-- For menu & data
AHKVacuum = {}
AHKVacuum.name = "AHKVacuum"
AHKVacuum.savedVars = {}
local ptk = LibPixelControl
local verbose = true -- false
local GetGameTimeMillisecondsLoc = GetGameTimeMilliseconds
local ms_time = GetGameTimeMillisecondsLoc()
local function dmsg(txt)
	if verbose then
		d((GetGameTimeMillisecondsLoc() - ms_time) .. ") " .. txt)
		ms_time = GetGameTimeMillisecondsLoc()
	end
end
local function newIndexedSet(...)
	local retval = {}
	for _,value in pairs({...}) do retval[value] = true end
	return retval
end
local actionsToTakeByDefault = newIndexedSet("Search","Take","Collect","Mine","Cut","Unlock","Dig","Dig Up","Fish","Reel In")
local blacklist = newIndexedSet("Bookshelf","Book Stack", "Spoiled Food","Greatsword","Sword","Axe","Bow","Shield","Staff","Sabatons","Jerkin","Dagger","Cuirass","Pauldron","Helm","Gauntlets","Guards","Boots","Shoes","Wasp","Fleshflies","Butterfly","Torchbug")
local whitelist = newIndexedSet("Giant Clam", "Platinum Seam", "Heavy Sack", "Heavy Crate", "Chest", "Hidden Treasure", "Dirt Mound")
-- Local references for eso functions
local IsPlayerTryingToMoveLoc = IsPlayerTryingToMove -- Returns: boolean tryingToMove
local IsMountedLoc = IsMounted -- Returns: boolean mounted
local GetGameCameraInteractableActionInfoLoc = GetGameCameraInteractableActionInfo -- Returns: string:nilable action, string:nilable name, boolean interactBlocked, boolean isOwned, number additionalInfo, number:nilable contextualInfo, string:nilable contextualLink, boolean isCriminalInteract
local IsUnitInCombatLoc = IsUnitInCombat -- (string unitTag) Returns: boolean isInCombat
-- Local variables
local curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract
local wasMovingBeforeLooting = false -- IsPlayerTryingToMoveLoc()
local wasMountedBeforeLooting = false -- IsMountedLoc()
local isPressingKey = false
local isInteracting = false
local doRidePickupAll = false

local function tapE()
	--ptk.SetIndOff(ptk.VK_SHIFT)
	ptk.SetIndOnFor(ptk.VK_E, 50)
end
local function tapT()
	ptk.SetIndOnFor(ptk.VK_T, 50)
	--zo_callLater(function() ptk.SetIndOn(ptk.VK_SHIFT) end, 100)
end
local function tapH()
	ptk.SetIndOnFor(ptk.VK_H, 50)
end
function AHKVacuum:ShopDirectionRightOn()  ptk.SetIndOn (ptk.VK_D) end
function AHKVacuum:ShopDirectionRightOff() ptk.SetIndOff(ptk.VK_D) end
function AHKVacuum:ShopDirectionLeftOn()   ptk.SetIndOn (ptk.VK_A) end
function AHKVacuum:ShopDirectionLeftOff()  ptk.SetIndOff(ptk.VK_A) end
function AHKVacuum:ShopDirectionUpOn()     ptk.SetIndOn (ptk.VK_W) end
function AHKVacuum:ShopDirectionUpOff()    ptk.SetIndOff(ptk.VK_W) end
--function AHKVacuum:ShopDirectionDownOn()   ptk.SetIndOn (ptk.VK_S) end
--function AHKVacuum:ShopDirectionDownOff()  ptk.SetIndOff(ptk.VK_S) end
function AHKVacuum:ShopDirectionDownOn()
	local action, interactableName, interactBlocked, isOwned, additionalInfo, contextualInfo, contextualLink, isCriminalInteract = GetGameCameraInteractableActionInfo()
	d("".." act:"..tostring(action)
		.." nm:"..tostring(interactableName)
		.." blk:"..tostring(interactBlocked)
		.." own:"..tostring(isOwned)
		.." addInfo:"..tostring(additionalInfo)--.."-"..tostring(gameCameraAdditionalInfo[additionalInfo])
		.." ctxInfo:"..tostring(contextualInfo)
		.." ctxLink:"..tostring(contextualLink)
		.." crim:"..tostring(isCriminalInteract))
	--local interactionExists, interactionAvailableNow, questInteraction, questTargetBased, questJournalIndex, questToolIndex, questToolOnCooldown = GetGameCameraInteractableInfo()
	--d("".." interactionExists:"..tostring(interactionExists)
	--	.." interactionAvailableNow:"..tostring(interactionAvailableNow)
	--	.." questInteraction:"..tostring(questInteraction)
	--	.." questTargetBased:"..tostring(questTargetBased)
	--	.." questJournalIndex:"..tostring(questJournalIndex)
	--	.." questToolIndex:"..tostring(questToolIndex)
	--	.." questToolOnCooldown:"..tostring(questToolOnCooldown))
	--d("reticleUnitType:"..tostring(GetUnitType("reticleover")))
	--d("reticleRawUnitName:"..tostring(GetRawUnitName("reticleover")))
	d("IsReticleTargetInteractable:"..tostring(ZO_PlayerToPlayer:IsReticleTargetInteractable()))
	--ZO_PlayerToPlayer:IsReticleTargetInteractable
	d("isPressingKey:"..tostring(isPressingKey).." isInteracting:"..tostring(isInteracting))
end
function AHKVacuum:ShopDirectionDownOff() end
function AHKVacuum:ShopAutomoveToggle()
	if not doRidePickupAll then
		doRidePickupAll = true
		d("Horse Vacuum ON")
	else
		doRidePickupAll = false
		d("Horse Vacuum OFF")
	end
end

local function CurFocus()
	curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract = GetGameCameraInteractableActionInfoLoc()
	return " - "..tostring(curAction).."/"..tostring(curInteractableName)
end

local function IsCurFocusSetForInteract()
	if curAction ~= nil and curInteractableName ~= nil
		and not curInteractBlocked
		and not curIsCriminalInteract
		and (curAdditionalInfo == ADDITIONAL_INTERACT_INFO_NONE
			or curAdditionalInfo == ADDITIONAL_INTERACT_INFO_LOCKED
			or curAdditionalInfo == ADDITIONAL_INTERACT_INFO_FISHING_NODE)
		and blacklist[curInteractableName] == nil
		and (whitelist[curInteractableName] ~= nil
			or (actionsToTakeByDefault[curAction] ~= nil
				and (doRidePickupAll or not IsMountedLoc() )
				and not IsUnitInCombatLoc("player") ) )
	then
		return true
	else
		return false
	end
end

function AHKVacuum.OnReticleSet()
	if not isPressingKey and not isInteracting then
		curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract = GetGameCameraInteractableActionInfoLoc()
		if IsCurFocusSetForInteract() then
			if IsPlayerTryingToMoveLoc() then wasMovingBeforeLooting = true end
			if IsMountedLoc() then wasMountedBeforeLooting = true end
			isPressingKey = true
			ptk.SetIndOnFor(ptk.VK_E, 50)
			--if wasMountedBeforeLooting then
			--	zo_callLater(function() isPressingKey = false end, 1000)
			--else
			--	zo_callLater(function() isPressingKey = false end, 100)
			--end
			dmsg("curInteractableName:"..tostring(curInteractableName).." Pressing:"..tostring(isPressingKey).." isInteracting:"..tostring(isInteracting))
		end

	end
end
function AHKVacuum.OnBeginInteracting()
	isPressingKey = false
	isInteracting = true
	dmsg("ONBEGININTERACTING OnBeginInteracting".." Pressing:"..tostring(isPressingKey).." isInteracting:"..tostring(isInteracting))
end
function AHKVacuum.OnFinishInteracting()
	if isInteracting then
		dmsg("OnFinishInteracting")
		isPressingKey = false
		isInteracting = false
		-- Since we finished, do a manual check to determine whether to interact again or resume actions
		AHKVacuum.OnReticleSet()
		dmsg("after OnReticleSet movement:".." NextItem:"..tostring(curInteractableName).." Pressing:"..tostring(isPressingKey).." isInteracting:"..tostring(isInteracting))
		if not isPressingKey then
			if wasMountedBeforeLooting and wasMovingBeforeLooting then
				d("wasMountedBeforeLooting and wasMovingBeforeLooting")
				isPressingKey = true
				zo_callLater(tapH, 0)
				zo_callLater(tapT, 200)
				zo_callLater(function() isPressingKey = false end, 400)
			elseif wasMovingBeforeLooting then
				d("wasMovingBeforeLooting")
				isPressingKey = true
				zo_callLater(tapT, 0)
				zo_callLater(function() isPressingKey = false end, 200)
			elseif wasMountedBeforeLooting then
				d("wasMountedBeforeLooting")
				isPressingKey = true
				zo_callLater(tapH, 0)
				zo_callLater(function() isPressingKey = false end, 200)
			end
			wasMountedBeforeLooting = false
			wasMovingBeforeLooting = false
		end
	end
end


function AHKVacuum:Initialize()
	ZO_CreateStringId("SI_BINDING_NAME_VACUUM_AUTOMOVE", "Vacuum Shop Automove")
	ZO_CreateStringId("SI_BINDING_NAME_VACUUM_RIGHT", "Vacuum Shop Right")
	ZO_CreateStringId("SI_BINDING_NAME_VACUUM_LEFT", "Vacuum Shop Left")
	ZO_CreateStringId("SI_BINDING_NAME_VACUUM_UP", "Vacuum Shop Up")
	ZO_CreateStringId("SI_BINDING_NAME_VACUUM_DOWN", "Vacuum Shop Down")
	AHKVacuum.savedVars = ZO_SavedVars:NewAccountWide(AHKVacuum.name.."SavedVariables", 1, nil, {})

	ZO_PreHookHandler(RETICLE.interact, "OnEffectivelyShown", AHKVacuum.OnReticleSet)
	ZO_PreHookHandler(RETICLE.interact, "OnHide", AHKVacuum.OnReticleSet)
	SecurePostHook (ZO_Fishing, "StartInteraction", AHKVacuum.OnBeginInteracting) -- begin harvesting/fishing/searching/taking
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_CHATTER_END, AHKVacuum.OnFinishInteracting) -- end of harvesting/fishing/not-searching(should work with onLootClosed)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_LOOT_CLOSED, AHKVacuum.OnFinishInteracting) -- pretty good for indicating done with harvesting/searching
	--EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_LOOT_RECEIVED, AHKVacuum.OnFinishInteracting) -- pretty good for indicating fast looted
	--EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, AHKVacuum.OnFinishInteracting) -- when fishing finished
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_NO_INTERACT_TARGET, AHKVacuum.OnFinishInteracting) -- if the E misses
	-- Hits E twice when beginning fishing

	--SecurePostHook (ZO_Fishing, "StartInteraction", function() dmsg("StartInteraction"..CurFocus()) end)
	--EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."TXT", EVENT_CHATTER_END, function() dmsg("EVENT_CHATTER_END"..CurFocus()) end)
	--EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."TXT", EVENT_LOOT_CLOSED, function() dmsg("EVENT_LOOT_CLOSED"..CurFocus()) end)
	--EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."TXT", EVENT_LOOT_RECEIVED, function() dmsg("EVENT_LOOT_RECEIVED"..CurFocus()) end)
	--EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."TXT", EVENT_INVENTORY_SINGLE_SLOT_UPDATE, function() dmsg("EVENT_INVENTORY_SINGLE_SLOT_UPDATE"..CurFocus()) end)
	--EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."TXT", EVENT_NO_INTERACT_TARGET, function() dmsg("EVENT_NO_INTERACT_TARGET"..CurFocus()) end)

--Nothing
--XXXXX	StartInteraction -- Pressed E
--3		EVENT_NO_INTERACT_TARGET

--Fishing and catch
--XXXXX	StartInteraction (Fish/Lake Fishing Hole) -- Pressed E
--21000	EVENT_INVENTORY_SINGLE_SLOT_UPDATE (Reel In/Lake Fishing Hole)	-- Bait taken
--1500	StartInteraction (Reel In/Lake Fishing Hole) -- Pressed E
--100	EVENT_INVENTORY_SINGLE_SLOT_UPDATE (Fish/Lake Fishing Hole) -- Fish deposited?
--0		EVENT_LOOT_RECEIVED (Fish/Lake Fishing Hole)
--0		EVENT_LOOT_CLOSED (Fish/Lake Fishing Hole)
--0		EVENT_CHATTER_END (Fish/Lake Fishing Hole)

--Collect Water
--XXXXX	StartInteraction (Collect/Pure Water) -- Pressed E
--2000	EVENT_INVENTORY_SINGLE_SLOT_UPDATE (nil/nil) -- Ore deposited
--0		EVENT_LOOT_RECEIVED (nil/nil)
--0		EVENT_LOOT_CLOSED (nil/nil)
--0		EVENT_CHATTER_END (nil/nil)

--Mine Platinum
--XXXXX	StartInteraction (Mine/Platinum Seam) -- Pressed E
--1800	EVENT_INVENTORY_SINGLE_SLOT_UPDATE (nil/nil) -- Ore deposited
--0		EVENT_LOOT_RECEIVED (nil/nil)
--0		EVENT_INVENTORY_SINGLE_SLOT_UPDATE (nil/nil) -- Ochre deposited
--0		EVENT_LOOT_RECEIVED (nil/nil)
--0		EVENT_INVENTORY_SINGLE_SLOT_UPDATE (nil/nil) -- Potent Nirncrux deposited
--0		EVENT_LOOT_RECEIVED (nil/nil)
--0		EVENT_LOOT_CLOSED (nil/nil)
--0		EVENT_CHATTER_END (nil/nil)

--Backpack
--XXXXX	StartInteraction (Search/Backpack) -- Pressed E
--122	EVENT_INVENTORY_SINGLE_SLOT_UPDATE (Search/Backpack) -- Ore deposited
--0		EVENT_LOOT_RECEIVED (Search/Backpack)
--0		EVENT_LOOT_CLOSED (Search/Backpack)
--0		EVENT_CHATTER_END (Search/Backpack)

--Poultry
--XXXXX	StartInteraction (Take/Poultry) -- Pressed E
--150	EVENT_INVENTORY_SINGLE_SLOT_UPDATE (nil/nil) -- Poultry deposited
--0		EVENT_LOOT_RECEIVED (nil/nil)
--0		EVENT_CHATTER_END (nil/nil)

--Heavy Sack
--XXXXX	StartInteraction (Search/Heavy Sack) -- Pressed E
--1524	EVENT_INVENTORY_SINGLE_SLOT_UPDATE (nil/nil) -- 10 Ore deposited
--0		EVENT_LOOT_RECEIVED (nil/nil)
--0		EVENT_LOOT_CLOSED (nil/nil)
--0		EVENT_CHATTER_END (nil/nil)

--Unlock Chest
--XXXXX	StartInteraction (Unlock/Chest) -- Pressed E
--		BeginLockpicking
--		EndLockpicking
--6000	EVENT_CHATTER_END (Unlock/Chest)
--2181	EVENT_INVENTORY_SINGLE_SLOT_UPDATE (nil/nil) -- Misc/Junk deposited
--0		EVENT_LOOT_RECEIVED (nil/nil)
--0		EVENT_INVENTORY_SINGLE_SLOT_UPDATE (nil/nil) -- Misc/Junk deposited
--0		EVENT_LOOT_RECEIVED (nil/nil)
--0		EVENT_INVENTORY_SINGLE_SLOT_UPDATE (nil/nil) -- Misc/Junk deposited
--0		EVENT_LOOT_RECEIVED (nil/nil)
--0		EVENT_INVENTORY_SINGLE_SLOT_UPDATE (nil/nil) -- Misc/Junk deposited
--0		EVENT_LOOT_RECEIVED (nil/nil)
--0		EVENT_LOOT_CLOSED (nil/nil)
--0		EVENT_CHATTER_END (nil/nil)
--148	EVENT_INVENTORY_SINGLE_SLOT_UPDATE (nil/nil) -- Misc/Junk deposited

--Lootable body
--XXXXX	StartInteraction (Search/Iron Orc Thundermaul) -- Pressed E
--102	EVENT_LOOT_CLOSED (Search/Iron Orc Thundermaul) -- 32 Gold acquired

	SLASH_COMMANDS["/keybindssave"] = KeybindsSave
	SLASH_COMMANDS["/keybindsreset"] = KeybindsReset
end

-- Then we create an event handler function which will be called when the "addon loaded" event
-- occurs. We'll use this to initialize our addon after all of its resources are fully loaded.
function AHKVacuum.OnAddOnLoaded(event, addonName) -- The event fires each time *any* addon loads - but we only care about when our own addon loads.
	if addonName == AHKVacuum.name then AHKVacuum:Initialize() end
end

-- Finally, we'll register our event handler function to be called when the proper event occurs.
EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_ADD_ON_LOADED, AHKVacuum.OnAddOnLoaded)