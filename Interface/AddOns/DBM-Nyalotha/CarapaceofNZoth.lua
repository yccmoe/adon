local mod	= DBM:NewMod(2366, "DBM-Nyalotha", nil, 1180)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20200128041711")
mod:SetCreatureID(157439)--Fury of N'Zoth
mod:SetEncounterID(2337)
mod:SetZone()
mod:SetHotfixNoticeRev(20200126000000)--2020, 1, 26
mod:SetMinSyncRevision(20200122000001)
--mod.respawnTime = 29

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_START 307809 307092 313039 315820 315891 315947",
	"SPELL_CAST_SUCCESS 313362 306971 306986 306988",
	"SPELL_AURA_APPLIED 313334 307832 306973 306990 306984 315954 307079",
	"SPELL_AURA_APPLIED_DOSE 315954",
	"SPELL_AURA_REMOVED 313334 306973 306990 307079 306984",
	"SPELL_AURA_REMOVED_DOSE 307079",
--	"SPELL_PERIODIC_DAMAGE",
--	"SPELL_PERIODIC_MISSED",
--	"SPELL_INTERRUPT",
--	"UNIT_DIED",
	"CHAT_MSG_RAID_BOSS_EMOTE",
	"UNIT_SPELLCAST_SUCCEEDED boss1",
	"UNIT_POWER_FREQUENT player"
)

--TODO, Cyst Genesis still listed in overview but removed from P3 in latest build, see if it still exists. 313118/307064
--TODO, escalated tank warning for adaptive membrane on Fury, if you're tanking it
--[[
(ability.id = 315820 or ability.id = 307809 or ability.id = 313039 or ability.id = 307092 or ability.id = 315891 or ability.id = 315947) and type = "begincast"
 or (ability.id = 313362 or ability.id = 306971 or ability.id = 306986 or ability.id = 306988) and type = "cast"
 or ability.id = 307079 and (type = "applybuff" or type = "removebuff")
 or ability.id = 318108 and type = "applybuff"
--]]
--General
local warnPhase								= mod:NewPhaseChangeAnnounce(2, nil, nil, nil, nil, nil, 2)
local warnGiftofNzoth						= mod:NewTargetNoFilterAnnounce(313334, 2)
local warnWillPower							= mod:NewCountAnnounce(307831, 3)
--Stage 1: Exterior Carapace
----Fury of N'Zoth
local warnMadnessBomb						= mod:NewTargetAnnounce(306973, 2)
local warnAdaptiveMembrane					= mod:NewTargetNoFilterAnnounce(306990, 4)
--local warnGazeofMadness						= mod:NewCountAnnounce(307482, 2)
local warnBlackScar							= mod:NewStackAnnounce(315954, 2, nil, "Tank")
--Stage 2: Subcutaneous Tunnel
local warnSynthesRemaining					= mod:NewCountAnnounce(307079, 2)
local warnSynthesisOver						= mod:NewEndAnnounce(307071, 1)
--Stage 3: Nightmare Chamber
local warnInsanityBomb						= mod:NewTargetAnnounce(306984, 2)

