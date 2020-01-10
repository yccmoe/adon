local ACRB_Size = 0; 					-- Buff 아이콘 증가 크기
local ACRB_CooldownFontSize = 9; 		-- 쿨다운 폰트 사이즈
local ACRB_BuffSizeRate = 1;			-- 기존 Size 크기 배수 
local ACRB_ShowBuffCooldown = true 		-- 버프 지속시간을 보이려면
local ACRB_MinShowBuffFontSize = 5 		-- 이크기보다 Cooldown font Size 가 작으면 안보이게 한다. 무조건 보이게 하려면 0
local ACRB_CooldownFontSizeRate = 0.5 	-- 버프 Size 대비 쿨다운 폰트 사이즈 
local ACRB_MAX_BUFFS = 6			  	-- 최대 표시 버프 개수 (3개 + 3개)
local ACRB_MAX_BUFFS_2 = 2				-- 최대 생존기 개수
local ACRB_MAX_DEBUFFS = 3				-- 최대 표시 디버프 개수 (3개)
local ACRB_MAX_DISPELDEBUFFS = 3		-- 최대 해제 디버프 개수 (3개)
local ACRB_ShowListFirst = true			-- 알림 List 항목을 먼저 보임 (가나다 순, 같은 디법이 여러게 걸리는 경우 1개만 보일 수 있음 ex 불고)
local ACRB_ShowAlert = true				-- HOT 리필 시 알림
local ACRB_MaxBuffSize = 20				-- 최대 Buff Size 창을 늘려도 이 크기 이상은 안커짐
local ACRB_HealerManaBarHeight = 1		-- 힐러 마나바 크기 (안보이게 하려면 0)
local ACRB_UpdateRate = 0.04			-- 1회 Update 주기 (초) 작으면 작을 수록 Frame Rate 감소 가능, 크면 Update 가 느림



-- 버프 남은시간에 리필 알림
-- 두번째 숫자는 표시 위치, 4(우상) 5(우중) 6(좌상) 1,2,3 은 우하에 보이는 우선 순위이다.
ACRB_ShowList_MONK_2 = {
	["포용의 안개"] = {6 * 0.3, 1},
	["소생의 안개"] = {20 * 0.3, 4}


}

-- 신기
ACRB_ShowList_PALADIN_1 = {
	["빛의 봉화"] = {0, 4},	
	["고결의 봉화"] = {0, 4},	
	["신념의 봉화"] = {0, 5},	
}


-- 수사
ACRB_ShowList_PRIEST_1 = {
	["속죄"] = {3, 4},	
	["신의 권능: 보호막"] = {15 * 0.3, 1}

}


-- 신사
ACRB_ShowList_PRIEST_2 = {
	["소생"] = {15 * 0.3, 4},	
	["회복의 기원"] = {0, 1},	

}


ACRB_ShowList_SHAMAN_3 = {
	["성난 해일"] = {15 * 0.3, 1},	
}


ACRB_ShowList_DRUID_4 = {
	["회복"] = {15 * 0.3, 4},
	["재생"] = {12 * 0.3, 5},
	["피어나는 생명"] = {15 * 0.3, 6},
	["회복 (싹틔우기)"] = {15 * 0.3, 2},
	["세나리온 수호물"] = {0, 1},
	

}


-- 안보이게 할 디법
local ACRB_BlackList = {
	["도전자의 짐"] = 1,	
}


-- 해제 알림 스킬
local ACRB_DispelAlertList = {
	--["시간 변위"] = 1,	
}




local ACRB_PVPBuffList = {


	[203720] = true, --Demon Spikes
    [53600]  = true, --SotR
    [192081] = true, --Ironfur 
    [2565]   = true, --Shield Block    
    [115308] = true, --Ironskin Brew


    --Death Knight
    [194679] = true, --Rune Tap
    [48707]  = true, --Anti-Magic Shell
    [55233]  = true, --Vampiric Blood
    [48792]  = true, --Icebound Fortitude
    [81256]  = true, --Dancing Rune Weapon
    [194844] = true, --Bonestorm
    --Demon Hunter
    [212800] = true, --Blur
    [196555] = true, --Nether Walk
    [187827] = true, --Metamorphosis (Tank)
    [203819] = true, --Demon Spikes
    --Warlock
    [104773] = true, --Unending Resolve
    [108416] = true, --Dark Pact
    [132413] = true, --Shadow Bulwark
    --Hunter
    [186265] = true, --Aspect of the Turtle
    [264735] = true, --Survival of the Fittest (Command Pet)
    [281195] = true, --Survival of the Fittest (Lone Wolf)
    --Rogue
    [1966]   = true, --Feint
    [31224]  = true, --Cloak of Shadows
    [5277]   = true, --Evasion
    [199754] = true, --Riposte
    [45182]  = true, --Cheating Death
    --Paladin
    [498]    = true, --Divine Protection
    [204018] = true, --Blessing of Spellwarding
    [6940]   = true, --Blessing of Sacrifice
    [1022]   = true, --Blessing of Protection
    [642]    = true, --Divine Shield
    [86659]  = true, --Guardian of the Ancient Kings
    [31850]  = true, --Ardent Defender
    [132403] = true, --SotR
    [184662] = true, --Shield of Vengeance
    [205191] = true, --Eye for an Eye
    --Monk
    [122470] = true, --Touch of Karma
    [122783] = true, --Diffuse Magic
    [122278] = true, --Dampen Harm
    [243435] = true, --Fortifying Brew (Heal)
    [120954] = true, --Fortifying Brew (Tank)
    [115176] = true, --Zen Meditation
    [215479] = true, --Ironskin Brew
    [115295] = true, --Guard
    [116849] = true, --Life Cocoon
    --Mage
    [45438]  = true, --Ice Block
    --[235313] = true, --Blazing Barrier
    --[235450] = true, --Prismatic Barrier
    --[11426]  = true, --Ice Barrier
    --Druid
    [61336]  = true, --Survival Instincts
    [22812]  = true, --Barkskin
    [102342] = true, --Ironbark
    [192081] = true, --Ironfur
    [158792] = true, --Pulverize
    [102558] = true, --Incarnation: Guardian of Ursoc
    --Warrior
    [197690] = true, --Defensive Stance
    [118038] = true, --Die by the Sword
    [184364] = true, --Enraged Regeneration
    [871]    = true, --Shield Wall
    [23920]  = true, --Spell Reflection
    [132404] = true, --Shield Block
    [97463]  = true, --Rallying Cry
    [12975] = true,  --Last Stand
    [190456] = true, --Ignore Pain
    --Priest
    [47788]  = true, --Guardian Spirit
    [33206]  = true, --Pain Suppression
    [47585]  = true, --Dispersion
    [19236]  = true, --Desperate Prayer
    --Shaman
    [108271] = true, --Astral Shift


}

