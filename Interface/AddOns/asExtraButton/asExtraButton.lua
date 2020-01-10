local AEB_Draenor = true			--Dreanor 기능창 이동
local AEB_Draenor_X = -50
local AEB_Draenor_Y = -310

local AEB_ExtraAction = true		--ExtraAction 이동
local AEB_ExtraAction_X = 0
local AEB_ExtraAction_Y = -310

local AEB_UnitPowerBarAlt = true	--Unit 특수 자원 바 이동
local AEB_UnitPowerBarAlt_X = 0
local AEB_UnitPowerBarAlt_Y = -30



local bSet = false;



function AEB_PositionAltPowerBar()
	local holder = CreateFrame("Frame", "AltPowerBarHolder", UIParent)
	holder:SetPoint("TOP", UIParent, "TOP", AEB_UnitPowerBarAlt_X, AEB_UnitPowerBarAlt_Y)
	holder:SetSize(128, 50)

    LoadAddOn("asMOD");

    if asMOD_setupFrame then
        asMOD_setupFrame (holder, "AltPowerBarHolder");
    end

	PlayerPowerBarAlt:ClearAllPoints()
	PlayerPowerBarAlt:SetPoint("CENTER", holder, "CENTER")
	PlayerPowerBarAlt:SetParent(holder)
	PlayerPowerBarAlt.ignoreFramePositionManager = true

	--The Blizzard function FramePositionDelegate:UIParentManageFramePositions()
	--calls :ClearAllPoints on PlayerPowerBarAlt under certain conditions.
	--Doing ".ClearAllPoints = function() end" causes error when you enter combat.
	local function Position(self)
		self:SetPoint("CENTER", AltPowerBarHolder, "CENTER")
	end
	hooksecurefunc(PlayerPowerBarAlt, "ClearAllPoints", Position)

--	AEB_mainframe:CreateMover(holder, "AltPowerBarMover", L["Alternative Power"])
end




function AEB_FixFrameSize()

	if bSet then
		return;
	end

	bSet = true;

	if AEB_ExtraAction then

		ExtraActionBarFrame:SetParent(UIParent)
		ExtraActionBarFrame:ClearAllPoints()
		ExtraActionBarFrame:SetPoint("CENTER", AEB_ExtraAction_X, AEB_ExtraAction_Y)
		ExtraActionBarFrame.ignoreFramePositionManager = true

        LoadAddOn("asMOD");

        if asMOD_setupFrame then
            asMOD_setupFrame (ExtraActionBarFrame, "ExtraActionBarFrame");
        end
	end


	FramerateLabel:SetParent(UIParent)
	FramerateLabel:ClearAllPoints()
	FramerateLabel:SetPoint("BOTTOM", -20, 150)
	FramerateLabel.ignoreFramePositionManager = true

    LoadAddOn("asMOD");

    if asMOD_setupFrame then
        asMOD_setupFrame (FramerateLabel, "FramerateLabel");
    end
	
	if AEB_Draenor then
		ZoneAbilityFrame:SetParent(UIParent)
		ZoneAbilityFrame:ClearAllPoints()
		ZoneAbilityFrame:SetPoint("CENTER", AEB_Draenor_X, AEB_Draenor_Y)
		ZoneAbilityFrame.ignoreFramePositionManager = true

        LoadAddOn("asMOD");

        if asMOD_setupFrame then
            asMOD_setupFrame (ZoneAbilityFrame, "ZoneAbilityFrame");
        end


	end

	if AEB_UnitPowerBarAlt then
		AEB_PositionAltPowerBar();
	end
end

AEB_FixFrameSize();



