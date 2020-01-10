--Spell Alert
local alert=CreateFrame("Frame")
alert:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
alert:SetScript("OnEvent", function(...)
local _,combatEvent,hideCaster,sourceGUID,sourceName,sourceFlags,sourceRaidFlags,destGUID,destName,destFlags, destRaidFlags,spellID,spellName,_,param1,_,_,param4 = CombatLogGetCurrentEventInfo()

if sourceGUID == UnitGUID("player") and combatEvent=="SPELL_INTERRUPT" then
    SendChatMessage(GetSpellLink(param1).." 짤", "say") -- 차단 Interrupt
elseif sourceGUID == UnitGUID("player") and combatEvent=="SPELL_DISPEL" and (bit.band(destFlags,COMBATLOG_OBJECT_REACTION_FRIENDLY)==COMBATLOG_OBJECT_REACTION_FRIENDLY) then
    SendChatMessage(destName.."의 "..GetSpellLink(param1).." 해제", "say") -- 해제(아군) Dispel(friendly)
end 
end)