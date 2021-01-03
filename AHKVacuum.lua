-- For menu & data
AHKVacuum = {}
AHKVacuum.name = "AHKVacuum"
--AHKVacuum.savedVars = {}
local function newIndexedSet(...)
	local retval = {}
	for key,value in pairs(...) do
		retval[key] = value
	end
	return retval
end
--AHKVacuum.lootActions = {
--					["Bookshelf"] =	  1,
--					["Book Stack"] =	  1,
--			}
AHKVacuum.ignoreSearch = {
					["Bookshelf"] =	  1,
					["Book Stack"] =	  1,
			}
AHKVacuum.ignoreTake = {
					["Spoiled Food"] =	  1,
					["Greatsword"] =	  1,
					["Sword"] =	  1,
					["Axe"] =	  1,
					["Bow"] =	  1,
					["Shield"] =	  1,
					["Staff"] =	  1,
					["Sabatons"] =	  1,
					["Jerkin"] =	  1,
					["Dagger"] =	  1,
					["Cuirass"] =	  1,
					["Pauldron"] =	  1,
					["Helm"] =	  1,
					["Gauntlets"] =	  1,
					["Guards"] =	  1,
					["Boots"] =	  1,
					["Shoes"] =	  1,
			}
AHKVacuum.lootSearch = {
					["Backpack"] =	   1,
					["Barrel"] =		 1,
					["Barrels"] =		1,
					["Basket"] =		 1,
					["Cabinet"] =		1,
					["Cauldron"] =	   1,
					["Crate"] =		  1,
					["Crates"] =		 1,
					["Dresser"] =		1,
					["Keg"] =			1,
					["Saltrice Sack"] =  1,
					["Sack"] =		   1,
					["Tomato Crate"] =   1,
					["Wardrobe"] =	   1,
			}
AHKVacuum.lootTake = {
					["Alchemy Bottle"] = 1,
					["Apple"] =		  1,
					["Banana"] =		 1,
					["Bananas"] =		1,
					["Bread"] =		  1,
					["Drink"] =		  1,
					["Cheese"] =		 1,
					["Fish"] =		   1,
					["Pie"] =			1,
					["Poultry"] =		1,
					["Rabbit"] =		 1,
			}
AHKVacuum.lootCollect = {
					["Platinum Seam"] =  1,
					["Nirnroot"] =	   1,
			}
local ptk = LibPixelControl
local ms_time = GetGameTimeMilliseconds()
local function dmsg(txt)
	d((GetGameTimeMilliseconds() - ms_time) .. ") " .. txt)
	ms_time = GetGameTimeMilliseconds()
end
local prvAction, prvInteractableName, prvInteractBlocked, prvIsOwned, prvAdditionalInfo, prvContextualInfo, prvContextualLink, prvIsCriminalInteract = GetGameCameraInteractableActionInfo()
local curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract = GetGameCameraInteractableActionInfo()
local prvInteractionType = GetInteractionType()
local curInteractionType = GetInteractionType()
local isPressingRight, isPressingLeft, isPressingUp, isPressingDown = false, false, false, false
local doAutomoveVacuumLoot = false
local doVacuumLoot = false
function AHKVacuum.PrintReticle(action, interactableName, interactBlocked, isOwned, additionalInfo, contextualInfo, contextualLink, isCriminalInteract)
	--local action, interactableName, interactBlocked, isOwned, additionalInfo, contextualInfo, contextualLink, isCriminalInteract = GetGameCameraInteractableActionInfo()
	d("---"
		.." act:"..tostring(action)
		.." nm:"..tostring(interactableName)
		.." blk:"..tostring(interactBlocked)
		.." own:"..tostring(isOwned)
		.." addInfo:"..tostring(additionalInfo)
		.." ctxInfo:"..tostring(contextualInfo)
		.." ctxLink:"..tostring(contextualLink)
		.." crim:"..tostring(isCriminalInteract))
