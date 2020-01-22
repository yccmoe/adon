local addonName, addon = ...
addon.U = addon.U or { }
local TCL, L, D, U, E = addon.TomCatsLibs, addon.TomCatsLibs.Locales, addon.TomCatsLibs.Data, addon.U, addon.TomCatsLibs.Events
local S
local initSavedVariables = { }
function initSavedVariables:ADDON_LOADED(_, name)
    if name == addonName then
        E.UnregisterEvent("ADDON_LOADED", initSavedVariables)
        initSavedVariables = nil
        S = addon.savedVariables
    end
end
E.RegisterEvent("ADDON_LOADED", initSavedVariables)
function U.IsCompatibleWith(projectID)
    return WOW_PROJECT_ID == projectID
end
function U.IsClassic()
    return WOW_PROJECT_ID == WOW_PROJECT_CLASSIC
end
function U.IsRetail()
    return WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
end
--todo: Internationalize
addon.supportedMaps = {
    [14] = {
        name = "TomCats-ArathiHighlandsRares",
        title = "TomCat's Tours: Rares of Arathi Highlands",
        zone = "Arathi Highlands",
        iconTexture = "Interface\\AddOns\\TomCats\\images\\stromgarde-icon",
        backgroundColor = {118/255,18/255,20/255,0.80 }
    },
    [62] = {
        name = "TomCats-DarkshoreRares",
        title = "TomCat's Tours: Rares of Darkshore",
        zone = "Darkshore",
        iconTexture = "Interface\\AddOns\\TomCats\\images\\darnassus-icon",
        backgroundColor = {68/255,34/255,68/255,0.80 }
    },
    [1355] = {
        name = "TomCats-Nazjatar",
        title = "TomCat's Tours: Nazjatar",
        zone = "Nazjatar",
        iconTexture = "Interface\\AddOns\\TomCats\\images\\nazjatar-icon",
        backgroundColor = { 0.0,0.0,0.0,1.0 }
    },
    [1462] = {
        name = "TomCats-Mechagon",
        title = "TomCat's Tours: Mechagon",
        zone = "Mechagon",
        iconTexture = "Interface\\AddOns\\TomCats\\images\\mechagon-icon",
        backgroundColor = { 0.0,0.0,0.0,1.0 },
    },
    [1527] = {
        name = "TomCats-Nzoth",
        title = "TomCat's Tours: Uldum",
        zone = "Uldum",
        iconTexture = "Interface\\AddOns\\TomCats\\images\\00018",
        backgroundColor = { 0.0,0.0,0.0,1.0 },
    },
    [1530] = {
        name = "TomCats-Nzoth",
        title = "TomCat's Tours: Vale of Eternal Blossoms",
        zone = "Vale of Eternal Blossoms",
        iconTexture = "Interface\\AddOns\\TomCats\\images\\00018",
        backgroundColor = { 0.0,0.0,0.0,1.0 },
    },
}
-- Begin interim restart checking code
local function split(inputstr)
    local t={}
    for str in string.gmatch(inputstr, "([^.]+)") do
        table.insert(t, str)
    end
    return t
end
local function convertVersionToNumber(version)
    local parts = split(version)
    return tonumber(parts[1]) * 1000000 + tonumber(parts[2]) * 1000 + tonumber(parts[3])
end
local addonTOCVersion = convertVersionToNumber(GetAddOnMetadata("TomCats", "version"))
local newFilesSinceVersion = convertVersionToNumber("1.4.0")
if (newFilesSinceVersion > addonTOCVersion) then
    DEFAULT_CHAT_FRAME:AddMessage("|cffff0000Warning: TomCat's Tours requires that you restart WoW in order for the recent update to function properly|r")
end
-- End interim restart checking code
TCL.Charms.scope = "account"
local slashCommandHandlers = { }
local components = { }
local function handleSlashCommand(msg)
    if (msg) then
        if (msg == "") then
            InterfaceOptionsFrame_OpenToCategory(TomCats_Config)
            --todo: Remove the redundant call if Blizzard ever fixes this
            InterfaceOptionsFrame_OpenToCategory(TomCats_Config)
        else
            local func = slashCommandHandlers[string.upper(msg)]
            if (not func) then
                InterfaceOptionsFrame_OpenToCategory(TomCats_Config_Slash_Commands)
                --todo: Remove the redundant call if Blizzard ever fixes this
                InterfaceOptionsFrame_OpenToCategory(TomCats_Config_Slash_Commands)
            else
                func()
            end
        end
    end