--General
local specWarnGiftofNzoth					= mod:NewSpecialWarningYou(313334, nil, nil, nil, 1, 2)
local specWarnServantofNzoth				= mod:NewSpecialWarningTargetChange(307832, false, nil, 2, 1, 2)
local yellServantofNzoth					= mod:NewYell(307832)
local specWarnBlackScar						= mod:NewSpecialWarningStack(315954, nil, 2, nil, nil, 1, 6)
local specWarnBlackScarTaunt				= mod:NewSpecialWarningTaunt(315954, nil, nil, nil, 1, 2)
local specwarnWillPower						= mod:NewSpecialWarningCount(307831, nil, nil, nil, 1, 10)
--local specWarnGTFO						= mod:NewSpecialWarningGTFO(270290, nil, nil, nil, 1, 8)
--Stage 1: Exterior Carapace
----Fury of N'Zoth
local specWarnMadnessBomb					= mod:NewSpecialWarningMoveAway(306973, nil, nil, nil, 1, 2)
local yellMadnessBomb						= mod:NewYell(306973)
local yellMadnessBombFades					= mod:NewShortFadesYell(306973)
local specWarnGrowthCoveredTentacle			= mod:NewSpecialWarningDodgeCount(307131, nil, nil, nil, 3, 2)
----Gaze of Madness
local specWarnGazeOfMadness					= mod:NewSpecialWarningSwitch("ej20565", "Dps", nil, nil, 1, 2)
--Stage 2: Subcutaneous Tunnel
local specWarnEternalDarkness				= mod:NewSpecialWarningCount(307048, nil, nil, nil, 2, 2)
local specWarnOccipitalBlast				= mod:NewSpecialWarningDodge(307092, nil, nil, nil, 2, 2)
--Stage 3: Nightmare Chamber
local specWarnInsanityBomb					= mod:NewSpecialWarningMoveAway(306984, nil, nil, nil, 1, 2)
local yellInsanityBomb						= mod:NewYell(306984)
local yellInsanityBombFades					= mod:NewShortFadesYell(306984)
local specWarnInfiniteDarkness				= mod:NewSpecialWarningCount(313040, nil, nil, nil, 2, 2)
local specWarnThrashingTentacle				= mod:NewSpecialWarningCount(315820, nil, nil, nil, 2, 2)

--General
local timerGiftofNzoth						= mod:NewBuffFadesTimer(20, 313334, nil, nil, nil, 5)
--Stage 1: Exterior Carapace
mod:AddTimerLine(DBM:EJ_GetSectionInfo(20558))
----Fury of N'Zoth
local timerMadnessBombCD					= mod:NewCDTimer(22.2, 306973, nil, nil, nil, 3)--22-24
local timerAdaptiveMembraneCD				= mod:NewCDTimer(27.7, 306990, nil, nil, nil, 5, nil, DBM_CORE_DAMAGE_ICON..DBM_CORE_TANK_ICON, nil, 3, 3)
local timerAdaptiveMembrane					= mod:NewBuffActiveTimer(12, 306990, nil, false, 2, 5, nil, DBM_CORE_DAMAGE_ICON)
local timerMentalDecayCD					= mod:NewCDTimer(21, 313364, nil, nil, nil, 3)
local timerGrowthCoveredTentacleCD			= mod:NewNextCountTimer(60, 307131, nil, nil, nil, 1, nil, nil, nil, 1, 3)
local timerMandibleSlamCD					= mod:NewCDTimer(12.7, 315947, nil, "Tank", 2, 5, nil, DBM_CORE_TANK_ICON)--12.7
----Adds
local timerGazeofMadnessCD					= mod:NewCDCountTimer(58, "ej20565", nil, nil, nil, 1, nil, DBM_CORE_DAMAGE_ICON)
--Stage 2: Subcutaneous Tunnel
mod:AddTimerLine(DBM:EJ_GetSectionInfo(20566))
local timerEternalDarknessCD				= mod:NewCDTimer(22.2, 307048, nil, nil, nil, 2)--Can be delayed if it overlaps with blast, otherwise dead on
local timerOccipitalBlastCD					= mod:NewCDTimer(33.3, 307092, nil, nil, nil, 3)--Can be delayed if it overlaps with Eternal darkness, otherwise dead on
--Stage 3: Nightmare Chamber
mod:AddTimerLine(DBM:EJ_GetSectionInfo(20569))
local timerInsanityBombCD					= mod:NewCDTimer(66.9, 306984, nil, nil, nil, 3)
local timerInfiniteDarknessCD				= mod:NewCDTimer(53.9, 313040, nil, nil, nil, 2)
local timerThrashingTentacleCD				= mod:NewCDCountTimer(20, 315820, nil, nil, nil, 3)

--local berserkTimer							= mod:NewBerserkTimer(720)

mod:AddRangeFrameOption("10")
mod:AddInfoFrameOption(307831, true)
--mod:AddSetIconOption("SetIconOnEyeBeam", 264382, true, false, {1, 2})
mod:AddNamePlateOption("NPAuraOnMembrane2", 306990, false)

