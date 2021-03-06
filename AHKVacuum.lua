-- For menu & data
AHKVacuum = {}
AHKVacuum.name = "AHKVacuum"
AHKVacuum.savedVars = {}
local ptk = LibPixelControl
local verbose = false -- true -- false
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
local blacklist = newIndexedSet("Bookshelf","Book Stack", "Spoiled Food","Greatsword","Sword","Axe","Bow","Shield","Staff","Sabatons","Jerkin","Dagger","Cuirass","Pauldron","Helm","Gauntlets","Guards","Boots","Shoes")
local insectsToTake = newIndexedSet("Wasp","Fleshflies","Butterfly","Torchbug","Dragonfly","Swamp Jelly","Fetcherfly")
local mountedWhitelist = newIndexedSet("Giant Clam", "Platinum Seam", "Heavy Sack", "Heavy Crate", "Chest", "Hidden Treasure", "Dirt Mound", "Skyshard", "Steam Pipe", "Wasp Nest",
	"Protean Runestone","Rich Platinum Seam","Rich Rubedite Ore","Pristine Ruby Ash Wood","Lush Ancestor Silk",
	"Lush Blessed Thistle","Lush Bugloss","Lush Columbine","Lush Corn Flower","Lush Dragonthorn","Lush Lady's Smock","Lush Mountain Flower","Lush Wormwood")
--[818] = "5763596;EVENT_RETICLE_TARGET_CHANGED;Take;Netch Calf;NotBlocked;0;nil;CanInteract;IsNotInteracting;NotMounted;NotTryingToMove;NotLooting;InteractionCameraNotActive;INTERACTION_NONE;;INTERACT_TARGET_TYPE_NONE;;false;{ [1] = 131119,} ",
--[827] = "5766800;AHKVacuum:OnReticleSetChanged;Excavate;Dig Site;NotBlocked;0;nil;CanInteract;IsNotInteracting;NotMounted;TryingToMove;NotLooting;InteractionCameraNotActive;INTERACTION_NONE;;INTERACT_TARGET_TYPE_NONE;;false;nil",

-- Local references for eso functions
local IsPlayerTryingToMoveLoc = IsPlayerTryingToMove -- Returns: boolean tryingToMove
local IsMountedLoc = IsMounted -- Returns: boolean mounted
local GetGameCameraInteractableActionInfoLoc = GetGameCameraInteractableActionInfo -- Returns: string:nilable action, string:nilable name, boolean interactBlocked, boolean isOwned, number additionalInfo, number:nilable contextualInfo, string:nilable contextualLink, boolean isCriminalInteract
local IsInteractingLoc = IsInteracting -- Returns: boolean interacting
local IsUnitInCombatLoc = IsUnitInCombat -- (string unitTag) Returns: boolean isInCombat
local GetUnitStealthStateLoc = GetUnitStealthState -- * GetUnitStealthState(*string* _unitTag_) ** _Returns:_ *integer* _stealthState_
local IsCrouchingLoc = function() return (GetUnitStealthStateLoc("player") ~= STEALTH_STATE_NONE) end
local IsGameCameraUIModeActiveLoc = IsGameCameraUIModeActive -- ** _Returns:_ *bool* _active_
-- Local variables
local prvAction, prvInteractableName, prvInteractBlocked, prvIsOwned, prvAdditionalInfo, prvContextualInfo, prvContextualLink, prvIsCriminalInteract
local curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract
local startedAction, startedInteractableName, startedInteractBlocked, startedIsOwned, startedAdditionalInfo, startedContextualInfo, startedContextualLink, startedIsCriminalInteract
local wasMovingBeforeLooting = false -- IsPlayerTryingToMoveLoc()
local wasMountedBeforeLooting = false -- IsMountedLoc()
local isPressingKey = false
local isInteracting = false
local isFinishing = false
--local handleFailSafe = nil
local doRidePickupAll = false
local doAutoStartFishing = false
local msLastPressE = 0 -- msLastPressE = GetGameTimeMillisecondsLoc()
local msLastInteractionBegin = 0 -- msLastInteractionBegin = GetGameTimeMillisecondsLoc()
local msLastInteractionEnd = 0 -- msLastInteractionEnd = GetGameTimeMillisecondsLoc()