end
SLASH_TOMCATS1 = "/TOMCATS"
SlashCmdList["TOMCATS"] = handleSlashCommand
local slashCommandsHtmlHead = "<html>\n<body>\n<h1>Slash Commands</h1>\n<br />\n"
local slashCommandHtmlTemplate = "<h3>%s:</h3>\n<p>/TOMCATS %s</p>\n<br />\n"
local slashCommandsHtmlFoot = "</body>\n</html>"
TomCats = {}
TomCats.version = "1.4.5"
local function refreshInterfaceControlPanels()
    local slashCommandsHtml = slashCommandsHtmlHead
    local infoText = "Installed Components:\n|cffffffff"
    slashCommandsHtml = slashCommandsHtml .. format(slashCommandHtmlTemplate, "Open the TomCat's Tours Control Panel", "")
    for i, component in ipairs(components) do
        if (component.slashCommands) then
            for _, slashCommand in ipairs(component.slashCommands) do
                slashCommandsHtml = slashCommandsHtml .. format(slashCommandHtmlTemplate, slashCommand.desc, string.upper(slashCommand.command))
            end
        end
        infoText = infoText .. "   " .. component.name .. " (v" .. component.version .. ")"
        if (i ~= #components) then
            infoText = infoText .. "\n"
        end
    end
    infoText = infoText .. "|r"
    TomCats_Config.InstalledComponents:SetText(infoText)
    slashCommandsHtml = slashCommandsHtml .. slashCommandsHtmlFoot
    TomCats_Config_Slash_Commands.html:SetText(slashCommandsHtml)
end
function TomCats:Register(componentInfo)
    DEBUGADDON = addon;
    if (componentInfo) then
        if (componentInfo.slashCommands) then
            for _, slashCommand in ipairs(componentInfo.slashCommands) do
                slashCommandHandlers[string.upper(slashCommand.command)] = slashCommand.func
            end
        end
        if (componentInfo.raresLogHandlers) then
            for k, v in pairs(componentInfo.raresLogHandlers) do
                if addon.supportedMaps[k] then
                    addon.supportedMaps[k].handlers = v
                end
            end
        end
        table.insert(components, componentInfo)
        refreshInterfaceControlPanels()
    end
end
local linkText = "Visions of N'zoth Rares by TomCat's Tours"
local chatStep = 1
local function playChat()
    PlaySound(SOUNDKIT.TELL_MESSAGE)
    local message
    local link = "|cffff80ff[|cffffff00" .. "TomCat from TomCat's Tours" .. "|cffff80ff]"
    if (chatStep == 1) then
        addon.savedVariables.account.notifications["NZOTHLAUNCH"] = true
        addon.charm.MinimapLoopPulseAnim:Stop()
        addon.charm:Hide()
        message = "|cffff80ffHi. I hope I am not intruding...I just wanted to say thanks for using my TomCat's Tours addons!|r"
    end
    if (chatStep == 2) then
        message = "|cffff80ffI thought you might be interested in trying my new addon: " .. linkText
    end
    if (chatStep == 3) then
        message = "|cffff80ffPlease check it out, and thanks for the support!"
    end
    DEFAULT_CHAT_FRAME:AddMessage(format(_G["CHAT_WHISPER_GET"] .. message, link))
    chatStep = chatStep + 1
    if (chatStep < 4) then
        C_Timer.After(2 + chatStep, playChat)
    end
end
local function ChangeMap(self)
    WorldMapFrame:SetMapID(self.mapID)
    if WorldMapFrame:IsMaximized() then
        WorldMapFrame.BorderFrame.MaximizeMinimizeFrame:Minimize()
    end
    if not TomCatsRareMapFrame:IsShown() then
        TomCatsRarePanelToggle:OnClick()
    elseif not TomCatsRareMapFrame.RaresFrame:IsShown() then
        TomCatsRareMapFrame.DetailsFrame:Hide()
        TomCatsRareMapFrame.RaresFrame:Show()
    end
end
VignettePinMixin.OnAcquired_Orig = VignettePinMixin.OnAcquired
function VignettePinMixin:OnAcquired(vignetteGUID, vignetteInfo)
    self:OnAcquired_Orig(vignetteGUID, vignetteInfo)
    if vignetteInfo and vignetteInfo.atlasName and (vignetteInfo.atlasName == "VignetteKill" or vignetteInfo.atlasName == "Capacitance-General-WorkOrderCheckmark" or vignetteInfo.atlasName == "VignetteEventElite") then
        self.Texture:SetAtlas(vignetteInfo.atlasName, false)
        self.HighlightTexture:SetAtlas(vignetteInfo.atlasName, false)
        local x, y = self.Texture:GetSize()
        self.Texture:SetSize(x * 0.8, y * 0.8)
        self.HighlightTexture:SetSize(x * 0.8, y * 0.8)
    end
end
local function ADDON_LOADED(_, _, arg1)
    if (arg1 == addonName) then
        E.UnregisterEvent("ADDON_LOADED", ADDON_LOADED)
        S.account.preferences = S.account.preferences or { }
        S.account.preferences.TomCatsMinimapButton = { position = 3 }
        S.account.notifications = S.account.notifications or { }
        if ((not addon.savedVariables.account.notifications["NZOTHLAUNCH"])) then
            --todo: Disable for Classic releases
            local _, _, _, _, reason = GetAddOnInfo("TomCats-Nzoth")
            if (reason and reason == "MISSING") then
                addon.charm = TCL.Charms.Create({
                    name = "TomCatsMinimapButton",
                    iconTexture = "Interface\\AddOns\\TomCats\\images\\tomcat-icon",
                    backgroundColor = { 0.0,0.0,0.0,1.0 },
                    handler_onclick = playChat
                })
                addon.charm.tooltip = {
                    Show = function(this)
                        GameTooltip:ClearLines()
                        GameTooltip:SetOwner(this, "ANCHOR_LEFT")
                        GameTooltip:SetText("TomCat would like to chat!", 1, 1, 1)
                        GameTooltip:AddLine("TomCat's Tours", nil, nil, nil, true)
                        GameTooltip:Show()
                    end,
                    Hide = function()
                        GameTooltip:Hide()
                    end
                }
                addon.charm.MinimapLoopPulseAnim:Play()
                addon.charm:SetFrameLevel(TOMCATS_LIBS_ICON_LASTFRAMELEVEL + 100)
            else
                addon.savedVariables.account.notifications["NZOTHLAUNCH"] = true
            end
        end
        S.account.tutorials = S.account.tutorials or { }
        S.character.cvars = S.character.cvars or { }
        TomCats_Config.name = "TomCat's Tours"
        InterfaceOptions_AddCategory(TomCats_Config)
        TomCats_Config_Slash_Commands.name = "Slash Commands"
        TomCats_Config_Slash_Commands.parent = "TomCat's Tours"
        InterfaceOptions_AddCategory(TomCats_Config_Slash_Commands)
        refreshInterfaceControlPanels()
        local offset = -36
        local buttonSpacing = -34
        local count = 0
        local mapIDs = { 14, 62, 1355, 1462 }
        for i = 1, #mapIDs do
            local k = mapIDs[i]
            local v = addon.supportedMaps[k]
            local enabled = GetAddOnEnableState(UnitName("player"),v.name)
            if (enabled ~= 0) then
                local rareMapShortcut = TCL.Charms.Create({
                    name = "TomCatsWorldmapRaresButton" .. k,
                    iconTexture = v.iconTexture,
                    backgroundColor = v.backgroundColor,
                    handler_onclick = ChangeMap,
                    ignoreSlideBar = true,
                    ignoreSexyMap = true
                })
                rareMapShortcut:SetParent(WorldMapFrame)
                rareMapShortcut:SetFrameStrata("MEDIUM")
                rareMapShortcut:SetFrameLevel(9999)
                rareMapShortcut:ClearAllPoints()
                rareMapShortcut:SetPoint("TOPRIGHT", WorldMapFrame:GetCanvasContainer(), "TOPRIGHT", -4, offset + buttonSpacing * count)
                rareMapShortcut.shadow:Show()
                rareMapShortcut.tooltip = {
                    Show = function(this)
                        GameTooltip:ClearLines()
                        GameTooltip:SetOwner(this, "ANCHOR_LEFT")
                        GameTooltip:SetText(v.zone, 1, 1, 1)
                        GameTooltip:Show()
                    end,
                    Hide = function()
                        GameTooltip:Hide()
                    end
                }
                --rareMapShortcut:RegisterForDrag()
                rareMapShortcut.mapID = k
                count = count + 1
            else
                addon.supportedMaps[k] = nil
            end
        end
    end
end
E.RegisterEvent("ADDON_LOADED", ADDON_LOADED)
 -- FrameXML.toc:8
 -- FrameXML.toc:11
 -- FrameXML.toc:56
 -- SharedUIPanelTemplates.xml:3
 -- FrameXML.toc:152
