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
local function newActionSet()
	local retval = {
			takeByDefault = true,
			whitelist = {},
			blacklist = {},
		}
	return retval
end
local gameCameraAdditionalInfo = {}
gameCameraAdditionalInfo[ADDITIONAL_INTERACT_INFO_EMPTY]="EMPTY"
gameCameraAdditionalInfo[ADDITIONAL_INTERACT_INFO_FISHING_NODE]="FISHING_NODE"
gameCameraAdditionalInfo[ADDITIONAL_INTERACT_INFO_HOUSE_BANK]="HOUSE_BANK"
gameCameraAdditionalInfo[ADDITIONAL_INTERACT_INFO_INSTANCE_TYPE]="INSTANCE_TYPE"
gameCameraAdditionalInfo[ADDITIONAL_INTERACT_INFO_IN_HIDEYHOLE]="IN_HIDEYHOLE"
gameCameraAdditionalInfo[ADDITIONAL_INTERACT_INFO_LOCKED]="LOCKED"
gameCameraAdditionalInfo[ADDITIONAL_INTERACT_INFO_NONE]="NONE"
gameCameraAdditionalInfo[ADDITIONAL_INTERACT_INFO_PICKPOCKET_CHANCE]="PICKPOCKET_CHANCE"
gameCameraAdditionalInfo[ADDITIONAL_INTERACT_INFO_REQUIRES_KEY]="REQUIRES_KEY"
gameCameraAdditionalInfo[ADDITIONAL_INTERACT_INFO_WEREWOLF_ACTIVE_WHILE_ATTEMPTING_TO_CRAFT]="WEREWOLF_ACTIVE_WHILE_ATTEMPTING_TO_CRAFT"
local clientInteractResult = {}
clientInteractResult[CLIENT_INTERACT_RESULT_CANT_SWIM_AND_FISH]="CANT_SWIM_AND_FISH"
clientInteractResult[CLIENT_INTERACT_RESULT_DONT_OWN_HOUSE_BANK]="DONT_OWN_HOUSE_BANK"
clientInteractResult[CLIENT_INTERACT_RESULT_FAIL_DOOR_REQ]="FAIL_DOOR_REQ"
clientInteractResult[CLIENT_INTERACT_RESULT_FLAVOR_NPC]="FLAVOR_NPC"
clientInteractResult[CLIENT_INTERACT_RESULT_INTERACT_DISABLED]="INTERACT_DISABLED"
clientInteractResult[CLIENT_INTERACT_RESULT_IN_COMBAT]="IN_COMBAT"
clientInteractResult[CLIENT_INTERACT_RESULT_LOCK_TOO_DIFFICULT]="LOCK_TOO_DIFFICULT"
clientInteractResult[CLIENT_INTERACT_RESULT_NO_LOCKPICKS]="NO_LOCKPICKS"
clientInteractResult[CLIENT_INTERACT_RESULT_NO_LURE]="NO_LURE"
clientInteractResult[CLIENT_INTERACT_RESULT_PICKPOCKET_NO_INVENTORY_SPACE]="PICKPOCKET_NO_INVENTORY_SPACE"
clientInteractResult[CLIENT_INTERACT_RESULT_PICKPOCKET_ON_COOLDOWN]="PICKPOCKET_ON_COOLDOWN"
clientInteractResult[CLIENT_INTERACT_RESULT_PICKPOCKET_OUT_OF_POSITION]="PICKPOCKET_OUT_OF_POSITION"
clientInteractResult[CLIENT_INTERACT_RESULT_PICKPOCKET_TOO_FAR]="PICKPOCKET_TOO_FAR"
clientInteractResult[CLIENT_INTERACT_RESULT_SHUNNED]="SHUNNED"
clientInteractResult[CLIENT_INTERACT_RESULT_SUCCESS]="SUCCESS"
clientInteractResult[CLIENT_INTERACT_RESULT_SUSPICIOUS]="SUSPICIOUS"
clientInteractResult[CLIENT_INTERACT_RESULT_WEREWOLF]="WEREWOLF"
clientInteractResult[CLIENT_INTERACT_RESULT_WEREWOLF_UNABLE_TO_CRAFT]="WEREWOLF_UNABLE_TO_CRAFT"


