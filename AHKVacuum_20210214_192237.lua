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
local actionsToTakeByDefault = newIndexedSet("Search","Take","Collect","Mine","Cut","Unlock","Dig","Dig Up","Fish")
local blacklist = newIndexedSet("Bookshelf","Book Stack", "Spoiled Food","Greatsword","Sword","Axe","Bow","Shield","Staff","Sabatons","Jerkin","Dagger","Cuirass","Pauldron","Helm","Gauntlets","Guards","Boots","Shoes","Wasp","Fleshflies","Butterfly","Torchbug")
local mountedWhitelist = newIndexedSet("Giant Clam", "Platinum Seam", "Heavy Sack", "Heavy Crate", "Chest", "Hidden Treasure", "Dirt Mound", "Skyshard", "Steam Pipe",
	"Protean Runestone","Rich Platinum Seam","Rich Rubedite Ore","Pristine Ruby Ash Wood","Lush Ancestor Silk",
	"Lush Blessed Thistle","Lush Bugloss","Lush Columbine","Lush Corn Flower","Lush Dragonthorn","Lush Lady's Smock","Lush Mountain Flower","Lush Wormwood")
-- Local references for eso functions
local IsPlayerTryingToMoveLoc = IsPlayerTryingToMove -- Returns: boolean tryingToMove
local IsMountedLoc = IsMounted -- Returns: boolean mounted
local GetGameCameraInteractableActionInfoLoc = GetGameCameraInteractableActionInfo -- Returns: string:nilable action, string:nilable name, boolean interactBlocked, boolean isOwned, number additionalInfo, number:nilable contextualInfo, string:nilable contextualLink, boolean isCriminalInteract
local IsUnitInCombatLoc = IsUnitInCombat -- (string unitTag) Returns: boolean isInCombat
-- Local variables
local prvAction, prvInteractableName, prvInteractBlocked, prvIsOwned, prvAdditionalInfo, prvContextualInfo, prvContextualLink, prvIsCriminalInteract
local curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract
local wasMovingBeforeLooting = false -- IsPlayerTryingToMoveLoc()
local wasMountedBeforeLooting = false -- IsMountedLoc()
local isPressingKey = false
local isInteracting = false
local isFinishing = false
--local handleFailSafe = nil
local doRidePickupAll = true
local doAutoStartFishing = true
local lastActivationMs = 0

local clientInteractingWith = nil -- EVENT_CLIENT_INTERACT_RESULT
local clientInteractingAction = nil
local clientInteractingTime = 0
local clientInteractingEndWith = nil -- EVENT_INTERACTION_ENDED
local clientInteractingEndTime = 0

local ZO_FishingInteractionWith = nil -- ZO_Fishing:StartInteraction
local ZO_FishingInteractionTime = 0
local ZO_FishingInteractionEndWith = nil -- ZO_Fishing:StopInteraction
local ZO_FishingInteractionEndTime = 0

