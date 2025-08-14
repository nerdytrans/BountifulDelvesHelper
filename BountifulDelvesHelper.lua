BountifulDelvesHelper = BountifulDelvesHelper or {}

if not BountifulDelvesHelperDB then
    BountifulDelvesHelperDB = {
        highestDelveTier = nil,
        waypointSystem = "default"
    }
end

if not BountifulDelvesHelperIconDB then
    BountifulDelvesHelperIconDB = {
        minimapPos = 140,
        hide = false,
    }
end

SLASH_DELVES1 = "/delves"

areaIDs = {
    [2248] = "Isle Of Dorn",
    [2215] = "Hallowfall",
    [2214] = "Ringing Deeps",
    [2255] = "Azj-Kahet",
    [2346] = "Undermine"
}

waypoints = {
    --Isle of Dorn
    -- "Earthcrawl Mines"
    [7787] = { ["zone"] = 2248, ["x"] = 38.6, ["y"] = 74.0 },
    -- "Fungal Folly"
    [7779] = { ["zone"] = 2248, ["x"] = 52.03, ["y"] = 65.77 },
    -- "Kriegval's Rest"
    [7781] = { ["zone"] = 2248, ["x"] = 62.19, ["y"] = 42.70 },
    --The Ringing Deeps
    -- "The Waterworks"
    [7782] = { ["zone"] = 2214, ["x"] = 42.15, ["y"] = 48.71 },
    -- "The Dread Pit"
    [7788] = { ["zone"] = 2214, ["x"] = 70.20, ["y"] = 37.3 },
    -- "Excavation Site 9"
    [8181] = { ["zone"] = 2214, ["x"] = 76.0, ["y"] = 96.50 },
    --Hallowfall
    -- "Mycomancer Cavern"
    [7780] = { ["zone"] = 2215, ["x"] = 71.3, ["y"] = 31.2 },
    -- "Nightfall Sanctum"
    [7785] = { ["zone"] = 2215, ["x"] = 34.32, ["y"] = 47.43 },
    -- "The Sinkhole"
    [7783] = { ["zone"] = 2215, ["x"] = 50.6, ["y"] = 53.3 },
    -- "Skittering Breach"
    [7789] = { ["zone"] = 2215, ["x"] = 65.48, ["y"] = 61.74 },
    --Azj-Kahet
    -- "The Spiral Weave"
    [7790] = { ["zone"] = 2255, ["x"] = 45.0, ["y"] = 19.0 },
    -- "Tak-Rethan Abyss"
    [7784] = { ["zone"] = 2255, ["x"] = 55.0, ["y"] = 73.92 },
    -- "The Underkeep"
    [7786] = { ["zone"] = 2255, ["x"] = 51.85, ["y"] = 88.30 },
    --Undermine
    -- "Sidestreet Sluice"
    [8246] = { ["zone"] = 2346, ["x"] = 35.20, ["y"] = 52.80 },
    -- "Demolition Dome"
    [8246] = { ["zone"] = 2346, ["x"] = 50.30, ["y"] = 9.60 },
}

worldQuestsIDs = {
    ["82158"] = "Special Assignment: Lynx Rescue",
    ["82414"] = "Special Assignment: A Pound of Cure",
    ["82355"] = "Special Assignment: Cinderbee Surge",
    ["82531"] = "Special Assignment: Bombs from Behind",
    ["83229"] = "Special Assignment: When the Deeps Stir",
    ["82787"] = "Special Assignment: Rise of the Colossals",
    ["81691"] = "Special Assignment: Shadows Below",
    ["81649"] = "Special Assignment: Titanic Resurgence"
}

