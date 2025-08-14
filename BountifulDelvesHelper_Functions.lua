function getColorText(color, text)
    return "\124cff" .. color .. text .. "\124r"
end

 
function setWaypoint(type, mapPoiID, name)
    local waypoint = waypoints[mapPoiID]
    if type == "default" then
        local point = UiMapPoint.CreateFromCoordinates(waypoint["zone"], waypoint["x"] / 100, waypoint["y"] / 100)
        C_Map.SetUserWaypoint(point)
        C_SuperTrack.SetSuperTrackedUserWaypoint(true)
    elseif type == "tomtom" then
        local tomtomCommand = "/way #" .. waypoint["zone"] .. " " .. waypoint["x"] .. " " .. waypoint["y"] .. " " .. name;
        DEFAULT_CHAT_FRAME.editBox:SetText(tomtomCommand)
        ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox, 0)
    end
end

function setWaypointFromXY(type, zoneID, x, y, name)
    if type == "default" then
        local point = UiMapPoint.CreateFromCoordinates(zoneID, x / 100, y / 100)
        C_Map.SetUserWaypoint(point)
        C_SuperTrack.SetSuperTrackedUserWaypoint(true)
    elseif type == "tomtom" then
        local tomtomCommand = "/way #" .. zoneID .. " " .. x .. " " .. y .. " " .. name;
        DEFAULT_CHAT_FRAME.editBox:SetText(tomtomCommand)
        ChatEdit_SendText(DEFAULT_CHAT_FRAME.editBox, 0)
    end
end

function openStartGroupFrame(type)
    if not PVEFrame:IsShown() then
        PVEFrame_ToggleFrame()
    end

    GroupFinderFrameGroupButton3:Click()

    if type == "delves" or type == nil then
        LFGListCategorySelection_SelectCategory(LFGListFrame.CategorySelection, 121, 0)
        LFGListFrame.CategorySelection.StartGroupButton:Click()
        LFGListFrame.EntryCreation.GroupDropdown:OpenMenu()
    elseif type == "memories" then
        LFGListCategorySelection_SelectCategory(LFGListFrame.CategorySelection, 6, 0)
        LFGListFrame.CategorySelection.StartGroupButton:Click()
    end
end

function openFindGroupFrame(type)
    if not PVEFrame:IsShown() then
        PVEFrame_ToggleFrame()
    end

    GroupFinderFrameGroupButton3:Click()

    if type == "delves" or type == nil then
        LFGListCategorySelection_SelectCategory(LFGListFrame.CategorySelection, 121, 0)
        LFGListFrame.CategorySelection.FindGroupButton:Click()
    elseif type == "memories" then
        LFGListCategorySelection_SelectCategory(LFGListFrame.CategorySelection, 6, 0)
        LFGListFrame.CategorySelection.FindGroupButton:Click()
    end
end

--LFGListFrame.SearchPanel.SearchBox.Instructions:SetText("Memory")
--LFGListFrame.SearchPanel.SearchBox.Instructions2.text = "Memory"

function getGearColorText(ilvl, text)
    local color = "1eff00"

    if ilvl >= 571 and ilvl < 584 then
        color = "0070dd"
    elseif ilvl >= 584 then
        color = "a335ee"
    end

    return "\124cff" .. color .. text .. "\124r"
end

function guiCreateNewline(container, count)
    local count = count or 1
    for index = 1, count do
        local newline = AceGUI:Create("Label")
        newline:SetFullWidth(true)
        container:AddChild(newline)
    end
end

function guiCreateLabel(container, fontSize, text, width)
    local label = AceGUI:Create("Label")
    label:SetText(text)
    label:SetFont(fontSize)
    label:SetWidth(width)
    container:AddChild(label)
end

function guiCreateSpacing(container, width)
    local spacing = AceGUI:Create("Label")
    spacing:SetWidth(width)
    container:AddChild(spacing)
end

function split(pString, pPattern)
    local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
    local fpat = "(.-)" .. pPattern
    local last_end = 1
    local s, e, cap = pString:find(fpat, 1)
    while s do
        if s ~= 1 or cap ~= "" then
            table.insert(Table, cap)
        end
        last_end = e + 1
        s, e, cap = pString:find(fpat, last_end)
    end
    if last_end <= #pString then
        cap = pString:sub(last_end)
        table.insert(Table, cap)
    end
    return Table
end