AHKVacuum.lootActions = {}
AHKVacuum.lootActions["Search"] = newActionSet()
AHKVacuum.lootActions["Search"].blacklist = newIndexedSet("Bookshelf","Book Stack")
AHKVacuum.lootActions["Take"] = newActionSet()
AHKVacuum.lootActions["Take"].blacklist = newIndexedSet("SpoiledFood","Greatsword","Sword","Axe","Bow","Shield","Staff","Sabatons","Jerkin","Dagger","Cuirass","Pauldron","Helm","Gauntlets","Guards","Boots","Shoes","Wasp","Fleshflies","Butterfly","Torchbug")
AHKVacuum.lootActions["Collect"] = newActionSet()
AHKVacuum.lootActions["Mine"] = newActionSet()
AHKVacuum.lootActions["Cut"] = newActionSet()
AHKVacuum.lootActions["Use"] = newActionSet()
AHKVacuum.lootActions["Use"].takeByDefault = false
AHKVacuum.lootActions["Use"].whitelist = newIndexedSet("Giant Clam", "Hidden Treasure")
AHKVacuum.lootActions["Unlock"] = newActionSet()
AHKVacuum.lootActions["Unlock"].whitelist = newIndexedSet("Chest")
AHKVacuum.lootActions["Dig"] = newActionSet()
AHKVacuum.lootActions["Dig"].whitelist = newIndexedSet("Dirt Mound")
AHKVacuum.lootActions["Dig Up"] = newActionSet()
AHKVacuum.lootActions["Dig Up"].whitelist = newIndexedSet("Dirt Mound")
AHKVacuum.lootActions["Fish"] = newActionSet()
AHKVacuum.lootActions["Reel In"] = newActionSet()
AHKVacuum.ridinglist = newIndexedSet("Giant Clam", "Platinum Seam", "Heavy Sack", "Heavy Crate", "Chest")

-- Local references for eso functions
local IsPlayerMovingLoc = IsPlayerMoving -- Returns: boolean moving
local IsPlayerTryingToMoveLoc = IsPlayerTryingToMove -- Returns: boolean tryingToMove
local IsMountedLoc = IsMounted -- Returns: boolean mounted
local GetGameCameraInteractableActionInfoLoc = GetGameCameraInteractableActionInfo -- Returns: string:nilable action, string:nilable name, boolean interactBlocked, boolean isOwned, number additionalInfo, number:nilable contextualInfo, string:nilable contextualLink, boolean isCriminalInteract
local GetMapPlayerPositionLoc = GetMapPlayerPosition -- Returns: number normalizedX, number normalizedZ, number heading, boolean isShownInCurrentMap
local IsUnitInCombatLoc = IsUnitInCombat -- (string unitTag) Returns: boolean isInCombat
-- IsUnitAttackable( "reticleover" )

-- Local variables
local curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract = GetGameCameraInteractableActionInfoLoc()
local prvAction, prvInteractableName, prvInteractBlocked, prvIsOwned, prvAdditionalInfo, prvContextualInfo, prvContextualLink, prvIsCriminalInteract = curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract
local isPressingRight, isPressingLeft, isPressingUp, isPressingDown = false, false, false, false
local doRidePickupAll = false
local resumeReticleWatch = GetGameTimeMillisecondsLoc()
local wasMovingBeforeLooting = false -- IsPlayerTryingToMoveLoc()
local wasMountedBeforeLooting = false -- IsMountedLoc()
local isActivelyLooting = false
local isPressingKey = false


local function resetToWandering()
	wasMovingBeforeLooting = false
	wasMountedBeforeLooting = false
	isActivelyLooting = false
end
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
function AHKVacuum:ShopAutomoveToggle()
	if not doRidePickupAll then
		doRidePickupAll = true
		d("Vacuum ON")
	else
		doRidePickupAll = false
		d("Vacuum OFF")
	end