delveTiers = {
    { ["bountifulLootIlvl"] = 610, ["recommendedIlvl"] = 587, ["vaultIlvl"] = 623 },
    { ["bountifulLootIlvl"] = 613, ["recommendedIlvl"] = 590, ["vaultIlvl"] = 623 },
    { ["bountifulLootIlvl"] = 616, ["recommendedIlvl"] = 593, ["vaultIlvl"] = 626 },
    { ["bountifulLootIlvl"] = 619, ["recommendedIlvl"] = 597, ["vaultIlvl"] = 636 },
    { ["bountifulLootIlvl"] = 623, ["recommendedIlvl"] = 606, ["vaultIlvl"] = 642 },
    { ["bountifulLootIlvl"] = 626, ["recommendedIlvl"] = 613, ["vaultIlvl"] = 645 },
    { ["bountifulLootIlvl"] = 636, ["recommendedIlvl"] = 626, ["vaultIlvl"] = 645 },
    { ["bountifulLootIlvl"] = 639, ["recommendedIlvl"] = 639, ["vaultIlvl"] = 649 },
    { ["bountifulLootIlvl"] = 639, ["recommendedIlvl"] = 645, ["vaultIlvl"] = 649 },
    { ["bountifulLootIlvl"] = 639, ["recommendedIlvl"] = 652, ["vaultIlvl"] = 649 },
    { ["bountifulLootIlvl"] = 639, ["recommendedIlvl"] = 658, ["vaultIlvl"] = 649 }
}

AceGUI = LibStub("AceGUI-3.0")
isFrameVisible = false
BountifulDelvesHelperMainFrame = {}