-- 직업 리필 
local ACRB_ShowList = nil;
local ACRB_baseSize = 0;


local function ACRB_InitList()

	local spec = GetSpecialization();
	local localizedClass, englishClass = UnitClass("player")

	ACRB_ShowList = nil;

	if spec then
		listname = "ACRB_ShowList_" .. englishClass .. "_" .. spec;
	end

	ACRB_ShowList = _G[listname];

end


-- 오버레이
local unusedOverlayGlows = {};
local numOverlays = 0;
local framex, framey;
local BOSS_DEBUFF_SIZE_INCREASE = 5;


function  ACRB_GetOverlayGlow()
	local overlay = tremove(unusedOverlayGlows);
	if ( not overlay ) then
		numOverlays = numOverlays + 1;
		overlay = CreateFrame("Frame", "ACRB_ActionButtonOverlay"..numOverlays, UIParent, "ACRB_ActionBarButtonSpellActivationAlert");
	end
	return overlay;
end


function ACRB_ShowOverlayGlow(self)

	if ( self.overlay ) then
		if ( self.overlay.animOut:IsPlaying() ) then
			self.overlay.animOut:Stop();
			self.overlay.animIn:Play();
		end
	else
		self.overlay = ACRB_GetOverlayGlow();
		local frameWidth, frameHeight = self:GetSize();
		self.overlay:SetParent(self);
		self.overlay:ClearAllPoints();
		--Make the height/width available before the next frame:
		self.overlay:SetSize(frameWidth * 1.4, frameHeight * 1.4);
		self.overlay:SetPoint("TOPLEFT", self, "TOPLEFT", -frameWidth * 0.3, frameHeight * 0.3);
		self.overlay:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", frameWidth * 0.3, -frameHeight * 0.3);
		self.overlay.animIn:Play();
	end
end

function ACRB_HideOverlayGlow(self)


	if ( self.overlay ) then
		if ( self.overlay.animIn:IsPlaying() ) then
			self.overlay.animIn:Stop();
		end
		if ( self:IsVisible() ) then
			self.overlay.animOut:Play();
		else
			ACRB_OverlayGlowAnimOutFinished(self.overlay.animOut);	--We aren't shown anyway, so we'll instantly hide it.
		end
	end
end


function ACRB_OverlayGlowAnimOutFinished(animGroup)
	local overlay = animGroup:GetParent();
	local actionButton = overlay:GetParent();
	overlay:Hide();
	tinsert(unusedOverlayGlows, overlay);
	actionButton.overlay = nil;
end


function ACRB_OverlayGlowAnimOutFinished(animGroup)
	local overlay = animGroup:GetParent();
	local actionButton = overlay:GetParent();
	overlay:Hide();
	tinsert(unusedOverlayGlows, overlay);
	actionButton.overlay = nil;
end

function ACRB_OverlayGlowOnUpdate(self, elapsed)
	AnimateTexCoords(self.ants, 256, 256, 48, 48, 22, elapsed, 0.01);
end