end
function AHKVacuum.UpdateVacuumLoot()
	local newVacuumLoot = (isPressingRight or isPressingLeft or isPressingUp or isPressingDown or doAutomoveVacuumLoot)
	if newVacuumLoot ~= doVacuumLoot then
		doVacuumLoot = newVacuumLoot
	end
	if isPressingUp or isPressingDown then
		doAutomoveVacuumLoot = false
	end
end
local function tapE() ptk.SetIndOnFor(ptk.VK_E, 50) end
--function AHKVacuum:ShopAutomoveToggle()
--	if not doAutomoveVacuumLoot then
--		ptk.SetIndOn (ptk.VK_W)
--		doAutomoveVacuumLoot = true
--	else
--		ptk.SetIndOff (ptk.VK_W)
--		doAutomoveVacuumLoot = false
--	end
--	AHKVacuum.UpdateVacuumLoot()
--end
function AHKVacuum:ShopAutomoveToggle()
	if not doVacuumLoot then
		doVacuumLoot = true
		d("VacuumLoot ON")
	else
		doVacuumLoot = false
		d("VacuumLoot OFF")
	end
end
function AHKVacuum:ShopDirectionRightOn()  ptk.SetIndOn (ptk.VK_D) isPressingRight = true  AHKVacuum.UpdateVacuumLoot() end
function AHKVacuum:ShopDirectionRightOff() ptk.SetIndOff(ptk.VK_D) isPressingRight = false AHKVacuum.UpdateVacuumLoot() end
function AHKVacuum:ShopDirectionLeftOn()   ptk.SetIndOn (ptk.VK_A) isPressingLeft = true   AHKVacuum.UpdateVacuumLoot() end
function AHKVacuum:ShopDirectionLeftOff()  ptk.SetIndOff(ptk.VK_A) isPressingLeft = false  AHKVacuum.UpdateVacuumLoot() end
function AHKVacuum:ShopDirectionUpOn()     ptk.SetIndOn (ptk.VK_W) isPressingUp = true     AHKVacuum.UpdateVacuumLoot() end
function AHKVacuum:ShopDirectionUpOff()    ptk.SetIndOff(ptk.VK_W) isPressingUp = false    AHKVacuum.UpdateVacuumLoot() end
function AHKVacuum:ShopDirectionDownOn()   ptk.SetIndOn (ptk.VK_S) isPressingDown = true   AHKVacuum.UpdateVacuumLoot() end
function AHKVacuum:ShopDirectionDownOff()  ptk.SetIndOff(ptk.VK_S) isPressingDown = false  AHKVacuum.UpdateVacuumLoot() end
--function AHKVacuum:ShopDirectionDownOn()   end
--function AHKVacuum:ShopDirectionDownOff()
--	--AHKVacuum.PrintReticle(prvAction, prvInteractableName, prvInteractBlocked, prvIsOwned, prvAdditionalInfo, prvContextualInfo, prvContextualLink, prvIsCriminalInteract)
--	--AHKVacuum.PrintReticle(curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract)
--	--AHKVacuum.PrintReticle(GetGameCameraInteractableActionInfo())
--	d("GetInteractionType:"..tostring(GetInteractionType()))
--end
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
	if isPressingUp or doAutomoveVacuumLoot then ptk.SetIndOff(ptk.VK_W) end
	if isPressingDown then ptk.SetIndOff(ptk.VK_S) end
	tapE()
	EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, AHKVacuum.OnInventorySingleSlotUpdate)
end
function AHKVacuum.ResumeMovement()
	dmsg("Looted. Resuming Movement")
	if isPressingRight then ptk.SetIndOn(ptk.VK_D) end
	if isPressingLeft then ptk.SetIndOn(ptk.VK_A) end
	if isPressingUp or doAutomoveVacuumLoot then ptk.SetIndOn(ptk.VK_W) end
	if isPressingDown then ptk.SetIndOn(ptk.VK_S) end
	curInteractableName = nil