local ClientInteractResult = {[CLIENT_INTERACT_RESULT_ANTIQUITY_DIGGING_NO_INVENTORY_SPACE]="CLIENT_INTERACT_RESULT_ANTIQUITY_DIGGING_NO_INVENTORY_SPACE",[CLIENT_INTERACT_RESULT_CANT_SWIM_AND_FISH]="CLIENT_INTERACT_RESULT_CANT_SWIM_AND_FISH",[CLIENT_INTERACT_RESULT_CANT_WHILE_FALLING]="CLIENT_INTERACT_RESULT_CANT_WHILE_FALLING",[CLIENT_INTERACT_RESULT_CANT_WHILE_SWIMMING]="CLIENT_INTERACT_RESULT_CANT_WHILE_SWIMMING",[CLIENT_INTERACT_RESULT_DONT_OWN_HOUSE_BANK]="CLIENT_INTERACT_RESULT_DONT_OWN_HOUSE_BANK",[CLIENT_INTERACT_RESULT_FAIL_DOOR_REQ]="CLIENT_INTERACT_RESULT_FAIL_DOOR_REQ",[CLIENT_INTERACT_RESULT_FEARFUL_VAMPIRE]="CLIENT_INTERACT_RESULT_FEARFUL_VAMPIRE",[CLIENT_INTERACT_RESULT_FEARFUL_WEREWOLF]="CLIENT_INTERACT_RESULT_FEARFUL_WEREWOLF",[CLIENT_INTERACT_RESULT_FLAVOR_NPC]="CLIENT_INTERACT_RESULT_FLAVOR_NPC",[CLIENT_INTERACT_RESULT_GENERIC_ERROR]="CLIENT_INTERACT_RESULT_GENERIC_ERROR",[CLIENT_INTERACT_RESULT_INTERACT_DISABLED]="CLIENT_INTERACT_RESULT_INTERACT_DISABLED",[CLIENT_INTERACT_RESULT_IN_COMBAT]="CLIENT_INTERACT_RESULT_IN_COMBAT",[CLIENT_INTERACT_RESULT_LOCK_TOO_DIFFICULT]="CLIENT_INTERACT_RESULT_LOCK_TOO_DIFFICULT",[CLIENT_INTERACT_RESULT_NO_LOCKPICKS]="CLIENT_INTERACT_RESULT_NO_LOCKPICKS",[CLIENT_INTERACT_RESULT_NO_LURE]="CLIENT_INTERACT_RESULT_NO_LURE",[CLIENT_INTERACT_RESULT_PICKPOCKET_NO_INVENTORY_SPACE]="CLIENT_INTERACT_RESULT_PICKPOCKET_NO_INVENTORY_SPACE",[CLIENT_INTERACT_RESULT_PICKPOCKET_ON_COOLDOWN]="CLIENT_INTERACT_RESULT_PICKPOCKET_ON_COOLDOWN",[CLIENT_INTERACT_RESULT_PICKPOCKET_OUT_OF_POSITION]="CLIENT_INTERACT_RESULT_PICKPOCKET_OUT_OF_POSITION",[CLIENT_INTERACT_RESULT_PICKPOCKET_TOO_FAR]="CLIENT_INTERACT_RESULT_PICKPOCKET_TOO_FAR",[CLIENT_INTERACT_RESULT_SHUNNED]="CLIENT_INTERACT_RESULT_SHUNNED",[CLIENT_INTERACT_RESULT_SHUNNED_FEARFUL_VAMPIRE]="CLIENT_INTERACT_RESULT_SHUNNED_FEARFUL_VAMPIRE",[CLIENT_INTERACT_RESULT_SHUNNED_FEARFUL_WEREWOLF]="CLIENT_INTERACT_RESULT_SHUNNED_FEARFUL_WEREWOLF",[CLIENT_INTERACT_RESULT_STEALING_PLACED_PREVENTED]="CLIENT_INTERACT_RESULT_STEALING_PLACED_PREVENTED",[CLIENT_INTERACT_RESULT_SUCCESS]="CLIENT_INTERACT_RESULT_SUCCESS",[CLIENT_INTERACT_RESULT_SUSPICIOUS]="CLIENT_INTERACT_RESULT_SUSPICIOUS",[CLIENT_INTERACT_RESULT_WEREWOLF]="CLIENT_INTERACT_RESULT_WEREWOLF",[CLIENT_INTERACT_RESULT_WEREWOLF_UNABLE_TO_CRAFT]="CLIENT_INTERACT_RESULT_WEREWOLF_UNABLE_TO_CRAFT"}
local InteractionType = {[INTERACTION_ANTIQUITY_DIG_SPOT]="INTERACTION_ANTIQUITY_DIG_SPOT",[INTERACTION_ANTIQUITY_SCRYING]="INTERACTION_ANTIQUITY_SCRYING",[INTERACTION_ATTRIBUTE_RESPEC]="INTERACTION_ATTRIBUTE_RESPEC",[INTERACTION_AVA_HOOK_POINT]="INTERACTION_AVA_HOOK_POINT",[INTERACTION_BANK]="INTERACTION_BANK",[INTERACTION_BOOK]="INTERACTION_BOOK",[INTERACTION_BUY_BAG_SPACE]="INTERACTION_BUY_BAG_SPACE",[INTERACTION_CONVERSATION]="INTERACTION_CONVERSATION",[INTERACTION_CRAFT]="INTERACTION_CRAFT",[INTERACTION_DYE_STATION]="INTERACTION_DYE_STATION",[INTERACTION_FAST_TRAVEL]="INTERACTION_FAST_TRAVEL",[INTERACTION_FAST_TRAVEL_KEEP]="INTERACTION_FAST_TRAVEL_KEEP",[INTERACTION_FISH]="INTERACTION_FISH",[INTERACTION_FURNITURE]="INTERACTION_FURNITURE",[INTERACTION_GUILDBANK]="INTERACTION_GUILDBANK",[INTERACTION_GUILDKIOSK_BID]="INTERACTION_GUILDKIOSK_BID",[INTERACTION_GUILDKIOSK_PURCHASE]="INTERACTION_GUILDKIOSK_PURCHASE",[INTERACTION_HARVEST]="INTERACTION_HARVEST",[INTERACTION_HIDEYHOLE]="INTERACTION_HIDEYHOLE",[INTERACTION_KEEP_GUILD_CLAIM]="INTERACTION_KEEP_GUILD_CLAIM",[INTERACTION_KEEP_GUILD_RELEASE]="INTERACTION_KEEP_GUILD_RELEASE",[INTERACTION_KEEP_INSPECT]="INTERACTION_KEEP_INSPECT",[INTERACTION_KEEP_PIECE]="INTERACTION_KEEP_PIECE",[INTERACTION_LOCKPICK]="INTERACTION_LOCKPICK",[INTERACTION_LOOT]="INTERACTION_LOOT",[INTERACTION_MAIL]="INTERACTION_MAIL",[INTERACTION_NONE]="INTERACTION_NONE",[INTERACTION_PAY_BOUNTY]="INTERACTION_PAY_BOUNTY",[INTERACTION_PICKPOCKET]="INTERACTION_PICKPOCKET",[INTERACTION_QUEST]="INTERACTION_QUEST",[INTERACTION_RETRAIT]="INTERACTION_RETRAIT",[INTERACTION_SIEGE]="INTERACTION_SIEGE",[INTERACTION_SKILL_RESPEC]="INTERACTION_SKILL_RESPEC",[INTERACTION_STABLE]="INTERACTION_STABLE",[INTERACTION_STONE_MASON]="INTERACTION_STONE_MASON",[INTERACTION_STORE]="INTERACTION_STORE",[INTERACTION_TRADINGHOUSE]="INTERACTION_TRADINGHOUSE",[INTERACTION_TREASURE_MAP]="INTERACTION_TREASURE_MAP",[INTERACTION_VENDOR]="INTERACTION_VENDOR"}
local InteractCancelContext = {[INTERACT_CANCEL_CONTEXT_COMBAT]="INTERACT_CANCEL_CONTEXT_COMBAT",[INTERACT_CANCEL_CONTEXT_DEFAULT]="INTERACT_CANCEL_CONTEXT_DEFAULT"}
local InteractTargetType ={[INTERACT_TARGET_TYPE_AOE_LOOT]="INTERACT_TARGET_TYPE_AOE_LOOT",[INTERACT_TARGET_TYPE_CLIENT_CHARACTER]="INTERACT_TARGET_TYPE_CLIENT_CHARACTER",[INTERACT_TARGET_TYPE_COLLECTIBLE]="INTERACT_TARGET_TYPE_COLLECTIBLE",[INTERACT_TARGET_TYPE_FIXTURE]="INTERACT_TARGET_TYPE_FIXTURE",[INTERACT_TARGET_TYPE_ITEM]="INTERACT_TARGET_TYPE_ITEM",[INTERACT_TARGET_TYPE_NONE]="INTERACT_TARGET_TYPE_NONE",[INTERACT_TARGET_TYPE_OBJECT]="INTERACT_TARGET_TYPE_OBJECT",[INTERACT_TARGET_TYPE_QUEST_ITEM]="INTERACT_TARGET_TYPE_QUEST_ITEM",}

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
local function LogValues(eventName, args)
	local ms_log_time = GetGameTimeMillisecondsLoc()
	local strArgs = ""
	local sep = ";"
	--for _,value in pairs(args) do strArgs = strArgs..","..tostring(value) end
	curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract = GetGameCameraInteractableActionInfoLoc()
	local lootName, targetType, actionName, isOwned = GetLootTargetInfo()
	strArgs = tostring(ms_log_time)..sep..eventName
		..sep..tostring(curAction)..sep..tostring(curInteractableName) ..sep..BoolDecode(curInteractBlocked, "Blocked", "NotBlocked") ..sep..tostring(curAdditionalInfo) ..sep..tostring(curContextualInfo)
		..sep..BoolDecode(CanInteractWithItem(), "CanInteract", "CanNotInteract")
		..sep..BoolDecode(IsInteracting(), "IsInteracting", "IsNotInteracting")
		..sep..BoolDecode(IsPlayerTryingToMoveLoc(), "TryingToMove", "NotTryingToMove")
		--* IsLooting() --** _Returns:_ *bool* _isLooting_
		..sep..BoolDecode(IsLooting(), "Looting", "NotLooting")
		--* IsInteractionCameraActive() --** _Returns:_ *bool* _isActive_
		..sep..BoolDecode(IsInteractionCameraActive(), "InteractionCameraActive", "InteractionCameraNotActive")
		-- GetInteractionType() -- _Returns:_ *[InteractionType|#InteractionType]* _interactMode_
		..sep..tostring(InteractionType[GetInteractionType()])
		--* GetLootTargetInfo() --** _Returns:_ *string* _name_, *[InteractTargetType|#InteractTargetType]* _targetType_, *string* _actionName_, *bool* _isOwned_
		..sep..tostring(lootName)..sep..tostring(InteractTargetType[targetType])..sep..tostring(actionName)..sep..tostring(isOwned)
		..sep..dump(args)
	AHKVacuum.savedVars.log[AHKVacuum.savedVars.logIdx] = strArgs
	AHKVacuum.savedVars.logIdx = AHKVacuum.savedVars.logIdx + 1
end
local function tapE()
	isPressingKey = true
	isInteracting = false
	isFinishing = false
	dmsg("Tap E")
	LogValues("tapE")
	ptk.SetIndOnFor(ptk.VK_E, 20)
	lastActivationMs = GetGameTimeMillisecondsLoc()

	--handleFailSafe = zo_callLater(AHKVacuum.ClearInteraction, 200) -- refresh if no event occurs
	--dmsg("handleFailSafe:"..tostring(handleFailSafe))
end
local function tapT()
	ptk.SetIndOnFor(ptk.VK_T, 20)
end
local function tapH()
	ptk.SetIndOnFor(ptk.VK_H, 20)
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
		and (doRidePickupAll or mountedWhitelist[curInteractableName] ~= nil or not IsMountedLoc())
		and actionsToTakeByDefault[curAction] ~= nil
		and (doAutoStartFishing or curAdditionalInfo ~= ADDITIONAL_INTERACT_INFO_FISHING_NODE)
		and not IsUnitInCombatLoc("player")
	then return true else return false end
end
function AHKVacuum.OnReticleSet()
	curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract = GetGameCameraInteractableActionInfoLoc()
	if curAction~=prvAction or curInteractableName~=prvInteractableName or curInteractBlocked~=prvInteractBlocked or curIsOwned~=prvIsOwned or curAdditionalInfo~=prvAdditionalInfo or curContextualInfo~=prvContextualInfo or curContextualLink~=prvContextualLink or curIsCriminalInteract~=prvIsCriminalInteract then 
		if curInteractableName~=nil and not curInteractBlocked then
			AHKVacuum.ClearInteraction()
		end
		prvAction, prvInteractableName, prvInteractBlocked, prvIsOwned, prvAdditionalInfo, prvContextualInfo, prvContextualLink, prvIsCriminalInteract = curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract
		LogValues("AHKVacuum:OnReticleSetChanged")
	end
	if not isPressingKey and not isInteracting and not isFinishing and lastActivationMs < GetGameTimeMillisecondsLoc()+50 then
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
	--if handleFailSafe then EVENT_MANAGER:UnregisterForUpdate("CallLaterFunction"..handleFailSafe) end --clear handleFailSafe
	--if isPressingKey then -- if instigated by us
		dmsg("OnBeginInteracting"..CurFocus())
		LogValues("AHKVacuum:OnBeginInteracting")
		--if IsPlayerTryingToMoveLoc() then
		--	zo_callLater(AHKVacuum.ClearInteraction, 100)
		--else
			isInteracting = true
			isPressingKey = false
			isFinishing = false
		--end
	--end
end
function AHKVacuum.OnFinishInteracting()
	--if handleFailSafe then EVENT_MANAGER:UnregisterForUpdate("CallLaterFunction"..handleFailSafe) end --clear handleFailSafe
	--dmsg("OnFinishInteracting"
	--				.." "..BoolDecode(isPressingKey, "PressingKey", "NotPressingKey")
	--				.."/"..BoolDecode(isInteracting, "Interacting", "NotInteracting")
	--				.."/"..BoolDecode(isFinishing, "Finishing", "NotFinishing"))
	if not isPressingKey and isInteracting and not isFinishing then
		dmsg("OnFinishInteracting"..CurFocus())
		LogValues("AHKVacuum:OnFinishInteracting")
		isFinishing = true
		isInteracting = false
		-- Since we finished, do a manual check to determine whether to interact again or resume actions
		curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract = GetGameCameraInteractableActionInfoLoc()
		-- If there's another thing to loot then do it, otherwise resume movement
		if IsApprovedInteractable() then
			dmsg("Interact with next item:"..CurFocus())
			tapE()
		elseif IsUnitInCombatLoc("player") then
			AHKVacuum.ClearInteraction()
		elseif clientInteractingAction == "Fish" then
			AHKVacuum.ClearInteraction()
			tapH() -- Mount when done fishing
		else
			--if not doRidePickupAll then wasMountedBeforeLooting = false end
			if wasMountedBeforeLooting and not IsMountedLoc() then
				--d("wasMountedBeforeLooting")
				tapH()
			elseif wasMovingBeforeLooting then
				--d("wasMovingBeforeLooting")
				tapT()
				zo_callLater(AHKVacuum.ClearInteraction, 50)
			else
				AHKVacuum.ClearInteraction()
			end
		end
	end
end

function AHKVacuum.OnMountedStateChange(eventCode, mounted)
	dmsg("OnMountedStateChange"
		.." "..BoolDecode(isPressingKey, "PressingKey", "NotPressingKey")
		.."/"..BoolDecode(isInteracting, "Interacting", "NotInteracting")
		.."/"..BoolDecode(isFinishing, "Finishing", "NotFinishing"))

	if mounted and wasMovingBeforeLooting and isFinishing then
		--d("wasMovingBeforeLooting")
		tapT()
		zo_callLater(AHKVacuum.ClearInteraction, 50)
	end
end

function AHKVacuum.HookFish(eventCode, bagId, slotId, isNewItem, itemSoundCategory, inventoryUpdateReason, stackCountChange) -- EVENT_INVENTORY_SINGLE_SLOT_UPDATE (number eventCode, Bag bagId, number slotId, boolean isNewItem, ItemUISoundCategory itemSoundCategory, number inventoryUpdateReason, number stackCountChange)
	--if (GetItemType(bagId,slotId) == ITEMTYPE_LURE and isNewItem == false and stackCountChange == -1 and itemSoundCategory == 39) then
	if (GetItemType(bagId,slotId) == ITEMTYPE_LURE) then
		dmsg("Lure used, pressing E")
		ptk.SetIndOnFor(ptk.VK_E, 20)
	end
end


local function InitLogs()
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
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."LOG", EVENT_MOUNTED_STATE_CHANGED, function(...) LogValues("EVENT_MOUNTED_STATE_CHANGED", {...}) end)
	SecurePostHook (ZO_Fishing, "StartInteraction", function(...) LogValues("ZO_Fishing:StartInteraction", {}) end)
	SecurePostHook (ZO_Fishing, "StopInteraction", function(...) LogValues("ZO_Fishing:StopInteraction", {}) end)
	SecurePostHook (ZO_Fishing, "EndInteraction", function(...) LogValues("ZO_Fishing:EndInteraction", {...}) end) -- nothing?

--SecurePostHook ("AcceptSharedQuest", function(...) LogValues("AcceptSharedQuest", {...}) end)
--SecurePostHook ("ToggleWalk", function(...) LogValues("ToggleWalk", {...}) end) -- can't call private function

	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."LOG", EVENT_GAME_CAMERA_ACTIVATED, function(...) LogValues("EVENT_GAME_CAMERA_ACTIVATED", {...}) end)
	SecurePostHook ("ClearCursor", function(...) LogValues("ClearCursor", {...}) end)

	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."LOG", EVENT_NEW_MOVEMENT_IN_UI_MODE, function(...) LogValues("EVENT_NEW_MOVEMENT_IN_UI_MODE", {...}) end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."LOG", EVENT_RETICLE_TARGET_CHANGED, function(...) LogValues("EVENT_RETICLE_TARGET_CHANGED", {...}) end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."LOG", EVENT_RETICLE_TARGET_PLAYER_CHANGED, function(...) LogValues("EVENT_RETICLE_TARGET_PLAYER_CHANGED", {...}) end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."LOG", EVENT_VISUAL_LAYER_CHANGED, function(...) LogValues("EVENT_VISUAL_LAYER_CHANGED", {...}) end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."LOG", EVENT_UNIT_CREATED, function(...) LogValues("EVENT_UNIT_CREATED", {...}) end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."LOG", EVENT_WORLD_EVENTS_INITIALIZED, function(...) LogValues("EVENT_WORLD_EVENTS_INITIALIZED", {...}) end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."LOG", EVENT_WORLD_EVENT_ACTIVATED, function(...) LogValues("EVENT_WORLD_EVENT_ACTIVATED", {...}) end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."LOG", EVENT_WORLD_EVENT_ACTIVE_LOCATION_CHANGED, function(...) LogValues("EVENT_WORLD_EVENT_ACTIVE_LOCATION_CHANGED", {...}) end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."LOG", EVENT_WORLD_EVENT_DEACTIVATED, function(...) LogValues("EVENT_WORLD_EVENT_DEACTIVATED", {...}) end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."LOG", EVENT_WORLD_EVENT_UNIT_CHANGED_PIN_TYPE, function(...) LogValues("EVENT_WORLD_EVENT_UNIT_CHANGED_PIN_TYPE", {...}) end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."LOG", EVENT_WORLD_EVENT_UNIT_CREATED, function(...) LogValues("EVENT_WORLD_EVENT_UNIT_CREATED", {...}) end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."LOG", EVENT_WORLD_EVENT_UNIT_DESTROYED, function(...) LogValues("EVENT_WORLD_EVENT_UNIT_DESTROYED", {...}) end)

	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."LOG", EVENT_GAME_CAMERA_UI_MODE_CHANGED, function(...) LogValues("EVENT_GAME_CAMERA_UI_MODE_CHANGED", {...}) end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."LOG", EVENT_PLAYER_STATUS_CHANGED, function(...) LogValues("EVENT_PLAYER_STATUS_CHANGED", {...}) end)

	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."LOG", EVENT_INTERACTION_ENDED, function(...) LogValues("EVENT_INTERACTION_ENDED", {...}) end)


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

	if AHKVacuum.savedVars.log == nil or AHKVacuum.savedVars.logIdx == nil or false then
		AHKVacuum.savedVars.log = {}
		AHKVacuum.savedVars.logIdx = 1
	end

	ZO_PreHookHandler(RETICLE.interact, "OnEffectivelyShown", AHKVacuum.OnReticleSet)
	ZO_PreHookHandler(RETICLE.interact, "OnHide", AHKVacuum.OnReticleSet)

	--SecurePostHook (ZO_Fishing, "StartInteraction", AHKVacuum.OnBeginInteracting) -- begin harvesting/fishing/searching/taking
	--EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_CLIENT_INTERACT_RESULT, AHKVacuum.OnBeginInteracting) -- I think this starts everything and can replace StartInteraction. Don't remember why I couldn't
	--EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_CHATTER_BEGIN, AHKVacuum.OnBeginInteracting) -- Hopefully begins all others
	if AHKVacuum.savedVars.interactResultSuccess == nil then
		AHKVacuum.savedVars.interactResultSuccess = {}
	end
	if AHKVacuum.savedVars.interactEnded == nil then
		AHKVacuum.savedVars.interactEnded = {}
	end
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_CLIENT_INTERACT_RESULT, function(_, result, interactTargetName)
			if result == CLIENT_INTERACT_RESULT_SUCCESS then
				clientInteractingWith = interactTargetName
				clientInteractingAction = curAction
				clientInteractingTime = GetGameTimeMillisecondsLoc()
				AHKVacuum.savedVars.interactResultSuccess[clientInteractingWith] = clientInteractingTime
				AHKVacuum.OnBeginInteracting() -- if this doesn't work, put back StartInteraction
			end
			dmsg("EVENT_CLIENT_INTERACT_RESULT: "..tostring(ClientInteractResult[result]).." "..tostring(interactTargetName))
		end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_INTERACTION_ENDED, function(_, interactType, cancelContext)
			if clientInteractingWith ~= nil then
				clientInteractingEndWith = clientInteractingWith
				clientInteractingEndTime = GetGameTimeMillisecondsLoc()
				AHKVacuum.savedVars.interactEnded[clientInteractingEndWith] = clientInteractingEndTime-clientInteractingTime
				clientInteractingWith = nil
			end
			dmsg("EVENT_INTERACTION_ENDED: "..tostring(InteractionType[interactType]).." "..tostring(InteractCancelContext[cancelContext]))
			dmsg("fake calling OnFinishInteracting")
			isPressingKey = false
			isInteracting = true
			isFinishing = false
			AHKVacuum.OnFinishInteracting()
		end)

	if AHKVacuum.savedVars.zofishInteractSuccess == nil then
		AHKVacuum.savedVars.zofishInteractSuccess = {}
	end
	if AHKVacuum.savedVars.zofishInteractEnded == nil then
		AHKVacuum.savedVars.zofishInteractEnded = {}
	end
	SecurePostHook (ZO_Fishing, "StartInteraction", function()
			curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract = GetGameCameraInteractableActionInfoLoc()
			if curInteractableName ~= nil then
				zofishInteractionWith = curInteractableName
				zofishInteractionTime = GetGameTimeMillisecondsLoc()
				AHKVacuum.savedVars.zofishInteractSuccess[zofishInteractionWith] = zofishInteractionTime
			end
		end)
	SecurePostHook (ZO_Fishing, "StopInteraction", function()
			if zofishInteractionWith ~= nil then
				zofishInteractionEndWith = zofishInteractionWith
				zofishInteractingEndTime = GetGameTimeMillisecondsLoc()
				AHKVacuum.savedVars.zofishInteractEnded[zofishInteractionEndWith] = zofishInteractingEndTime-zofishInteractionTime
				zofishInteractionWith = nil
			end
		end)

	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_CHATTER_END, AHKVacuum.OnFinishInteracting) -- end of harvesting/fishing/not-searching(should work with onLootClosed)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_LOOT_CLOSED, AHKVacuum.OnFinishInteracting) -- seems to be needed for Search of bodies
	--EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_INTERACTION_ENDED, AHKVacuum.OnFinishInteracting) -- trying above
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_COMBAT_EVENT, AHKVacuum.OnFinishInteracting) -- to handle "Target is out of range"
	EVENT_MANAGER:AddFilterForEvent(AHKVacuum.name, EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_TARGET_OUT_OF_RANGE)

	--EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_NO_INTERACT_TARGET, AHKVacuum.ClearInteraction)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_LOOT_ITEM_FAILED, AHKVacuum.ClearInteraction)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_PENDING_INTERACTION_CANCELLED, AHKVacuum.ClearInteraction)

	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, AHKVacuum.HookFish)

	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_MOUNTED_STATE_CHANGED, AHKVacuum.OnMountedStateChange)

	InitLogs()
	--SLASH_COMMANDS["/keybindssave"] = KeybindsSave
	--SLASH_COMMANDS["/keybindsreset"] = KeybindsReset
	SLASH_COMMANDS["/afish"] = function()
			if not doAutoStartFishing then
				doAutoStartFishing = true
				d("Vacuum Start Fishing ON")
			else
				doAutoStartFishing = false
				d("Vacuum Start Fishing OFF")
			end
		end