local clientInteractingWith = nil -- EVENT_CLIENT_INTERACT_RESULT
local clientInteractingAction = nil
local clientInteractingTime = 0
local clientInteractingEndWith = nil -- EVENT_INTERACTION_ENDED
local clientInteractingEndTime = 0

local clientFinishingInteractionType = nil

local ZO_FishingInteractionWith = nil -- ZO_Fishing:StartInteraction
local ZO_FishingInteractionTime = 0
local ZO_FishingInteractionEndWith = nil -- ZO_Fishing:StopInteraction
local ZO_FishingInteractionEndTime = 0

local ClientInteractResult = {[CLIENT_INTERACT_RESULT_ANTIQUITY_DIGGING_NO_INVENTORY_SPACE]="CLIENT_INTERACT_RESULT_ANTIQUITY_DIGGING_NO_INVENTORY_SPACE",[CLIENT_INTERACT_RESULT_CANT_SWIM_AND_FISH]="CLIENT_INTERACT_RESULT_CANT_SWIM_AND_FISH",[CLIENT_INTERACT_RESULT_CANT_WHILE_FALLING]="CLIENT_INTERACT_RESULT_CANT_WHILE_FALLING",[CLIENT_INTERACT_RESULT_CANT_WHILE_SWIMMING]="CLIENT_INTERACT_RESULT_CANT_WHILE_SWIMMING",[CLIENT_INTERACT_RESULT_DONT_OWN_HOUSE_BANK]="CLIENT_INTERACT_RESULT_DONT_OWN_HOUSE_BANK",[CLIENT_INTERACT_RESULT_FAIL_DOOR_REQ]="CLIENT_INTERACT_RESULT_FAIL_DOOR_REQ",[CLIENT_INTERACT_RESULT_FEARFUL_VAMPIRE]="CLIENT_INTERACT_RESULT_FEARFUL_VAMPIRE",[CLIENT_INTERACT_RESULT_FEARFUL_WEREWOLF]="CLIENT_INTERACT_RESULT_FEARFUL_WEREWOLF",[CLIENT_INTERACT_RESULT_FLAVOR_NPC]="CLIENT_INTERACT_RESULT_FLAVOR_NPC",[CLIENT_INTERACT_RESULT_GENERIC_ERROR]="CLIENT_INTERACT_RESULT_GENERIC_ERROR",[CLIENT_INTERACT_RESULT_INTERACT_DISABLED]="CLIENT_INTERACT_RESULT_INTERACT_DISABLED",[CLIENT_INTERACT_RESULT_IN_COMBAT]="CLIENT_INTERACT_RESULT_IN_COMBAT",[CLIENT_INTERACT_RESULT_LOCK_TOO_DIFFICULT]="CLIENT_INTERACT_RESULT_LOCK_TOO_DIFFICULT",[CLIENT_INTERACT_RESULT_NO_LOCKPICKS]="CLIENT_INTERACT_RESULT_NO_LOCKPICKS",[CLIENT_INTERACT_RESULT_NO_LURE]="CLIENT_INTERACT_RESULT_NO_LURE",[CLIENT_INTERACT_RESULT_PICKPOCKET_NO_INVENTORY_SPACE]="CLIENT_INTERACT_RESULT_PICKPOCKET_NO_INVENTORY_SPACE",[CLIENT_INTERACT_RESULT_PICKPOCKET_ON_COOLDOWN]="CLIENT_INTERACT_RESULT_PICKPOCKET_ON_COOLDOWN",[CLIENT_INTERACT_RESULT_PICKPOCKET_OUT_OF_POSITION]="CLIENT_INTERACT_RESULT_PICKPOCKET_OUT_OF_POSITION",[CLIENT_INTERACT_RESULT_PICKPOCKET_TOO_FAR]="CLIENT_INTERACT_RESULT_PICKPOCKET_TOO_FAR",[CLIENT_INTERACT_RESULT_SHUNNED]="CLIENT_INTERACT_RESULT_SHUNNED",[CLIENT_INTERACT_RESULT_SHUNNED_FEARFUL_VAMPIRE]="CLIENT_INTERACT_RESULT_SHUNNED_FEARFUL_VAMPIRE",[CLIENT_INTERACT_RESULT_SHUNNED_FEARFUL_WEREWOLF]="CLIENT_INTERACT_RESULT_SHUNNED_FEARFUL_WEREWOLF",[CLIENT_INTERACT_RESULT_STEALING_PLACED_PREVENTED]="CLIENT_INTERACT_RESULT_STEALING_PLACED_PREVENTED",[CLIENT_INTERACT_RESULT_SUCCESS]="CLIENT_INTERACT_RESULT_SUCCESS",[CLIENT_INTERACT_RESULT_SUSPICIOUS]="CLIENT_INTERACT_RESULT_SUSPICIOUS",[CLIENT_INTERACT_RESULT_WEREWOLF]="CLIENT_INTERACT_RESULT_WEREWOLF",[CLIENT_INTERACT_RESULT_WEREWOLF_UNABLE_TO_CRAFT]="CLIENT_INTERACT_RESULT_WEREWOLF_UNABLE_TO_CRAFT"}
local InteractionType = {[INTERACTION_ANTIQUITY_DIG_SPOT]="INTERACTION_ANTIQUITY_DIG_SPOT",[INTERACTION_ANTIQUITY_SCRYING]="INTERACTION_ANTIQUITY_SCRYING",[INTERACTION_ATTRIBUTE_RESPEC]="INTERACTION_ATTRIBUTE_RESPEC",[INTERACTION_AVA_HOOK_POINT]="INTERACTION_AVA_HOOK_POINT",[INTERACTION_BANK]="INTERACTION_BANK",[INTERACTION_BOOK]="INTERACTION_BOOK",[INTERACTION_BUY_BAG_SPACE]="INTERACTION_BUY_BAG_SPACE",[INTERACTION_CONVERSATION]="INTERACTION_CONVERSATION",[INTERACTION_CRAFT]="INTERACTION_CRAFT",[INTERACTION_DYE_STATION]="INTERACTION_DYE_STATION",[INTERACTION_FAST_TRAVEL]="INTERACTION_FAST_TRAVEL",[INTERACTION_FAST_TRAVEL_KEEP]="INTERACTION_FAST_TRAVEL_KEEP",[INTERACTION_FISH]="INTERACTION_FISH",[INTERACTION_FURNITURE]="INTERACTION_FURNITURE",[INTERACTION_GUILDBANK]="INTERACTION_GUILDBANK",[INTERACTION_GUILDKIOSK_BID]="INTERACTION_GUILDKIOSK_BID",[INTERACTION_GUILDKIOSK_PURCHASE]="INTERACTION_GUILDKIOSK_PURCHASE",[INTERACTION_HARVEST]="INTERACTION_HARVEST",[INTERACTION_HIDEYHOLE]="INTERACTION_HIDEYHOLE",[INTERACTION_KEEP_GUILD_CLAIM]="INTERACTION_KEEP_GUILD_CLAIM",[INTERACTION_KEEP_GUILD_RELEASE]="INTERACTION_KEEP_GUILD_RELEASE",[INTERACTION_KEEP_INSPECT]="INTERACTION_KEEP_INSPECT",[INTERACTION_KEEP_PIECE]="INTERACTION_KEEP_PIECE",[INTERACTION_LOCKPICK]="INTERACTION_LOCKPICK",[INTERACTION_LOOT]="INTERACTION_LOOT",[INTERACTION_MAIL]="INTERACTION_MAIL",[INTERACTION_NONE]="INTERACTION_NONE",[INTERACTION_PAY_BOUNTY]="INTERACTION_PAY_BOUNTY",[INTERACTION_PICKPOCKET]="INTERACTION_PICKPOCKET",[INTERACTION_QUEST]="INTERACTION_QUEST",[INTERACTION_RETRAIT]="INTERACTION_RETRAIT",[INTERACTION_SIEGE]="INTERACTION_SIEGE",[INTERACTION_SKILL_RESPEC]="INTERACTION_SKILL_RESPEC",[INTERACTION_STABLE]="INTERACTION_STABLE",[INTERACTION_STONE_MASON]="INTERACTION_STONE_MASON",[INTERACTION_STORE]="INTERACTION_STORE",[INTERACTION_TRADINGHOUSE]="INTERACTION_TRADINGHOUSE",[INTERACTION_TREASURE_MAP]="INTERACTION_TREASURE_MAP",[INTERACTION_VENDOR]="INTERACTION_VENDOR"}
local InteractCancelContext = {[INTERACT_CANCEL_CONTEXT_COMBAT]="INTERACT_CANCEL_CONTEXT_COMBAT",[INTERACT_CANCEL_CONTEXT_DEFAULT]="INTERACT_CANCEL_CONTEXT_DEFAULT"}
local InteractTargetType ={[INTERACT_TARGET_TYPE_AOE_LOOT]="INTERACT_TARGET_TYPE_AOE_LOOT",[INTERACT_TARGET_TYPE_CLIENT_CHARACTER]="INTERACT_TARGET_TYPE_CLIENT_CHARACTER",[INTERACT_TARGET_TYPE_COLLECTIBLE]="INTERACT_TARGET_TYPE_COLLECTIBLE",[INTERACT_TARGET_TYPE_FIXTURE]="INTERACT_TARGET_TYPE_FIXTURE",[INTERACT_TARGET_TYPE_ITEM]="INTERACT_TARGET_TYPE_ITEM",[INTERACT_TARGET_TYPE_NONE]="INTERACT_TARGET_TYPE_NONE",[INTERACT_TARGET_TYPE_OBJECT]="INTERACT_TARGET_TYPE_OBJECT",[INTERACT_TARGET_TYPE_QUEST_ITEM]="INTERACT_TARGET_TYPE_QUEST_ITEM",}
local StealthState ={[STEALTH_STATE_DETECTED]="STEALTH_STATE_DETECTED",[STEALTH_STATE_HIDDEN]="STEALTH_STATE_HIDDEN",[STEALTH_STATE_HIDDEN_ALMOST_DETECTED]="STEALTH_STATE_HIDDEN_ALMOST_DETECTED",[STEALTH_STATE_HIDING]="STEALTH_STATE_HIDING",[STEALTH_STATE_NONE]="STEALTH_STATE_NONE",[STEALTH_STATE_STEALTH]="STEALTH_STATE_STEALTH",[STEALTH_STATE_STEALTH_ALMOST_DETECTED]="STEALTH_STATE_STEALTH_ALMOST_DETECTED",}

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
	if verbose then
		local ms_log_time = GetGameTimeMillisecondsLoc()
		local strArgs = ""
		local sep = ";"
		--for _,value in pairs(args) do strArgs = strArgs..","..tostring(value) end
		curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract = GetGameCameraInteractableActionInfoLoc()
		local lootName, targetType, actionName, isOwned = GetLootTargetInfo()
		strArgs = tostring(ms_log_time)..sep..eventName
			..sep..tostring(curAction)..sep..tostring(curInteractableName) ..sep..BoolDecode(curInteractBlocked, "Blocked", "NotBlocked") ..sep..tostring(curAdditionalInfo) ..sep..tostring(curContextualInfo)
			..sep..BoolDecode(CanInteractWithItem(), "CanInteract", "CanNotInteract")
			..sep..BoolDecode(IsInteractingLoc(), "IsInteracting", "IsNotInteracting")
			..sep..BoolDecode(IsMountedLoc(), "Mounted", "NotMounted")
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
end
local useItem = IsProtectedFunction("UseItem") and function(...)
		return CallSecureProtected("UseItem", ...)
	end or function(...)
		UseItem(...)
		return true
	end