end
function AHKVacuum:ShopDirectionRightOn()  ptk.SetIndOn (ptk.VK_D) isPressingRight = true  end
function AHKVacuum:ShopDirectionRightOff() ptk.SetIndOff(ptk.VK_D) isPressingRight = false end
function AHKVacuum:ShopDirectionLeftOn()   ptk.SetIndOn (ptk.VK_A) isPressingLeft = true   end
function AHKVacuum:ShopDirectionLeftOff()  ptk.SetIndOff(ptk.VK_A) isPressingLeft = false  end
function AHKVacuum:ShopDirectionUpOn()     ptk.SetIndOn (ptk.VK_W) isPressingUp = true     end
function AHKVacuum:ShopDirectionUpOff()    ptk.SetIndOff(ptk.VK_W) isPressingUp = false    end
--function AHKVacuum:ShopDirectionDownOn()   ptk.SetIndOn (ptk.VK_S) isPressingDown = true   end
--function AHKVacuum:ShopDirectionDownOff()  ptk.SetIndOff(ptk.VK_S) isPressingDown = false  end
function AHKVacuum:ShopDirectionDownOn()
	local action, interactableName, interactBlocked, isOwned, additionalInfo, contextualInfo, contextualLink, isCriminalInteract = GetGameCameraInteractableActionInfo()
	d("".." act:"..tostring(action)
		.." nm:"..tostring(interactableName)
		.." blk:"..tostring(interactBlocked)
		.." own:"..tostring(isOwned)
		.." addInfo:"..tostring(additionalInfo).."-"..tostring(gameCameraAdditionalInfo[additionalInfo])
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
end
function AHKVacuum:ShopDirectionDownOff()
end

local isInteracting = false
function AHKVacuum.OnReticleSet()
	if not isPressingKey and not isInteracting then
		prvAction, prvInteractableName, prvInteractBlocked, prvIsOwned, prvAdditionalInfo, prvContextualInfo, prvContextualLink, prvIsCriminalInteract = curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract
		curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract = GetGameCameraInteractableActionInfoLoc()
		if curAction ~= nil and curInteractableName ~= nil
			and not curInteractBlocked
			and not curIsCriminalInteract
			and (curAdditionalInfo == ADDITIONAL_INTERACT_INFO_NONE or curAdditionalInfo == ADDITIONAL_INTERACT_INFO_FISHING_NODE)
			and AHKVacuum.lootActions[curAction] ~= nil
		then
			local lootAction = AHKVacuum.lootActions[curAction]
			if ((lootAction.takeByDefault and lootAction.blacklist[curInteractableName] == nil) or lootAction.whitelist[curInteractableName] ~= nil) then
				if doRidePickupAll or not IsMountedLoc() or AHKVacuum.ridinglist[curInteractableName] ~= nil then
					tapE()
					zo_callLater(function() isPressingKey = false end, 200)
					isPressingKey = true
					dmsg("curInteractableName:"..tostring(curInteractableName).." Pressing:"..tostring(isPressingKey))
				end
			end
		end

	end
end
function AHKVacuum.OnBeginInteracting()
	dmsg("OnBeginInteracting")
	isInteracting = true
end
function AHKVacuum.OnFinishInteracting()
	dmsg("OnFinishInteracting")
	isInteracting = false
	isPressingKey = false
end

local function DoLoot()
	dmsg("Do "..tostring(curAction))
	if IsPlayerTryingToMoveLoc() then wasMovingBeforeLooting = true end
	if IsMountedLoc() then wasMountedBeforeLooting = true end
	if curAction == "Search" and IsPlayerTryingToMoveLoc() then
		zo_callLater(function() tapE() end, 100)
	else
		tapE()
	end
	resumeReticleWatch = GetGameTimeMillisecondsLoc() + 25000
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, AHKVacuum.OnInventorySingleSlotUpdate)
end