end

function AHKVacuum:ShopDirectionRightOn()  ptk.SetIndOn (ptk.VK_D) end
function AHKVacuum:ShopDirectionRightOff() ptk.SetIndOff(ptk.VK_D) end
function AHKVacuum:ShopDirectionLeftOn()   ptk.SetIndOn (ptk.VK_A) end
function AHKVacuum:ShopDirectionLeftOff()  ptk.SetIndOff(ptk.VK_A) end
function AHKVacuum:ShopDirectionUpOn()     ptk.SetIndOn (ptk.VK_W) end
function AHKVacuum:ShopDirectionUpOff()    ptk.SetIndOff(ptk.VK_W) end
--function AHKVacuum:ShopDirectionDownOn()   ptk.SetIndOn (ptk.VK_S) end
--function AHKVacuum:ShopDirectionDownOff()  ptk.SetIndOff(ptk.VK_S) end
function AHKVacuum:ShopDirectionDownOn()   end
function AHKVacuum:ShopDirectionDownOff()  
	dmsg(""
					.." "..BoolDecode(isPressingKey, "PressingKey", "NotPressingKey")
					.."/"..BoolDecode(isInteracting, "Interacting", "NotInteracting")
					.."/"..BoolDecode(isFinishing, "Finishing", "NotFinishing"))
end


function AHKVacuum:ShopAutomoveToggle()
	if not doRidePickupAll then
		doRidePickupAll = true
		d("Horse Vacuum ON")
	else
		doRidePickupAll = false
		d("Horse Vacuum OFF")
	end
end
function AHKVacuum:ToggleAutoStartFishing()
	if not doAutoStartFishing then
		doAutoStartFishing = true
		d("Vacuum Start Fishing ON")
	else
		doAutoStartFishing = false
		d("Vacuum Start Fishing OFF")
	end
end

-- Then we create an event handler function which will be called when the "addon loaded" event
-- occurs. We'll use this to initialize our addon after all of its resources are fully loaded.
function AHKVacuum.OnAddOnLoaded(event, addonName) -- The event fires each time *any* addon loads - but we only care about when our own addon loads.
	if addonName == AHKVacuum.name then AHKVacuum:Initialize() end
end

-- Finally, we'll register our event handler function to be called when the proper event occurs.
EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_ADD_ON_LOADED, AHKVacuum.OnAddOnLoaded)