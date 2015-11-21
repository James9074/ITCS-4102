--[=[--------------------------------------------------------------------
	WoW4102 Project
	Move and resize default container windows without using a heavy container addon.
----------------------------------------------------------------------
	Slash commands:
	/4102              		-Shows commands
	/4102 reset	       		-Resets everything
	/4102 resize [.05 - 2]  -Resizes all containers (Ex: /4102 resize 2)
------------------------------------------------------------------------]=]

-- Stores the new container position after dragging,
-- so that we know where to draw it next frame
function StoreBagPos(Container)

	local xPos
	local yPos
	local horizontal
	local vertical
	
	local width = UIParent:GetWidth()
	local height = UIParent:GetHeight()
	if Container:GetCenter() * Container:GetScale() > (width / 2) then
		horizontal = "RIGHT"
		xPos = (Container:GetRight() * Container:GetScale()) - width
	else
		horizontal = "LEFT"
		xPos = Container:GetLeft() * Container:GetScale()
	end
	if Container:GetCenter() * Container:GetScale() > (height / 2) then
		vertical = "TOP"
		yPos = (Container:GetTop() * Container:GetScale()) - height
	else
		vertical = "BOTTOM"
		yPos = Container:GetBottom() * Container:GetScale()
	end

	local info = database[Container:GetID()] or {}
	database[Container:GetID()] = info

	info.point = vertical..horizontal
	info.x = xPos
	info.y = yPos

	Container:ClearAllPoints()
	Container:SetPoint(info.point, floor(xPos / Container:GetScale() + 0.5), floor(yPos / Container:GetScale() + 0.5))

end

-- Reverts all Container movements for a particular Container
function UndoBagMovements(Container)
	local id = Container:GetID()

	local info = database[id]
	if not info then
		return StoreBagPos(Container)
	end
	local s = info.scale or 1
	Container:ClearAllPoints()
	Container:SetPoint(info.point, info.x / s, info.y / s)
end

-- Resizes all bags
function Resize(Container, scale)
	local id = Container:GetID()
	local info = database[id] or {}
	database[id] = info

	info.scale = scale
	Container:SetScale(scale)

	if info.point then
		UndoBagMovements(Container)
	end
end

-- Restores all bags to their original positions
function RestoreAllPositions()
	for i = 1, NUM_CONTAINER_FRAMES do
		local Container = _G["ContainerFrame"..i]
		if Container:IsShown() then
			local id = Container:GetID()
			if id < 100 then
				local info = database[id]
				if info and info.point then
					Resize(Container, info.scale or 1)
				else
					StoreBagPos(Container)
				end
			end
		end
	end
end

-- Mouse Down Event Handler (pre-drag)
function OnMouseDown(title)
	local Container = title:GetParent()
	if not IsAltKeyDown() then	
		Container:StartMoving()
		Container.__isMoving = true
		title:GetScript("OnLeave")(title)
	end
end

-- Mouse Up Event Handler (post-drag)
function OnMouseUp(title)
	local Container = title:GetParent()
	if Container.__isMoving then
		Container:StopMovingOrSizing()
		Container:SetUserPlaced(false)
		Container.__isMoving = nil
		StoreBagPos(Container)
		title:GetScript("OnEnter")(title)
	end
end

function OnHide(title)
	local Container = title:GetParent()

	if Container.__isMoving then

		Container:StopMovingOrSizing()
		Container.__isMoving = nil
	end
end

-- For when we click a Container's header
function OnClick(title, b, ...)
	local Container = title:GetParent()
	if IsAltKeyDown() then
		title.__onClick(title, b, ...)
	end
	
end

-- For when we mouse wheel a Container's header
function OnMouseWheel(frame, delta)
	if IsControlKeyDown() then
		local Container = frame:GetParent()
		local scale = Container:GetScale()
		if delta > 0 then
			scale = min(scale + 0.05, 2)
		elseif delta < 0 then
			scale = max(scale - 0.05, 0.5)
		end
		Resize(Container, floor(scale * 100 + 0.5) / 100)
	end
end

function OnEnter(portrait)
	GameTooltip:Hide();
	GameTooltip:SetOwner(portrait:GetParent());
	GameTooltip:AddLine("Container - Draggable", 1, 1, 1)
	GameTooltip:AddLine("<Alt-Click for Container menu>", 0, 1, 0)
	GameTooltip:AddLine("Control and mousewheel to resize the Container", 0, 1, 0)
	GameTooltip:Show()

	local Container = portrait:GetParent()
	if Container:GetLeft() < GameTooltip:GetWidth() then
		GameTooltip:ClearAllPoints()
		GameTooltip:SetPoint("BOTTOMLEFT", Container, "TOPRIGHT")
	end
end

------------------------------------------------------------------------