mod.vb.TentacleCount = 0
mod.vb.gazeCount = 0
mod.vb.DarknessCount = 0
mod.vb.phase = 1
mod.vb.anchorCount = 0
local lastSanity = 100

local function thrashingTentacleLoop(self)
	self.vb.TentacleCount = self.vb.TentacleCount + 1
	specWarnThrashingTentacle:Show(self.vb.TentacleCount)
	specWarnThrashingTentacle:Play("watchstep")
	timerThrashingTentacleCD:Start(20, self.vb.TentacleCount+1)
	self:Schedule(20, thrashingTentacleLoop, self)
end

function mod:OnCombatStart(delay)
	self.vb.TentacleCount = 0
	self.vb.gazeCount = 0
	self.vb.DarknessCount = 0
	self.vb.phase = 1
	self.vb.anchorCount = 0
	lastSanity = 100
	if self:IsHard() then--Heroic confirmed, mythic assumed
		timerMadnessBombCD:Start(5-delay)--SUCCESS
		timerGazeofMadnessCD:Start(10-delay, 1)
		timerMentalDecayCD:Start(12-delay)--SUCCESS
		timerAdaptiveMembraneCD:Start(16-delay)--SUCCESS
		timerMandibleSlamCD:Start(16-delay)
		timerGrowthCoveredTentacleCD:Start(30-delay)
	else--Normal confirmed, LFR assumed
		timerMadnessBombCD:Start(5.8-delay)--SUCCESS
		timerGazeofMadnessCD:Start(12.1-delay, 1)--Unknown, guessed by 0.82 adjustment
		timerMentalDecayCD:Start(14.8-delay)--SUCCESS 12.1?
		timerAdaptiveMembraneCD:Start(19.5-delay)--SUCCESS
		timerMandibleSlamCD:Start(20-delay)
		timerGrowthCoveredTentacleCD:Start(36-delay)--Unknown, guessed by 0.82 adjustment
	end
	--berserkTimer:Start(720-delay)
	if self.Options.InfoFrame then
		DBM.InfoFrame:SetHeader(DBM:GetSpellInfo(307831))
		DBM.InfoFrame:Show(8, "playerpower", 1, ALTERNATE_POWER_INDEX, nil, nil, 2)--Sorting lowest to highest
	end
	if self.Options.NPAuraOnMembrane2 then
		DBM:FireEvent("BossMod_EnableHostileNameplates")
	end
end

function mod:OnCombatEnd()
	if self.Options.InfoFrame then
		DBM.InfoFrame:Hide()
	end
	if self.Options.RangeFrame then
		DBM.RangeCheck:Hide()
	end
	if self.Options.NPAuraOnMembrane2 then
		DBM.Nameplate:Hide(true, nil, nil, nil, true, true)
	end
end

--function mod:OnTimerRecovery()

--end

