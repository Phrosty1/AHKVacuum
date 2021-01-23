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
local actionsToTakeByDefault = newIndexedSet("Search","Take","Collect","Mine","Cut","Unlock","Dig","Dig Up","Fish") -- ,"Reel In"
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
local isFinishing = false
local doRidePickupAll = false

local function tapE()
	isPressingKey = true
	dmsg("Tap E")
	ptk.SetIndOnFor(ptk.VK_E, 50)
end
local function tapT()
	ptk.SetIndOnFor(ptk.VK_T, 50)
end
local function tapH()
	ptk.SetIndOnFor(ptk.VK_H, 50)
end
local function CurFocus()
	curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract = GetGameCameraInteractableActionInfoLoc()
	return " - "..tostring(curAction).."/"..tostring(curInteractableName).."/"..tostring(curInteractBlocked)
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
	if not isPressingKey and not isInteracting and not isFinishing then
		curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract = GetGameCameraInteractableActionInfoLoc()
		if IsCurFocusSetForInteract() then
			if IsPlayerTryingToMoveLoc() then wasMovingBeforeLooting = true end
			if IsMountedLoc() then wasMountedBeforeLooting = true end
			tapE()
			dmsg("OnReticleSet -"..CurFocus())
		end
	end
end
function AHKVacuum.ClearInteraction()
	isPressingKey = false
	isInteracting = false
	isFinishing = false
	--EVENT_MANAGER:UnregisterForEvent(AHKVacuum.name, EVENT_CHATTER_END)
	--EVENT_MANAGER:UnregisterForEvent(AHKVacuum.name, EVENT_LOOT_CLOSED)
end
function AHKVacuum.OnFinishInteracting()
	if isInteracting then
		isInteracting = false
		isFinishing = true
		dmsg("OnFinishInteracting")
		-- We can't use ClearInteraction since it unsets isInteracting briefly and we don't want OnReticleSet to accidentally fire
		--isPressingKey = false
		--isInteracting = false
		--EVENT_MANAGER:UnregisterForEvent(AHKVacuum.name, EVENT_CHATTER_END)
		--EVENT_MANAGER:UnregisterForEvent(AHKVacuum.name, EVENT_LOOT_CLOSED)
		-- Since we finished, do a manual check to determine whether to interact again or resume actions
		curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract = GetGameCameraInteractableActionInfoLoc()
		dmsg("NextItem:"..tostring(curInteractableName).." Pressing:"..tostring(isPressingKey).." isInteracting:"..tostring(isInteracting))
		-- If there's another thing to loot then do it, otherwise resume movement
		if IsCurFocusSetForInteract() then
			local delay = 0
			if curAction=="Fish" or curAction=="Reel In" then
				delay = 200
			elseif curInteractableName=="Chest" then
				delay = 200
			elseif curAction=="Take" then
				delay = 0
			else
				delay = 0
			end
			zo_callLater(tapE, delay)
			dmsg("OnFinishInteracting -"..CurFocus())
		else
			local t = 0
			if wasMountedBeforeLooting and wasMovingBeforeLooting then
				d("wasMountedBeforeLooting and wasMovingBeforeLooting")
				zo_callLater(tapH, t) t=t+200
				zo_callLater(tapT, t) t=t+200
			elseif wasMovingBeforeLooting then
				d("wasMovingBeforeLooting")
				zo_callLater(tapT, t) t=t+200
			elseif wasMountedBeforeLooting then
				d("wasMountedBeforeLooting")
				zo_callLater(tapT, t) t=t+200
			end
			zo_callLater(AHKVacuum.ClearInteraction, t) -- We hold isInteracting as true until we're done hitting keys then we're back to searching
			wasMountedBeforeLooting = false
			wasMovingBeforeLooting = false
		end
	end