function showUI()
    Delves = {}

    for delvePoiID, delveConfig in pairs(waypoints) do
        local delve = C_AreaPoiInfo.GetAreaPOIInfo(delveConfig["zone"], delvePoiID)

        if delve ~= nil and delve["atlasName"] == "delves-bountiful" then
            local areaName = areaIDs[delveConfig["zone"]]
            local icon = C_UIWidgetManager.GetAllWidgetsBySetID(delve.iconWidgetSet)
            local isOvercharged = false

            if #icon == 2 then
                isOvercharged = true
            end

            Delves[delvePoiID] = { ["name"] = delve["name"], ["zone"] = areaName, ["overcharged"] = isOvercharged }
        end
    end

    local function DrawDelvesGroup(container)
        local count = 0
        for _ in pairs(Delves) do
            count = count + 1
        end
        if count == 0 then
            guiCreateNewline(container, 3)

            if UnitLevel("player") < 68 then
                local label = AceGUI:Create("Label")
                label:SetText(getColorText("FF7E40", "  Delves unlock at Level 68"))
                label:SetFont(GameFontHighlightLarge:GetFont())
                label:SetFullWidth(true)
                container:AddChild(label)
            else
                local label = AceGUI:Create("Label")
                label:SetText(getColorText("FF7E40", "  There are currently no bountiful Delves available"))
                label:SetFont(GameFontHighlightLarge:GetFont())
                label:SetFullWidth(true)
                container:AddChild(label)
            end

        else
            guiCreateNewline(container, 2)

            cofferKeys = C_CurrencyInfo.GetCurrencyInfo(3028)
            cofferKeyIcon = GetItemIcon(224172)

            if cofferKeys.quantity == 0 then
                textColor = "\124cffE02E2E"
            else
                textColor = "\124cff2FE02F"
            end

            if cofferKeys.quantity == 1 then
                cofferKeyCountLabel = "key"
            else
                cofferKeyCountLabel = "keys"
            end

            local text = AceGUI:Create("InteractiveLabel")
            text:SetImage(cofferKeyIcon)
            text:SetImageSize(22, 22)
            text:SetText(textColor .. cofferKeys.quantity .. "\124cffFFFFFF " .. cofferKeyCountLabel .. " on this character\124r")
            text:SetWidth(420)
            text:SetFont(GameFontHighlightLarge:GetFont())
            container:AddChild(text)

            guiCreateSpacing(container, 5)

            local weeklyQuestCount = 4
            local weeklyQuestIDs = {
                847360,
                847363,
                847361
            }
            for _, weeklyQuestID in pairs(weeklyQuestIDs) do
                if (C_QuestLog.IsQuestFlaggedCompleted(weeklyQuestID)) then
                    weeklyQuestCount = weeklyQuestCount - 1
                end
            end

            WeeklyQuestsIcon = GetItemIcon(122606)

            if weeklyQuestCount == 0 then
                textColor = "\124cffE02E2E"
            else
                textColor = "\124cff2FE02F"
            end

            if weeklyQuestCount == 1 then
                cofferKeyCountLabel = "key"
            else
                cofferKeyCountLabel = "keys"
            end

            local text = AceGUI:Create("InteractiveLabel")
            text:SetImage(WeeklyQuestsIcon)
            text:SetImageSize(22, 22)
            text:SetText(textColor .. weeklyQuestCount .. "\124cffFFFFFF " .. cofferKeyCountLabel .. " left to obtain from weekly activities")
            text:SetWidth(420)
            text:SetFont(GameFontHighlightLarge:GetFont())
            container:AddChild(text)

            guiCreateSpacing(container, 5)

            cofferKeyShardsCount = C_Item.GetItemCount(236096)
            keysToCreateCount = math.floor(cofferKeyShardsCount / 100)
            CofferKeyShardIcon = GetItemIcon(236096)

            if cofferKeyShardsCount < 100 then
                textColor = "\124cffE02E2E"
            else
                textColor = "\124cff2FE02F"
            end

            if keysToCreateCount == 1 then
                cofferKeyCountLabel = "key"
            else
                cofferKeyCountLabel = "keys"
            end

            local text = AceGUI:Create("InteractiveLabel")
            text:SetImage(CofferKeyShardIcon)
            text:SetImageSize(22, 22)
            text:SetText(textColor .. keysToCreateCount .. "\124cffFFFFFF " .. cofferKeyCountLabel .. " available from \124cff3088E0" .. cofferKeyShardsCount .. "\124cffFFFFFF shards\124r")
            text:SetWidth(420)
            text:SetFont(GameFontHighlightLarge:GetFont())
            container:AddChild(text)

            guiCreateNewline(container, 3)

            local button = AceGUI:Create("Button")
            button:SetText("Great Vault")
            button:SetWidth(100)
            button:SetCallback("OnClick", function()
                C_AddOns.LoadAddOn("Blizzard_WeeklyRewards")
                BountifulDelvesHelperMainFrame:Hide()
                WeeklyRewardsFrame:Show()
            end)
            container:AddChild(button)

            local lfgbutton1 = AceGUI:Create("Button")
            lfgbutton1:SetText("Start LFG")
            lfgbutton1:SetWidth(100)
            lfgbutton1:SetCallback("OnClick", function()
                openStartGroupFrame("delves")
                BountifulDelvesHelperMainFrame:Hide()
            end)
            container:AddChild(lfgbutton1)

            if IsInRaid() then
                lfgbutton1:SetDisabled(true)
            elseif IsInGroup() and not UnitIsGroupLeader("player") then
                lfgbutton1:SetDisabled(true)
            else
                lfgbutton1:SetDisabled(false)
            end

            local lfgbutton2 = AceGUI:Create("Button")
            lfgbutton2:SetText("Search LFG")
            lfgbutton2:SetWidth(100)
            lfgbutton2:SetCallback("OnClick", function()
                openFindGroupFrame("delves")
                BountifulDelvesHelperMainFrame:Hide()
            end)
            container:AddChild(lfgbutton2)

            local label = AceGUI:Create("Label")
            label:SetFullWidth(true)
            container:AddChild(label)

            guiCreateNewline(container, 1)

            local label = AceGUI:Create("Label")
            label:SetFullWidth(true)
            container:AddChild(label)

            local label = AceGUI:Create("Label")
            label:SetText("Delve Name")
            label:SetFont(GameFontHighlightSmall:GetFont())
            label:SetWidth(220)
            container:AddChild(label)

            local label = AceGUI:Create("Label")
            label:SetText("Zone")
            label:SetFont(GameFontHighlightSmall:GetFont())
            label:SetWidth(120)
            container:AddChild(label)

            local label = AceGUI:Create("Label")
            label:SetFont(GameFontHighlightSmall:GetFont())
            label:SetWidth(150)
            container:AddChild(label)

            local label = AceGUI:Create("Label")
            label:SetFullWidth(true)
            container:AddChild(label)

            for mapPoiID, delve in pairs(Delves) do
                local label = AceGUI:Create("Label")
                label:SetImageSize(18, 18)
                local name = ""

                if delve["overcharged"] == true then
                    name = "(OC) " .. "\124cffFF9C00" .. delve["name"] .. "\124r"
                else
                    name = "\124cffA335EE" .. delve["name"] .. "\124r"
                end

                label:SetText(name)
                label:SetFont(GameFontHighlightMedium:GetFont())
                label:SetWidth(220)
                container:AddChild(label)

                local label = AceGUI:Create("Label")
                label:SetText(delve["zone"])
                label:SetFont(GameFontHighlightMedium:GetFont())
                label:SetWidth(120)
                container:AddChild(label)

                local button = AceGUI:Create("Button")
                button:SetText("Waypoint")
                button:SetWidth(120)
                button:SetCallback("OnClick", function()
                    setWaypoint("default", mapPoiID, delve["name"])
                end)
                container:AddChild(button)

                local button = AceGUI:Create("Button")
                button:SetText("TomTom")
                button:SetWidth(120)
                button:SetCallback("OnClick", function()
                    setWaypoint("tomtom", mapPoiID, delve["name"])
                end)
                container:AddChild(button)

                if C_AddOns.IsAddOnLoaded("TomTom") == false then
                    button:SetDisabled(true)
                end

                guiCreateNewline(container, 1)
            end
        end
    end

    local function DrawMemoryGroup(container)
        guiCreateNewline(container, 2)

        radiantEchoCount = C_Item.GetItemCount(246771)
        radiantEchoIcon = GetItemIcon(246771)

        if radiantEchoCount == 0 then
            textColor = "\124cffE02E2E"
        else
            textColor = "\124cff2FE02F"
        end

        if radiantEchoCount == 1 then
            radiantEchoCountLabel = "radiant echo"
        else
            radiantEchoCountLabel = "radiant echoes"
        end

        if UnitLevel("player") < 68 then
            guiCreateNewline(container)
            local label = AceGUI:Create("Label")
            label:SetText(getColorText("FF7E40", "  Worldsoul Memories unlock at Level 68"))
            label:SetFont(GameFontHighlightLarge:GetFont())
            label:SetFullWidth(true)
            container:AddChild(label)
        elseif radiantEchoCount == 0 then
            guiCreateNewline(container)
            local label = AceGUI:Create("Label")
            label:SetText(getColorText("FF7E40", "  Have at least one Radiant Echo in your inventory to display icons on the map"))
            label:SetFont(GameFontHighlightLarge:GetFont())
            label:SetFullWidth(true)
            container:AddChild(label)
        else
            local text = AceGUI:Create("InteractiveLabel")
            text:SetImage(radiantEchoIcon)
            text:SetImageSize(22, 22)
            text:SetText(textColor .. radiantEchoCount .. "\124cffFFFFFF " .. radiantEchoCountLabel .. " on this character\124r")
            text:SetWidth(420)
            text:SetFont(GameFontHighlightLarge:GetFont())
            container:AddChild(text)

            local button = AceGUI:Create("Button")
            button:SetText("Start LFG")
            button:SetWidth(100)
            button:SetCallback("OnClick", function()
                openStartGroupFrame("memories")
            end)
            container:AddChild(button)

            guiCreateSpacing(container, 5)

            if IsInGroup() and not UnitIsGroupLeader("player") then
                button:SetDisabled(true)
            end

            local button = AceGUI:Create("Button")
            button:SetText("Search LFG")
            button:SetWidth(110)
            button:SetCallback("OnClick", function()
                openFindGroupFrame("memories")
            end)
            container:AddChild(button)

            guiCreateNewline(container, 8)

            local memories = { }

            for areaID, areaName in pairs(areaIDs) do
                local pois = C_AreaPoiInfo.GetEventsForMap(areaID)
                for _, poiID in pairs(pois) do
                    local poi = C_AreaPoiInfo.GetAreaPOIInfo(areaID, poiID)
                    if poi["atlasName"] == "UI-EventPoi-WorldSoulMemory" then
                        name = split(poi["name"], "\: ")[2] or poi["name"]
                        memories[name] = { ["zoneID"] = areaID, ["zone"] = areaName, ["x"] = poi.position.x * 100, ["y"] = poi.position.y * 100 }
                    end
                end
            end

            local label = AceGUI:Create("Label")
            label:SetText("Memory Name")
            label:SetFont(GameFontHighlightSmall:GetFont())
            label:SetWidth(220)
            container:AddChild(label)

            local label = AceGUI:Create("Label")
            label:SetText("Zone")
            label:SetFont(GameFontHighlightSmall:GetFont())
            label:SetWidth(120)
            container:AddChild(label)

            local label = AceGUI:Create("Label")
            label:SetText("")
            label:SetFont(GameFontHighlightSmall:GetFont())
            label:SetWidth(150)
            container:AddChild(label)

            local label = AceGUI:Create("Label")
            label:SetFullWidth(true)
            container:AddChild(label)

            for name, memory in pairs(memories) do
                cofferKeyIcon = GetItemIcon(224172)
                local label = AceGUI:Create("Label")
                label:SetImageSize(18, 18)
                label:SetText("\124cffA335EE" .. name .. "\124r")
                label:SetFont(GameFontHighlightMedium:GetFont())
                label:SetWidth(220)
                container:AddChild(label)

                local label = AceGUI:Create("Label")
                label:SetText(memory["zone"])
                label:SetFont(GameFontHighlightMedium:GetFont())
                label:SetWidth(120)
                container:AddChild(label)

                local button = AceGUI:Create("Button")
                button:SetText("Waypoint")
                button:SetWidth(120)
                button:SetCallback("OnClick", function()
                    setWaypointFromXY("default", memory["zoneID"], memory["x"], memory["y"], name)
                end)
                container:AddChild(button)

                local button = AceGUI:Create("Button")
                button:SetText("TomTom")
                button:SetWidth(120)
                button:SetCallback("OnClick", function()
                    setWaypointFromXY("tomtom", memory["zoneID"], memory["x"], memory["y"], name)
                end)
                container:AddChild(button)

                if C_AddOns.IsAddOnLoaded("TomTom") == false then
                    button:SetDisabled(true)
                end

                guiCreateNewline(container, 1)
            end

            --completedCount = 0
            --for questID, _ in pairs(worldQuestsIDs) do
            --    isCompleted = C_QuestLog.IsQuestFlaggedCompletedOnAccount(questID)
            --    if isCompleted then
            --        completedCount = completedCount + 1
            --    end
            --end
            --
            --local text = AceGUI:Create("Label")
            --text:SetText("Special assignments: " .. completedCount .. "/4")
            --text:SetFullWidth(true)
            --text:SetFont(GameFontHighlightMedium:GetFont())
            --container:AddChild(text)
        end
    end

    function DrawTiersOverviewGroup(container)
        guiCreateNewline(container, 3)

        local label = AceGUI:Create("Label")
        label:SetText("Tiers")
        label:SetFont(GameFontHighlightMedium:GetFont())
        label:SetWidth(160)
        container:AddChild(label)

        for index = 1, 11 do
            local label = AceGUI:Create("Label")

            if index < 10 then
                label:SetText("  " .. index)
            else
                label:SetText(" " .. index)
            end

            label:SetFont(GameFontHighlightMedium:GetFont())
            label:SetWidth(40)
            container:AddChild(label)
        end

        guiCreateNewline(container)

        local label = AceGUI:Create("Label")
        label:SetText("Recommended Gear")
        label:SetFont(GameFontHighlightMedium:GetFont())
        label:SetWidth(160)
        container:AddChild(label)

        for _, tierDetails in pairs(delveTiers) do
            local label = AceGUI:Create("Label")
            label:SetText(tierDetails["recommendedIlvl"])
            label:SetFont(GameFontHighlightMedium:GetFont())
            label:SetWidth(40)
            container:AddChild(label)
        end

        guiCreateNewline(container)

        local label = AceGUI:Create("Label")
        label:SetText("Bountiful Loot")
        label:SetFont(GameFontHighlightMedium:GetFont())
        label:SetWidth(160)
        container:AddChild(label)

        for _, tierDetails in pairs(delveTiers) do
            local label = AceGUI:Create("Label")
            local bountifulLoot = tierDetails["bountifulLootIlvl"]

            label:SetText(getGearColorText(bountifulLoot, bountifulLoot))

            label:SetFont(GameFontHighlightMedium:GetFont())
            label:SetWidth(40)
            container:AddChild(label)
        end

        guiCreateNewline(container)

        local label = AceGUI:Create("Label")
        label:SetText("Great Vault")
        label:SetFont(GameFontHighlightMedium:GetFont())
        label:SetWidth(160)
        container:AddChild(label)

        for _, tierDetails in pairs(delveTiers) do
            local label = AceGUI:Create("Label")
            label:SetText(tierDetails["vaultIlvl"])
            label:SetFont(GameFontHighlightMedium:GetFont())
            label:SetWidth(40)
            container:AddChild(label)
        end

        guiCreateNewline(container)
    end

    local function SelectGroup(container, event, group)
        container:ReleaseChildren()
        if group == "tab1" then
            DrawDelvesGroup(container)
        elseif group == "tab2" then
            DrawMemoryGroup(container)
        elseif group == "tab3" then
            DrawTiersOverviewGroup(container)
        elseif group == "tab4" then
            DrawOptionsOverviewGroup(container)
        end
    end

    BountifulDelvesHelperMainFrame = AceGUI:Create("Frame")
    BountifulDelvesHelperMainFrame:EnableResize(false)
    BountifulDelvesHelperMainFrame:SetTitle("Bountiful Delves Helper")
    BountifulDelvesHelperMainFrame:SetStatusText("Bountiful Delves Helper - v1.2.6")
    BountifulDelvesHelperMainFrame:SetCallback("OnClose", function(widget)
        isFrameVisible = false
    end)
    BountifulDelvesHelperMainFrame:SetHeight(400)
    BountifulDelvesHelperMainFrame:SetLayout("Fill")

    local tab = AceGUI:Create("TabGroup")
    tab:SetLayout("Flow")
    tab:SetTabs({ { text = "Bountiful Delves", value = "tab1" }, { text = "Worldsoul Memories", value = "tab2" }, { text = "Tiers Overview", value = "tab3" }, { text = "Options", value = "tab4" } })
    tab:SetCallback("OnGroupSelected", SelectGroup)
    tab:SelectTab("tab1")

    BountifulDelvesHelperMainFrame:AddChild(tab)

    _G["BountifulDelvesHelperGlobalFrame"] = BountifulDelvesHelperMainFrame.frame
    tinsert(UISpecialFrames, "BountifulDelvesHelperGlobalFrame")