function mod:SPELL_CAST_START(args)
	local spellId = args.spellId
	if spellId == 315820 then
		--self.vb.TentacleCount = self.vb.TentacleCount + 1
		--specWarnThrashingTentacle:Show(self.vb.TentacleCount)
		--specWarnThrashingTentacle:Play("watchstep")--???
		--timerThrashingTentacleCD:Start()
	elseif spellId == 307809 then
		self.vb.DarknessCount = self.vb.DarknessCount + 1
		specWarnEternalDarkness:Show(self.vb.DarknessCount)
		specWarnEternalDarkness:Play("aesoon")
		--Only Phase 2/2.5 on heroic and mythic, but on normal and LFR it's also phase 3
		local timer = self:IsHard() and 22.2 or (self.vb.phase == 3) and 67.4 or 25
		timerEternalDarknessCD:Start(timer)
	elseif spellId == 313039 then
		self.vb.DarknessCount = self.vb.DarknessCount + 1
		specWarnInfiniteDarkness:Show(self.vb.DarknessCount)
		specWarnInfiniteDarkness:Play("aesoon")
		timerInfiniteDarknessCD:Start(53.9)--Heroic+ only
	elseif (spellId == 307092 or spellId == 315891) and args:GetSrcCreatureID() == 157439  then--Stage 2/Stage 3 (so we ignore 162285 casts)
		specWarnOccipitalBlast:Show()
		specWarnOccipitalBlast:Play("shockwave")
		timerOccipitalBlastCD:Start(self:IsHard() and 33.3 or 37.5)
	elseif spellId == 315947 then
		--Not case in phase 2, just 1, 2.5, and 3
		local timer
		if self:IsHard() then
			timer = (self.vb.phase == 3) and 10.7 or (self.vb.phase == 2.5) and 22.2 or 12.7
		else
			timer = (self.vb.phase == 3) and 13.7 or (self.vb.phase == 2.5) and 25 or 16.2
		end
		timerMandibleSlamCD:Start(timer)
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	local spellId = args.spellId
	if spellId == 313362 then
		--Requires antispam because sometimes boss double casts
		if args:GetSrcCreatureID() == 157439 and self:AntiSpam(5, 8) then--Fury of N'Zoth
			local timer
			if self:IsHard() then
				timer = (self.vb.phase == 3) and 26.7 or (self.vb.phase == 2) and 22.2 or (self.vb.phase == 2.5) and 42.2 or 21
			else
				timer = (self.vb.phase == 3) and 33.7 or (self.vb.phase == 2) and 22.6 or (self.vb.phase == 2.5) and 47.5 or 26.2
			end
			timerMentalDecayCD:Start(timer)
		end
	elseif spellId == 306971 then
		local timer
		--Not case in phase 3, just 1, 2, and 2.5
		if self:IsHard() then
			timer = (self.vb.phase == 2.5) and 22.2 or (self.vb.phase == 2) and 33.3 or 24
		else
			timer = (self.vb.phase == 2.5) and 24.9 or (self.vb.phase == 2) and 37.4 or 30
		end
		timerMadnessBombCD:Start(timer)
	elseif spellId == 306986 then
		timerInsanityBombCD:Start(self:IsHard() and 66.9 or 83.7)
	elseif spellId == 306988 and self:AntiSpam(3, 9) then
		--Yes this has 4 distinct timers. Verified in multiple logs that the second stage 2 in fact does have it's own CD
		local timer
		if self:IsHard() then
			timer = (self.vb.phase == 3) and 32 or (self.vb.phase == 2) and 21.1 or (self.vb.phase == 2.5) and 33.3 or 27.6
		else
			timer = (self.vb.phase == 3) and 40 or (self.vb.phase == 2) and 25 or (self.vb.phase == 2.5) and 37.4 or 36.2
		end
		timerAdaptiveMembraneCD:Start(timer)
	end
end