function GetNextFish()
    local bagSize = GetBagSize(BAG_BACKPACK)
    for slotIndex = 0, bagSize - 1 do
		local itemType = GetItemType(BAG_BACKPACK, slotIndex)
		if GetItemType(BAG_BACKPACK, slotIndex) == ITEMTYPE_FISH then
			dmsg("fish in slot:"..tostring(slotIndex))
			return slotIndex
		end
	end
	dmsg("no fish")
	return nil
end
function UseNextFish()
	local nextFish = GetNextFish()
	--dmsg("Using fish in slot:"..tostring(nextFish))
	LogValues("UseNextFish:"..tostring(nextFish))
	if nextFish then
		useItem(BAG_BACKPACK, nextFish)
	end
end
local function tapE()
	if not IsGameCameraUIModeActiveLoc() then
		isPressingKey = true
		dmsg("Tap E - "..tostring(curInteractableName))
		LogValues("tapE")
		ptk.SetIndOnFor(ptk.VK_E, 20)
		zo_callLater(function() isPressingKey = false end, 100)
		msLastPressE = GetGameTimeMillisecondsLoc()
	end
end
local function tapT()
	if not IsGameCameraUIModeActiveLoc() then
		dmsg("Tap T")
		ptk.SetIndOnFor(ptk.VK_T, 20)
	end