-- Setup
local function ACRB_setupFrame(frame)
	if not frame or not frame.displayedUnit or not UnitIsPlayer(frame.displayedUnit) then return end
	local frameName = frame:GetName()
	
	local CUF_AURA_BOTTOM_OFFSET = 2;
	local CUF_NAME_SECTION_SIZE = 15;


	local options = DefaultCompactUnitFrameSetupOptions;
	local powerBarHeight = 8;
	local powerBarUsedHeight = options.displayPowerBar and powerBarHeight or 0;


	local x, y = frame:GetSize();

	y = y - powerBarUsedHeight;

	local baseSize = math.min(x/7 * ACRB_BuffSizeRate,y/3 * ACRB_BuffSizeRate) ;

	if baseSize > ACRB_MaxBuffSize then
		baseSize = ACRB_MaxBuffSize
	end

	local fontsize = baseSize * ACRB_CooldownFontSizeRate; 

	if not frame.asbuffFrames then
		frame.asbuffFrames = {}
	end

	for i = 1, ACRB_MAX_BUFFS do
		local buffPrefix = frameName .. "asBuff"
		local buffFrame = _G[buffPrefix .. i] or CreateFrame("Button", buffPrefix .. i, frame, "asCompactBuffTemplate")
		buffFrame:ClearAllPoints()
		buffFrame:EnableMouse(false); 

		if i <= ACRB_MAX_BUFFS - 3 then

			if math.fmod(i - 1, 3) == 0 then
				if i == 1 then
					local buffPos, buffRelativePoint, buffOffset = "BOTTOMRIGHT", "BOTTOMLEFT", CUF_AURA_BOTTOM_OFFSET + powerBarUsedHeight;
					buffFrame:ClearAllPoints();
					buffFrame:SetPoint(buffPos, frame, "BOTTOMRIGHT", -2, buffOffset);
				else
					buffFrame:SetPoint("BOTTOMRIGHT", _G[buffPrefix .. i - 3], "TOPRIGHT", 0, 1)
				end
			else
				buffFrame:SetPoint("BOTTOMRIGHT", _G[buffPrefix .. i - 1], "BOTTOMLEFT", -1, 0)
			end
		else

			-- 3개는 따로 뺀다.
			if i == ACRB_MAX_BUFFS - 2 then
				-- 우상
				--
				buffFrame:ClearAllPoints();
				buffFrame:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -2, -2);


			elseif i == ACRB_MAX_BUFFS - 1 then
				-- 우중
				buffFrame:ClearAllPoints();
				buffFrame:SetPoint("RIGHT", frame, "RIGHT", -2, 0);

			else
				-- 좌상
				buffFrame:ClearAllPoints();
				buffFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 2, -2);

			end

		end

		frame.asbuffFrames[i] = buffFrame;
		ACRB_HideOverlayGlow(buffFrame);
	end


	if not frame.asdebuffFrames then
		frame.asdebuffFrames = {}
	end

	for i = 1, ACRB_MAX_DEBUFFS do
		local buffPrefix = frameName .. "asDebuff"
		local debuffFrame = _G[buffPrefix .. i] or CreateFrame("Button", buffPrefix .. i, frame, "asCompactDebuffTemplate")
		debuffFrame:ClearAllPoints()
		debuffFrame:EnableMouse(false); 
		if math.fmod(i - 1, 3) == 0 then
			if i == 1 then
				local debuffPos, debuffRelativePoint, debuffOffset = "BOTTOMLEFT", "BOTTOMRIGHT", CUF_AURA_BOTTOM_OFFSET + powerBarUsedHeight;
				debuffFrame:ClearAllPoints();
				debuffFrame:SetPoint(debuffPos, frame, "BOTTOMLEFT", 3, debuffOffset);
			else
				debuffFrame:SetPoint("BOTTOMLEFT", _G[buffPrefix .. i - 3], "TOPLEFT", 0, 1)
			end
		else
			debuffFrame:SetPoint("BOTTOMLEFT", _G[buffPrefix .. i - 1], "BOTTOMRIGHT", 1, 0)
		end
		frame.asdebuffFrames[i] = debuffFrame;
	end

	if not frame.asdispelDebuffFrames then
		frame.asdispelDebuffFrames = {}
	end

	for i=1, ACRB_MAX_DISPELDEBUFFS do
		local dispelDebuffPrefix = frameName .. "asdispelDebuff"
		local dispelDebuffFrame = _G[dispelDebuffPrefix .. i] or CreateFrame("Button", dispelDebuffPrefix .. i, frame, "asCompactDispelDebuffTemplate")
		dispelDebuffFrame:EnableMouse(false); 
		frame.asdispelDebuffFrames[i] = dispelDebuffFrame;
	end

	frame.asdispelDebuffFrames[1]:SetPoint("RIGHT", frame.asbuffFrames[(ACRB_MAX_BUFFS - 2)],  "LEFT", -1, 0);
	for i=1, ACRB_MAX_DISPELDEBUFFS do
		if ( i > 1 ) then
			frame.asdispelDebuffFrames[i]:SetPoint("RIGHT", frame.asdispelDebuffFrames[i - 1], "LEFT", 0, 0);
		end
		frame.asdispelDebuffFrames[i]:SetSize(baseSize, baseSize);
	end

    for _,d in ipairs(frame.asbuffFrames) do
		d:SetSize(baseSize, baseSize);

		d.count:SetFont(STANDARD_TEXT_FONT, fontsize +1 ,"OUTLINE")
		d.count:SetPoint("BOTTOMRIGHT", 0, 0);
		if  ACRB_ShowBuffCooldown and fontsize >= ACRB_MinShowBuffFontSize   then
	   		d.cooldown:SetHideCountdownNumbers(false);
			for _,r in next,{d.cooldown:GetRegions()}	do 
				if r:GetObjectType()=="FontString" then 
					r:SetFont(STANDARD_TEXT_FONT,fontsize,"OUTLINE")
					r:SetPoint("TOPLEFT", -2, 2);
					break 
				end 
			end
		end
	end


	for _,d in ipairs(frame.asdebuffFrames) do
	   	d.baseSize = baseSize     -- 디버프
		d.maxHeight = options.height - powerBarUsedHeight - CUF_AURA_BOTTOM_OFFSET - CUF_NAME_SECTION_SIZE;

		d.count:SetFont(STANDARD_TEXT_FONT, fontsize + 1,"OUTLINE")
		d.count:SetPoint("BOTTOMRIGHT", 0, 0);

		if  ACRB_ShowBuffCooldown and fontsize >= ACRB_MinShowBuffFontSize   then
		   	d.cooldown:SetHideCountdownNumbers(false);
			for _,r in next,{d.cooldown:GetRegions()}	do 
				if r:GetObjectType()=="FontString" then 
					r:SetFont(STANDARD_TEXT_FONT,fontsize,"OUTLINE")
					r:SetPoint("TOPLEFT", -2, 2);
					break 
				end 
			end
		end
 	end


	local borderPrefix = frameName .. "asBorder"

	frame.asDispelBorder = _G[borderPrefix]  or frame:CreateTexture(borderPrefix,"BACKGROUND")
	frame.asDispelBorder:SetTexture("Interface\\AddOns\\asCompactRaidBuff\\overborder.tga")
	frame.asDispelBorder:SetPoint("TOPLEFT",-2,2)
	frame.asDispelBorder:SetPoint("BOTTOMRIGHT",2, -2)
	frame.asDispelBorder:SetTexCoord(0,1,0,1)


	local manabarPrefix = frameName .. "asManabar"

	frame.asManabar =  _G[manabarPrefix] or CreateFrame("StatusBar", manabarPrefix, frame.healthBar)
	frame.asManabar:SetStatusBarTexture("Interface\\TARGETINGFRAME\\UI-StatusBar")
	frame.asManabar:GetStatusBarTexture():SetHorizTile(false)
	frame.asManabar:SetMinMaxValues(0, 100)
	frame.asManabar:SetValue(100)
	frame.asManabar:SetWidth(x-2)
	frame.asManabar:SetHeight(ACRB_HealerManaBarHeight)
	frame.asManabar:SetPoint("BOTTOM",frame.healthBar,"BOTTOM", 0, 0)