-- EVENT_INVENTORY_SINGLE_SLOT_UPDATE (number eventCode, Bag bagId, number slotId, boolean isNewItem, ItemUISoundCategory itemSoundCategory, number inventoryUpdateReason, number stackCountChange)
function AHKVacuum.OnInventorySingleSlotUpdate(eventCode, bagId, slotId, isNewItem, itemSoundCategory, inventoryUpdateReason, stackCountChange)
	EVENT_MANAGER:UnregisterForEvent(AHKVacuum.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE)
	dmsg("Item Collected.")
	curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract = GetGameCameraInteractableActionInfoLoc()
	resumeReticleWatch = GetGameTimeMillisecondsLoc()
	AHKVacuum.OnReticleChanged()

	if GetGameTimeMillisecondsLoc() >= resumeReticleWatch then -- if we haven't already engaged in picking up another item then resume moving
		dmsg("resumeReticleWatch.")
		if wasMountedBeforeLooting and wasMovingBeforeLooting then
			d("wasMountedBeforeLooting and wasMovingBeforeLooting")
			zo_callLater(function() tapH() end, 0)
			zo_callLater(function() tapT() end, 200)
		elseif wasMovingBeforeLooting then
			d("wasMovingBeforeLooting")
			tapT()
		elseif wasMountedBeforeLooting then
			d("wasMountedBeforeLooting")
			tapH()
		end
		wasMountedBeforeLooting = false
		wasMovingBeforeLooting = false
	end
end
function AHKVacuum.OnReticleSetOld()
	if GetGameTimeMillisecondsLoc() >= resumeReticleWatch then
		prvAction, prvInteractableName, prvInteractBlocked, prvIsOwned, prvAdditionalInfo, prvContextualInfo, prvContextualLink, prvIsCriminalInteract = curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract
		curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract = GetGameCameraInteractableActionInfoLoc()
		--if curAction ~= prvAction or curInteractableName ~= prvInteractableName or curInteractBlocked ~= prvInteractBlocked then AHKVacuum.OnReticleChanged() end
		if curAction ~= prvAction
		  or curInteractableName ~= prvInteractableName
		  or curInteractBlocked ~= prvInteractBlocked
		  or curIsOwned ~= prvIsOwned
		  or curAdditionalInfo ~= prvAdditionalInfo
		  or curContextualInfo ~= prvContextualInfo
		  or curContextualLink ~= prvContextualLink
		  or curIsCriminalInteract ~= prvIsCriminalInteract then
			--dmsg("Reticle Change")
			--local action, interactableName, interactBlocked, isOwned, additionalInfo, contextualInfo, contextualLink, isCriminalInteract = prvAction, prvInteractableName, prvInteractBlocked, prvIsOwned, prvAdditionalInfo, prvContextualInfo, prvContextualLink, prvIsCriminalInteract
			--d("Prv ".." act:"..tostring(action)
			--	.." nm:"..tostring(interactableName)
			--	.." blk:"..tostring(interactBlocked)
			--	.." own:"..tostring(isOwned)
			--	.." addInfo:"..tostring(additionalInfo)
			--	.." ctxInfo:"..tostring(contextualInfo)
			--	.." ctxLink:"..tostring(contextualLink)
			--	.." crim:"..tostring(isCriminalInteract))
			--local action, interactableName, interactBlocked, isOwned, additionalInfo, contextualInfo, contextualLink, isCriminalInteract = curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract
			--d("Cur ".." act:"..tostring(action)
			--	.." nm:"..tostring(interactableName)
			--	.." blk:"..tostring(interactBlocked)
			--	.." own:"..tostring(isOwned)
			--	.." addInfo:"..tostring(additionalInfo)
			--	.." ctxInfo:"..tostring(contextualInfo)
			--	.." ctxLink:"..tostring(contextualLink)
			--	.." crim:"..tostring(isCriminalInteract))
			AHKVacuum.OnReticleChanged()
		end
	end
