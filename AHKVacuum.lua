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
AHKVacuum.lootActions["Use"].whitelist = newIndexedSet("Giant Clam")
AHKVacuum.ridinglist = newIndexedSet("Giant Clam", "Platinum Seam", "Heavy Sack")

local prvAction, prvInteractableName, prvInteractBlocked, prvIsOwned, prvAdditionalInfo, prvContextualInfo, prvContextualLink, prvIsCriminalInteract = GetGameCameraInteractableActionInfo()
local curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract = GetGameCameraInteractableActionInfo()
local prvInteractionType = GetInteractionType()
local curInteractionType = GetInteractionType()
local isPressingRight, isPressingLeft, isPressingUp, isPressingDown = false, false, false, false
local doAutorunAfterLoot = false
function AHKVacuum.PrintReticle(action, interactableName, interactBlocked, isOwned, additionalInfo, contextualInfo, contextualLink, isCriminalInteract)
	--local action, interactableName, interactBlocked, isOwned, additionalInfo, contextualInfo, contextualLink, isCriminalInteract = GetGameCameraInteractableActionInfo()
	dmsg("---"
		.." act:"..tostring(action)
		.." nm:"..tostring(interactableName)
		.." blk:"..tostring(interactBlocked)
		.." own:"..tostring(isOwned)
		.." addInfo:"..tostring(additionalInfo)
		.." ctxInfo:"..tostring(contextualInfo)
		.." ctxLink:"..tostring(contextualLink)
		.." crim:"..tostring(isCriminalInteract))
end
local function tapE() ptk.SetIndOnFor(ptk.VK_E, 50) end
local function tapT() ptk.SetIndOnFor(ptk.VK_T, 50) end
function AHKVacuum:ShopAutomoveToggle()
	if not doAutorunAfterLoot then
		doAutorunAfterLoot = true
		d("VacuumLoot ON")
		tapT()
	else
		doAutorunAfterLoot = false
		d("VacuumLoot OFF")
	end
end
function AHKVacuum:ShopDirectionRightOn()  ptk.SetIndOn (ptk.VK_D) isPressingRight = true  end
function AHKVacuum:ShopDirectionRightOff() ptk.SetIndOff(ptk.VK_D) isPressingRight = false end
function AHKVacuum:ShopDirectionLeftOn()   ptk.SetIndOn (ptk.VK_A) isPressingLeft = true   end
function AHKVacuum:ShopDirectionLeftOff()  ptk.SetIndOff(ptk.VK_A) isPressingLeft = false  end
function AHKVacuum:ShopDirectionUpOn()     ptk.SetIndOn (ptk.VK_W) isPressingUp = true     end
function AHKVacuum:ShopDirectionUpOff()    ptk.SetIndOff(ptk.VK_W) isPressingUp = false    end
function AHKVacuum:ShopDirectionDownOn()   ptk.SetIndOn (ptk.VK_S) isPressingDown = true   end
function AHKVacuum:ShopDirectionDownOff()  ptk.SetIndOff(ptk.VK_S) isPressingDown = false  end
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
	curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract = GetGameCameraInteractableActionInfo() -- Returns: string:nilable action, string:nilable name, boolean interactBlocked, boolean isOwned, number additionalInfo, number:nilable contextualInfo, string:nilable contextualLink, boolean isCriminalInteract
	if curAction ~= prvAction or curInteractableName ~= prvInteractableName or curInteractBlocked ~= prvInteractBlocked then
		AHKVacuum.OnReticleChanged()
	end
end
function AHKVacuum.OnReticleChanged()
	if curInteractableName ~= nil
		and not curInteractBlocked
		and not curIsCriminalInteract
		and curAdditionalInfo == 0 -- not sure what this is but 2 is apparently when something is empty
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
		--AHKVacuum.savedVars[idxAction][curInteractableName] = {GetGameCameraInteractableActionInfo()}
		AHKVacuum.savedVars[idxAction][curInteractableName] = {curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract}
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
