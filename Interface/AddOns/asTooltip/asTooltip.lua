AFFL_Config = {["anchor1"] = "CENTER", ["anchor2"] = "CENTER", ["x"] = 0, ["y"] = 0, ["width"] = 0, ["height"] = 0};

local AFFL_mouse = false				--마우스 툴팁
local AFFL_X = -220					--툴팁 X 위치 (마우스 툴팁 아닐때만)
local AFFL_Scale = 0.9				--툴팁 크기


LoadAddOn("asMOD")

hooksecurefunc("GameTooltip_SetDefaultAnchor", function (tooltip, parent,...)
	-- Return if no tooltip or parent
	if (not tooltip or not parent) then
		return
	end


	if AFFL_mouse then

		tooltip:SetOwner(parent, "ANCHOR_CURSOR")
		tooltip:SetScale(AFFL_Scale)

	else
		

	local StatusBarCount = StatusTrackingBarManager:GetNumberVisibleBars();
	

	local frame1 = _G["MultiBarBottomLeft"];
	local frame2 = _G["MultiBarBottomRight"];
	local frame3 = _G["PetActionBarFrame"];

	local position = 50;

	if (frame1:IsShown() or frame2:IsShown()) then
		position = position + 60;
	end


	if (frame3:IsShown()) then
		position = position + 40;
	end

	if StatusBarCount == 1 then
		position = position + 15;
	elseif StatusBarCount == 2 then
		position = position + 20;
	end
	
    


	tooltip:SetOwner(parent, "ANCHOR_NONE")
	tooltip:ClearAllPoints()
   	tooltip:SetPoint("BOTTOM", "UIParent", "BOTTOM", AFFL_X, position)
	tooltip:SetScale(AFFL_Scale)

    
   
end
end)
