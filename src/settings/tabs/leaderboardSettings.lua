local language = require("language.language")
local toggleButton = require("src.ui.buttons.toggleButton")
local droplist = require("src.ui.selectors.droplist")
local button = require("src.ui.buttons.button")
local slider = require("src.ui.selectors.slider")
local utils = require("common.utils")

local leaderboardSettings = {}

local defaultValues = {}
local defaultGeneralValues = {
    leaderboardScale = 1,

    numDrivers = 10,
}
local defaultContentValues = {
    tyreActive = true,
    tyrePos = 1,

    lapCountActive = true,
    lapCountPos = 2,

    lastLapLeaderboardActive = true,
    lastLapPos = 3,

    bestLapLeaderboardActive = true,
    bestLapPos = 4,

    gapActive = true,
    gapPos = 5,

    overtakeArrowsActive = true,
    overtakeArrowsPos = 6,

    statusActive = true,
    statusPos = 7,

    focusedCarActive = true,

    titlesActive = true,
}

utils.copyTable(defaultGeneralValues, defaultValues)
utils.copyTable(defaultContentValues, defaultValues)
leaderboardSettings.store = ac.storage(defaultValues)

local function resetGeneralToDefault()
    for key, value in pairs(defaultGeneralValues) do
        leaderboardSettings.store[key] = value
    end
end

local function resetContentToDefault()
    for key, value in pairs(defaultContentValues) do
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