end
local function tapH()
	if not IsGameCameraUIModeActiveLoc() then
		dmsg("Tap H")
		ptk.SetIndOnFor(ptk.VK_H, 20)
	end
end
local function CurFocus()
	curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract = GetGameCameraInteractableActionInfoLoc()
	local retval = " - "..tostring(curAction).."/"..tostring(curInteractableName)
					.."/"..BoolDecode(curInteractBlocked, "Blocked", "NotBlocked")
					.."/"..BoolDecode(CanInteractWithItem(), "CanInteract", "CanNotInteract")
					.."/"..BoolDecode(IsInteractingLoc(), "IsInteracting", "IsNotInteracting")
					.."/"..BoolDecode(IsPlayerTryingToMoveLoc(), "TryingToMove", "NotTryingToMove")
	return retval
end
function AHKVacuum.ClearInteraction()
	dmsg("ClearInteraction"..CurFocus())
	isPressingKey = false
	isInteracting = false
	isFinishing = false
	clientInteractingWith = nil
	--wasMovingBeforeLooting = false
	--wasMountedBeforeLooting = false
end
local function IsApprovedInteractable()
	if curAction ~= nil and curInteractableName ~= nil
		and not curInteractBlocked
		and not curIsCriminalInteract
		and (curAdditionalInfo == ADDITIONAL_INTERACT_INFO_NONE
			or curAdditionalInfo == ADDITIONAL_INTERACT_INFO_LOCKED
			or curAdditionalInfo == ADDITIONAL_INTERACT_INFO_FISHING_NODE)
		and (actionsToTakeByDefault[curAction] ~= nil or mountedWhitelist[curInteractableName] ~= nil)
		and blacklist[curInteractableName] == nil
		and (doRidePickupAll or mountedWhitelist[curInteractableName] ~= nil or not IsMountedLoc())
		and (insectsToTake[curInteractableName] == nil or not IsMountedLoc())
		and (doAutoStartFishing or curAdditionalInfo ~= ADDITIONAL_INTERACT_INFO_FISHING_NODE or clientFinishingInteractionType == INTERACTION_LOOT)
		and not IsGameCameraUIModeActiveLoc() -- not in menu
		and not IsUnitInCombatLoc("player") -- not in combat
		and GetUnitStealthStateLoc("player") == STEALTH_STATE_NONE -- not crouched
	then return true else return false end
