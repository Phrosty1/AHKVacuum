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
local function BoolDecode(boolVal, trueStr, falseStr)
	if boolVal==true then return trueStr
	elseif boolVal==false then return falseStr
	else return tostring(boolVal) end
end
local function newIndexedSet(...)
	local retval = {}
	for _,value in pairs({...}) do retval[value] = true end
	return retval
end
local actionsToTakeByDefault = newIndexedSet("Search","Take","Collect","Mine","Cut","Unlock","Dig","Dig Up","Fish") -- ,"Reel In"
local blacklist = newIndexedSet("Bookshelf","Book Stack", "Spoiled Food","Greatsword","Sword","Axe","Bow","Shield","Staff","Sabatons","Jerkin","Dagger","Cuirass","Pauldron","Helm","Gauntlets","Guards","Boots","Shoes","Wasp","Fleshflies","Butterfly","Torchbug")
local whitelist = newIndexedSet("Giant Clam", "Platinum Seam", "Heavy Sack", "Heavy Crate", "Chest", "Hidden Treasure", "Dirt Mound", "Skyshard", "Steam Pipe")
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
local handleFailSafe = nil

local obj = {}
local msHoldKeysUntil = 0

local function tapE()
	isPressingKey = true
	isInteracting = false
	isFinishing = false
	dmsg("Tap E")
	ptk.SetIndOnFor(ptk.VK_E, 50)

	--handleFailSafe = zo_callLater(AHKVacuum.ClearInteraction, 200) -- refresh if no event occurs
	--dmsg("handleFailSafe:"..tostring(handleFailSafe))
end
local function tapT()
	ptk.SetIndOnFor(ptk.VK_T, 50)
end
local function tapH()
	ptk.SetIndOnFor(ptk.VK_H, 50)
end
local function CurFocus()
	curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract = GetGameCameraInteractableActionInfoLoc()
	local retval = " - "..tostring(curAction).."/"..tostring(curInteractableName)
					.."/"..BoolDecode(curInteractBlocked, "Blocked", "NotBlocked")
					.."/"..BoolDecode(CanInteractWithItem(), "CanInteract", "CanNotInteract")
					.."/"..BoolDecode(IsInteracting(), "IsInteracting", "IsNotInteracting")
					.."/"..BoolDecode(IsPlayerTryingToMoveLoc(), "TryingToMove", "NotTryingToMove")
	return retval
end
function AHKVacuum.ClearInteraction()
	dmsg("ClearInteraction"..CurFocus())
	isPressingKey = false
	isInteracting = false
	isFinishing = false
	wasMovingBeforeLooting = false
	wasMountedBeforeLooting = false
end
local function IsApprovedInteractable()
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
	then return true else return false end
end
function AHKVacuum.OnReticleSet()
	if not isPressingKey and not isInteracting and not isFinishing then
		curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract = GetGameCameraInteractableActionInfoLoc()
		if IsApprovedInteractable() then
			dmsg("OnReticleSet"..CurFocus())
			if IsPlayerTryingToMoveLoc() then wasMovingBeforeLooting = true end
			if IsMountedLoc() then wasMountedBeforeLooting = true end
			tapE()
		end
	end
end
function AHKVacuum.OnBeginInteracting()
--	obj.action, obj.name, obj.interactBlocked, obj.isOwned, obj.additionalInfo, obj.contextualInfo, obj.contextualLink, obj.isCriminalInteract = GetGameCameraInteractableActionInfoLoc()

	if handleFailSafe then EVENT_MANAGER:UnregisterForUpdate("CallLaterFunction"..handleFailSafe) end --clear handleFailSafe
	if isPressingKey then -- if instigated by us
		dmsg("OnBeginInteracting"..CurFocus())
		--if IsPlayerTryingToMoveLoc() then
		--	zo_callLater(AHKVacuum.ClearInteraction, 100)
		--else
			isInteracting = true
			isPressingKey = false
			isFinishing = false
		--end
	end
end
function AHKVacuum.OnFinishInteracting()
	if handleFailSafe then EVENT_MANAGER:UnregisterForUpdate("CallLaterFunction"..handleFailSafe) end --clear handleFailSafe
	--dmsg("OnFinishInteracting"
	--				.." "..BoolDecode(isPressingKey, "PressingKey", "NotPressingKey")
	--				.."/"..BoolDecode(isInteracting, "Interacting", "NotInteracting")
	--				.."/"..BoolDecode(isFinishing, "Finishing", "NotFinishing"))
	--clear handleFailSafe
	if isInteracting then
		dmsg("OnFinishInteracting"..CurFocus())
		isFinishing = true
		isInteracting = false
		-- Since we finished, do a manual check to determine whether to interact again or resume actions
		curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract = GetGameCameraInteractableActionInfoLoc()
		-- If there's another thing to loot then do it, otherwise resume movement
		if IsApprovedInteractable() then
			d("Interact with next item:"..CurFocus())
			tapE()
		else
			if not doRidePickupAll then wasMountedBeforeLooting = false end
			local t = 0
			if wasMountedBeforeLooting and wasMovingBeforeLooting then
				d("wasMountedBeforeLooting and wasMovingBeforeLooting")
				if not IsMountedLoc() then zo_callLater(tapH, t) t=t+200 end
				zo_callLater(tapT, t) t=t+200
			elseif wasMovingBeforeLooting then
				d("wasMovingBeforeLooting")
				zo_callLater(tapT, t) t=t+200
			elseif wasMountedBeforeLooting then
				d("wasMountedBeforeLooting")
				zo_callLater(tapT, t) t=t+200
			end
			zo_callLater(AHKVacuum.ClearInteraction, t) -- We hold isInteracting as true until we're done hitting keys then we're back to searching
		end
	end
