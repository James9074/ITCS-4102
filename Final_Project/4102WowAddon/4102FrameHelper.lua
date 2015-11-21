--[=[--------------------------------------------------------------------
	WoW4102 Project
	Move and resize default container windows without using a heavy container addon.
----------------------------------------------------------------------
	Slash commands:
	/4102              		-Shows commands
	/4102 reset	       		-Resets everything
	/4102 resize [.05 - 2]  -Resizes all containers (Ex: /4102 resize 2)
------------------------------------------------------------------------]=]

--Below are frame helpers, event handlers, and in-game command line instructionsas
------------------------------------------------------------------------

hooksecurefunc("ContainerFrame_GenerateFrame", function(container, size, id)
	if id and id > 0 and ENABLE_COLORBLIND_MODE == "0" then
		local link = GetInventoryItemLink("player", ContainerIDToInventoryID(id))
		local _, _, quality = GetItemInfo(link)
		local r, g, b = GetItemQualityColor(quality)
		_G[container:GetName().."Name"]:SetTextColor(r, g, b)
	else
		_G[container:GetName().."Name"]:SetTextColor(1, 1, 1)
	end
end)

------------------------------------------------------------------------

local WoW4102 = CreateFrame("Frame")
WoW4102:RegisterEvent("BANKFRAME_OPENED")
WoW4102:RegisterEvent("PLAYER_LOGIN")
WoW4102:SetScript("OnEvent", function(self, event)

	if event == "BANKFRAME_OPENED" then
		--return ToggleAllcontainers()
	end

	self:UnregisterEvent("PLAYER_LOGIN")

	if WoW4102DB and type(next(WoW4102DB)) == "string" then
		--Removing old name based settings
		WoW4102DB = nil
	end

	if WoW4102DB then
		--Using global settings
		WoW4102DBPC = nil -- clean up old character settings
		database = WoW4102DB
	else
		--Using character settings
		if not WoW4102DBPC then
			--Initializing new character
			WoW4102DBPC = {}
		end
		--Set our global DB to the newly created DB
		database = WoW4102DBPC
	end

	for i = 1, NUM_CONTAINER_FRAMES do
		local container = _G["ContainerFrame"..i]
		container:SetMovable(true)

		local title = container.ClickableTitleFrame
		title:SetScript("OnMouseDown", OnMouseDown)
		title:SetScript("OnMouseUp", OnMouseUp)
		title:SetScript("OnHide", OnHide)

		title.__onClick = title:GetScript("OnClick")
		title:SetScript("OnClick", OnClick)

		title:EnableMouseWheel(true)
		title:SetScript("OnMouseWheel", OnMouseWheel)

		local portrait = container.PortraitButton
		portrait:HookScript("OnEnter", OnEnter)
		portrait:SetScript("OnMouseWheel", OnMouseWheel)
	end

	hooksecurefunc("UpdateContainerFrameAnchors", RestoreAllPositions)
end)