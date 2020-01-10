-- Deja Mark

BINDING_HEADER_DEJAMARK = "DejaMark"
_G["BINDING_NAME_CLICK DejaMark:LeftButton"] = "Show Markers(Hold)"

local DMM_isClassic
local _, _, _, tocversion = GetBuildInfo()
if (tocversion < 20000) then
	DMM_isClassic = true
end

World_Flares = {
	5,
	6,
	3,
	2,
	7,
	1,
	4,
	8,
	0,
}

local DejaMarkFrame=CreateFrame("Frame","DejaMarkFrame",UIParent)
DejaMarkFrame:SetClampedToScreen( true )
DejaMarkFrame:SetMovable(true)
DejaMarkFrame:EnableMouse(true)
DejaMarkFrame:SetSize(100,100)
DejaMarkFrame:SetScale(1.0)
DejaMarkFrame:Hide()

local t=DejaMarkFrame:CreateTexture(nil,"ARTWORK")
	t:SetAllPoints(DejaMarkFrame)
	t:SetTexture("Interface\\DialogFrame\\UI-DialogBox-Background")

for index = 1, 9 do -- Lua starts tables at 1 isntead of 0... so below I do lots of equating 9 to 0 as an index...
	-- Button = CreateFrame("Button", "DejaMarkIconButton"..index, self); --Use "SecureActionButtonTemplate" if using macros
	Button = CreateFrame("Button", "DejaMarkIconButton"..index, DejaMarkFrame, "SecureActionButtonTemplate"); --Use "SecureActionButtonTemplate" if using macros
	Button:SetWidth(32);
	Button:SetHeight(32);
	Button:SetID(index);
	if(index==9)then
		Button:SetPoint("BOTTOMRIGHT");
	elseif(index==1)then
		Button:SetPoint("TOPLEFT");
	elseif(index==2)then
		Button:SetPoint("TOP");
	elseif(index==3)then
		Button:SetPoint("TOPRIGHT");
	elseif(index==4)then
		Button:SetPoint("LEFT");
	elseif(index==5)then
		Button:SetPoint("BOTTOM");
	elseif(index==6)then
		Button:SetPoint("RIGHT");
	elseif(index==7)then
		Button:SetPoint("BOTTOMLEFT");
	elseif(index==8)then
		Button:SetPoint("CENTER");
	end

	Button.Texture = Button:CreateTexture(Button:GetName().."NormalTexture", "ARTWORK");
	if(index==9)then
		Button.Texture:SetTexture("Interface\\BUTTONS\\UI-GroupLoot-Pass-Up");
	else
		Button.Texture:SetTexture("Interface\\TargetingFrame\\UI-RaidTargetingIcons");
		SetRaidTargetIconTexture(Button.Texture, index); -- Blizzard specific function that centers sprite texture via index but doesn't include clearing all marks
	end

	Button.Texture:SetAllPoints();
	Button:RegisterForClicks("LeftButtonUp","RightButtonUp");
	-- Button:SetScript("OnClick", DejaMarkButton_OnClick); --Comment out if using macros
	
	Button:SetScript("OnEnter", function(self, ...)
		self.Texture:ClearAllPoints();
		self.Texture:SetPoint("TOPLEFT", -5, 5);
		self.Texture:SetPoint("BOTTOMRIGHT", 5, -5);
	end);
	
	Button:SetScript("OnLeave", function(self, ...)
		self.Texture:SetAllPoints();
	end);

	if DMM_isClassic then --Check for Classic which doesn't have world markers. This doesn't use macros and won't have the custom script warning popup.
		Button:SetScript("OnClick", function (self, button, down)
			if (index == 9) then
				if (button=="LeftButton") then
 					SetRaidTarget("target", 0)
				end
				if (button=="RightButton") then
					for index = 1, 9 do
						SetRaidTarget("player", index)
					end
				end
			else
				local targetindex = GetRaidTargetIndex("target")
				if (targetindex == index) then
					SetRaidTarget("target", 0)
				else
					SetRaidTarget("target", index)
				end
			end
		end)
	else
		Button:SetAttribute("type","macro") -- /tm on left click, /wm on right click

		wfIndex = World_Flares[Button:GetID()]
		-- print(index, wfIndex)
		if (wfIndex==0) then
			Button:SetAttribute("macrotext",'/run PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON) if SecureCmdOptionParse("[btn:1]") then for i=1,9 do SetRaidTarget("player",i)end end\n/cwm [btn:2] all')
		else
			Button:SetAttribute("macrotext",'/run PlaySound(SOUNDKIT.U_CHAT_SCROLL_BUTTON) if SecureCmdOptionParse("[btn:1]") then SetRaidTargetIcon("target", '..index..') end\n/wm [btn:2] '..wfIndex..'\n/cwm [btn:2] '..wfIndex..'')
		end
	end
end

--toggle frame, has no visible parts. exists as a place to accept a click run a snippet
local toggleframe = CreateFrame("Button","DejaMark",UIParent,"SecureHandlerClickTemplate")
	toggleframe:RegisterEvent("PLAYER_TARGET_CHANGED")
	toggleframe:RegisterForClicks("AnyUp", "AnyDown")
	toggleframe:SetFrameRef("ParentFrame",DejaMarkFrame)
	
	toggleframe:SetAttribute("_onclick",[[
		ParentFrame = self:GetFrameRef("ParentFrame")
		if down then
			ParentFrame:SetPoint("CENTER","$cursor")
			ParentFrame:Show()
		else
			ParentFrame:Hide()
		end
	]])