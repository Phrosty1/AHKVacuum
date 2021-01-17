-- For menu & data
AHKVacuum = {}
AHKVacuum.name = "AHKVacuum"
AHKVacuum.savedVars = {}
local ptk = LibPixelControl
local verbose = false
local ms_time = GetGameTimeMilliseconds()
local function dmsg(txt)
	if verbose then
		d((GetGameTimeMilliseconds() - ms_time) .. ") " .. txt)
		ms_time = GetGameTimeMilliseconds()
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
AHKVacuum.ridinglist = newIndexedSet("Giant Clam", "Platinum Seam", "Heavy Sack", "Heavy Crate", "Chest")

-- Local references for eso functions
local IsPlayerMovingLoc = IsPlayerMoving -- Returns: boolean moving
local IsPlayerTryingToMoveLoc = IsPlayerTryingToMove -- Returns: boolean tryingToMove
local GetGameCameraInteractableActionInfoLoc = GetGameCameraInteractableActionInfo -- Returns: string:nilable action, string:nilable name, boolean interactBlocked, boolean isOwned, number additionalInfo, number:nilable contextualInfo, string:nilable contextualLink, boolean isCriminalInteract
local GetMapPlayerPositionLoc = GetMapPlayerPosition -- Returns: number normalizedX, number normalizedZ, number heading, boolean isShownInCurrentMap
local GetInteractionTypeLoc = GetInteractionType -- Returns: number InteractionType interactMode
local GetGameCameraInteractableInfoLoc = GetGameCameraInteractableInfo -- Returns: boolean interactionExists, boolean interactionAvailableNow, boolean questInteraction, boolean questTargetBased, number questJournalIndex, number questToolIndex, boolean questToolOnCooldown


-- Local variables
local curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract = GetGameCameraInteractableActionInfoLoc()
local prvAction, prvInteractableName, prvInteractBlocked, prvIsOwned, prvAdditionalInfo, prvContextualInfo, prvContextualLink, prvIsCriminalInteract = curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract
local prvInteractionType = GetInteractionTypeLoc()
local curInteractionType = GetInteractionTypeLoc()
local isPressingRight, isPressingLeft, isPressingUp, isPressingDown = false, false, false, false
local doAutorunAfterLoot = false

local curInteractionExists, curInteractionAvailableNow, curQuestInteraction, curQuestTargetBased, curQuestJournalIndex, curQuestToolIndex, curQuestToolOnCooldown = GetGameCameraInteractableInfoLoc()
local prvInteractionExists, prvInteractionAvailableNow, prvQuestInteraction, prvQuestTargetBased, prvQuestJournalIndex, prvQuestToolIndex, prvQuestToolOnCooldown = curInteractionExists, curInteractionAvailableNow, curQuestInteraction, curQuestTargetBased, curQuestJournalIndex, curQuestToolIndex, curQuestToolOnCooldown

local function tapE()
	ptk.SetIndOff(ptk.VK_SHIFT)
	ptk.SetIndOnFor(ptk.VK_E, 50)
end
local function tapT()
	ptk.SetIndOnFor(ptk.VK_T, 50)
	zo_callLater(function() ptk.SetIndOn(ptk.VK_SHIFT) end, 100)
end
function AHKVacuum:ShopAutomoveBegin()
	doAutorunAfterLoot = true
	tapT()
	d("VacuumLoot ON")
end
function AHKVacuum:ShopAutomoveEnd()
	doAutorunAfterLoot = false
	ptk.SetIndOff(ptk.VK_SHIFT)
	d("VacuumLoot OFF")
end
function AHKVacuum:ShopAutomoveToggle()
	if not doAutorunAfterLoot then
		AHKVacuum:ShopAutomoveBegin()
	else
		AHKVacuum:ShopAutomoveEnd()
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
	local targetX, targetY, targetH = GetMapPlayerPositionLoc('reticleover')
	local playerTryingToMove = IsPlayerTryingToMoveLoc()
	d(	"playerTryingToMove:"..tostring(playerTryingToMove)
		.." X:"..tostring(targetX)
		.." Y:"..tostring(targetY)
		.." H:"..tostring(targetH))
end
function AHKVacuum:ShopDirectionDownOff()
end

-- EVENT_INVENTORY_SINGLE_SLOT_UPDATE (number eventCode, Bag bagId, number slotId, boolean isNewItem, ItemUISoundCategory itemSoundCategory, number inventoryUpdateReason, number stackCountChange)
function AHKVacuum.OnInventorySingleSlotUpdate(eventCode, bagId, slotId, isNewItem, itemSoundCategory, inventoryUpdateReason, stackCountChange)
	EVENT_MANAGER:UnregisterForEvent(AHKVacuum.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE)
	dmsg("Item Collected.")
	AHKVacuum.ResumeMovement()