end
local function IsCurFocusSetForInteract()
	if curAction ~= nil and curInteractableName ~= nil
		and not curInteractBlocked
		and not curIsCriminalInteract
		and (curAdditionalInfo == ADDITIONAL_INTERACT_INFO_NONE or curAdditionalInfo == ADDITIONAL_INTERACT_INFO_FISHING_NODE)
		and AHKVacuum.lootActions[curAction] ~= nil
	then
		local lootAction = AHKVacuum.lootActions[curAction]
		if ((lootAction.takeByDefault and lootAction.blacklist[curInteractableName] == nil) or lootAction.whitelist[curInteractableName] ~= nil) then
			return true
		end
	end
	return false
end
function AHKVacuum.OnReticleChanged()
	if IsCurFocusSetForInteract() and not IsUnitInCombatLoc("player") then
		if doRidePickupAll or not IsMountedLoc() or AHKVacuum.ridinglist[curInteractableName] ~= nil then
			--DoLoot()
		end
	end
	if curInteractableName ~= nil then
		local idxAction = curAction or "blank"
		if not AHKVacuum.savedVars[idxAction] then AHKVacuum.savedVars[idxAction] = {} end
		--AHKVacuum.savedVars[idxAction][curInteractableName] = {GetGameCameraInteractableActionInfoLoc()}
		AHKVacuum.savedVars[idxAction][curInteractableName] = {curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract}
	end
end
function AHKVacuum.ActionLayerChanged(eventCode, layerIndex, activeLayerIndex) -- EVENT_ACTION_LAYER_POPPED (number eventCode, number layerIndex, number activeLayerIndex)
	--dmsg("ActionLayerChanged".." layerIndex:"..tostring(layerIndex).." activeLayerIndex:"..tostring(activeLayerIndex))
	resetToWandering()
end
function AHKVacuum.ConfirmInteract(eventCode, dialogTitle, dialogBody) -- EVENT_CONFIRM_INTERACT (number eventCode, string dialogTitle, string dialogBody, string acceptText, string cancelText)
	dmsg("ConfirmInteract".." dialogTitle:"..tostring(dialogTitle).." dialogBody:"..tostring(dialogBody))
end
function AHKVacuum.OnEventCameraActivated(eventCode)
	dmsg("OnEventCameraActivated")
end
function AHKVacuum.ClientInteract(eventCode, result, interactTargetName) -- EVENT_CLIENT_INTERACT_RESULT (number eventCode, ClientInteractResult result, string interactTargetName)
	dmsg("ClientInteract".." result:"..tostring(clientInteractResult[result]).." interactTargetName:"..tostring(interactTargetName))
end

function AHKVacuum:Initialize()
	ZO_CreateStringId("SI_BINDING_NAME_VACUUM_AUTOMOVE", "Vacuum Shop Automove")
	ZO_CreateStringId("SI_BINDING_NAME_VACUUM_RIGHT", "Vacuum Shop Right")
	ZO_CreateStringId("SI_BINDING_NAME_VACUUM_LEFT", "Vacuum Shop Left")
	ZO_CreateStringId("SI_BINDING_NAME_VACUUM_UP", "Vacuum Shop Up")
	ZO_CreateStringId("SI_BINDING_NAME_VACUUM_DOWN", "Vacuum Shop Down")
	ZO_PreHookHandler(RETICLE.interact, "OnEffectivelyShown", AHKVacuum.OnReticleSet)
	ZO_PreHookHandler(RETICLE.interact, "OnHide", AHKVacuum.OnReticleSet)
	AHKVacuum.savedVars = ZO_SavedVars:NewAccountWide(AHKVacuum.name.."SavedVariables", 1, nil, {})

	SecurePostHook (ZO_Fishing, "StartInteraction", AHKVacuum.OnBeginInteracting) -- begin harvesting/fishing/searching/taking
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_CHATTER_END, AHKVacuum.OnFinishInteracting) -- end of harvesting/fishing/not-searching(should work with onLootClosed)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_LOOT_CLOSED, AHKVacuum.OnFinishInteracting) -- pretty good for indicating done with harvesting/searching

	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_LOOT_RECEIVED, function() dmsg("EVENT_LOOT_RECEIVED") end) -- pretty good for indicating fast looted
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_LOOT_CLOSED, function() dmsg("EVENT_LOOT_CLOSED") end) -- pretty good for indicating fast looted
	--EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_LOOT_CLOSED, AHKVacuum.OnFinishInteracting) -- TMPBRI needs to reel in fish

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