end

function AHKVacuum.HookFish(eventCode, bagId, slotId, isNewItem, itemSoundCategory, inventoryUpdateReason, stackCountChange) -- EVENT_INVENTORY_SINGLE_SLOT_UPDATE (number eventCode, Bag bagId, number slotId, boolean isNewItem, ItemUISoundCategory itemSoundCategory, number inventoryUpdateReason, number stackCountChange)
	if (GetItemType(bagId,slotId) == ITEMTYPE_LURE and isNewItem == false and stackCountChange == -1 and itemSoundCategory == 39) then
		dmsg("Lure used, pressing E")
		ptk.SetIndOnFor(ptk.VK_E, 50)
	end
end

local function dump(o)
	if type(o) == 'table' then
		local s = '{ '
		for k,v in pairs(o) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			s = s .. '['..k..'] = ' .. dump(v) .. ','
		end
		return s .. '} '
	else
		return tostring(o)
	end
end

local function InitLots()
	local function LogValues(eventName, args)
		local ms_log_time = GetGameTimeMillisecondsLoc()
		local strArgs = ""
		local sep = ";"
		--for _,value in pairs(args) do strArgs = strArgs..","..tostring(value) end
		curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract = GetGameCameraInteractableActionInfoLoc()
		strArgs = tostring(ms_log_time)..sep..eventName..";"..tostring(curAction)..sep..tostring(curInteractableName) ..sep..BoolDecode(curInteractBlocked, "Blocked", "NotBlocked") ..sep..tostring(curAdditionalInfo) ..sep..tostring(curContextualInfo)
			..sep..BoolDecode(CanInteractWithItem(), "CanInteract", "CanNotInteract")
			..sep..BoolDecode(IsInteracting(), "IsInteracting", "IsNotInteracting")
			..sep..BoolDecode(IsPlayerTryingToMoveLoc(), "TryingToMove", "NotTryingToMove")
			..sep..dump(args)
		AHKVacuum.savedVars.log[AHKVacuum.savedVars.logIdx] = strArgs
		AHKVacuum.savedVars.logIdx = AHKVacuum.savedVars.logIdx + 1
	end
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."LOG", EVENT_LOOT_CLOSED, function(...) LogValues("EVENT_LOOT_CLOSED", {...}) end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."LOG", EVENT_LOOT_ITEM_FAILED, function(...) LogValues("EVENT_LOOT_ITEM_FAILED", {...}) end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."LOG", EVENT_LOOT_RECEIVED, function(...) LogValues("EVENT_LOOT_RECEIVED", {...}) end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."LOG", EVENT_LOOT_UPDATED, function(...) LogValues("EVENT_LOOT_UPDATED", {...}) end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."LOG", EVENT_CHATTER_BEGIN, function(...) LogValues("EVENT_CHATTER_BEGIN", {...}) end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."LOG", EVENT_CHATTER_END, function(...) LogValues("EVENT_CHATTER_END", {...}) end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."LOG", EVENT_CONFIRM_INTERACT, function(...) LogValues("EVENT_CONFIRM_INTERACT", {...}) end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."LOG", EVENT_CONVERSATION_FAILED_INVENTORY_FULL, function(...) LogValues("EVENT_CONVERSATION_FAILED_INVENTORY_FULL", {...}) end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."LOG", EVENT_CONVERSATION_FAILED_UNIQUE_ITEM, function(...) LogValues("EVENT_CONVERSATION_FAILED_UNIQUE_ITEM", {...}) end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."LOG", EVENT_CONVERSATION_UPDATED, function(...) LogValues("EVENT_CONVERSATION_UPDATED", {...}) end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."LOG", EVENT_INTERACT_BUSY, function(...) LogValues("EVENT_INTERACT_BUSY", {...}) end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."LOG", EVENT_NO_INTERACT_TARGET, function(...) LogValues("EVENT_NO_INTERACT_TARGET", {...}) end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."LOG", EVENT_PENDING_INTERACTION_CANCELLED, function(...) LogValues("EVENT_PENDING_INTERACTION_CANCELLED", {...}) end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."LOG", EVENT_CLIENT_INTERACT_RESULT, function(...) LogValues("EVENT_CLIENT_INTERACT_RESULT", {...}) end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."LOG", EVENT_COMBAT_EVENT, function(...) LogValues("EVENT_COMBAT_EVENT", {...}) end)
	EVENT_MANAGER:AddFilterForEvent(AHKVacuum.name.."LOG", EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_TARGET_OUT_OF_RANGE)
	SecurePostHook (ZO_Fishing, "StartInteraction", function(...) LogValues("ZO_Fishing:StartInteraction", {...}) end)
	SecurePostHook (ZO_Fishing, "StopInteraction", function(...) LogValues("ZO_Fishing:StopInteraction", {...}) end)
	--SecurePostHook ("EndInteraction", function(...) dmsg("EndInteraction"..CurFocus()) DispValues({...}) end) -- nothing?