end
function AHKVacuum.OnReticleSet()
	prvAction, prvInteractableName, prvInteractBlocked, prvIsOwned, prvAdditionalInfo, prvContextualInfo, prvContextualLink, prvIsCriminalInteract = curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract
	curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract = GetGameCameraInteractableActionInfo() -- Returns: string:nilable action, string:nilable name, boolean interactBlocked, boolean isOwned, number additionalInfo, number:nilable contextualInfo, string:nilable contextualLink, boolean isCriminalInteract
	if curAction ~= prvAction or curInteractableName ~= prvInteractableName or curInteractBlocked ~= prvInteractBlocked then
		AHKVacuum.OnReticleChanged()
	end
	--prvInteractionType = curInteractionType
	--curInteractionType = GetInteractionType()
	--if curInteractionType ~= prvInteractionType then
	--	d("InteractionType Changed from "..tostring(prvInteractionType).." to "..tostring(curInteractionType))
	--end
end
function AHKVacuum.OnReticleChanged()
	if doVacuumLoot then -- don't do anything unless holding a key
		if curInteractableName ~= nil then
			AHKVacuum.PrintReticle(curAction, curInteractableName, curInteractBlocked, curIsOwned, curAdditionalInfo, curContextualInfo, curContextualLink, curIsCriminalInteract)
		end
		if curInteractableName ~= nil
			--and not curInteractBlocked
			and not curIsCriminalInteract
			and curAdditionalInfo == 0 -- not sure what this is but 2 is apparently when something is empty
			and (curAction == "Search" or curAction == "Take" or curAction == "Collect" or curAction == "Mine" or curAction == "Cut")
			and AHKVacuum.ignoreSearch[curInteractableName] == nil
		then
			AHKVacuum.HaltMovementToLoot()
		end
	end
end
--function AHKVacuum.OnReticleChanged()
--	if curInteractableName ~= nil and not curInteractBlocked and not curIsCriminalInteract and (curAction == "Search" or curAction == "Take" or curAction == "Collect" or curAction == "Mine" or curAction == "Cut") then
--		if IsMounted() then return end
--		local txt = curAction.." - "..curInteractableName
--		local doLog = false
--		local doPressE = false
--		if (curAction == "Search" or curAction == "Take" or curAction == "Collect" or curAction == "Mine" or curAction == "Cut") and AHKVacuum.ignoreSearch[curInteractableName] == nil then -- remove
--			doPressE = true
--			doLog = true
--		end
--		if curAction == "Search" then
--			if AHKVacuum.lootSearch[curInteractableName] then doPressE = true
--			else doLog = true
--			end
--		elseif curAction == "Take" then
--			if AHKVacuum.lootTake[curInteractableName] then doPressE = true
--			else doLog = true
--			end
--		elseif curAction == "Collect" or curAction == "Mine" or curAction == "Cut" then
--			if AHKVacuum.lootCollect[curInteractableName] then doPressE = true
--			else doLog = true
--			end
--		else
--			doLog = true
--		end
--		doLog = true -- remove
--		if doPressE then
--			EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, AHKVacuum.OnInventorySingleSlotUpdate)
--			zo_callLater(function() EVENT_MANAGER:UnregisterForEvent(AHKVacuum.name, EVENT_INVENTORY_SINGLE_SLOT_UPDATE) end, 200)
--			tapE()
--			txt = txt..". Pressing E."
--		end
--		if doLog then
--			local idxAction = curAction or "blank"
--			if not AHKVacuum.savedVars[idxAction] then AHKVacuum.savedVars[idxAction] = {} end
--			AHKVacuum.savedVars[idxAction][curInteractableName] = {GetGameCameraInteractableActionInfo()}
--			txt = txt..". Logged."
--		end
--		if not doPressE and not doLog then
--			txt = txt..". Ignored."
--		end
--		dmsg(txt)
--	end
--end