end
function AHKVacuum.OnReticleSet()
	curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract = GetGameCameraInteractableActionInfoLoc()
	if curAction~=prvAction or curInteractableName~=prvInteractableName or curInteractBlocked~=prvInteractBlocked or curIsOwned~=prvIsOwned or curAdditionalInfo~=prvAdditionalInfo or curContextualInfo~=prvContextualInfo or curContextualLink~=prvContextualLink or curIsCriminalInteract~=prvIsCriminalInteract then 
		--if curInteractableName~=nil and curInteractableName~=startedInteractableName and not curInteractBlocked then
		--	AHKVacuum.ClearInteraction()
		--end
		prvAction, prvInteractableName, prvInteractBlocked, prvIsOwned, prvAdditionalInfo, prvContextualInfo, prvContextualLink, prvIsCriminalInteract = curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract
		LogValues("AHKVacuum:OnReticleSetChanged")
	end
	local curTime = GetGameTimeMillisecondsLoc()
	--if not isPressingKey and not isInteracting and not isFinishing and msLastPressE < curTime+100 then
	--if curTime > msLastPressE+100 and curTime > msLastInteractionBegin+1500 and not isInteracting and not isFinishing then
	if curTime > msLastPressE+200 and clientInteractingWith==nil and not isFinishing and not IsInteractingLoc() then
		curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract = GetGameCameraInteractableActionInfoLoc()
		if IsApprovedInteractable() then
			--dmsg("OnReticleSet"..CurFocus())
			if IsPlayerTryingToMoveLoc() then 
				wasMovingBeforeLooting = true 
				if IsMountedLoc() then wasMountedBeforeLooting = true else wasMountedBeforeLooting = false end
			else
				wasMovingBeforeLooting = false
			end
			if curAction=="Take" and insectsToTake[curInteractableName] == nil then
				wasMovingBeforeLooting = false
				wasMountedBeforeLooting = false
			end
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
			msLastInteractionBegin = GetGameTimeMillisecondsLoc()
			isPressingKey = false
			isFinishing = false
		--end
	--end
