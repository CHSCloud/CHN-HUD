local language = require("lang.language")
local toggleButton = require("src.ui.toggleButton")
local droplist = require("src.ui.droplist")
local button = require("src.ui.button")
local slider = require("src.ui.slider")

local leaderboardSettings = {}

local defaultValues = {
    leaderboardScale = 1,

    numDrivers = 10,

    tyreActive = true,
    tyrePos = 1,

    lapCountActive = true,
    lapCountPos = 2,

    lastLapActive = true,
    lastLapPos = 3,

    gapActive = true,
    gapPos = 4,

    overtakeArrowsActive = true,
    overtakeArrowsPos = 5,

    statusActive = true,
    statusPos = 6,

    focusedCarActive = true,
    
    
}

leaderboardSettings.store = ac.storage(defaultValues)

local function resetToDefault()
    for key, value in pairs(defaultValues) do
        leaderboardSettings.store[key] = value
    end
end

local function invertPositions(keyActive, oldPos, newPos)
    for key, value in pairs(defaultValues) do
        if key ~= keyActive and leaderboardSettings.store[key] == newPos and string.match(key, "Pos") then
            leaderboardSettings.store[key] = oldPos
        end
    end
end

---comment
---@param pos vec2
local function drawContents(pos)
    invertPositions("tyreActive", leaderboardSettings.store.tyrePos)
    local positions = {"1", "2", "3", "4", "5", "6"}
    if toggleButton.main("tyresToggle", pos, leaderboardSettings.store.tyreActive, "Tyres") then
        leaderboardSettings.store.tyreActive = not leaderboardSettings.store.tyreActive
    end
    local old = leaderboardSettings.store.tyrePos
    leaderboardSettings.store.tyrePos = droplist.main("##tyrePos", "", vec2(pos.x + ui.measureDWriteText("Tyres", 12).x + 50, pos.y - 2), 60, leaderboardSettings.store.tyrePos, positions, droplist.PosText.Start)
    if old ~= leaderboardSettings.store.tyrePos then
        invertPositions("tyrePos", old, leaderboardSettings.store.tyrePos)
    end
    
    pos.y = pos.y + 30

    if toggleButton.main("lapsToggle", pos, leaderboardSettings.store.lapCountActive, "Lap count") then
        leaderboardSettings.store.lapCountActive = not leaderboardSettings.store.lapCountActive
    end
    old = leaderboardSettings.store.lapCountPos
    leaderboardSettings.store.lapCountPos = droplist.main("##lapCountPos", "", vec2(pos.x + ui.measureDWriteText("Lap count", 12).x + 50, pos.y - 2), 60, leaderboardSettings.store.lapCountPos, positions, droplist.PosText.Start)
    if old ~= leaderboardSettings.store.lapCountPos then
        invertPositions("lapCountPos", old, leaderboardSettings.store.lapCountPos)
    end
    pos.y = pos.y + 30
        
    if toggleButton.main("lastLapToggle", pos, leaderboardSettings.store.lastLapActive, "Last lap time") then
        leaderboardSettings.store.lastLapActive = not leaderboardSettings.store.lastLapActive
    end
    old = leaderboardSettings.store.lastLapPos
    leaderboardSettings.store.lastLapPos = droplist.main("##lastLapPos", "", vec2(pos.x + ui.measureDWriteText("Last lap time", 12).x + 50, pos.y - 2), 60, leaderboardSettings.store.lastLapPos, positions, droplist.PosText.Start)
    if old ~= leaderboardSettings.store.lastLapPos then
        invertPositions("lastLapPos", old, leaderboardSettings.store.lastLapPos)
    end
    pos.y = pos.y + 30
        
    if toggleButton.main("statusToggle", pos, leaderboardSettings.store.statusActive, "Player status") then
        leaderboardSettings.store.statusActive = not leaderboardSettings.store.statusActive
    end
    old = leaderboardSettings.store.statusPos
    leaderboardSettings.store.statusPos = droplist.main("##statusPos", "", vec2(pos.x + ui.measureDWriteText("Player status", 12).x + 50, pos.y - 2), 60, leaderboardSettings.store.statusPos, positions, droplist.PosText.Start)
    if old ~= leaderboardSettings.store.statusPos then
        invertPositions("statusPos", old, leaderboardSettings.store.statusPos)
    end
    pos.y = pos.y + 30
        
    if toggleButton.main("gapToggle", pos, leaderboardSettings.store.gapActive, "Gap") then
        leaderboardSettings.store.gapActive = not leaderboardSettings.store.gapActive
    end
    old = leaderboardSettings.store.gapPos
    leaderboardSettings.store.gapPos = droplist.main("##gapPos", "", vec2(pos.x + ui.measureDWriteText("Gap", 12).x + 50, pos.y - 2), 60, leaderboardSettings.store.gapPos, positions, droplist.PosText.Start)
    if old ~= leaderboardSettings.store.gapPos then
        invertPositions("gapPos", old, leaderboardSettings.store.gapPos)
    end
    pos.y = pos.y + 30
        
    if toggleButton.main("overtakeToggle", pos, leaderboardSettings.store.overtakeArrowsActive, "Overtaking arrows") then
        leaderboardSettings.store.overtakeArrowsActive = not leaderboardSettings.store.overtakeArrowsActive
    end
    old = leaderboardSettings.store.overtakeArrowsPos
    leaderboardSettings.store.overtakeArrowsPos = droplist.main("##overtakeArrowsPos", "", vec2(pos.x + ui.measureDWriteText("Overtaking arrows", 12).x + 50, pos.y - 2), 60, leaderboardSettings.store.overtakeArrowsPos, positions, droplist.PosText.Start)
    if old ~= leaderboardSettings.store.overtakeArrowsPos then
        invertPositions("overtakeArrowsPos", old, leaderboardSettings.store.overtakeArrowsPos)
    end
    pos.y = pos.y + 40

    if toggleButton.main("focusedCarToggle", pos, leaderboardSettings.store.focusedCarActive, "Always display Focused Car") then
        leaderboardSettings.store.focusedCarActive = not leaderboardSettings.store.focusedCarActive
    end
    pos.y = pos.y + 30

    return pos.y
end

function leaderboardSettings.leaderboardSettings()
    local posY = 75

    -- Escala:
    leaderboardSettings.store.leaderboardScale = slider.main(language.get("SIZE"), string.format("%.2f", leaderboardSettings.store.leaderboardScale), vec2(20, posY), 250, leaderboardSettings.store.leaderboardScale, 0.7, 2)
    posY = posY + 50

    -- Número de players no placar:
    leaderboardSettings.store.numDrivers = math.floor(slider.main("Num of drivers", string.format("%i", leaderboardSettings.store.numDrivers), vec2(20, posY), 250, leaderboardSettings.store.numDrivers, 1, 20))

    posY = posY + 40
    posY = drawContents(vec2(20, posY))

    posY = posY + 40


    if button.main(vec2(20, posY), language.get("RESET_DEFAULT")) then
        resetToDefault()
    end 
end


return leaderboardSettings