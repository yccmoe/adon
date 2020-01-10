ADRT= nil;
ADRT_mainframe = nil;
ADRT_SpellList = nil;
ADRT_Main= nil;

-- 설정
ADRT_SIZE = 30;	

local ADRT_CoolButtons_X = 10			-- Button 위치 Frame 옆 Offset1
local ADRT_CoolButtons_Y = 0
local ADRT_CoolButtons_X_Middle = 215	-- asHealthText 사용시 보일 위치
local ADRT_CoolButtons_Y_Middle = -36

local ADRT_Alpha = 0.9
local ADRT_CooldownFontSize = 11
local ADRT_DR = 18; 					-- 점감 Time 20초
local ADRT_ShowTargetMiddle = false;		-- Target Frame 옆에 보이고 싶지 않을 때 true 하고, ADRT_CoolButtons_X_Middle 조정

--설정 표시할 Unit
local ADRT_UnitList = {
	"target", 		-- 대상 표시 안하길 원하면 이 줄 삭제
	"focus",			-- 주시대상 표시 안하길 원하면 이 줄 삭제
	"arena1",
	"arena2",
	"arena3",
	"arena4",
	"arena5",
}




local spellList = {
	--[[ INCAPACITATES ]]--
	-- Druid
	[    99] = 2, -- Incapacitating Roar (talent)
	[203126] = 2, -- Maim (with blood trauma pvp talent)
	-- Hunter
	[  3355] = 2, -- Freezing Trap
	[ 19386] = 2, -- Wyvern Sting
	[209790] = 2, -- Freezing Arrow
	-- Mage
	[   118] = 2, -- Polymorph
	[ 28272] = 2, -- Polymorph (pig)
	[ 28271] = 2, -- Polymorph (turtle)
	[ 61305] = 2, -- Polymorph (black cat)
	[ 61721] = 2, -- Polymorph (rabbit)
	[ 61780] = 2, -- Polymorph (turkey)
	[126819] = 2, -- Polymorph (procupine)
	[161353] = 2, -- Polymorph (bear cub)
	[161354] = 2, -- Polymorph (monkey)
	[161355] = 2, -- Polymorph (penguin)
	[161372] = 2, -- Polymorph (peacock)
	[ 82691] = 2, -- Ring of Frost
	-- Monk
	[115078] = 2, -- Paralysis
	-- Paladin
	[ 20066] = 2, -- Repentance
	-- Priest
	[   605] = 2, -- Mind Control
	[  9484] = 2, -- Shackle Undead
	[ 64044] = 2, -- Psychic Horror (Horror effect)
	[ 88625] = 2, -- Holy Word: Chastise
	-- Rogue
	[  1776] = 2, -- Gouge
	[  6770] = 2, -- Sap
	-- Shaman
	[ 51514] = 2, -- Hex
	[211004] = 2, -- Hex (spider)
	[210873] = 2, -- Hex (raptor)
	[211015] = 2, -- Hex (cockroach)
	[211010] = 2, -- Hex (snake)
	-- Warlock
	[   710] = 2, -- Banish
	[  6789] = 2, -- Mortal Coil
	-- Pandaren
	[107079] = 2, -- Quaking Palm
	
	--[[ SILENCES ]]--
	-- Death Knight
	[ 47476] = 3, -- Strangulate
	-- Demon Hunter
	[204490] = 3, -- Sigil of Silence
	-- Druid
	-- Hunter
	[202933] = 3, -- Spider Sting (pvp talent)
	-- Mage
	-- Paladin
	[ 31935] = 3, -- Avenger's Shield
	-- Priest
	[ 15487] = 3, -- Silence
	[199683] = 3, -- Last Word (SW: Death silence)
	-- Rogue
	[  1330] = 3, -- Garrote
	-- Blood Elf
	[ 25046] = 3, -- Arcane Torrent (Energy version)
	[ 28730] = 3, -- Arcane Torrent (Priest/Mage/Lock version)
	[ 50613] = 3, -- Arcane Torrent (Runic power version)
	[ 69179] = 3, -- Arcane Torrent (Rage version)
	[ 80483] = 3, -- Arcane Torrent (Focus version)
	[129597] = 3, -- Arcane Torrent (Monk version)
	[155145] = 3, -- Arcane Torrent (Paladin version)
	[202719] = 3, -- Arcane Torrent (DH version)
	
	--[[ DISORIENTS ]]--
	-- Death Knight
	[207167] = 1, -- Blinding Sleet (talent) -- FIXME: is this the right category?
	-- Demon Hunter
	[207685] = 1, -- Sigil of Misery
	-- Druid
	[ 33786] = 1, -- Cyclone
	-- Hunter
	[213691] = 1, -- Scatter Shot
	[186387] = 1, -- Bursting Shot
	-- Mage
	[ 31661] = 1, -- Dragon's Breath
	-- Monk
	[198909] = 1, -- Song of Chi-ji -- FIXME: is this the right category( tooltip specifically says disorient, so I guessed here)
	[202274] = 1, -- Incendiary Brew -- FIXME: is this the right category( tooltip specifically says disorient, so I guessed here)
	-- Paladin
	[105421] = 1, -- Blinding Light -- FIXME: is this the right category? Its missing from blizzard's list
	-- Priest
	[  8122] = 1, -- Psychic Scream
	-- Rogue
	[  2094] = 1, -- Blind
	-- Warlock
	[  5782] = 1, -- Fear -- probably unused
	[118699] = 1, -- Fear -- new debuff ID since MoP
	[130616] = 1, -- Fear (with Glyph of Fear)
	[  5484] = 1, -- Howl of Terror (talent)
	[115268] = 1, -- Mesmerize (Shivarra)
	[  6358] = 1, -- Seduction (Succubus)
	-- Warrior
	[  5246] = 1, -- Intimidating Shout (main target)
	
	--[[ STUNS ]]--
	-- Death Knight
	-- Abomination's Might note: 207165 is the stun, but is never applied to players,
	-- so I haven't included it.
	[108194] = 4, -- Asphyxiate (talent for unholy)
	[221562] = 4, -- Asphyxiate (baseline for blood)
	[ 91800] = 4, -- Gnaw (Ghoul)
	[ 91797] = 4, -- Monstrous Blow (Dark Transformation Ghoul)
	[207171] = 4, -- Winter is Coming (Remorseless winter stun)
	-- Demon Hunter
	[179057] = 4, -- Chaos Nova
	[200166] = 4, -- Metamorphosis
	[205630] = 4, -- Illidan's Grasp, primary effect
	[208618] = 4, -- Illidan's Grasp, secondary effect
	[211881] = 4, -- Fel Eruption
	-- Druid
	[203123] = 4, -- Maim
	[  5211] = 4, -- Mighty Bash
	[163505] = 4, -- Rake (Stun from Prowl)
	-- Hunter
	[117526] = 4, -- Binding Shot
	[ 24394] = 4, -- Intimidation
	-- Mage

	-- Monk
	[119381] = 4, -- Leg Sweep
	-- Paladin
	[   853] = 4, -- Hammer of Justice
	-- Priest
	[200200] = 4, -- Holy word: Chastise
	[226943] = 4, -- Mind Bomb
	-- Rogue
	-- Shadowstrike note: 196958 is the stun, but it never applies to players,
	-- so I haven't included it.
	[  1833] = 4, -- Cheap Shot
	[   408] = 4, -- Kidney Shot
	[199804] = 4, -- Between the Eyes
	-- Shaman
	[118345] = 4, -- Pulverize (Primal Earth Elemental)
	[118905] = 4, -- Static Charge (Capacitor Totem)
	[204399] = 4, -- Earthfury (pvp talent)
	-- Warlock
	[ 89766] = 4, -- Axe Toss (Felguard)
	[ 30283] = 4, -- Shadowfury
	[ 22703] = 4, -- Summon Infernal
	-- Warrior
	[132168] = 4, -- Shockwave
	[132169] = 4, -- Storm Bolt
	-- Tauren
	[ 20549] = 4, -- War Stomp
	
	--[[ ROOTS ]]--
	-- Death Knight
	[ 96294] = 5, -- Chains of Ice (Chilblains Root)
	[204085] = 5, -- Deathchill (pvp talent)
	-- Druid
	[   339] = 5, -- Entangling Roots
	[102359] = 5, -- Mass Entanglement (talent)
	[ 45334] = 5, -- Immobilized (wild charge, bear form)
	-- Hunter
	[ 53148] = 5, -- Charge (Tenacity pet)
	[162480] = 5, -- Steel Trap
	[190927] = 5, -- Harpoon
	[200108] = 5, -- Ranger's Net
	[212638] = 5, -- tracker's net
	[201158] = 5, -- Super Sticky Tar (Expert Trapper, Hunter talent, Tar Trap effect)
	-- Mage
	[   122] = 5, -- Frost Nova
	[ 33395] = 5, -- Freeze (Water Elemental)
	-- [157997] = 5, -- Ice Nova -- since 6.1, ice nova doesn't DR with anything
	[228600] = 5, -- Glacial spike (talent)
	-- Monk
	[116706] = 5, -- Disable
	-- Priest
	-- Shaman
	[ 64695] = 5, -- Earthgrab Totem
	
	--[[ KNOCKBACK ]]--
	-- Death Knight
	--[108199] = "Knockback", -- Gorefiend's Grasp
	-- Druid
	--[102793] = "Knockback", -- Ursol's Vortex
	--[132469] = "Knockback", -- Typhoon
	-- Hunter
	-- Shaman
	--[ 51490] = "Knockback", -- Thunderstorm
	-- Warlock
	--[  6360] = "Knockback", -- Whiplash
	--[115770] = "Knockback", -- Fellash
	
		-- taunt
		--[[
	-- Death Knight
	[ 56222] = 6, -- Dark Command
	[ 57603] = 6, -- Death Grip
	-- I have also seen this spellID used for the Death Grip debuff in MoP:
	[ 51399] = 6, -- Death Grip
	-- Demon Hunter
	[185245] = 6, -- Torment
	-- Druid
	[  6795] = 6, -- Growl
	-- Hunter
	[ 20736] = 6, -- Distracting Shot
	[ 2649] = 6, -- pet
	[ 204683] = 6, -- pet
	-- Monk
	[116189] = 6, -- Provoke
	[118635] = 6, -- Provoke via the Black Ox Statue -- NEED TESTING
	-- Paladin
	[ 62124] = 6, -- Reckoning
	-- Warlock
	[ 17735] = 6, -- Suffering (Voidwalker)
	-- Warrior
	[   355] = 6, -- Taunt
	-- Shaman
	[ 36213] = 6, -- Angered Earth (Earth Elemental)
	--]]

}