end
function AHKVacuum.OnFinishInteracting()
	startedAction, startedInteractableName, startedInteractBlocked, startedIsOwned, startedAdditionalInfo, startedContextualInfo, startedContextualLink, startedIsCriminalInteract = {}
	if clientInteractingWith ~= nil then
		clientInteractingEndWith = clientInteractingWith
		clientInteractingEndTime = GetGameTimeMillisecondsLoc()
		AHKVacuum.savedVars.interactEnded[clientInteractingEndWith] = clientInteractingEndTime-clientInteractingTime
	end
	clientInteractingWith = nil
	msLastInteractionEnd = GetGameTimeMillisecondsLoc()
	dmsg("OnFinishInteracting."..CurFocus())
	if isInteracting then
		isInteracting = false
		isFinishing = true
		--AHKVacuum.OnFinishInteracting()
		LogValues("OnFinishInteracting")
		-- Since we finished, do a manual check to determine whether to interact again or resume actions
		curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract = GetGameCameraInteractableActionInfoLoc()
		-- Depending on why the interaction stopped, if there's another thing to loot then do it, otherwise resume movement
		if IsUnitInCombatLoc("player") then
			dmsg("Finished and in combat."..CurFocus())
			isFinishing = false
			wasMovingBeforeLooting = false
			wasMountedBeforeLooting = false
		elseif IsGameCameraUIModeActiveLoc() then
			dmsg("Finished and in menu."..CurFocus())
			isFinishing = false
			wasMovingBeforeLooting = false
			wasMountedBeforeLooting = false
		elseif IsApprovedInteractable() then
			tapE()
			isFinishing = false
			dmsg("Interact with next item:"..CurFocus())
		elseif clientInteractingAction == "Fish" then
			UseNextFish()
			isFinishing = false
			wasMovingBeforeLooting = false
			wasMountedBeforeLooting = false
		elseif wasMountedBeforeLooting and not IsMountedLoc() then
			dmsg("wasMountedBeforeLooting")
			isFinishing = false
			wasMountedBeforeLooting = false
			tapH()
		elseif wasMovingBeforeLooting then
			dmsg("wasMovingBeforeLooting")
			isFinishing = false
			wasMovingBeforeLooting = false
			wasMountedBeforeLooting = false
			tapT()
		else
			dmsg("NOT wasMountedBeforeLooting, NOT wasMovingBeforeLooting")
			isFinishing = false
			wasMovingBeforeLooting = false
			wasMountedBeforeLooting = false
			AHKVacuum.ClearInteraction()
		end
	end
end

function AHKVacuum.OnMountedStateChange(eventCode, mounted)
	dmsg("OnMountedStateChange"
		--.." "..BoolDecode(isPressingKey, "PressingKey", "NotPressingKey")
		.." ".."SinceKey:"..tostring(GetGameTimeMillisecondsLoc()-msLastPressE)
		.."/"..BoolDecode(isInteracting, "Interacting", "NotInteracting")
		.."/"..BoolDecode(isFinishing, "Finishing", "NotFinishing"))
	if mounted then
		if mounted and wasMovingBeforeLooting and not IsPlayerTryingToMoveLoc() then
			--d("wasMovingBeforeLooting")
			tapT()
			--zo_callLater(AHKVacuum.ClearInteraction, 50)
		end
		AHKVacuum.ClearInteraction()
		wasMovingBeforeLooting = false
		wasMountedBeforeLooting = false
	end