end
function AHKVacuum.HaltMovementToLoot()
	dmsg("HaltMovementToLoot")
	if isPressingRight then ptk.SetIndOff(ptk.VK_D) end
	if isPressingLeft then ptk.SetIndOff(ptk.VK_A) end
	if isPressingUp then ptk.SetIndOff(ptk.VK_W) end
	if isPressingDown then ptk.SetIndOff(ptk.VK_S) end
	tapE()
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, AHKVacuum.OnInventorySingleSlotUpdate)
end
function AHKVacuum.ResumeMovement()
	dmsg("Looted. Resuming Movement")
	if isPressingRight then ptk.SetIndOn(ptk.VK_D) end
	if isPressingLeft then ptk.SetIndOn(ptk.VK_A) end
	if isPressingUp then ptk.SetIndOn(ptk.VK_W) end
	if isPressingDown then ptk.SetIndOn(ptk.VK_S) end
	curInteractableName = nil
	if doAutorunAfterLoot then tapT() end
end
function AHKVacuum.OnReticleSet()
	prvAction, prvInteractableName, prvInteractBlocked, prvIsOwned, prvAdditionalInfo, prvContextualInfo, prvContextualLink, prvIsCriminalInteract = curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract
	curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract = GetGameCameraInteractableActionInfoLoc()
	prvInteractionExists, prvInteractionAvailableNow, prvQuestInteraction, prvQuestTargetBased, prvQuestJournalIndex, prvQuestToolIndex, prvQuestToolOnCooldown = curInteractionExists, curInteractionAvailableNow, curQuestInteraction, curQuestTargetBased, curQuestJournalIndex, curQuestToolIndex, curQuestToolOnCooldown
	curInteractionExists, curInteractionAvailableNow, curQuestInteraction, curQuestTargetBased, curQuestJournalIndex, curQuestToolIndex, curQuestToolOnCooldown = GetGameCameraInteractableInfoLoc()
	if curAction ~= prvAction or curInteractableName ~= prvInteractableName or curInteractBlocked ~= prvInteractBlocked then AHKVacuum.OnReticleChanged() end
	--if curAction ~= prvAction
	--or curInteractableName ~= prvInteractableName
	--or curInteractBlocked ~= prvInteractBlocked
	--or curIsOwned ~= prvIsOwned
	--or curAdditionalInfo ~= prvAdditionalInfo
	--or curContextualInfo ~= prvContextualInfo
	--or curContextualLink ~= prvContextualLink
	--or curIsCriminalInteract ~= prvIsCriminalInteract then
	--	local action, interactableName, interactBlocked, isOwned, additionalInfo, contextualInfo, contextualLink, isCriminalInteract = curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract
	--	dmsg("GetGameCameraInteractableActionInfoLoc")
	--	d(""
	--		.." act:"..tostring(action)
	--		.." nm:"..tostring(interactableName)
	--		.." blk:"..tostring(interactBlocked)
	--		.." own:"..tostring(isOwned)
	--		.." addInfo:"..tostring(additionalInfo)
	--		.." ctxInfo:"..tostring(contextualInfo)
	--		.." ctxLink:"..tostring(contextualLink)
	--		.." crim:"..tostring(isCriminalInteract))
	--end
	--if curInteractionExists ~= prvInteractionExists
	--or curInteractionAvailableNow ~= prvInteractionAvailableNow
	--or curQuestInteraction ~= prvQuestInteraction
	--or curQuestTargetBased ~= prvQuestTargetBased
	--or curQuestJournalIndex ~= prvQuestJournalIndex
	--or curQuestToolIndex ~= prvQuestToolIndex
	--or curQuestToolOnCooldown ~= prvQuestToolOnCooldown then
	--	local interactionExists, interactionAvailableNow, questInteraction, questTargetBased, questJournalIndex, questToolIndex, questToolOnCooldown = curInteractionExists, curInteractionAvailableNow, curQuestInteraction, curQuestTargetBased, curQuestJournalIndex, curQuestToolIndex, curQuestToolOnCooldown
	--	dmsg("GetGameCameraInteractableInfoLoc")
	--	d(""
	--		.." interactionExists:"..tostring(interactionExists)
	--		.." interactionAvailableNow:"..tostring(interactionAvailableNow)
	--		.." questInteraction:"..tostring(questInteraction)
	--		.." questTargetBased:"..tostring(questTargetBased)
	--		.." questJournalIndex:"..tostring(questJournalIndex)
	--		.." questToolIndex:"..tostring(questToolIndex)
	--		.." questToolOnCooldown:"..tostring(questToolOnCooldown))
	--end
	if curAction ~= prvAction
	or curInteractableName ~= prvInteractableName
	or curInteractBlocked ~= prvInteractBlocked
	or curIsOwned ~= prvIsOwned
	or curAdditionalInfo ~= prvAdditionalInfo
	or curContextualInfo ~= prvContextualInfo
	or curContextualLink ~= prvContextualLink
	or curIsCriminalInteract ~= prvIsCriminalInteract
	or curInteractionExists ~= prvInteractionExists
	or curInteractionAvailableNow ~= prvInteractionAvailableNow
	or curQuestInteraction ~= prvQuestInteraction
	or curQuestTargetBased ~= prvQuestTargetBased
	or curQuestJournalIndex ~= prvQuestJournalIndex
	or curQuestToolIndex ~= prvQuestToolIndex
	or curQuestToolOnCooldown ~= prvQuestToolOnCooldown then
		if verbose then
			local action, interactableName, interactBlocked, isOwned, additionalInfo, contextualInfo, contextualLink, isCriminalInteract = curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract
			dmsg("GetGameCameraInteractableActionInfoLoc")
			d(""
				.." act:"..tostring(action)
				.." nm:"..tostring(interactableName)
				.." blk:"..tostring(interactBlocked)
				.." own:"..tostring(isOwned)
				.." addInfo:"..tostring(additionalInfo)
				.." ctxInfo:"..tostring(contextualInfo)
				.." ctxLink:"..tostring(contextualLink)
				.." crim:"..tostring(isCriminalInteract))
			local interactionExists, interactionAvailableNow, questInteraction, questTargetBased, questJournalIndex, questToolIndex, questToolOnCooldown = curInteractionExists, curInteractionAvailableNow, curQuestInteraction, curQuestTargetBased, curQuestJournalIndex, curQuestToolIndex, curQuestToolOnCooldown
			--dmsg("GetGameCameraInteractableInfoLoc")
			d(""
				.." interactionExists:"..tostring(interactionExists)
				.." interactionAvailableNow:"..tostring(interactionAvailableNow)
				.." questInteraction:"..tostring(questInteraction)
				.." questTargetBased:"..tostring(questTargetBased)
				.." questJournalIndex:"..tostring(questJournalIndex)
				.." questToolIndex:"..tostring(questToolIndex)
				.." questToolOnCooldown:"..tostring(questToolOnCooldown))
		end
	end