local function contents()
    local pos = vec2(20, 80)
    invertPositions("tyreActive", leaderboardSettings.store.tyrePos)
    local positions = { "1", "2", "3", "4", "5", "6", "7" }

    ui.dwriteDrawText(language.get("CONTENT"), 12, vec2(pos.x - 5, pos.y), COLOR.WHITE)
    pos.y = pos.y + 25
    if toggleButton.main("tyresToggle", pos, leaderboardSettings.store.tyreActive, language.get("TYRES")) then
        leaderboardSettings.store.tyreActive = not leaderboardSettings.store.tyreActive
    end
    local old = leaderboardSettings.store.tyrePos
    leaderboardSettings.store.tyrePos = droplist.main("##tyrePos", " |  " .. language.get("POSITION"),
        vec2(pos.x + ui.measureDWriteText(language.get("TYRES"), 12).x + 55, pos.y - 2), 60,
        leaderboardSettings.store.tyrePos, positions, droplist.PosText.Start)
    if old ~= leaderboardSettings.store.tyrePos then
        invertPositions("tyrePos", old, leaderboardSettings.store.tyrePos)
    end

    pos.y = pos.y + 40

    if toggleButton.main("lapsToggle", pos, leaderboardSettings.store.lapCountActive, language.get("LAP_COUNT")) then
        leaderboardSettings.store.lapCountActive = not leaderboardSettings.store.lapCountActive
    end
    old = leaderboardSettings.store.lapCountPos
    leaderboardSettings.store.lapCountPos = droplist.main("##lapCountPos", " |  " .. language.get("POSITION"),
        vec2(pos.x + ui.measureDWriteText(language.get("LAP_COUNT"), 12).x + 55, pos.y - 2), 60,
        leaderboardSettings.store.lapCountPos, positions, droplist.PosText.Start)
    if old ~= leaderboardSettings.store.lapCountPos then
        invertPositions("lapCountPos", old, leaderboardSettings.store.lapCountPos)
    end
    pos.y = pos.y + 40

    if toggleButton.main("lastLapToggle", pos, leaderboardSettings.store.lastLapLeaderboardActive, language.get("LAST_LAP_TIME")) then
        leaderboardSettings.store.lastLapLeaderboardActive = not leaderboardSettings.store.lastLapLeaderboardActive
    end
    old = leaderboardSettings.store.lastLapPos
    leaderboardSettings.store.lastLapPos = droplist.main("##lastLapPos", " |  " .. language.get("POSITION"),
        vec2(pos.x + ui.measureDWriteText(language.get("LAST_LAP_TIME"), 12).x + 55, pos.y - 2), 60,
        leaderboardSettings.store.lastLapPos, positions, droplist.PosText.Start)
    if old ~= leaderboardSettings.store.lastLapPos then
        invertPositions("lastLapPos", old, leaderboardSettings.store.lastLapPos)
    end
    pos.y = pos.y + 40

    if toggleButton.main("bestLapToggle", pos, leaderboardSettings.store.bestLapLeaderboardActive, language.get("BEST_LAP_TIME")) then
        leaderboardSettings.store.bestLapLeaderboardActive = not leaderboardSettings.store.bestLapLeaderboardActive
    end
    old = leaderboardSettings.store.bestLapPos
    leaderboardSettings.store.bestLapPos = droplist.main("##bestLapPos", " |  " .. language.get("POSITION"),
        vec2(pos.x + ui.measureDWriteText(language.get("BEST_LAP_TIME"), 12).x + 55, pos.y - 2), 60,
        leaderboardSettings.store.bestLapPos, positions, droplist.PosText.Start)
    if old ~= leaderboardSettings.store.bestLapPos then
        invertPositions("bestLapPos", old, leaderboardSettings.store.bestLapPos)
    end
    pos.y = pos.y + 40

    if toggleButton.main("statusToggle", pos, leaderboardSettings.store.statusActive, language.get("PLAYER_STATUS")) then
        leaderboardSettings.store.statusActive = not leaderboardSettings.store.statusActive
    end
    old = leaderboardSettings.store.statusPos
    leaderboardSettings.store.statusPos = droplist.main("##statusPos", " |  " .. language.get("POSITION"),
        vec2(pos.x + ui.measureDWriteText(language.get("PLAYER_STATUS"), 12).x + 55, pos.y - 2), 60,
        leaderboardSettings.store.statusPos, positions, droplist.PosText.Start)
    if old ~= leaderboardSettings.store.statusPos then
        invertPositions("statusPos", old, leaderboardSettings.store.statusPos)
    end
    pos.y = pos.y + 40

    if toggleButton.main("gapToggle", pos, leaderboardSettings.store.gapActive, "Gap") then
        leaderboardSettings.store.gapActive = not leaderboardSettings.store.gapActive
    end
    old = leaderboardSettings.store.gapPos
    leaderboardSettings.store.gapPos = droplist.main("##gapPos", " |  " .. language.get("POSITION"),
        vec2(pos.x + ui.measureDWriteText("Gap", 12).x + 55, pos.y - 2), 60, leaderboardSettings.store.gapPos, positions,
        droplist.PosText.Start)
    if old ~= leaderboardSettings.store.gapPos then
        invertPositions("gapPos", old, leaderboardSettings.store.gapPos)
    end
    pos.y = pos.y + 40

    if toggleButton.main("overtakeToggle", pos, leaderboardSettings.store.overtakeArrowsActive, language.get("OVERTAKING_ARROWS")) then
        leaderboardSettings.store.overtakeArrowsActive = not leaderboardSettings.store.overtakeArrowsActive
    end
    old = leaderboardSettings.store.overtakeArrowsPos
    leaderboardSettings.store.overtakeArrowsPos = droplist.main("##overtakeArrowsPos", " |  " .. language.get("POSITION"),
        vec2(pos.x + ui.measureDWriteText(language.get("OVERTAKING_ARROWS"), 12).x + 55, pos.y - 2), 60,
        leaderboardSettings.store.overtakeArrowsPos, positions, droplist.PosText.Start)
    if old ~= leaderboardSettings.store.overtakeArrowsPos then
        invertPositions("overtakeArrowsPos", old, leaderboardSettings.store.overtakeArrowsPos)
    end
    pos.y = pos.y + 40

    ui.dwriteDrawText(language.get("OTHERS"), 12, vec2(pos.x - 5, pos.y), COLOR.WHITE)
    pos.y = pos.y + 25
    if toggleButton.main("focusedCarToggle", pos, leaderboardSettings.store.focusedCarActive, language.get("ALWAYS_FOCUSED_CAR")) then
        leaderboardSettings.store.focusedCarActive = not leaderboardSettings.store.focusedCarActive
    end

    pos.y = pos.y + 40
    if toggleButton.main("titlesLeaderBoardToggle", pos, leaderboardSettings.store.titlesActive, language.get("SHOW_TITLES")) then
        leaderboardSettings.store.titlesActive = not leaderboardSettings.store.titlesActive
    end
    pos.y = pos.y + 40
    if button.main(vec2(20, pos.y), language.get("RESET_DEFAULT")) then
        resetContentToDefault()
    end
end

local function general()
    local posY = 100

    -- Escala:
    leaderboardSettings.store.leaderboardScale = slider.main(language.get("SIZE"),
        string.format("%.2f", leaderboardSettings.store.leaderboardScale), vec2(20, posY), 250,
        leaderboardSettings.store.leaderboardScale, 0.7, 2)
    posY = posY + 50

    -- Número de players no placar:
    leaderboardSettings.store.numDrivers = math.floor(slider.main(language.get("NUM_DRIVERS"),
        string.format("%i", leaderboardSettings.store.numDrivers), vec2(20, posY), 250,
        leaderboardSettings.store.numDrivers, 1, 20))

    posY = posY + 40

    if button.main(vec2(20, posY), language.get("RESET_DEFAULT")) then
        resetGeneralToDefault()
    end
end


function leaderboardSettings.leaderboardSettings()
    ui.tabBar('##ID', function()
        ui.tabItem(language.get("GENERAL"), general)
        ui.tabItem(language.get("CONTENT"), contents)
    end)
end

return leaderboardSettings