local spellList = {
    [207167]  = 1,       -- Blinding Sleet
    [198909]  = 1,       -- Song of Chi-ji
    [202274]  = 1,       -- Incendiary Brew
    [33786]   = 1,       -- Cyclone
    [209753]  = 1,       -- Cyclone Honor Talent
    [31661]   = 1,       -- Dragon's Breath
    [105421]  = 1,       -- Blinding Light
    [8122]    = 1,       -- Psychic Scream
    [605]     = 1,       -- Mind Control
    [2094]    = 1,       -- Blind
    [5782]    = 1,       -- Fear
    [118699]  = 1,       -- Fear (Incorrect?)
    [130616]  = 1,       -- Fear (Incorrect?)
    [5484]    = 1,       -- Howl of Terror
    [115268]  = 1,       -- Mesmerize
    [6358]    = 1,       -- Seduction
    [5246]    = 1,       -- Intimidating Shout
    [207685]  = 1,       -- Sigil of Misery
    [236748]  = 1,       -- Intimidating Roar
    [226943]  = 1,       -- Mind Bomb
    [2637]    = 1,       -- Hibernate
--  [xxxx]    = 1,       -- Holographic Horror Projector

    [99]      = 2,    -- Incapacitating Roar
    [203126]  = 2,    -- Maim (Blood trauma)
    [236025]  = 2,    -- Enraged Maim
    [3355]    = 2,    -- Freezing Trap
    [203337]  = 2,    -- Freezing Trap (Honor Talent)
    [212365]  = 2,    -- Freezing Trap (Incorrect?)
    [19386]   = 2,    -- Wyvern Sting
    [209790]  = 2,    -- Freezing Arrow
    [213691]  = 2,    -- Scatter Shot
    [118]     = 2,    -- Polymorph
    [126819]  = 2,    -- Polymorph (Porcupine)
    [61721]   = 2,    -- Polymorph (Rabbit)
    [28271]   = 2,    -- Polymorph (Turtle)
    [28272]   = 2,    -- Polymorph (Pig)
    [161353]  = 2,    -- Polymorph (Bear cub)
    [161372]  = 2,    -- Polymorph (Peacock)
    [61305]   = 2,    -- Polymorph (Black Cat)
    [61780]   = 2,    -- Polymorph (Turkey)
    [161355]  = 2,    -- Polymorph (Penguin)
    [161354]  = 2,    -- Polymorph (Monkey)
    [277792]  = 2,    -- Polymorph (Bumblebee)
    [277787]  = 2,    -- Polymorph (Baby Direhorn)
    [82691]   = 2,    -- Ring of Frost
    [115078]  = 2,    -- Paralysis
    [20066]   = 2,    -- Repentance
    [9484]    = 2,    -- Shackle Undead
    [200196]  = 2,    -- Holy Word: Chastise
    [1776]    = 2,    -- Gouge
    [6770]    = 2,    -- Sap
    [199743]  = 2,    -- Parley
    [51514]   = 2,    -- Hex
    [211004]  = 2,    -- Hex (Spider)
    [210873]  = 2,    -- Hex (Raptor)
    [211015]  = 2,    -- Hex (Cockroach)
    [211010]  = 2,    -- Hex (Snake)
    [196942]  = 2,    -- Hex (Voodoo Totem)
    [277784]  = 2,    -- Hex (Wicker Mongrel)
    [277778]  = 2,    -- Hex (Zandalari Tendonripper)
    [710]     = 2,    -- Banish
    [6789]    = 2,    -- Mortal Coil
    [107079]  = 2,    -- Quaking Palm
    [217832]  = 2,    -- Imprison
    [221527]  = 2,    -- Imprison (Honor Talent)
    [197214]  = 2,    -- Sundering
--  [274930]  = 2,    -- Organic Discombobulation Grenade

    [47476]   = 3,         -- Strangulate
    [204490]  = 3,         -- Sigil of Silence
    [78675]   = 3,         -- Solar Beam
    [202933]  = 3,         -- Spider Sting
    [233022]  = 3,         -- Spider Sting 2
    [217824]  = 3,         -- Shield of Virtue
    [199683]  = 3,         -- Last Word
    [15487]   = 3,         -- Silence
    [1330]    = 3,         -- Garrote
    [43523]   = 3,         -- Unstable Affliction Silence Effect
    [196364]  = 3,         -- Unstable Affliction Silence Effect 2

    [210141]  = 4,            -- Zombie Explosion
    [108194]  = 4,            -- Asphyxiate (unholy)
    [221562]  = 4,            -- Asphyxiate (blood)
    [91800]   = 4,            -- Gnaw
    [212332]  = 4,            -- Smash
    [91797]   = 4,            -- Monstrous Blow
    [22570]   = 4,            -- Maim (invalid?)
    [203123]  = 4,            -- Maim
    [163505]  = 4,            -- Rake (Prowl)
    [5211]    = 4,            -- Mighty Bash
    [19577]   = 4,            -- Intimidation (no longer used?)
    [24394]   = 4,            -- Intimidation
--  [232055]  = 4,            -- Fists of Fury
    [119381]  = 4,            -- Leg Sweep
    [853]     = 4,            -- Hammer of Justice
    [1833]    = 4,            -- Cheap Shot
    [408]     = 4,            -- Kidney Shot
    [199804]  = 4,            -- Between the Eyes
    [118905]  = 4,            -- Static Charge (Capacitor Totem)
    [118345]  = 4,            -- Pulverize
    [89766]   = 4,            -- Axe Toss
    [171017]  = 4,            -- Meteor Strike (Infernal)
    [171018]  = 4,            -- Meteor Strike (Abyssal)
    [22703]   = 4,            -- Infernal Awakening
    [30283]   = 4,            -- Shadowfury
    [46968]   = 4,            -- Shockwave
    [132168]  = 4,            -- Shockwave (Protection)
    [145047]  = 4,            -- Shockwave (Proving Grounds PvE)
    [132169]  = 4,            -- Storm Bolt
    [64044]   = 4,            -- Psychic Horror
    [200200]  = 4,            -- Holy Word: Chastise Censure
--  [204399]  = 4,            -- Earthfury (doesn't seem to DR)
    [179057]  = 4,            -- Chaos Nova
    [205630]  = 4,            -- Illidan's Grasp, primary effect
    [208618]  = 4,            -- Illidan's Grasp, secondary effect
    [211881]  = 4,            -- Fel Eruption
    [20549]   = 4,            -- War Stomp
    [199085]  = 4,            -- Warpath
    [204437]  = 4,            -- Lightning Lasso
    [255723]  = 4,            -- Bull Rush
    [202244]  = 4,            -- Overrun (Also a knockback)
--  [213688]  = 4,            -- Fel Cleave (doesn't seem to DR)

    [204085]  = 5,            -- Deathchill
    [339]     = 5,            -- Entangling Roots
    [170855]  = 5,            -- Entangling Roots (Nature's Grasp)
    [201589]  = 5,            -- Entangling Roots (Tree of Life)
    [235963]  = 5,            -- Entangling Roots (Feral honor talent)
--  [45334]   = 5,            -- Immobilized (Wild Charge) (doesn't seem to DR)
    [102359]  = 5,            -- Mass Entanglement
    [53148]   = 5,            -- Charge (Hunter pet)
    [162480]  = 5,            -- Steel Trap
    [190927]  = 5,            -- Harpoon
    [200108]  = 5,            -- Ranger's Net
    [212638]  = 5,            -- Tracker's net
    [201158]  = 5,            -- Super Sticky Tar
    [136634]  = 5,            -- Narrow Escape
    [122]     = 5,            -- Frost Nova
    [33395]   = 5,            -- Freeze
    [198121]  = 5,            -- Frostbite
    [220107]  = 5,            -- Frostbite (Water Elemental? needs testing)
    [116706]  = 5,            -- Disable
    [64695]   = 5,            -- Earthgrab (Totem effect)
    [233582]  = 5,            -- Entrenched in Flame
    [117526]  = 5,            -- Binding Shot
    [207171]  = 5,            -- Winter is Coming

    [207777]  = 6,          -- Dismantle
    [233759]  = 6,          -- Grapple Weapon
    [236077]  = 6,          -- Disarm
    [236236]  = 6,          -- Disarm (Prot)
    [209749]  = 6,          -- Faerie Swarm (Balance)

 }



local emum_count = {3, 3, 3, 3, 3, 3}
local dr_time = {18, 18, 18, 18, 18, 18}
local dr_type = {1, 1, 1, 1, 1, 1}


local ADRT_List = {};
local ADRT_Current = {};
-- 자신이 시전한 점감이 아닐경우, 실명, 양변, 
local ADRT_SpecSpell = {2094, 118, 15487, 408, 122, 236236};
local ADRT_SpecSpell_List = {};


function ADRT_UpdateDebuffAnchor(debuffName, index, anchorIndex, size, offsetX, right, parent, castingbar)

	local buff = _G[debuffName..index];
	local point1 = "LEFT";
	local point2 = "RIGHT";
	local point3 = "RIGHT";
	local firstx = ADRT_CoolButtons_X;
	local firsty = ADRT_CoolButtons_Y;

	local showCastbars = GetCVarBool("showArenaEnemyCastbar");

	if castingbar and showCastbars then
	--	parent = castingbar;	
	--	firstx = firstx + 10
		firsty = firsty + 15;
	end

	if (right == false) then
		point1 = "RIGHT";
		point2 = "LEFT";
		point3 = "LEFT";
		offsetX = -offsetX;
		firstx = -firstx;
	end

	if ( index == 1 ) then
		if  parent == UIParent then
			buff:SetPoint("CENTER", parent, "CENTER", ADRT_CoolButtons_X_Middle, ADRT_CoolButtons_Y_Middle);
		else
			if debuffName == "ADRT_TargetDEBUFF_Button" and _G["ADotF"] then
				buff:SetPoint(point1, parent, point2, firstx, firsty-40);
			else
				buff:SetPoint(point1, parent, point2, firstx, firsty);
			end
		end

	else

		buff:SetPoint(point1, _G[debuffName..anchorIndex], point3, offsetX, 0);
	end

	-- Resize
	buff:SetWidth(size);
	buff:SetHeight(size);
	local debuffFrame =_G[debuffName..index.."Border"];
	debuffFrame:SetWidth(size+2);
	debuffFrame:SetHeight(size+2);
end



function ADRT_Alert(self, unit_type)

	local unit = ADRT_UnitList[unit_type]; 

	local destGUID = UnitGUID(unit);
	local button_idx = 1;
	local current = GetTime();
	local castingbar = nil;
	local size = ADRT_SIZE;

	--[[
	if not UnitIsPlayer(unit) then
		if ADRT_List[destGUID] then
			ADRT_List[destGUID] = nil;
		end
	end
	--]]


	if (unit == "target") then
		selfName = "ADRT_TargetDEBUFF_";
		maxIdx = MAX_TARGET_DEBUFFS;
		if  _G["AHT_main"] or ADRT_ShowTargetMiddle then
			parent = UIParent;
		else
			parent = _G["TargetFrame"];
		end

	elseif (unit == "focus") then
		selfName = "ADRT_FocusDEBUFF_";
		maxIdx = MAX_TARGET_DEBUFFS;
		parent = _G["FocusFrame"];
	elseif (unit == "arena1") then
		selfName = "ADRT_arena1DEBUFF_";
		maxIdx = MAX_TARGET_DEBUFFS;
		parent = _G["ArenaEnemyFrame1"];
		castingbar = _G["ArenaEnemyFrame1CastingBar"];
		size = size - 10;
	elseif (unit == "arena2") then
		selfName = "ADRT_arena2DEBUFF_";
		maxIdx = MAX_TARGET_DEBUFFS;
		parent = _G["ArenaEnemyFrame2"];
		castingbar = _G["ArenaEnemyFrame2CastingBar"];
		size = size - 10;
	elseif (unit == "arena3") then
		selfName = "ADRT_arena3DEBUFF_";
		maxIdx = MAX_TARGET_DEBUFFS;
		parent = _G["ArenaEnemyFrame3"];
		castingbar = _G["ArenaEnemyFrame3CastingBar"];
		size = size - 10;
	elseif (unit == "arena4") then
		selfName = "ADRT_arena4DEBUFF_";
		maxIdx = MAX_TARGET_DEBUFFS;
		parent = _G["ArenaEnemyFrame4"];
		castingbar = _G["ArenaEnemyFrame4CastingBar"];
		size = size - 10;
	elseif (unit == "arena5") then
		selfName = "ADRT_arena5DEBUFF_";
		maxIdx = MAX_TARGET_DEBUFFS;
		parent = _G["ArenaEnemyFrame5"];
		castingbar = _G["ArenaEnemyFrame5CastingBar"];
		size = size - 10;
	end
	

	frametype = selfName.."Button";

		
	self.time[unit_type] = 0xFFFFFFFF;

	
	for idx = 1, 6 do

		if ADRT_List[destGUID] and ADRT_List[destGUID][idx] then

			local drtime = dr_time[idx]; 
			local spellid = ADRT_List[destGUID][idx][1];
			local end_time = ADRT_List[destGUID][idx][2]; 
			local count = ADRT_List[destGUID][idx][3]; 
			local start = end_time - drtime;
			local duration = drtime;
	
			local discard,discard,icon = GetSpellInfo(spellid)
	
			if self.time[unit_type] > end_time then
				self.time[unit_type] = end_time
			end

			--print("update");

			if icon and current < end_time and current >= end_time - drtime then

				local frame;
				local frameIcon;
				local frameCooldown;
				local frameBorder;
				local color;

				frameName = frametype..button_idx;
	
				frame = _G[frameName];

				if ( not frame ) then
					frame = CreateFrame("Button", frameName, parent, "asDRTimerFrameTemplate");
					frame:EnableMouse(false); 
					for _,r in next,{_G[frameName.."Cooldown"]:GetRegions()}	do 
						if r:GetObjectType()=="FontString" then 
							r:SetFont("Fonts\\2002.TTF",ADRT_CooldownFontSize,"OUTLINE")
							r:SetPoint("TOPLEFT", -2, 2);
							break 
						end 
					end
				end

	
				frameIcon = _G[frameName.."Icon"];
				frameCount = _G[frameName.."Count"];
				frameCooldown = _G[frameName.."Cooldown"];
				frameBorder = _G[frameName.."Border"];

				frame:SetWidth(size);
				frame:SetHeight(size);
			

				frameIcon:SetTexture(icon);
				CooldownFrame_Set(frameCooldown, start, duration, duration > 0, 1);
				frameCooldown:SetHideCountdownNumbers(false);

				frameIcon:Show();
				frameCooldown:Show();
				
				if count == 2 then
					color = DebuffTypeColor["Magic"];
					frameBorder:SetVertexColor(color.r, color.g, color.b);
					frameBorder:SetAlpha(1);
					frameBorder:Show();
					ADRT_HideOverlayGlow(frame);
				elseif count >= 3 then
					color = DebuffTypeColor["none"];
					frameBorder:SetVertexColor(color.r, color.g, color.b);
					frameBorder:SetAlpha(1);
					frameBorder:Show();

					if count >= emum_count[idx] then
						ADRT_ShowOverlayGlow(frame);
					else
						ADRT_HideOverlayGlow(frame);
					end
				else
					frameBorder:Hide();
					frameCount:Hide();
					ADRT_HideOverlayGlow(frame);
				end

				frame:ClearAllPoints();
				frame:Show();

				button_idx = button_idx + 1;

			else
				ADRT_List[destGUID][idx] = nil;
			end

		end
	end

	if (unit == "target" or unit == "focus")  then
		for i=1, button_idx - 1 do
			ADRT_UpdateDebuffAnchor(frametype, i, i - 1, size, 4, true, parent, castingbar);
		end
	else
		for i=1, button_idx - 1 do
			ADRT_UpdateDebuffAnchor(frametype, i, i - 1, size, 4, false, parent, castingbar);
		end
	end


	for idx = button_idx, 6 do
		frameName = frametype..idx;
		frame = _G[frameName];

		if ( frame ) then
			ADRT_HideOverlayGlow(frame);
			frame:Hide();	
		end
	end

	return;
end


local function ADRT_CheckSpell()
	
end


function ADRT_OnEvent(self, event, ...)

	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
	
		local _, eventType, _, sourceGUID, _, _, _, destGUID, _, _, _, spellID, _, _, auraType = CombatLogGetCurrentEventInfo();

		local time = GetTime();
				
		if (eventType == "SPELL_AURA_REMOVED" or eventType == "SPELL_AURA_APPLIED" or eventType == "SPELL_AURA_REFRESH") and auraType == "DEBUFF" then
			local category = spellList[spellID]

			local className = GetPlayerInfoByGUID(destGUID)
			local isTarget = (destGUID == UnitGUID("target"));
			local isFocus = (destGUID == UnitGUID("focus"));
			local DRTime = ADRT_DR;
			local Type = 1;

			if eventType == "SPELL_AURA_APPLIED" then
				Type = 2;
			end

			if category and not (className) then
				return;
			end

			if not dr_time[category] then
				return
			end

			if not dr_type[category] or not (dr_type[category] == Type) then
				return
			end

			local DRTime = dr_time[category];
		
			if category then
			
				if sourceGUID == UnitGUID("player") or sourceGUID ==  UnitGUID("pet") then
				else
					spellID = ADRT_SpecSpell[category];
				end

				local bShow = false;


				if ADRT_List[destGUID] == nil then
					ADRT_List[destGUID] = {};
					ADRT_List[destGUID][category] = {spellID, time + DRTime, 1};
					bShow = true;
				elseif ADRT_List[destGUID][category] == nil then
					ADRT_List[destGUID][category] = {spellID, time + DRTime, 1};
					bShow = true;
				elseif ADRT_List[destGUID][category] then
					if time > ADRT_List[destGUID][category][2] then
						ADRT_List[destGUID][category] = {spellID, time + DRTime, 1};
						bShow = true
					elseif ADRT_List[destGUID][category][3] < emum_count[category] then
						bShow = true
						ADRT_List[destGUID][category][3] = ADRT_List[destGUID][category][3] + 1;
						if category < 6 then
							ADRT_List[destGUID][category][2] = time + DRTime;
						end
					else
						bShow = true
						ADRT_List[destGUID][category][2] = time + DRTime;
					end
				end
				
				if bShow then
					for unit_type = 1, #ADRT_UnitList do
						if destGUID == UnitGUID(ADRT_UnitList[unit_type]) then
							ADRT_Alert(self, unit_type);
						end
					end
				end
			end
		end

	elseif event == "PLAYER_TARGET_CHANGED" then
		for unit_type = 1, #ADRT_UnitList do
		
			if "target" == ADRT_UnitList[unit_type] then
				ADRT_Alert(self, unit_type);
			end
		end
	elseif event == "PLAYER_FOCUS_CHANGED" then
		for unit_type = 1, #ADRT_UnitList do
		
			if "focus" == ADRT_UnitList[unit_type] then
				ADRT_Alert(self, unit_type);
			end
		end

	elseif event == "PLAYER_ENTERING_WORLD" then
	
		ADRT_List = {};

		local bInstance, RTB_ZoneType = IsInInstance();

		if (RTB_ZoneType == "party" or RTB_ZoneType == "raid")  then
			self:UnregisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			self:SetScript("OnUpdate",nil);
		else
			self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			self:SetScript("OnUpdate",ADRT_OnUpdate);
		end



	end

	return;
end 

local update = 0;
local update2 = 0;

function ADRT_OnUpdate(self, elapsed)

	update = update + elapsed

	if update >= 0.25  then

		update = 0

		for unit_type = 1, #ADRT_UnitList do
			if (self.time[unit_type] <= GetTime()) then
				ADRT_Alert(self, unit_type);
			end
		end

	end

	update2 = update2 + elapsed

	if update2 >= 1  then

		update2 = 0;

		for destGUID, list in pairs(ADRT_List) do
			local count = 0;

			if list then
				for idx, info in pairs(list) do
					if info[2]  <= GetTime() then
						list[idx] = nil

					else
						count = count + 1;
					end
				end

				if count == 0 then
					ADRT_List[destGUID] = nil;
				end
			end
		end
	end

end

function ADRT_OnLoad(self)

	self.button = {};
	self.time = {};
	
	for unit_type = 1, #ADRT_UnitList do
	
		self.time[unit_type] = 0xFFFFFFFF;
		self.button[unit_type] = {};

	end

	--self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	
	self:RegisterEvent("PLAYER_TARGET_CHANGED");
	self:RegisterEvent("PLAYER_FOCUS_CHANGED");
	self:RegisterEvent("PLAYER_ENTERING_WORLD");

	self:SetScript("OnEvent", ADRT_OnEvent);
--	self:SetScript("OnUpdate",ADRT_OnUpdate);
end

local unusedOverlayGlows = {};
local numOverlays = 0;

function  ADRT_GetOverlayGlow()
	local overlay = tremove(unusedOverlayGlows);
	if ( not overlay ) then
		numOverlays = numOverlays + 1;
		overlay = CreateFrame("Frame", "ADRT_ActionButtonOverlay"..numOverlays, UIParent, "ADRT_ActionBarButtonSpellActivationAlert");
	end
	return overlay;
end


function ADRT_ShowOverlayGlow(self)
	if ( self.overlay ) then
		if ( self.overlay.animOut:IsPlaying() ) then
			self.overlay.animOut:Stop();
			self.overlay.animIn:Play();
		end
	else
		self.overlay = ADRT_GetOverlayGlow();
		local frameWidth, frameHeight = self:GetSize();
		self.overlay:SetParent(self);
		self.overlay:ClearAllPoints();
		--Make the height/width available before the next frame:
		self.overlay:SetSize(frameWidth * 1.5, frameHeight * 1.5);
		self.overlay:SetPoint("TOPLEFT", self, "TOPLEFT", -frameWidth * 0.3, frameHeight * 0.3);
		self.overlay:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", frameWidth * 0.3, -frameHeight * 0.3);
		self.overlay.animIn:Play();
	end
end

function ADRT_HideOverlayGlow(self)
	if ( self.overlay ) then
		if ( self.overlay.animIn:IsPlaying() ) then
			self.overlay.animIn:Stop();
		end
		if ( self:IsVisible() ) then
			self.overlay.animOut:Play();
		else
			ADRT_OverlayGlowAnimOutFinished(self.overlay.animOut);	--We aren't shown anyway, so we'll instantly hide it.
		end
	end
end


function ADRT_OverlayGlowAnimOutFinished(animGroup)
	local overlay = animGroup:GetParent();
	local actionButton = overlay:GetParent();
	overlay:Hide();
	tinsert(unusedOverlayGlows, overlay);
	actionButton.overlay = nil;
end

function ADRT_OverlayGlowOnUpdate(self, elapsed)
	AnimateTexCoords(self.ants, 256, 256, 48, 48, 22, elapsed, 0.01);
end




ADRT_mainframe = CreateFrame("Frame", "ADRT", UIParent);
ADRT_OnLoad(ADRT_mainframe);