end
function AHKVacuum.OnReticleChanged()
	if curAction ~= nil and curInteractableName ~= nil
		and not curInteractBlocked
		and not curIsCriminalInteract
		--and curAdditionalInfo == 0 -- not sure what this is but 2 is apparently when something is empty
		and AHKVacuum.lootActions[curAction] ~= nil
	then
		local lootAction = AHKVacuum.lootActions[curAction]
		if ((lootAction.takeByDefault and lootAction.blacklist[curInteractableName] == nil) or lootAction.whitelist[curInteractableName] ~= nil) then
			if not IsMounted() then
				AHKVacuum.HaltMovementToLoot()
			elseif AHKVacuum.ridinglist[curInteractableName] ~= nil then
				AHKVacuum.HaltMovementToLoot()
			end
		end
	end
	if curAction ~= nil and curInteractableName ~= nil then
		local idxAction = curAction or "blank"
		if not AHKVacuum.savedVars[idxAction] then AHKVacuum.savedVars[idxAction] = {} end
		--AHKVacuum.savedVars[idxAction][curInteractableName] = {GetGameCameraInteractableActionInfoLoc()}
		AHKVacuum.savedVars[idxAction][curInteractableName] = {curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract}
	end
end
function AHKVacuum.OnCombatStateChanged() -- EVENT_PLAYER_COMBAT_STATE (number eventCode, boolean inCombat)
	if doAutorunAfterLoot then
		AHKVacuum:ShopAutomoveEnd()
	end
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

	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_PLAYER_COMBAT_STATE, AHKVacuum.OnCombatStateChanged)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_ACTION_LAYER_PUSHED, AHKVacuum.OnCombatStateChanged)
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_ACTION_LAYER_POPPED, AHKVacuum.OnCombatStateChanged)

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