--No target
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
end

function AHKVacuum:Initialize()
	ZO_CreateStringId("SI_BINDING_NAME_VACUUM_AUTOMOVE", "Vacuum Shop Automove")
	ZO_CreateStringId("SI_BINDING_NAME_VACUUM_RIGHT", "Vacuum Shop Right")
	ZO_CreateStringId("SI_BINDING_NAME_VACUUM_LEFT", "Vacuum Shop Left")
	ZO_CreateStringId("SI_BINDING_NAME_VACUUM_UP", "Vacuum Shop Up")
	ZO_CreateStringId("SI_BINDING_NAME_VACUUM_DOWN", "Vacuum Shop Down")
	AHKVacuum.savedVars = ZO_SavedVars:NewAccountWide(AHKVacuum.name.."SavedVariables", 1, nil, {})

	if AHKVacuum.savedVars.log == nil or AHKVacuum.savedVars.logIdx == nil or true then
		AHKVacuum.savedVars.log = {}
		AHKVacuum.savedVars.logIdx = 0
	end

	ZO_PreHookHandler(RETICLE.interact, "OnEffectivelyShown", AHKVacuum.OnReticleSet)
	ZO_PreHookHandler(RETICLE.interact, "OnHide", AHKVacuum.OnReticleSet)

	SecurePostHook (ZO_Fishing, "StartInteraction", AHKVacuum.OnBeginInteracting) -- begin harvesting/fishing/searching/taking
	--EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_CLIENT_INTERACT_RESULT, AHKVacuum.OnBeginInteracting) -- I think this starts everything and can replace StartInteraction
	--EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_CHATTER_BEGIN, AHKVacuum.OnBeginInteracting) -- Hopefully begins all others

	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_CHATTER_END, AHKVacuum.OnFinishInteracting) -- end of harvesting/fishing/not-searching(should work with onLootClosed)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_LOOT_CLOSED, AHKVacuum.OnFinishInteracting) -- seems to be needed for Search of bodies
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_COMBAT_EVENT, AHKVacuum.OnFinishInteracting) -- to handle "Target is out of range"
	EVENT_MANAGER:AddFilterForEvent(AHKVacuum.name, EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_TARGET_OUT_OF_RANGE)

	--EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_NO_INTERACT_TARGET, AHKVacuum.ClearInteraction)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_LOOT_ITEM_FAILED, AHKVacuum.ClearInteraction)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_PENDING_INTERACTION_CANCELLED, AHKVacuum.ClearInteraction)

	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, AHKVacuum.HookFish)

	InitLots()
	--SLASH_COMMANDS["/keybindssave"] = KeybindsSave
	--SLASH_COMMANDS["/keybindsreset"] = KeybindsReset
end

function AHKVacuum:ShopDirectionRightOn()  ptk.SetIndOn (ptk.VK_D) end
function AHKVacuum:ShopDirectionRightOff() ptk.SetIndOff(ptk.VK_D) end
function AHKVacuum:ShopDirectionLeftOn()   ptk.SetIndOn (ptk.VK_A) end
function AHKVacuum:ShopDirectionLeftOff()  ptk.SetIndOff(ptk.VK_A) end
function AHKVacuum:ShopDirectionUpOn()     ptk.SetIndOn (ptk.VK_W) end
function AHKVacuum:ShopDirectionUpOff()    ptk.SetIndOff(ptk.VK_W) end
function AHKVacuum:ShopDirectionDownOn()   ptk.SetIndOn (ptk.VK_S) end
function AHKVacuum:ShopDirectionDownOff()  ptk.SetIndOff(ptk.VK_S) end
function AHKVacuum:ShopAutomoveToggle()
	if not doRidePickupAll then
		doRidePickupAll = true
		d("Horse Vacuum ON")
	else
		doRidePickupAll = false
		d("Horse Vacuum OFF")
	end
end

-- Then we create an event handler function which will be called when the "addon loaded" event
-- occurs. We'll use this to initialize our addon after all of its resources are fully loaded.
function AHKVacuum.OnAddOnLoaded(event, addonName) -- The event fires each time *any* addon loads - but we only care about when our own addon loads.
	if addonName == AHKVacuum.name then AHKVacuum:Initialize() end
end

-- Finally, we'll register our event handler function to be called when the proper event occurs.
EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_ADD_ON_LOADED, AHKVacuum.OnAddOnLoaded)