function mod:SPELL_AURA_APPLIED(args)
	local spellId = args.spellId
	if spellId == 313334 then
		if args:IsPlayer() then
			specWarnGiftofNzoth:Show()
			specWarnGiftofNzoth:Play("targetyou")
			timerGiftofNzoth:Start()
		else
			warnGiftofNzoth:CombinedShow(1, args.destName)
		end
	elseif spellId == 307832 then
		specWarnServantofNzoth:CombinedShow(1, args.destName)
		specWarnServantofNzoth:ScheduleVoice(1, "findmc")
		if args:IsPlayer() then
			yellServantofNzoth:Yell()
		end
	elseif spellId == 306973 then
		warnMadnessBomb:CombinedShow(0.3, args.destName)
		if args:IsPlayer() then
			specWarnMadnessBomb:Show()
			specWarnMadnessBomb:Play("runout")
			yellMadnessBomb:Yell()
			yellMadnessBombFades:Countdown(spellId)
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(10)
			end
		end
	elseif spellId == 306984 then
		warnInsanityBomb:CombinedShow(0.3, args.destName)
		if args:IsPlayer() then
			specWarnInsanityBomb:Show()
			specWarnInsanityBomb:Play("runout")
			yellInsanityBomb:Yell()
			yellInsanityBombFades:Countdown(spellId)
			if self.Options.RangeFrame then
				DBM.RangeCheck:Show(10)
			end
		end
	elseif spellId == 306990 and args:GetDestCreatureID() == 157439 then
		warnAdaptiveMembrane:Show(args.destName)
		timerAdaptiveMembrane:Start()
		if self.Options.InfoFrame then
			DBM.InfoFrame:SetHeader(args.spellName)
			DBM.InfoFrame:Show(2, "enemyabsorb", nil, args.amount, "boss1")
		end
		if self.Options.NPAuraOnMembrane2 then
			DBM.Nameplate:Show(true, args.destGUID, spellId, nil, 12)
		end
	elseif spellId == 307079 and self.vb.phase < 2 then--Synthesis
		self.vb.phase = 2
		warnPhase:Show(DBM_CORE_AUTO_ANNOUNCE_TEXTS.stage:format(2))
		warnPhase:Play("ptwo")
		timerMadnessBombCD:Stop()
		timerAdaptiveMembraneCD:Stop()
		timerMentalDecayCD:Stop()
		timerGrowthCoveredTentacleCD:Stop()
		timerGazeofMadnessCD:Stop()
		timerMandibleSlamCD:Stop()
		if self:IsHard() then
			timerMentalDecayCD:Start(17.2)--SUCCESS
			timerAdaptiveMembraneCD:Start(20.4)--SUCCESS
			timerEternalDarknessCD:Start(24)
			timerMadnessBombCD:Start(29.3)--SUCCESS
		else
			timerMentalDecayCD:Start(18.4)--SUCCESS
			timerAdaptiveMembraneCD:Start(21.9)--SUCCESS
			timerEternalDarknessCD:Start(26.2)
			timerMadnessBombCD:Start(32)--SUCCESS
		end
	elseif spellId == 315954 then
		local amount = args.amount or 1
		if amount >= 2 then
			if args:IsPlayer() then
				specWarnBlackScar:Show(amount)
				specWarnBlackScar:Play("stackhigh")
			else
				if not UnitIsDeadOrGhost("player") and not DBM:UnitDebuff("player", spellId) then
					specWarnBlackScarTaunt:Show(args.destName)
					specWarnBlackScarTaunt:Play("tauntboss")
				else
					warnBlackScar:Show(args.destName, amount)
				end
			end
		else
			warnBlackScar:Show(args.destName, amount)
		end
	end
end
mod.SPELL_AURA_APPLIED_DOSE = mod.SPELL_AURA_APPLIED

function mod:SPELL_AURA_REMOVED(args)
	local spellId = args.spellId
	if spellId == 313334 then
		if args:IsPlayer() then
			timerGiftofNzoth:Stop()
		end
	elseif spellId == 306973 then
		if args:IsPlayer() then
			yellMadnessBombFades:Cancel()
			if self.Options.RangeFrame then
				DBM.RangeCheck:Hide()
			end
		end
	elseif spellId == 306984 then
		if args:IsPlayer() then
			yellInsanityBombFades:Cancel()
			if self.Options.RangeFrame then
				DBM.RangeCheck:Hide()
			end
		end
	elseif spellId == 306990 and args:GetDestCreatureID() == 157439 then
		timerAdaptiveMembrane:Stop()
		if self.Options.InfoFrame then
			DBM.InfoFrame:SetHeader(DBM:GetSpellInfo(307831))
			DBM.InfoFrame:Show(8, "playerpower", 1, ALTERNATE_POWER_INDEX, nil, nil, 2)--Sorting lowest to highest
		end
		if self.Options.NPAuraOnMembrane2 then
			DBM.Nameplate:Hide(true, args.destGUID, spellId)
		end
	--elseif spellId == 307079 then--Synthesis
		--Do nothing, handled in anchor event
	end
end

function mod:SPELL_AURA_REMOVED_DOSE(args)
	local spellId = args.spellId
	if spellId == 307079 then
		local amount = args.amount or 0
		if amount ~= 0 then
			warnSynthesRemaining:Show(amount)
		end
	end
end