function AHKVacuum:Initialize()
	ZO_CreateStringId("SI_BINDING_NAME_VACUUM_AUTOMOVE", "Vacuum Shop Automove")
	ZO_CreateStringId("SI_BINDING_NAME_VACUUM_RIGHT", "Vacuum Shop Right")
	ZO_CreateStringId("SI_BINDING_NAME_VACUUM_LEFT", "Vacuum Shop Left")
	ZO_CreateStringId("SI_BINDING_NAME_VACUUM_UP", "Vacuum Shop Up")
	ZO_CreateStringId("SI_BINDING_NAME_VACUUM_DOWN", "Vacuum Shop Down")
	ZO_PreHookHandler(RETICLE.interact, "OnEffectivelyShown", AHKVacuum.OnReticleSet)
	ZO_PreHookHandler(RETICLE.interact, "OnHide", AHKVacuum.OnReticleSet)
	AHKVacuum.savedVars = ZO_SavedVars:NewAccountWide(AHKVacuum.name.."SavedVariables", 1, nil, {})
	AHKVacuum.savedVars.ignoreSearch = {"Bookshelf","Book Stack"}
	--AHKVacuum.savedVars["lootSearch"] = AHKVacuum.lootSearch
	--AHKVacuum.savedVars["lootTake"] = AHKVacuum.lootTake
	--AHKVacuum.savedVars["lootCollect"] = AHKVacuum.lootCollect


--local isAutoRunning = false
---- https://wiki.esoui.com/ZO_PreHook
---- ZO_PreHookHandler(control, handlerName, hookFunction)
---- ZO_PreHook(objectTable, existingFunctionName, hookFunction)
---- SecurePostHook
---- ZO_PostHookHandler
---- ToggleAutoRun
--EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_CONFIRM_INTERACT, AHKVacuum.OnConfirmInteract)
--EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_INTERACT_BUSY, AHKVacuum.OnInteractBusy)
--EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_CONFIRM_INTERACT, AHKVacuum.OnNoInteractTarget)
--SecurePostHook("EndInteraction", function() d("Someone wants to know if EndInteraction was done") end) -- EndInteraction(number interactionType)
--SecurePostHook("EndLooting", function() d("Someone wants to know if EndLooting was done") end)
----SecurePostHook(ZO_Reticle, "UpdateInteractText", function() d("UpdateInteractText") end)
--SecurePostHook(GamepadChatContainer, "UpdateInteractivity", function() d("GamepadChatContainer:UpdateInteractivity") end)
--SecurePostHook(ChatContainer, "UpdateInteractivity", function() d("ChatContainer:UpdateInteractivity") end)
--SecurePostHook("FishingManager:StartInteraction", function() d("FishingManager:StartInteraction") end)
--SecurePostHook("TakeLoot", function() d("TakeLoot") end)
--SecurePostHook("ZO_Loot_Shared:LootAllItems", function() d("ZO_Loot_Shared:LootAllItems") end)
---- EVENT_CONFIRM_INTERACT (number eventCode, string dialogTitle, string dialogBody, string acceptText, string cancelText)
--function AHKVacuum.OnConfirmInteract(eventCode, dialogTitle, dialogBody, acceptText, cancelText)
--	dmsg("OnConfirmInteract")
--	d("GetInteractionType:"..tostring(GetInteractionType()))
--end
----EVENT_INTERACT_BUSY (number eventCode)
----EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_INTERACT_BUSY, AHKVacuum.OnInteractBusy)
--function AHKVacuum.OnInteractBusy(eventCode, dialogTitle, dialogBody, acceptText, cancelText)
--	dmsg("OnInteractBusy")
--	d("GetInteractionType:"..tostring(GetInteractionType()))
--end
----EVENT_NO_INTERACT_TARGET (number eventCode)
----EVENT_MANAGER:RegisterForEvent(AHKVacuum.name, EVENT_CONFIRM_INTERACT, AHKVacuum.OnNoInteractTarget)
--function AHKVacuum.OnNoInteractTarget(eventCode, dialogTitle, dialogBody, acceptText, cancelText)
--	dmsg("OnNoInteractTarget")
--	d("GetInteractionType:"..tostring(GetInteractionType()))
--end

--GamepadChatContainer:UpdateInteractivity(isInteractive)
--ChatContainer:UpdateInteractivity(isInteractive)
--FishingManager:StartInteraction()?
--TakeLoot(slot)
--ZO_Loot_Shared:LootAllItems()


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
