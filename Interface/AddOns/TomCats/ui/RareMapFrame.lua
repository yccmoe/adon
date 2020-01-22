local _, addon = ...
local TCL = addon.TomCatsLibs
local L = addon.TomCatsLibs.Locales
local U = addon.U
if U.IsRetail() then
local supportedMaps, RaresLogFrame_ShowRareDetails
local DISPLAY_STATE_CLOSED = 1
local DISPLAY_STATE_OPEN_MINIMIZED_NO_LOG = 2
local DISPLAY_STATE_OPEN_MINIMIZED_WITH_LOG = 3
local DISPLAY_STATE_OPEN_MAXIMIZED = 4
local DISPLAY_STATE_OPEN_MINIMIZED_WITH_RARE_LOG = 5
local lastDisplayStates = { DISPLAY_STATE_CLOSED, DISPLAY_STATE_CLOSED }
local function setLastDisplayState(displayState)
    lastDisplayStates[1] = lastDisplayStates[2]
    lastDisplayStates[2] = displayState
end
local CREATURE_STATUS = {
    COMPLETE = 0,
    HIDDEN = 1,
    UNAVAILABLE = 2,
    LOOT_ELIGIBLE = 3,
    BONUS_ROLL_ELIGIBLE = 4,
    WORLD_QUEST_AVAILABLE = 5
}
local function SidePanelToggle_Refresh()
    if TomCatsRareMapFrame:IsShown() or not QuestMapFrame:IsShown() then
        WorldMapFrame.SidePanelToggle.OpenButton:Show()
        WorldMapFrame.SidePanelToggle.CloseButton:Hide()
    else
        WorldMapFrame.SidePanelToggle.OpenButton:Hide()
        WorldMapFrame.SidePanelToggle.CloseButton:Show()
    end
end
TomCatsRareLogMixin = {}
function TomCatsRareLogMixin:InitLayoutIndexManager()
    self.layoutIndexManager = CreateLayoutIndexManager()
    self.layoutIndexManager:AddManagedLayoutIndex("RaresLog", QUEST_LOG_WAR_CAMPAIGN_LAYOUT_INDEX + 1)
    self.RaresFrame.Contents.Separator:Show()
    self.RaresFrame.Contents.StoryHeader:Show()
    self.RaresFrame.Contents.Notice.Text:SetText(
                "New features being developed constantly. Be sure to update your addons regularly!|r\n\n|cff00ff00Thank you for using TomCat's Tours\n|cffffffffVisit https://twitch.tv/TomCat|r"
    --            "New feature being developed:\n|cffffffffRare Spawn Share (34% of votes)|r\n\n|cff00ff00Round 3 voting has begun!|r\nVote each day on what's next:\n|cffffffffhttps://twitch.tv/TomCat|r"
    )
end
local raresLog
local function CheckForUpdatedRaresLog()
    if raresLog and raresLog.updated then
        TomCatsRareMapFrame:RefreshRaresLog()
        raresLog.updated = nil
    end
end
C_Timer.NewTicker(0.2, CheckForUpdatedRaresLog)
local RareTextColorLookup = {
    [CREATURE_STATUS.COMPLETE] = { QuestDifficultyColors["standard"], QuestDifficultyHighlightColors["standard"] },
    [CREATURE_STATUS.LOOT_ELIGIBLE] = { QuestDifficultyHighlightColors["header"], QuestDifficultyHighlightColors["difficult"] },
    [CREATURE_STATUS.UNAVAILABLE] = { QuestDifficultyColors["impossible"], QuestDifficultyHighlightColors["impossible"] },
}
local RareButtonLookup = {
    [CREATURE_STATUS.COMPLETE] = "Complete",
    [CREATURE_STATUS.LOOT_ELIGIBLE] = "Incomplete",
    [CREATURE_STATUS.UNAVAILABLE] = "Unavailable",
}
function TomCatsRareLogTitleButton_OnClick(self)
    PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
    TomCatsRareMapFrame.RaresFrame:Hide()
    RaresLogFrame_ShowRareDetails(self.creature)