--[[
function mod:SPELL_PERIODIC_DAMAGE(_, _, _, _, destGUID, _, _, _, spellId, spellName)
	if spellId == 270290 and destGUID == UnitGUID("player") and self:AntiSpam(2, 2) then
		specWarnGTFO:Show(spellName)
		specWarnGTFO:Play("watchfeet")
	end
end
mod.SPELL_PERIODIC_MISSED = mod.SPELL_PERIODIC_DAMAGE

function mod:SPELL_INTERRUPT(args)
	if type(args.extraSpellId) == "number" and args.extraSpellId == 298548 then

	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 157452 then--nightmare-antigen

	elseif cid == 157442 then--gaze-of-madness

	elseif cid == 157475 then--synthesis-growth

	end
end
--]]

function mod:CHAT_MSG_RAID_BOSS_EMOTE(msg, npc, _, _, target)
	--"<23.58 17:24:45> [CHAT_MSG_RAID_BOSS_EMOTE] |TInterface\\Icons\\INV_EyeofNzothPet.blp:20|t A %s emerges!#Gaze of Madness#####0#0##0#1983#nil#0#false#false#false#false", -- [566]
	if msg:find("INV_EyeofNzothPet.blp") then
		self.vb.gazeCount = self.vb.gazeCount + 1
		specWarnGazeOfMadness:Show(self.vb.gazeCount)
		specWarnGazeOfMadness:Play("killmob")
		timerGazeofMadnessCD:Start(self:IsHard() and 58 or 70.7, self.vb.gazeCount+1)--Normal mode guessed by 0.82 adjustment
	--"<48.92 17:25:10> [CHAT_MSG_RAID_BOSS_EMOTE] |TInterface\\Icons\\INV_MISC_MONSTERHORN_04.BLP:20|t A %s emerges. Look out!#Growth-Covered Tentacle#####0#0##0#1990#nil#0#false#false#false#false",
	elseif msg:find("INV_MISC_MONSTERHORN_04.BLP") then
		self.vb.TentacleCount = self.vb.TentacleCount + 1
		specWarnGrowthCoveredTentacle:Show(self.vb.TentacleCount)
		specWarnGrowthCoveredTentacle:Play("watchstep")
		timerGrowthCoveredTentacleCD:Start(self:IsHard() and 60 or 73.1, self.vb.TentacleCount+1)--Normal mode guessed by 0.82 adjustment
	end
end