end

function AHKVacuum.HookFish(eventCode, bagId, slotId, isNewItem, itemSoundCategory, inventoryUpdateReason, stackCountChange) -- EVENT_INVENTORY_SINGLE_SLOT_UPDATE (number eventCode, Bag bagId, number slotId, boolean isNewItem, ItemUISoundCategory itemSoundCategory, number inventoryUpdateReason, number stackCountChange)
	--if (GetItemType(bagId,slotId) == ITEMTYPE_LURE and isNewItem == false and stackCountChange == -1 and itemSoundCategory == ITEM_SOUND_CATEGORY_LURE) then
	local itemType = GetItemType(bagId,slotId)
	--if (itemType == ITEMTYPE_LURE and isNewItem == false and stackCountChange == -1 and itemSoundCategory == ITEM_SOUND_CATEGORY_LURE) then
	if ((itemType == ITEMTYPE_LURE or itemSoundCategory == ITEM_SOUND_CATEGORY_LURE) and isNewItem == false and stackCountChange == -1) then
		dmsg("Lure used, pressing E")
		ptk.SetIndOnFor(ptk.VK_E, 20)
	elseif ((itemType == ITEMTYPE_FISH or itemSoundCategory == ITEM_SOUND_CATEGORY_FISH) and isNewItem == false and stackCountChange == -1) then
		dmsg("Filleted fish. Using next")
		LogValues("zo_callLater UseNextFish 1000")
		zo_callLater(UseNextFish, 1000)
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

	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."LOG", EVENT_GAME_CAMERA_ACTIVATED, function(...) LogValues("EVENT_GAME_CAMERA_ACTIVATED", {...}) end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."LOG", EVENT_GAME_CAMERA_DEACTIVATED, function(...) LogValues("EVENT_GAME_CAMERA_DEACTIVATED", {...}) end)
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

	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."LOG", EVENT_INVENTORY_SINGLE_SLOT_UPDATE, function(...) LogValues("EVENT_INVENTORY_SINGLE_SLOT_UPDATE", {...}) end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name.."LOG", EVENT_ACTION_UPDATE_COOLDOWNS, function(...) LogValues("EVENT_ACTION_UPDATE_COOLDOWNS", {...}) end)


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
			local curTime = GetGameTimeMillisecondsLoc()
			if curTime >= msLastPressE+2000 then
				AHKVacuum.ClearInteraction()
				wasMovingBeforeLooting = false
				wasMountedBeforeLooting = false
			end
			--if result == CLIENT_INTERACT_RESULT_SUCCESS then
			if result == CLIENT_INTERACT_RESULT_SUCCESS and not IsPlayerTryingToMoveLoc() and curTime < msLastPressE+2000 then
				startedAction, startedInteractableName, startedInteractBlocked, startedIsOwned, startedAdditionalInfo, startedContextualInfo, startedContextualLink, startedIsCriminalInteract = curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract
--if curAction~=startedAction or curInteractableName~=startedInteractableName or curInteractBlocked~=startedInteractBlocked or curIsOwned~=startedIsOwned or curAdditionalInfo~=startedAdditionalInfo or curContextualInfo~=startedContextualInfo or curContextualLink~=startedContextualLink or curIsCriminalInteract~=startedIsCriminalInteract then 
				isInteracting = true
				msLastInteractionBegin = curTime
				isFinishing = false

				clientInteractingWith = interactTargetName
				clientInteractingAction = curAction
				clientInteractingTime = curTime
				AHKVacuum.savedVars.interactResultSuccess[clientInteractingWith] = clientInteractingTime
				if curAction == "Fish" then
					AHKVacuum.OnBeginInteracting()
					wasMovingBeforeLooting = false
					wasMountedBeforeLooting = true
				end
			end
			dmsg("EVENT_CLIENT_INTERACT_RESULT: "..tostring(ClientInteractResult[result]).." "..tostring(interactTargetName))
		end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_INTERACTION_ENDED, function(_, interactType, cancelContext)
			dmsg("EVENT_INTERACTION_ENDED: "..tostring(InteractionType[interactType]).." "..tostring(InteractCancelContext[cancelContext]))
			if curAction == "Fish" then
				isInteracting = true
				clientFinishingInteractionType = interactType
			end
			AHKVacuum.OnFinishInteracting()
			clientFinishingInteractionType = nil
		end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_COMBAT_EVENT, AHKVacuum.OnFinishInteracting)
	EVENT_MANAGER:AddFilterForEvent(AHKVacuum.name, EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_TARGET_OUT_OF_RANGE)

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

	--EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_CHATTER_END, AHKVacuum.OnFinishInteracting) -- end of harvesting/fishing/not-searching(should work with onLootClosed)
	--EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_LOOT_CLOSED, AHKVacuum.OnFinishInteracting) -- seems to be needed for Search of bodies
	--EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_INTERACTION_ENDED, AHKVacuum.OnFinishInteracting) -- trying above
	--EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_COMBAT_EVENT, AHKVacuum.OnFinishInteracting) -- to handle "Target is out of range"
	--EVENT_MANAGER:AddFilterForEvent(AHKVacuum.name, EVENT_COMBAT_EVENT, REGISTER_FILTER_COMBAT_RESULT, ACTION_RESULT_TARGET_OUT_OF_RANGE)

	--EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_NO_INTERACT_TARGET, AHKVacuum.ClearInteraction)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_LOOT_ITEM_FAILED, AHKVacuum.ClearInteraction)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_PENDING_INTERACTION_CANCELLED, AHKVacuum.ClearInteraction)

	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, AHKVacuum.HookFish)

	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_MOUNTED_STATE_CHANGED, AHKVacuum.OnMountedStateChange)
	if GetUnitDisplayName("player") == "@Phrosty1" then
		verbose = true
		--verbose = false
		InitLogs()
	end
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
--function AHKVacuum:ShopDirectionUpOn()     ptk.SetIndOn (ptk.VK_W) end
--function AHKVacuum:ShopDirectionUpOff()    ptk.SetIndOff(ptk.VK_W) end
--function AHKVacuum:ShopDirectionDownOn()   ptk.SetIndOn (ptk.VK_S) end
--function AHKVacuum:ShopDirectionDownOff()  ptk.SetIndOff(ptk.VK_S) end
function AHKVacuum:ShopDirectionUpOn() end
function AHKVacuum:ShopDirectionUpOff()  
	d(""
		.." "..BoolDecode(isPressingKey, "PressingKey", "NotPressingKey")
		.."/"..BoolDecode(isInteracting, "Interacting", "NotInteracting")
		.."/"..BoolDecode(isFinishing, "Finishing", "NotFinishing"))
	d("clientInteractingWith:"..tostring(clientInteractingWith))
	d("Player:"..tostring(GetUnitDisplayName("player")))
	d("ITEM_SOUND_CATEGORY_LURE:"..tostring(ITEM_SOUND_CATEGORY_LURE)) -- 39
	d("ITEM_SOUND_CATEGORY_FISH:"..tostring(ITEM_SOUND_CATEGORY_FISH)) -- 43
	local StealthState ={[STEALTH_STATE_DETECTED]="STEALTH_STATE_DETECTED",[STEALTH_STATE_HIDDEN]="STEALTH_STATE_HIDDEN",[STEALTH_STATE_HIDDEN_ALMOST_DETECTED]="STEALTH_STATE_HIDDEN_ALMOST_DETECTED",[STEALTH_STATE_HIDING]="STEALTH_STATE_HIDING",[STEALTH_STATE_NONE]="STEALTH_STATE_NONE",[STEALTH_STATE_STEALTH]="STEALTH_STATE_STEALTH",[STEALTH_STATE_STEALTH_ALMOST_DETECTED]="STEALTH_STATE_STEALTH_ALMOST_DETECTED",}
	d("StealthStateNum: "..tostring(GetUnitStealthState("player")))
	d("StealthState: "..tostring(StealthState[GetUnitStealthState("player")]))
end
function AHKVacuum:ShopDirectionDownOn() end
function AHKVacuum:ShopDirectionDownOff()  
	UseNextFish()
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