end

function DrawOptionsOverviewGroup(container)
    guiCreateNewline(container, 3)

    local button = AceGUI:Create("Button")
    button:SetText("Toggle Minimap Button")
    button:SetWidth(250)
    button:SetCallback("OnClick", function()
        if BountifulDelvesHelperIconDB.hide == true then
            BountifulDelvesHelperMinimapButton:Show("BountifulDelvesHelper")
            BountifulDelvesHelperIconDB.hide = false
        else
            BountifulDelvesHelperMinimapButton:Hide("BountifulDelvesHelper")
            BountifulDelvesHelperIconDB.hide = true
        end
    end)
    container:AddChild(button)

end

function triggerFrame()
    if not isFrameVisible then
        showUI()
        isFrameVisible = true
    else
        BountifulDelvesHelperMainFrame:Hide()
        isFrameVisible = false
    end
end

function BountifulDelvesHelper:ToggleMainFrame()
    triggerFrame()
end

SlashCmdList["DELVES"] = function(arg1)
    if arg1 == "hide" and BountifulDelvesHelperIconDB["hide"] == false or BountifulDelvesHelperIconDB["hide"] == nil then
        BountifulDelvesHelperIconDB["hide"] = true
        print("[Bountiful Delves Helper] Minimap icon hidden, use /reload for it to take effect.")
    elseif arg1 == "show" and BountifulDelvesHelperIconDB["hide"] == true then
        BountifulDelvesHelperIconDB["hide"] = false
        print("[Bountiful Delves Helper] Minimap icon shown, use /reload for it to take effect.")
    elseif arg1 == "" then
        if not isFrameVisible then
            showUI()
            isFrameVisible = true
        end
    end
end

local eventListenerFrame = CreateFrame("Frame", "BountifulDelvesHelperListenerFrame")
local function eventHandler(self, event, arg1)
    if event == "GOSSIP_SHOW" and arg1 == "delves-difficulty-picker" then
        local highestTier = 1
        for index, data in pairs(DelvesDifficultyPickerFrame:GetOptions()) do
            if data["status"] == 0 then
                highestTier = index
            end
        end
    end
end

eventListenerFrame:SetScript("OnEvent", eventHandler)
eventListenerFrame:RegisterEvent("GOSSIP_SHOW")