end
function TomCatsRareLogTitleButton_OnMouseDown(self)
    local anchor, _, _, x, y = self.Text:GetPoint()
    self.Text:SetPoint(anchor, x + 1, y - 1)
end
function TomCatsRareLogTitleButton_OnMouseUp(self)
    local anchor, _, _, x, y = self.Text:GetPoint()
    self.Text:SetPoint(anchor, x - 1, y + 1)
end
local LOOT_NOUN_COLOR = CreateColor(1.0, 0.82, 0.0, 1.0)
function TomCatsRareLogTitleButton_OnEnter(self)
    local textColor = RareTextColorLookup[self.creature["Status"]][2]
    self.Text:SetTextColor( textColor.r, textColor.g, textColor.b )
    local creature = self.creature
    EmbeddedItemTooltip:ClearAllPoints()
    EmbeddedItemTooltip:SetPoint("TOPLEFT", self, "TOPRIGHT", 34, 0)
    EmbeddedItemTooltip:SetOwner(self, "ANCHOR_PRESERVE")
    local color = WORLD_QUEST_QUALITY_COLORS[1]
    EmbeddedItemTooltip:SetText(creature["Name"], color.r, color.g, color.b)
    local tooltipWidth = 20 + max(231, EmbeddedItemTooltipTextLeft1:GetStringWidth())
    if ( tooltipWidth > UIParent:GetRight() - QuestMapFrame:GetParent():GetRight() ) then
        EmbeddedItemTooltip:ClearAllPoints()
        EmbeddedItemTooltip:SetPoint("TOPRIGHT", self, "TOPLEFT", -34, 0)
        EmbeddedItemTooltip:SetOwner(self, "ANCHOR_PRESERVE")
        EmbeddedItemTooltip:SetText(creature["Name"], color.r, color.g, color.b)
    end
    local footerText = ("|cff00ff00<%s>|r"):format(L["Click to view Creature Details"])
    if (creature["Loot"]) then
        local itemID
        if type(creature["Loot"]) == "table" then
            if creature["Loot"].items then
                itemID = creature["Loot"].items[1]
                if #(creature["Loot"].items) > 1 then
                    footerText = ("+ %d more items\n\n" .. footerText):format(#(creature["Loot"].items) - 1)
                end
            end
        else
            itemID = creature["Loot"]
        end
        if itemID then
            GameTooltip_AddBlankLinesToTooltip(EmbeddedItemTooltip, 1)
            GameTooltip_AddColoredLine(EmbeddedItemTooltip, LOOT_NOUN, LOOT_NOUN_COLOR, true)
            EmbeddedItemTooltip_SetItemByID(EmbeddedItemTooltip.ItemTooltip, itemID)
        end
    end
    EmbeddedItemTooltip.BottomFontString:SetText(footerText)
    EmbeddedItemTooltip.BottomFontString:SetShown(true)
    EmbeddedItemTooltip:Show()
end
function TomCatsRareLogTitleButton_OnLeave(self)
    local textColor = RareTextColorLookup[self.creature["Status"]][1]
    self.Text:SetTextColor( textColor.r, textColor.g, textColor.b )
    EmbeddedItemTooltip:Hide()
end
function TomCatsRareRewardItem_OnEnter(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:SetItemByID(self:GetID())
    GameTooltip:Show()
end
function TomCatsRareRewardItem_OnClick(self)
    if ( IsModifiedClick() and self.objectType == "item") then
        local _, itemLink = GetItemInfo(self:GetID())
        HandleModifiedItemClick(itemLink)
    end
end
function TomCatsRareLogMixin:RefreshRaresLog()
    self.titleFramePool:ReleaseAll()
    self.poiFramePool:ReleaseAll()
    local lastButton
    if (raresLog) then
        if not raresLog.isSorted then
            raresLog.isSorted = true
            raresLog.creatures_sorted = { }
            local rareNames = { }
            local lookupByName = { }
            for _, v in pairs(raresLog.creatures) do
                local name = v["Name"]
                if not name then
                    raresLog.isSorted = false
                else
                    table.insert(rareNames,name)
                    lookupByName[name] = v
                end
            end
            table.sort(rareNames)
            for _, v in ipairs(rareNames) do
                table.insert(raresLog.creatures_sorted,lookupByName[v])
            end
        end
        for _, creature in pairs(raresLog.creatures_sorted) do
            if creature["Status"] ~= CREATURE_STATUS.HIDDEN then
                local button = self.titleFramePool:Acquire()
                button.creature = creature
                button.Text:SetText(creature["Name"])
                local textColor = RareTextColorLookup[creature["Status"]][1]
                button.Text:SetTextColor(textColor.r, textColor.g, textColor.b)
                button:ClearAllPoints()
                if (lastButton) then
                    button:SetPoint("TOPLEFT",lastButton,"BOTTOMLEFT",0,-4)
                else
                    button:SetPoint("TOPLEFT",self.RaresFrame.Contents.StoryHeader, "BOTTOMLEFT", 29, -8)
                end
                lastButton = button
                button:Show()
                local poiButton = self.poiFramePool:Acquire()
                poiButton:ClearAllPoints()
                poiButton:SetPoint("LEFT", button, -21, 2)
                poiButton.parent = button
                poiButton:SetFrameLevel(button:GetFrameLevel() + 1)
                poiButton:Show()
                poiButton.creature = creature
                for key, value in pairs(RareButtonLookup) do
                    if (key == creature["Status"]) then
                        poiButton[value]:Show()
                    else
                        poiButton[value]:Hide()
                    end
                end
            end
        end
    end
end
function TomCatsRareLogMixin:Refresh()
    self.RaresFrame.Contents.LogHeader.Text:SetText(L["Rare Creatures Log"])
    self.RaresFrame.Contents.LogHeader:Show()
    self.RaresFrame.Contents.StoryHeader.Text:SetText(C_Map.GetMapInfo(WorldMapFrame:GetMapID())["name"])
    self.layoutIndexManager:Reset()
    self:RefreshRaresLog()
    self.RaresFrame.Contents:Layout()
end
function TomCatsRareLogMixin:SetShown()
    if not self:IsShown() then
        self:Show()
        self.DetailsFrame:Hide()
        self.RaresFrame:Show()
        local handlers = supportedMaps[WorldMapFrame:GetMapID()].handlers
        if handlers and handlers.raresLog then
            raresLog = handlers.raresLog()
            raresLog.locationIndex = raresLog.locationIndex or 1
        else
            raresLog = nil
        end
    end
end
function TomCatsRareLogMixin:UpdateDisplayState()
    if not WorldMapFrame:IsShown() then
        setLastDisplayState(DISPLAY_STATE_CLOSED)
    elseif QuestMapFrame:IsShown() or QuestMapFrame.DetailsFrame:IsShown() then
        if QuestMapFrame.DetailsFrame:IsShown() then
            self:Hide()
            QuestScrollFrame:Hide()
        else
            if supportedMaps[WorldMapFrame:GetMapID()] and addon.savedVariables.character.preferQuestLog == nil then
                self:SetShown(true)
                QuestScrollFrame:Hide()
                self:Refresh()
                setLastDisplayState(DISPLAY_STATE_OPEN_MINIMIZED_WITH_RARE_LOG)
                return
            end
            QuestScrollFrame:Show()
        end
        setLastDisplayState(DISPLAY_STATE_OPEN_MINIMIZED_WITH_LOG)
    else
        if WorldMapFrame:IsMaximized() then
            setLastDisplayState(DISPLAY_STATE_OPEN_MAXIMIZED)
        else
            setLastDisplayState(DISPLAY_STATE_OPEN_MINIMIZED_NO_LOG)
        end
    end
    self:Hide()
end
function TomCatsRareMapFrame_OnLoad(self)
    self:InitLayoutIndexManager()
    self.titleFramePool = CreateFramePool("BUTTON", TomCatsRareMapFrame.RaresFrame.Contents, "TomCatsRareLogTitleTemplate")
    self.poiFramePool = CreateFramePool("FRAME", TomCatsRareMapFrame.RaresFrame.Contents, "TomCatsRarePOITemplate")
end
function TomCatsRareMapFrame_OnEvent() end
function TomCatsRareMapFrame_OnHide() end
local lastMapID = 0
local helpPlate_override
local function UpdateAll()
    if WorldMapFrame:GetMapID() ~= lastMapID then
        lastMapID = WorldMapFrame:GetMapID()
        if TomCatsRareMapFrame:IsShown() then
            local supportedMap = supportedMaps[WorldMapFrame:GetMapID()]
            if supportedMap then
                local handlers = supportedMaps[WorldMapFrame:GetMapID()].handlers
                if handlers and handlers.raresLog then
                    raresLog = handlers.raresLog()
                else
                    raresLog = nil
                end
                TomCatsRareMapFrame:Refresh()
            end
        end
    end
    TomCatsRareMapFrame:UpdateDisplayState()
    TomCatsRarePanelToggle:Refresh()
    SidePanelToggle_Refresh()
    if HelpPlate_IsShowing(helpPlate_override) and (WorldMapFrame:IsMaximized() or not WorldMapFrame:IsShown()) then
        HelpPlate_Hide()
    end
end
local function RevertToQuestFrameShown(save)
    WorldMapFrame:SetDisplayState(DISPLAY_STATE_OPEN_MINIMIZED_WITH_LOG)
    QuestScrollFrame:Show()
    TomCatsRareMapFrame:Hide()
    TomCatsRarePanelToggle:Refresh()
    SidePanelToggle_Refresh()
    setLastDisplayState(DISPLAY_STATE_OPEN_MINIMIZED_WITH_LOG)
    if save then
        SetCVar("questLogOpen", "1")
    end
end
local function Hook_WorldMapFrame_SidePanelToggle()
    if supportedMaps[WorldMapFrame:GetMapID()] then
        addon.savedVariables.character.preferQuestLog = true
    end
    if (lastDisplayStates[1] == DISPLAY_STATE_OPEN_MINIMIZED_WITH_RARE_LOG and lastDisplayStates[2] == DISPLAY_STATE_OPEN_MINIMIZED_NO_LOG) or
            (lastDisplayStates[2] == DISPLAY_STATE_OPEN_MINIMIZED_WITH_RARE_LOG and lastDisplayStates[1] == DISPLAY_STATE_OPEN_MINIMIZED_NO_LOG) then
        RevertToQuestFrameShown(true)
    end
end
local function Hook_ToggleQuestLog()
    if lastDisplayStates[2] == DISPLAY_STATE_OPEN_MINIMIZED_WITH_RARE_LOG then
        RevertToQuestFrameShown()
    end
end
TomCatsWorldMapRareSidePanelToggleMixin = { }
function TomCatsWorldMapRareSidePanelToggleMixin:OnClick()
    addon.savedVariables.character.preferQuestLog = nil
    if (self.OpenButton:IsShown()) then
        WorldMapFrame:SetDisplayState(DISPLAY_STATE_OPEN_MINIMIZED_WITH_LOG)
        QuestScrollFrame:Hide()
        TomCatsRareMapFrame:SetShown(true)
        TomCatsRareMapFrame:Refresh()
        self.OpenButton:Hide()
        self.CloseButton:Show()
        SetCVar("questLogOpen", "1")
    else
        WorldMapFrame:SetDisplayState(DISPLAY_STATE_OPEN_MINIMIZED_NO_LOG)
        TomCatsRareMapFrame:Hide()
        self.OpenButton:Show()
        self.CloseButton:Hide()
        SetCVar("questLogOpen", "0")
    end
    WorldMapFrame.SidePanelToggle.OpenButton:Show()
    WorldMapFrame.SidePanelToggle.CloseButton:Hide()
end
function TomCatsWorldMapRareSidePanelToggleMixin:Refresh()
    if WorldMapFrame.SidePanelToggle:IsShown() and supportedMaps[WorldMapFrame:GetMapID()] then
        self:Show()
        if TomCatsRareMapFrame:IsShown() then
            self.OpenButton:Hide()
            self.CloseButton:Show()
        else
            self.OpenButton:Show()
            self.CloseButton:Hide()
        end
    else
        self:Hide()
    end
end
local function TryShowTutorial()
    if not addon.savedVariables.account.tutorials["Rares Log Toggle"] then
        local frame = CreateFrame("FRAME",nil,TomCatsRarePanelToggle,"TomCatsRareMapFrameTutorialBoxTemplate")
        frame:SetFrameStrata("DIALOG")
        frame:SetFrameLevel(100)
        frame.Text:SetText(L["TUTORIAL_RaresLogToggle"])
        frame.Text:SetSpacing(4)
        SetClampedTextureRotation(frame.Arrow.Arrow, 270)
        SetClampedTextureRotation(frame.Arrow.Glow, 270)
        frame.Arrow:ClearAllPoints()
        frame.Arrow:SetPoint("BOTTOMLEFT", frame, "RIGHT", -4, 4)
        frame.Arrow.Glow:ClearAllPoints()
        frame.Arrow.Glow:SetPoint("CENTER", frame.Arrow.Arrow, "CENTER", 2, 0)
        frame:ClearAllPoints()
        frame:SetPoint("RIGHT", TomCatsRarePanelToggle, "BOTTOMLEFT", -18, 0)
        local newHeight = frame.Text:GetHeight() + 48
        if 100 >= newHeight then newHeight = 100 end
        frame:SetHeight(newHeight)
        frame.CloseButton:SetScript("OnClick", function()
            addon.savedVariables.account.tutorials["Rares Log Toggle"] = true
            frame:Hide()
        end)
        frame:Show()
    end
end
local function AddOverlayFrame(self, templateName, templateType, anchorPoint, relativeFrame, relativePoint, offsetX, offsetY)
    local frame = CreateFrame(templateType, nil, self, templateName)
    if anchorPoint then
        frame:SetPoint(anchorPoint, relativeFrame, relativePoint, offsetX, offsetY)
    end
    frame.relativeFrame = relativeFrame or self
    return frame
end
local function ADDON_LOADED(_, _, arg1)
    if (arg1 == addon.name) then
        TCL.Events.UnregisterEvent("ADDON_LOADED", ADDON_LOADED)
        CreateFrame("FRAME", "TomCatsRareMapFrame", WorldMapFrame, "TomCatsRareMapFrameTemplate")
        CreateFrame("FRAME", "TomCatsRareInfoRewardsFrame", nil, "TomCatsRareInfoRewardsFrameTemplate")
            supportedMaps = addon.supportedMaps
            TomCatsRarePanelToggle = AddOverlayFrame(WorldMapFrame,"TomCatsWorldMapRareSidePanelToggleTemplate", "BUTTON", "BOTTOMRIGHT", WorldMapFrame:GetCanvasContainer(), "BOTTOMRIGHT", -2, 36)
            tinsert(WorldMapFrame.overlayFrames, TomCatsRarePanelToggle)
            TryShowTutorial()
            TomCatsRareMapFrame:SetParent(WorldMapFrame)
            TomCatsRareMapFrame:SetFrameStrata("HIGH")
            TomCatsRareMapFrame:SetFrameLevel(10)
            TomCatsRareMapFrame:ClearAllPoints()
            TomCatsRareMapFrame:SetPoint("TOPRIGHT", -6, -20)
            hooksecurefunc(WorldMapFrame, "SetMapID", UpdateAll)
            hooksecurefunc(WorldMapFrame.SidePanelToggle, "OnClick", Hook_WorldMapFrame_SidePanelToggle)
            hooksecurefunc(WorldMapFrame, "SetDisplayState", UpdateAll)
            hooksecurefunc("QuestMapFrame_ShowQuestDetails", UpdateAll)
            hooksecurefunc("ToggleQuestLog", Hook_ToggleQuestLog)
            hooksecurefunc("HideUIPanel", UpdateAll)
            if WorldMapFrame.SidePanelToggle.OpenButton.isSkinned then
                WorldMapFrame.SidePanelToggle:Hide()
                WorldMapFrame.SidePanelToggle = WorldMapFrame:AddOverlayFrame("WorldMapSidePanelToggleTemplate", "BUTTON", "BOTTOMRIGHT", WorldMapFrame:GetCanvasContainer(), "BOTTOMRIGHT", -2, 1)
                hooksecurefunc(WorldMapFrame.SidePanelToggle, "OnClick", Hook_WorldMapFrame_SidePanelToggle)
            else
                local hooked
                hooksecurefunc(WorldMapFrame.SidePanelToggle.OpenButton:GetNormalTexture(), "SetVertexColor", function()
                    if not hooked then
                        WorldMapFrame.SidePanelToggle:Hide()
                        WorldMapFrame.SidePanelToggle = WorldMapFrame:AddOverlayFrame("WorldMapSidePanelToggleTemplate", "BUTTON", "BOTTOMRIGHT", WorldMapFrame:GetCanvasContainer(), "BOTTOMRIGHT", -2, 1)
                        hooksecurefunc(WorldMapFrame.SidePanelToggle, "OnClick", Hook_WorldMapFrame_SidePanelToggle)
                    end
                    hooked = true
                end)
            end
    end
end
local lastWaypoint
function TomCatsRareLogEntryIcon_OnClick(self)
    if (TomTom) then
        local playerMapID = C_Map.GetBestMapForUnit("player")
        local pinMapID = WorldMapFrame:GetMapID()
        if (pinMapID == playerMapID) then
            if (lastWaypoint) then
                TomTom:RemoveWaypoint(lastWaypoint)
            end
            local location = self:GetParent().creature["Locations"][raresLog.locationIndex]
            if location then
                lastWaypoint = TomTom:AddWaypoint(WorldMapFrame:GetMapID(), location[1], location[2], {
                    title = self:GetParent().creature["Name"],
                    persistent = false,
                    minimap = true,
                    world = true
                })
            end
        end
    end
end
local REWARDS_SECTION_OFFSET = 5
local function RareInfo_ShowRewards(creature)
    local rewardsFrame = TomCatsRareInfoRewardsFrame
    local totalRewards = 1
    local rewardButtons = rewardsFrame.RewardButtons
    for i = totalRewards, #rewardButtons do
        rewardButtons[i]:ClearAllPoints()
        rewardButtons[i]:Hide()
    end
    local rewardsCount = 0
    local lastFrame = rewardsFrame.Header
    local totalHeight = rewardsFrame.Header:GetHeight()
    local buttonHeight = rewardsFrame.RewardButtons[1]:GetHeight()
    rewardsFrame.ArtifactXPFrame:ClearAllPoints()
    rewardsFrame.ArtifactXPFrame:Hide()
    rewardsFrame.ItemChooseText:ClearAllPoints()
    rewardsFrame.ItemChooseText:Hide()
    rewardsFrame.spellRewardPool:ReleaseAll()
    rewardsFrame.followerRewardPool:ReleaseAll()
    rewardsFrame.spellHeaderPool:ReleaseAll()
    rewardsFrame.PlayerTitleText:Hide()
    rewardsFrame.TitleFrame:Hide()
    rewardsFrame.XPFrame:Hide()
    rewardsFrame.MoneyFrame:Hide()
    local loot = creature["Loot"] or {
        items = { }
    }
    if type(loot) ~= "table" then
        loot = {
            items = { loot }
        }
    end
    local numQuestRewards = 0
    if loot.items then
        numQuestRewards = #(loot.items)
    end
    local index
    local baseIndex = 0
    local buttonIndex = 0
    for i = 1, numQuestRewards, 1 do
        buttonIndex = buttonIndex + 1
        index = i + baseIndex
        local questItem = QuestInfo_GetRewardButton(rewardsFrame, i)
        questItem.type = "reward"
        questItem.objectType = "item"
        questItem:SetID(loot.items[i])
        questItem:Show()
        local itemID = loot.items[i]
        local item = Item:CreateFromItemID(itemID)
        item:ContinueOnItemLoad(function()
            questItem.Name:SetText(item:GetItemName())
            questItem.Icon:SetTexture(item:GetItemIcon())
            SetItemButtonQuality(questItem, item:GetItemQuality(), itemID, false)
        end)
        if ( buttonIndex > 1 ) then
            if ( mod(buttonIndex,2) == 1 ) then
                questItem:SetPoint("TOPLEFT", rewardButtons[index - 2], "BOTTOMLEFT", 0, -2)
                lastFrame = questItem
                totalHeight = totalHeight + buttonHeight + 2
            else
                questItem:SetPoint("TOPLEFT", rewardButtons[index - 1], "TOPRIGHT", 1, 0)
            end
        else
            questItem:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", 0, -REWARDS_SECTION_OFFSET)
            lastFrame = questItem
            totalHeight = totalHeight + buttonHeight + REWARDS_SECTION_OFFSET
        end
        rewardsCount = rewardsCount + 1
        lastFrame = questItem
    end
    rewardsFrame.ItemReceiveText:Hide()
    rewardsFrame.MoneyFrame:Hide()
    rewardsFrame.XPFrame:Hide()
    rewardsFrame.SkillPointFrame:Hide()
    rewardsFrame.HonorFrame:Hide()
    rewardsFrame:Show()
    rewardsFrame:SetHeight(totalHeight)
    return rewardsFrame, lastFrame
end
function RaresLogFrame_ShowRareDetails(creature)
    local elements = {
        TomCatsQuestInfoTitleHeader, 5, -5,
        TomCatsQuestInfoQuestType, 0, -5,
    }
    local contentWidth = 244
    local parentFrame = TomCatsRareMapFrame.DetailsFrame.ScrollFrame.Contents
    TomCatsQuestInfoTitleHeader:SetText(creature["Name"])
    TomCatsQuestInfoTitleHeader:SetWidth(contentWidth)
    TomCatsQuestInfoQuestType:SetText("|T1121272:20:20:0:2:1024:512:588:620:306:338|t Rare Spawn")
    local description = creature["Description"]
    if description then
        table.insert(elements, TomCatsQuestInfoDescriptionHeader)
        table.insert(elements, 0)
        table.insert(elements, -10)
        table.insert(elements, TomCatsQuestInfoDescriptionText)
        table.insert(elements, 0)
        table.insert(elements, -5)
        TomCatsQuestInfoDescriptionText:SetText(description)
        TomCatsQuestInfoDescriptionText:SetWidth(244)
    else
        TomCatsQuestInfoDescriptionHeader:SetShown(false)
        TomCatsQuestInfoDescriptionText:SetShown(false)
    end
    local lastFrame
    for i = 1, #elements, 3 do
        shownFrame = elements[i]
        shownFrame:SetParent(parentFrame)
        shownFrame:ClearAllPoints()
        if lastFrame then
            shownFrame:SetPoint("TOPLEFT", lastFrame, "BOTTOMLEFT", elements[i+1], elements[i+2])
        else
            shownFrame:SetPoint("TOPLEFT", parentFrame, "TOPLEFT", elements[i+1], elements[i+2])
        end
        lastFrame = shownFrame
        shownFrame:SetShown(true)
    end
    local rewardsFrame = RareInfo_ShowRewards(creature)
    parentFrame = TomCatsRareMapFrame.DetailsFrame.RewardsFrame
    rewardsFrame:SetParent(parentFrame)
    rewardsFrame:ClearAllPoints()
    rewardsFrame:SetWidth(244)
    rewardsFrame:SetPoint("TOPLEFT", parentFrame, "TOPLEFT", 8, -42)
    rewardsFrame:SetShown(true)
    TomCatsRareMapFrame.DetailsFrame.ScrollFrame.ScrollBar:SetValue(0)
    local height
    if ( TomCatsRareInfoRewardsFrame:IsShown() ) then
        height = TomCatsRareInfoRewardsFrame:GetHeight() + 49
    else
        height = 59
    end
    height = min(height, 275)
    TomCatsRareMapFrame.DetailsFrame.RewardsFrame:SetHeight(height)
    TomCatsRareMapFrame.DetailsFrame.RewardsFrame.Background:SetTexCoord(0, 1, 0, height / 275)
    TomCatsRareMapFrame.DetailsFrame:Show()
end
function TomCatsRareMapFrame_ReturnFromRareDetails()
    TomCatsRareMapFrame.RaresFrame:Show()
    TomCatsRareMapFrame.DetailsFrame:Hide()
end
TCL.Events.RegisterEvent("ADDON_LOADED", ADDON_LOADED)
end