end
function AHKVacuum.OnBeginInteracting()
	if isPressingKey then -- if instigated by us
		-- We can't use ClearInteraction since it unsets isInteracting briefly and we don't want OnReticleSet to accidentally fire
		isInteracting = true
		isPressingKey = false
		isFinishing = false
		--EVENT_MANAGER:UnregisterForEvent(AHKVacuum.name, EVENT_CHATTER_END)
		--EVENT_MANAGER:UnregisterForEvent(AHKVacuum.name, EVENT_LOOT_CLOSED)
		-- Find what we're actually interacting with
		curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract = GetGameCameraInteractableActionInfoLoc()
		local delay = 0
		if curAction=="Fish" or curAction=="Reel In" then
			--wasMountedBeforeLooting = false -- tmpbri
			--wasMovingBeforeLooting = false -- tmpbri
			--zo_callLater(function() EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, AHKVacuum.OnFinishInteracting) end, delay) -- delay enabling for a bit
			--EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, AHKVacuum.OnFinishInteracting)
			delay = 0
		elseif curInteractableName=="Chest" then
			--EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_LOOT_CLOSED, AHKVacuum.OnFinishInteracting)
			delay = 200
		elseif curAction=="Take" then
			--EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_CHATTER_END, AHKVacuum.OnFinishInteracting)
			delay = 0
		else
			--EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_LOOT_CLOSED, AHKVacuum.OnFinishInteracting)
			delay = 0
		end
		--zo_callLater(function() EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_LOOT_CLOSED, AHKVacuum.OnFinishInteracting) end, delay)
		--zo_callLater(function() EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_CHATTER_END, AHKVacuum.OnFinishInteracting) end, delay)
		--EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_LOOT_CLOSED, AHKVacuum.OnFinishInteracting)
		--EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_CHATTER_END, AHKVacuum.OnFinishInteracting)
		dmsg("OnBeginInteracting -"..CurFocus())
	end
end

function AHKVacuum.HookFish(eventCode, bagId, slotId, isNewItem, itemSoundCategory, inventoryUpdateReason, stackCountChange) -- EVENT_INVENTORY_SINGLE_SLOT_UPDATE (number eventCode, Bag bagId, number slotId, boolean isNewItem, ItemUISoundCategory itemSoundCategory, number inventoryUpdateReason, number stackCountChange)
	if (GetItemType(bagId,slotId) == ITEMTYPE_LURE and isNewItem == false and stackCountChange == -1 and itemSoundCategory == 39) then
		dmsg("Lure used, pressing E")
		ptk.SetIndOnFor(ptk.VK_E, 50)
		--zo_callLater(AHKVacuum.OnFinishInteracting, 500)
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
	-- Don't really have a good way of finding if something interrupted us
	-- so interact with nothing to reset the search
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_NO_INTERACT_TARGET, AHKVacuum.ClearInteraction)

	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_CHATTER_END, AHKVacuum.OnFinishInteracting) -- end of harvesting/fishing/not-searching(should work with onLootClosed)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_LOOT_CLOSED, AHKVacuum.OnFinishInteracting) -- seems to be needed for Search of bodies
	--EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_LOOT_RECEIVED, AHKVacuum.OnFinishInteracting) -- pretty good for indicating fast looted
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, AHKVacuum.HookFish)
	--EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_NO_INTERACT_TARGET, AHKVacuum.OnFinishInteracting) -- if the E misses
	-- Hits E twice when beginning fishing

	--SecurePostHook (ZO_Fishing, "StartInteraction", function() dmsg("StartInteraction"..CurFocus()) end)
	--EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."TXT", EVENT_CHATTER_END, function(...) dmsg("EVENT_CHATTER_END"..CurFocus()) d({...}) end)
	--EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."TXT", EVENT_LOOT_CLOSED, function(...) dmsg("EVENT_LOOT_CLOSED"..CurFocus()) d({...}) end)
	--EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."TXT", EVENT_LOOT_RECEIVED, function(...) dmsg("EVENT_LOOT_RECEIVED"..CurFocus()) d({...}) end)
	--EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."TXT", EVENT_INVENTORY_SINGLE_SLOT_UPDATE, function(...) dmsg("EVENT_INVENTORY_SINGLE_SLOT_UPDATE"..CurFocus()) d({...}) end)
	--EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."TXT", EVENT_NO_INTERACT_TARGET, function(...) dmsg("EVENT_NO_INTERACT_TARGET"..CurFocus()) d({...}) end)

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