end

-- 버프 설정 부
local function asCompactUnitFrame_UtilShouldDisplayBuff_buff(unit, index, filter)
	local name,  icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura = UnitBuff(unit, index, filter);

	if ACRB_BlackList and ACRB_BlackList[name] then
		return false;
	end

	if ACRB_ShowListFirst and ACRB_ShowList and ACRB_ShowList[name] then
		return false;
	end
	
	local hasCustom, alwaysShowMine, showForMySpec = SpellGetVisibilityInfo(spellId, UnitAffectingCombat("player") and "RAID_INCOMBAT" or "RAID_OUTOFCOMBAT");
	
	if ( hasCustom ) then
		return showForMySpec or (alwaysShowMine and (unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle"));
	else
		return (unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle") and canApplyAura and not SpellIsSelfBuff(spellId);
	end
end

local function asCompactUnitFrame_UtilIsBossAura(unit, index, filter, checkAsBuff)
	-- make sure you are using the correct index here!	allAurasIndex ~= debuffIndex
	local name,  icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura, isBossAura;
	if (checkAsBuff) then
		name,  icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura, isBossAura = UnitBuff(unit, index, filter);
	else
		name,  icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura, isBossAura = UnitDebuff(unit, index, filter);
	end
	return isBossAura;
end


--Utility Functions
local function asCompactUnitFrame_UtilShouldDisplayBuff(unit, index, filter)
	local name,  icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura = UnitBuff(unit, index, filter);
	
	local hasCustom, alwaysShowMine, showForMySpec = SpellGetVisibilityInfo(spellId, UnitAffectingCombat("player") and "RAID_INCOMBAT" or "RAID_OUTOFCOMBAT");
	
	if ( hasCustom ) then
		return showForMySpec or (alwaysShowMine and (unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle"));
	else
		return (unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle") and canApplyAura and not SpellIsSelfBuff(spellId);
	end
end

local function asCompactUnitFrame_UtilSetDispelDebuff(dispellDebuffFrame, debuffType, index)
	dispellDebuffFrame:Show();
	dispellDebuffFrame.icon:SetTexture("Interface\\RaidFrame\\Raid-Icon-Debuff"..debuffType);
	dispellDebuffFrame:SetID(index);
end




local function asCompactUnitFrame_UtilSetBuff2(buffFrame, unit, index, filter)
	local name,  icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura = UnitBuff(unit, index, filter);
	buffFrame.icon:SetTexture(icon);
	if ( count > 1 ) then
		local countText = count;
		if ( count >= 100 ) then
			countText = BUFF_STACKS_OVERFLOW;
		end
		buffFrame.count:Show();
		buffFrame.count:SetText(countText);
	else
		buffFrame.count:Hide();
	end
	buffFrame:SetID(index);
	local enabled = expirationTime and expirationTime ~= 0;
	if enabled then
		local startTime = expirationTime - duration;
		CooldownFrame_Set(buffFrame.cooldown, startTime, duration, true);

		if ACRB_ShowList and  ACRB_ShowAlert then
			local showlist_time = 0;

			if ACRB_ShowList[name]  then
				showlist_time = ACRB_ShowList[name][1];
			end

			if expirationTime - GetTime() < showlist_time then
				buffFrame.border:SetVertexColor(1, 1, 1);
				buffFrame.border:Show();
			else
				buffFrame.border:Hide();
			end
		else
			buffFrame.border:Hide();
		end


	else
		buffFrame.border:Hide()
		CooldownFrame_Clear(buffFrame.cooldown);
	end
	buffFrame:Show();
end

local function Comparison(AIndex, BIndex)



	local AID = AIndex[2];
	local BID = BIndex[2];

	if (AID ~= BID) then
		return AID > BID;
	end

	return false;
end


local function asCompactUnitFrame_UpdateBuffs(frame)

	if ( not frame.asbuffFrames ) then
		return;
	end

	local unit = frame.displayedUnit

	if not (unit) then
		return;
	end
	
	local index = 1;
	local frameNum = 1;
	local filter = nil;


	if UnitAffectingCombat("player") then
		filter = "PLAYER"
	end

	local aShowIdx = {};

	while ( frameNum <= 20 ) do
		local buffName= UnitBuff(unit, index, filter);
		if ( buffName ) then


			if ACRB_ShowList and ACRB_ShowList[buffName] then
				aShowIdx[frameNum] = {index, ACRB_ShowList[buffName][2]}
				frameNum = frameNum + 1;
			elseif ( asCompactUnitFrame_UtilShouldDisplayBuff_buff(unit, index, filter) and not asCompactUnitFrame_UtilIsBossAura(unit, index, filter, true) ) then
				aShowIdx[frameNum] = {index, 0}
				frameNum = frameNum + 1;
			end
		else
			break;
		end
		index = index + 1;
	end

	if ACRB_ShowListFirst then
		-- sort
		table.sort(aShowIdx, Comparison);

	end

	local frameidx = 1;
	local showframe = {};

	for i = 1, frameNum - 1 do

		if aShowIdx[i][2] > ACRB_MAX_BUFFS - 3 then
			local buffFrame = frame.asbuffFrames[aShowIdx[i][2]];
			asCompactUnitFrame_UtilSetBuff2(buffFrame, unit, aShowIdx[i][1], filter);
			showframe[aShowIdx[i][2]] = true;
		else
			local buffFrame = frame.asbuffFrames[frameidx];
			asCompactUnitFrame_UtilSetBuff2(buffFrame, unit, aShowIdx[i][1], filter);
			frameidx = frameidx + 1;
		end

		if frameidx >  (ACRB_MAX_BUFFS - 3) then
			break
		end


	end



	for i=frameidx, ACRB_MAX_BUFFS - 3 do
		local buffFrame = frame.asbuffFrames[i];
		buffFrame:Hide();
	end

	for i=ACRB_MAX_BUFFS - 2, ACRB_MAX_BUFFS do

		if 	showframe[i] == nil then
			local buffFrame = frame.asbuffFrames[i];
			buffFrame:Hide();
		end
	end
 
end



local function asCompactUnitFrame_UtilShouldDisplayBuff(unit, index, filter)
	local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura = UnitBuff(unit, index, filter);

	if ACRB_PVPBuffList[spellId] then
		return true;
	end

	return false;

end







local function asCompactUnitFrame_UtilSetBuff(buffFrame, unit, index, filter)
	local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura = UnitBuff(unit, index, filter);
	buffFrame.icon:SetTexture(icon);
	if ( count > 1 ) then
		local countText = count;
		if ( count >= 100) then
			countText = BUFF_STACKS_OVERFLOW;
		end
		buffFrame.count:Show();
		buffFrame.count:SetText(countText);
	else
		buffFrame.count:Hide();
	end
	buffFrame:SetID(index);
	local enabled = expirationTime and expirationTime ~= 0;
	if enabled then
		local startTime = expirationTime - duration;
		CooldownFrame_Set(buffFrame.cooldown, startTime, duration, true);
		buffFrame.cooldown:SetHideCountdownNumbers(false);
	else
		CooldownFrame_Clear(buffFrame.cooldown);
	end

	if not buffFrame.baseSize then
		buffFrame.baseSize = buffFrame:GetSize();
	end
	
	buffFrame.border:Hide();
	buffFrame:SetSize(buffFrame.baseSize + ACRB_Size, buffFrame.baseSize + ACRB_Size);
	buffFrame:Show();
end



-- Debuff 설정 부
local function asCompactUnitFrame_UtilSetDebuff(debuffFrame, unit, index, filter, isBossAura, isBossBuff)
	-- make sure you are using the correct index here!
	--isBossAura says make this look large.
	--isBossBuff looks in HELPFULL auras otherwise it looks in HARMFULL ones
	local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId;
	if (isBossBuff) then
		name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId = UnitBuff(unit, index, filter);
	else
		name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId = UnitDebuff(unit, index, filter);
	end
	debuffFrame.filter = filter;
	debuffFrame.icon:SetTexture(icon);
	if ( count > 1 ) then
		local countText = count;
		if ( count >= 100 ) then
			countText = BUFF_STACKS_OVERFLOW;
		end
		debuffFrame.count:Show();
		debuffFrame.count:SetText(countText);
	else
		debuffFrame.count:Hide();
	end
	debuffFrame:SetID(index);
	local enabled = expirationTime and expirationTime ~= 0;
	if enabled then
		local startTime = expirationTime - duration;
		CooldownFrame_Set(debuffFrame.cooldown, startTime, duration, true);
	else
		CooldownFrame_Clear(debuffFrame.cooldown);
	end
	
	local color = DebuffTypeColor[debuffType] or DebuffTypeColor["none"];
	debuffFrame.border:SetVertexColor(color.r, color.g, color.b);

	debuffFrame.isBossBuff = isBossBuff;
	if ( isBossAura ) then
		local size = min(debuffFrame.baseSize + BOSS_DEBUFF_SIZE_INCREASE, debuffFrame.maxHeight);
		debuffFrame:SetSize(size, size);
	else
		debuffFrame:SetSize(debuffFrame.baseSize, debuffFrame.baseSize);
	end
	
	debuffFrame:Show();
end

local function asCompactUnitFrame_UtilIsBossAura(unit, index, filter, checkAsBuff)
	-- make sure you are using the correct index here!	allAurasIndex ~= debuffIndex
	local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura, isBossAura, nameplateShowAll;
	if (checkAsBuff) then
		name,  icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura, isBossAura = UnitBuff(unit, index, filter);
	else
		name,  icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura, isBossAura, _, nameplateShowAll = UnitDebuff(unit, index, filter);
	end

	return isBossAura or nameplateShowAll;
end

local function asCompactUnitFrame_UtilShouldDisplayDebuff(unit, index, filter)
	local name,  icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura, isBossAura,  _, nameplateShowAll = UnitDebuff(unit, index, filter);


	if ACRB_BlackList and ACRB_BlackList[name] then
		return false;
	end

	if nameplateShowAll then
		return true;
	end

	
	local hasCustom, alwaysShowMine, showForMySpec = SpellGetVisibilityInfo(spellId, UnitAffectingCombat("player") and "RAID_INCOMBAT" or "RAID_OUTOFCOMBAT");
	if ( hasCustom ) then
		return showForMySpec or (alwaysShowMine and (unitCaster == "player" or unitCaster == "pet" or unitCaster == "vehicle") );	--Would only be "mine" in the case of something like forbearance.
	else
		return true;
	end
end

local function asCompactUnitFrame_UtilIsPriorityDebuff(unit, index, filter)
	local name,  icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId, canApplyAura, isBossAura = UnitDebuff(unit, index, filter);
	
	local _, classFilename = UnitClass("player");
	if ( classFilename == "PALADIN" ) then
		if ( spellId == 25771 ) then	--Forbearance
			return true;
		end
	elseif ( classFilename == "PRIEST" ) then
		if ( spellId == 6788 ) then	--Weakened Soul
			return true;
		end
	end
	
	return false;
end




local function asCompactUnitFrame_UpdateDebuffs(frame)
	if ( not frame.asdebuffFrames ) then
		return;
	end


	local unit = frame.displayedUnit;

	if not (unit) then
		return;
	end

	
	local index = 1;
	local frameNum = 1;
	local filter = nil;
	local maxDebuffs = ACRB_MAX_DEBUFFS;
	--Show both Boss buffs & debuffs in the debuff location
	--First, we go through all the debuffs looking for any boss flagged ones.
	while ( frameNum <= maxDebuffs ) do
		local debuffName = UnitDebuff(unit, index, filter);
		if ( debuffName ) then
			if ( asCompactUnitFrame_UtilIsBossAura(unit, index, filter, false) ) then
				local debuffFrame = frame.asdebuffFrames[frameNum];
				asCompactUnitFrame_UtilSetDebuff(debuffFrame, unit, index, filter, true, false);
				frameNum = frameNum + 1;
				--Boss debuffs are about twice as big as normal debuffs, so display one less.
				local bossDebuffScale = (debuffFrame.baseSize + BOSS_DEBUFF_SIZE_INCREASE)/debuffFrame.baseSize
				maxDebuffs = maxDebuffs - (bossDebuffScale - 1);
			end
		else
			break;
		end
		index = index + 1;
	end
	--Then we go through all the buffs looking for any boss flagged ones.
	index = 1;
	while ( frameNum <= maxDebuffs ) do
		local debuffName = UnitBuff(unit, index, filter);
		if ( debuffName ) then
			if ( asCompactUnitFrame_UtilIsBossAura(unit, index, filter, true) ) then
				local debuffFrame = frame.asdebuffFrames[frameNum];
				asCompactUnitFrame_UtilSetDebuff(debuffFrame, unit, index, filter, true, true);
				frameNum = frameNum + 1;
				--Boss debuffs are about twice as big as normal debuffs, so display one less.
				local bossDebuffScale = (debuffFrame.baseSize + BOSS_DEBUFF_SIZE_INCREASE)/debuffFrame.baseSize
				maxDebuffs = maxDebuffs - (bossDebuffScale - 1);
			end
		else
			break;
		end
		index = index + 1;
	end
	
	--Now we go through the debuffs with a priority (e.g. Weakened Soul and Forbearance)
	index = 1;
	while ( frameNum <= maxDebuffs ) do
		local debuffName = UnitDebuff(unit, index, filter);
		if ( debuffName ) then
			if ( asCompactUnitFrame_UtilIsPriorityDebuff(unit, index, filter) ) then
				local debuffFrame = frame.asdebuffFrames[frameNum];
				asCompactUnitFrame_UtilSetDebuff(debuffFrame, unit, index, filter, false, false);

				frameNum = frameNum + 1;
			end
		else
			break;
		end
		index = index + 1;
	end
	
	
	index = 1;
	--Now, we display all normal debuffs.
	while ( frameNum <= maxDebuffs ) do
		local debuffName = UnitDebuff(unit, index, filter);
		if ( debuffName ) then
			if ( asCompactUnitFrame_UtilShouldDisplayDebuff(unit, index, filter) and not asCompactUnitFrame_UtilIsBossAura(unit, index, filter, false) and
				not asCompactUnitFrame_UtilIsPriorityDebuff(unit, index, filter)) then
				local debuffFrame = frame.asdebuffFrames[frameNum];
				asCompactUnitFrame_UtilSetDebuff(debuffFrame, unit, index, filter, false, false);
				frameNum = frameNum + 1;
			end
		else
			break;
		end
		index = index + 1;
	end
	
	for i=frameNum, ACRB_MAX_DEBUFFS do
		local debuffFrame = frame.asdebuffFrames[i];
		debuffFrame:Hide();
	end
end

-- 해제 디버프

local dispellableDebuffTypes = { Magic = true, Curse = true, Disease = true, Poison = true};
local function asCompactUnitFrame_UpdateDispellableDebuffs(frame)

	if not frame.asdispelDebuffFrames then
		return;
	end

	local showdispell = false;
	
	local unit = frame.displayedUnit;

	if not (unit) then
		return;
	end


			
	--Clear what we currently have.
	for debuffType, display in pairs(dispellableDebuffTypes) do
		if ( display ) then
			frame["ashasDispel"..debuffType] = false;
		end
	end
	
	local index = 1;
	local frameNum = 1;
	local filter = "RAID";	--Only dispellable debuffs.
	while ( frameNum <= ACRB_MAX_DISPELDEBUFFS ) do
		local name, icon, count, debuffType, duration, expirationTime, unitCaster, canStealOrPurge, _, spellId = UnitDebuff(unit, index, filter);

		if ( dispellableDebuffTypes[debuffType] and not frame["ashasDispel"..debuffType] ) then
			frame["ashasDispel"..debuffType] = true;
			local dispellDebuffFrame = frame.asdispelDebuffFrames[frameNum];
			asCompactUnitFrame_UtilSetDispelDebuff(dispellDebuffFrame, debuffType, index)
		
			showdispell = true;


			if ACRB_DispelAlertList and name and ACRB_DispelAlertList[name] then
				ACRB_ShowOverlayGlow(frame);
			end
			
			if frame.asDispelBorder then

				local color = DebuffTypeColor[debuffType] or DebuffTypeColor["none"];
				frame.asDispelBorder:SetVertexColor(color.r, color.g, color.b);
				frame.asDispelBorder:Show();
			end
			frameNum = frameNum + 1;

		elseif ( not name ) then
			break;
		end
		index = index + 1;
	end
	for i=frameNum, ACRB_MAX_DISPELDEBUFFS do
		local dispellDebuffFrame = frame.asdispelDebuffFrames[i];
		dispellDebuffFrame:Hide();
	end

	if showdispell == false and frame.asDispelBorder then
		frame.asDispelBorder:Hide();
		ACRB_HideOverlayGlow(frame);
	end
end



local function asCompactUnitFrame_UpdateHealerMana(frame)

	if ( not frame.asManabar ) then
		return;
	end

	local unit = frame.displayedUnit

	if not (unit) then
		return;
	end

	local role = UnitGroupRolesAssigned(unit)


	if role == "HEALER" and not frame:IsForbidden() and not frame.powerBar:IsShown() then

		frame.asManabar:SetMinMaxValues(0, UnitPowerMax(unit, Enum.PowerType.Mana ))
		frame.asManabar:SetValue(UnitPower(unit, Enum.PowerType.Mana ));

		local info = PowerBarColor["MANA"];
		if ( info ) then
			local r, g, b = info.r, info.g, info.b;
			frame.asManabar:SetStatusBarColor(r, g, b);
		end

		frame.asManabar:Show();
	else

		frame.asManabar:Hide();
	end


	
end







local RaidIconList = {
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_6:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:",
	"|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:",
}

local function ACRB_DisplayRaidIcon(unit)
	local icon = GetRaidTargetIndex(unit)
	if icon and RaidIconList[icon] then
		return RaidIconList[icon] .. "0|t"
	else	
		return ""
	end
end


local function asCompactUnitFrame_UpdateBuffsPVP(frame)

	local unit = frame.displayedUnit


	if not (unit) then
		return;
	end


	if (not frame.asraidicon) then
		local frameName = frame:GetName()
		local buffPrefix = frameName .. "RAIDICON_"


		frame.asraidicon = frame:CreateFontString( buffPrefix , "OVERLAY")
		frame.asraidicon:SetFont(STANDARD_TEXT_FONT, 13)
		frame.asraidicon:SetPoint("TOPLEFT", frame.healthBar, "TOPLEFT", 13, 0)
	end


	if (not frame.buffFrames2) then

		local frameName = frame:GetName()

		frame.buffFrames2 = {};
	
		for i = 1, ACRB_MAX_BUFFS_2 do
			local buffPrefix = frameName .. "Buff2_"
			frame.buffFrames2[i] =  CreateFrame("Button", buffPrefix .. i, frame.healthBar, "asCompactBuffTemplate")
			frame.buffFrames2[i]:EnableMouse(false); 


			for _,r in next,{_G[buffPrefix .. i .."Cooldown"]:GetRegions()}	do 
				if r:GetObjectType()=="FontString" then 
					r:SetFont(STANDARD_TEXT_FONT,ACRB_CooldownFontSize,"OUTLINE")
					r:SetPoint("TOP", 0, 2);
					break 
				end 
			end
			frame.buffFrames2[i]:ClearAllPoints()
			if i == 1 then
				frame.buffFrames2[i]:SetPoint("TOPLEFT", frame.asraidicon, "TOPRIGHT", 2, 0)
			else
				frame.buffFrames2[i]:SetPoint("TOPLEFT", _G[buffPrefix .. i - 1], "TOPRIGHT", 0, 0)
			end
		end
	end

	local text = ACRB_DisplayRaidIcon(unit);

	frame.asraidicon:SetText(text);

	
	local index = 1;
	local frameNum = 1;
	local filter = nil;
	while ( frameNum <= ACRB_MAX_BUFFS_2 ) do
		local buffName = UnitBuff(unit, index, filter);
		if ( buffName ) then
			if ( asCompactUnitFrame_UtilShouldDisplayBuff(unit, index, filter)) then
				local buffFrame = frame.buffFrames2[frameNum];
				asCompactUnitFrame_UtilSetBuff(buffFrame, unit, index, filter);
				frameNum = frameNum + 1;
			end
		else
			break;
		end
		index = index + 1;
	end
	for i=frameNum, ACRB_MAX_BUFFS_2 do
		local buffFrame = frame.buffFrames2[i];
		if buffFrame then
		buffFrame:Hide();
	end
	end
end


local function ACRB_disableDefault(frame)

	if frame and not frame:IsForbidden() then
		frame:UnregisterEvent("UNIT_AURA");
		frame:UnregisterEvent("PLAYER_REGEN_ENABLED");
		frame:UnregisterEvent("PLAYER_REGEN_DISABLED");

		CompactUnitFrame_HideAllBuffs(frame);
		CompactUnitFrame_HideAllDebuffs(frame)
		CompactUnitFrame_HideAllDispelDebuffs(frame);
	end
end

local function ACRB_updateAllBuff(frame)

	if frame and frame:IsShown() then
		asCompactUnitFrame_UpdateBuffs(frame);
		asCompactUnitFrame_UpdateBuffsPVP(frame);
	end
end


local function ACRB_updateAllDebuff(frame)

	if frame and frame:IsShown() then
		asCompactUnitFrame_UpdateDebuffs(frame);
		asCompactUnitFrame_UpdateDispellableDebuffs(frame);
	end
end


local function ACRB_updateAllHealerMana(frame)

	if frame and frame:IsShown() then
		asCompactUnitFrame_UpdateHealerMana(frame);
	end
end




local together = nil;


local function ACRB_updatePartyAllBuff(idx)

	if IsInGroup() and  not (together == nil)  then
		
		if together == true then

			if IsInRaid() then -- raid
	
				local i= idx;
				for k=1,5 do
					local frame = _G["CompactRaidGroup"..i.."Member"..k]
					ACRB_updateAllBuff(frame)
				end
			else -- party
				if idx == 1 then



					for i=1, 5 do
						local frame = _G["CompactPartyFrameMember"..i]
						ACRB_updateAllBuff(frame)
					end
				end
			end
		else
			if IsInRaid() then -- raid
	
				for i= ((idx - 1) * 5) + 1, (idx * 5) do
					local frame = _G["CompactRaidFrame"..i]
					ACRB_updateAllBuff(frame)
				end
			else -- party
				if idx == 1 then

					for i=1, 5 do
						local frame = _G["CompactRaidFrame"..i]
						ACRB_updateAllBuff(frame)
					end
				end
			end
		end
	end
end


local function ACRB_updatePartyAllDebuff(idx)

	if IsInGroup() and  not (together == nil)  then

		if together == true then

			if IsInRaid() then -- raid
	
				local i= idx;
				for k=1,5 do
					local frame = _G["CompactRaidGroup"..i.."Member"..k]
					ACRB_updateAllDebuff(frame)
				end
			else -- party
				if idx == 1 then
					for i=1, 5 do
						local frame = _G["CompactPartyFrameMember"..i]
						ACRB_updateAllDebuff(frame)
					end
				end
			end
		else
			if IsInRaid() then -- raid
	
				for i= ((idx - 1) * 5) + 1, (idx * 5) do
					local frame = _G["CompactRaidFrame"..i]
					ACRB_updateAllDebuff(frame)
				end
			else -- party
				if idx == 1 then
					for i=1, 5 do
						local frame = _G["CompactRaidFrame"..i]
						ACRB_updateAllDebuff(frame)
					end
				end
			end
		end
	end

end


local function ACRB_updatePartyAllHealerMana(idx)

	if IsInGroup() and  not (together == nil) then

		if together == true then

			if IsInRaid() then -- raid
	
				local i= idx;
				for k=1,5 do
					local frame = _G["CompactRaidGroup"..i.."Member"..k]
					ACRB_updateAllHealerMana(frame)
				end
			else -- party
				if idx == 1 then

					for i=1, 5 do
						local frame = _G["CompactPartyFrameMember"..i]
						ACRB_updateAllHealerMana(frame)
					end
				end
			end
		else
			if IsInRaid() then -- raid
	
				for i= ((idx - 1) * 5) + 1, (idx * 5) do

					local frame = _G["CompactRaidFrame"..i]
					ACRB_updateAllHealerMana(frame)
				end
			else -- party
				if idx == 1 then

					for i=1, 5 do
						local frame = _G["CompactRaidFrame"..i]
						ACRB_updateAllHealerMana(frame)
					end
				end
			end
		end
	end
end


local function ACRB_DisableAura()

	 if IsInGroup() and not (together == nil) then

		if together == true then

			if IsInRaid() then -- raid
	
				for i=1,8 do
					for k=1,5 do
						local frame = _G["CompactRaidGroup"..i.."Member"..k]
						ACRB_disableDefault(frame);
						ACRB_setupFrame(frame);
					end
				end
			else -- party
				for i=1, 5 do
					local frame = _G["CompactPartyFrameMember"..i]
					ACRB_disableDefault(frame);
					ACRB_setupFrame(frame);

				end
			end
		else
			if IsInRaid() then -- raid
	
				for i=1,40 do
					local frame = _G["CompactRaidFrame"..i]
					ACRB_disableDefault(frame);
					ACRB_setupFrame(frame);
				end
			else -- party
				for i=1, 5 do
					local frame = _G["CompactRaidFrame"..i]
					ACRB_disableDefault(frame);
					ACRB_setupFrame(frame);
				end
			end
		end
	end

end





local update = 0;
local updatecount = 1;

local pending = {}
local abaseSize = {}
local mustdisable = true;



local function ACRB_OnUpdate(self, elapsed)

	update = update + elapsed;

	if update >= ACRB_UpdateRate  then
		update = 0;

		if updatecount <= 8 then
			ACRB_updatePartyAllBuff(updatecount);
		elseif updatecount <= 16 then
			ACRB_updatePartyAllDebuff(updatecount - 8);
		elseif updatecount <= 24 then
			ACRB_updatePartyAllHealerMana(updatecount - 16);
		elseif mustdisable then

			mustdisable = false;

			local profile = GetActiveRaidProfile();
			if profile then
				together = GetRaidProfileOption(profile, "keepGroupsTogether")
			end

			ACRB_DisableAura();
		end
		
		updatecount = updatecount + 1;

		if updatecount > 25 then
			updatecount = 1;
		end
	end
end




local function ACRB_OnEvent(self, event, ...)

		local arg1 = ...;

		if  event == "UNIT_SPELLCAST_SUCCEEDED" and arg1 == "player"  then
			for i=1,8 do

				ACRB_updatePartyAllBuff(i);
			end
		elseif (event == "PLAYER_ENTERING_WORLD") then
			ACRB_InitList();
			mustdisable = true;
		elseif (event == "ACTIVE_TALENT_GROUP_CHANGED") then
			ACRB_InitList();
		elseif (event == "GROUP_ROSTER_UPDATE") or (event == "CVAR_UPDATE") or (event == "ROLE_CHANGED_INFORM") then
			mustdisable = true;
		elseif (event == "COMPACT_UNIT_FRAME_PROFILES_LOADED") then

			local profile = GetActiveRaidProfile();
			if profile then
				together = GetRaidProfileOption(profile, "keepGroupsTogether")
			end
		end
end

local function asCompactUnitFrame_UpdateAll(frame)

	if frame and not frame:IsForbidden() then 
		local name = frame:GetName();

		if name and string.find (name, "CompactRaidGroup") or string.find (name, "CompactPartyFrameMember") or string.find (name, "CompactRaidFrame") then
			mustdisable = true;
		end

	end
end

local ACRB_mainframe = CreateFrame("Frame", "ACRB_main", UIParent);
ACRB_mainframe:SetScript("OnUpdate", ACRB_OnUpdate)
ACRB_mainframe:SetScript("OnEvent", ACRB_OnEvent)
ACRB_mainframe:RegisterEvent("GROUP_ROSTER_UPDATE");
ACRB_mainframe:RegisterEvent("PLAYER_ENTERING_WORLD");
ACRB_mainframe:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player");
ACRB_mainframe:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED");
ACRB_mainframe:RegisterEvent("CVAR_UPDATE");
ACRB_mainframe:RegisterEvent("ROLE_CHANGED_INFORM");
ACRB_mainframe:RegisterEvent("COMPACT_UNIT_FRAME_PROFILES_LOADED");
ACRB_mainframe:RegisterEvent("VARIABLES_LOADED");






hooksecurefunc("CompactUnitFrame_UpdateAll" ,asCompactUnitFrame_UpdateAll);