local function LoadTestEvents()
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_ACTION_LAYER_POPPED, AHKVacuum.ActionLayerChanged)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_ACTION_LAYER_PUSHED, AHKVacuum.ActionLayerChanged)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_CLIENT_INTERACT_RESULT, AHKVacuum.ClientInteract) -- Begin harvesting/fishing/searching
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_CONFIRM_INTERACT, AHKVacuum.ConfirmInteract)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_LOOT_RECEIVED, AHKVacuum.OnLootReceived) -- pretty good for indicating fast looted
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_LOOT_CLOSED, AHKVacuum.OnLootClosed) -- pretty good for indicating done with harvesting/searching
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_GAME_CAMERA_ACTIVATED, AHKVacuum.OnEventCameraActivated)
	--EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_RETICLE_TARGET_CHANGED, function() dmsg("EVENT_RETICLE_TARGET_CHANGED") end) -- fires when looking over creatures
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_INTERACT_BUSY, function() dmsg("EVENT_INTERACT_BUSY") end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_NO_INTERACT_TARGET, function() dmsg("EVENT_NO_INTERACT_TARGET") end) -- Hitting E with no target

	--SecurePostHook (ZO_Reticle, "OnUpdate", function() d("OnUpdate") end) -- ZO_Reticle:OnUpdate -- Runs like crazy
	--ZO_InteractionManager:OnBeginInteraction(interaction)
	SecurePostHook (ZO_Fishing, "StartInteraction", function() dmsg("ZO_Fishing:StartInteraction") end) -- begin harvesting/fishing/searching/taking
	--SecurePostHook (ZO_Fishing, "StopInteraction", function() d("ZO_Fishing:StopInteraction") end)
	--SecurePostHook (ZO_Fishing, "InteractionCanceled", function() d("ZO_Fishing:InteractionCanceled") end)
	--SecurePostHook (ZO_Fishing, "PrepareForInteraction", function() d("ZO_Fishing:PrepareForInteraction") end)
	--SecurePostHook (ZO_InteractionManager, "OnBeginInteraction", function() d("ZO_InteractionManager:OnBeginInteraction") end)

	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_CAMERA_DISTANCE_SETTING_CHANGED, function() dmsg("EVENT_CAMERA_DISTANCE_SETTING_CHANGED") end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_CHATTER_BEGIN, function() dmsg("EVENT_CHATTER_BEGIN") end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_CHATTER_END, function() dmsg("EVENT_CHATTER_END") end) -- end of harvesting/fishing/not-searching(should work with onLootClosed)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_CONFIRM_INTERACT, function() dmsg("EVENT_CONFIRM_INTERACT") end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_CONVERSATION_FAILED_INVENTORY_FULL, function() dmsg("EVENT_CONVERSATION_FAILED_INVENTORY_FULL") end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_CONVERSATION_FAILED_UNIQUE_ITEM, function() dmsg("EVENT_CONVERSATION_FAILED_UNIQUE_ITEM") end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_CONVERSATION_UPDATED, function() dmsg("EVENT_CONVERSATION_UPDATED") end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_INTERACT_BUSY, function() dmsg("EVENT_INTERACT_BUSY") end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_NO_INTERACT_TARGET, function() dmsg("EVENT_NO_INTERACT_TARGET") end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_PENDING_INTERACTION_CANCELLED, function() dmsg("EVENT_PENDING_INTERACTION_CANCELLED") end)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_CLIENT_INTERACT_RESULT, function() dmsg("EVENT_CLIENT_INTERACT_RESULT") end)
end