--"<415.03 15:50:30> [CLEU] SPELL_AURA_APPLIED#Player-3685-0A675506#Hulahoops-Turalyon#Player-3685-0A675506#Hulahoops-Turalyon#318108#Boon of the Black Prince#BUFF#nil", -- [17297]
--"<415.38 15:50:30> [CHAT_MSG_MONSTER_YELL] I dare not enter that foul place, lest I lose myself to his madness. Strike him down!#Wrathion###Siory##0#0##0#1325#nil#0#false#false#false#false", -- [17314]
--"<423.12 15:50:38> [UNIT_SPELLCAST_SUCCEEDED] Fury of N'Zoth(??) -Anchor Here- [[boss1:Cast-3-3886-2217-7151-45313-0017A8B59E:45313]]", -- [17461]
function mod:UNIT_SPELLCAST_SUCCEEDED(uId, _, spellId)
	if spellId == 315673 then--Thrashing Tentacle
		--timerThrashingTentacleCD:Start()--27.8
	elseif spellId == 45313 then--Anchor Here (this can be used for phase 2 start as well, but it's slower)
		self.vb.anchorCount = self.vb.anchorCount + 1
		--We need to ignore first anchor, and do nothing with it since we start P2 much earlier with Synthesis
		if self.vb.anchorCount == 1 then return end
		--Non mythic has an extra 'Anchor Here' cast that isn't cast on mythic
		if (self.vb.anchorCount == 2 and self:IsMythic()) or self.vb.anchorCount == 3 then
			--Boon of Black Prince can be used as a backup but it's NOT as consistent and introduces a 3 second variation to elements. Should only be used if this can't be
			--It may be wise to move timer canceling for phase 2/2.5 to boon but timer starting stay at anchor event
			self.vb.phase = 3
			self.vb.TentacleCount = 0
			warnPhase:Show(DBM_CORE_AUTO_ANNOUNCE_TEXTS.stage:format(3))
			warnPhase:Play("pthree")
			timerMentalDecayCD:Stop()
			timerAdaptiveMembraneCD:Stop()
			timerEternalDarknessCD:Stop()
			timerMadnessBombCD:Stop()
			timerOccipitalBlastCD:Stop()
			timerMandibleSlamCD:Stop()
			--Timers assumed from heroic phase 3, might be different since boss mechanics differ on mythic
			if self:IsHard() then
				timerMentalDecayCD:Start(12.1)--SUCCESS
				timerMandibleSlamCD:Start(17.1)
				timerInsanityBombCD:Start(21.6)--SUCCESS
				timerThrashingTentacleCD:Start(32, 1)--Confirmed from https://www.twitch.tv/videos/541753121 from 00:54:06 onward
				self:Schedule(32, thrashingTentacleLoop, self)
				timerAdaptiveMembraneCD:Start(38.1)--SUCCESS
				timerInfiniteDarknessCD:Start(54)
			else
				--These are probably off by 1-3 seconds, it's impossible to perfect this, even using boon, without transcriptor log to capture anchor here event
				timerMentalDecayCD:Start(14.5)--SUCCESS
				timerMandibleSlamCD:Start(20.9)
				timerInsanityBombCD:Start(26.1)--SUCCESS
				timerThrashingTentacleCD:Start(32, 1)
				self:Schedule(32, thrashingTentacleLoop, self)
				timerAdaptiveMembraneCD:Start(46.6)--SUCCESS
				timerEternalDarknessCD:Start(67)
			end
		else
			--he hangs around in tunnel for 10%
			self.vb.phase = 2.5
			warnSynthesisOver:Show()
			timerMadnessBombCD:Stop()
			timerAdaptiveMembraneCD:Stop()
			timerEternalDarknessCD:Stop()
			timerMentalDecayCD:Stop()
			if self:IsHard() then
				timerOccipitalBlastCD:Start(5)
				timerMadnessBombCD:Start(13.1)--SUCCESS
				timerMandibleSlamCD:Start(15.5)
				timerAdaptiveMembraneCD:Start(18.7)--SUCCESS
				timerEternalDarknessCD:Start(22.3)
				timerMentalDecayCD:Start(28.7)--SUCCESS
			else
				timerOccipitalBlastCD:Start(6.2)
				timerMadnessBombCD:Start(14.6)--SUCCESS
				timerMandibleSlamCD:Start(17.5)
				timerAdaptiveMembraneCD:Start(20.8)--SUCCESS
				timerEternalDarknessCD:Start(25)
				timerMentalDecayCD:Start(32.3)--SUCCESS
			end
		end
	end
end

function mod:UNIT_POWER_FREQUENT(uId)
	local currentSanity = UnitPower(uId, ALTERNATE_POWER_INDEX)
	if currentSanity > lastSanity then
		lastSanity = currentSanity
		return
	end
	if self:AntiSpam(5, 6) then--Additional throttle in case you lose sanity VERY rapidly with increased ICD for special warning
		if currentSanity == 15 and lastSanity > 15 then
			lastSanity = 15
			specwarnWillPower:Show(lastSanity)
			specwarnWillPower:Play("lowsanity")
		elseif currentSanity == 30 and lastSanity > 30 then
			lastSanity = 30
			specwarnWillPower:Show(lastSanity)
			specwarnWillPower:Play("lowsanity")
		end
	elseif self:AntiSpam(3, 7) then--Additional throttle in case you lose sanity VERY rapidly
		if currentSanity == 45 and lastSanity > 45 then
			lastSanity = 45
			warnWillPower:Show(lastSanity)
		elseif currentSanity == 60 and lastSanity > 60 then
			lastSanity = 60
			warnWillPower:Show(lastSanity)
		end
	end
end
