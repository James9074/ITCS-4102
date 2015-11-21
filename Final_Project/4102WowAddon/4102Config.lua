--[=[--------------------------------------------------------------------
	WoW4102 Project
	Move and resize default container windows without using a heavy container addon.
----------------------------------------------------------------------
	Slash commands:
	/4102              		-Shows commands
	/4102 reset	       		-Resets everything
	/4102 resize [.05 - 2]  -Resizes all containers (Ex: /4102 resize 2)
------------------------------------------------------------------------]=]

SLASH_WoW41021 = "/4102"
SlashCmdList.WoW4102 = function(cmd)
	local cmd, arg = strsplit(" ", strlower(strtrim(cmd)))
	if cmd == "reset" then
		wipe(database)
		for i = 1, NUM_CONTAINER_FRAMES do
			local bag = _G["ContainerFrame"..i]
			bag:SetScale(1)
			bag:SetUserPlaced(false)
			bag:ClearAllPoints()
		end
		return UpdateContainerFrameAnchors()
	elseif cmd == "resize" then
		local scale = tonumber(arg)
		if scale and scale >= 0.5 and scale <= 2 then
			for i = 1, NUM_CONTAINER_FRAMES do
				local bag = _G["ContainerFrame"..i]
				Resize(bag, scale)
			end
		end
		return
	end
	print("4102 Project Commands:")

	print(format("- |cff82c5ff%s|r - %s", "reset",  "resets all containers"))
	print(format("- |cff82c5ff%s|r - %s", "resize",  "resizes all containers (accepts range: 0.5 to 2)"))
end