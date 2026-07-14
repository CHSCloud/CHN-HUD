local sessionLapsSettings = require("src.settings.tabs.sessionLapsSettings")
local pinCheckBox = require("src.ui.buttons.pinCheckBox")
local window = require("common.window")
local sessionLapsData = require("src.data.sessionLaps.sessionLapsData")

local laps = require("src.hud.sessionLaps.components.laps")
local sectors = require("src.hud.sessionLaps.components.sectors")

local sessionLaps = {}

--- @type sessionLapsData
local data = sessionLapsData.new()


ac.onSessionStart(function()
    data.previousBestlap = 0
    sessionLapsData.resetSectors(data)
end)

function sessionLaps.windowMain()
    ui.pushDWriteFont("fonts/Montserrat-Bold.ttf") -- FONT TEXT

    data.currentWindowWidth = 240 * sessionLapsSettings.store.sessionLapsScale
    data.currentWindowHeight = 0
    sessionLapsData.setSectorsDivisions(data, sessionLapsSettings.store.numberDivisions - 1)
    for i = 1, #data.sectorsDivisions[0], 1 do
        ac.log("Divisão ".. tostring(i) .. " - ".. tostring(data.sectorsDivisions[0][i]) .. " - ".. tostring(data.sectorsDivisions[1][i]) .. " - ".. tostring(data.sectorsDivisions[2][i]))
    end
    ui.drawRectFilled(vec2(0, 0), data.currentWindowSize, WindowsColor, 5 * sessionLapsSettings.store.sessionLapsScale)
    -- Volta atual
    if sessionLapsSettings.store.currentLapActive then
        laps.drawCurrent(data)
    end

    -- Última volta
    if sessionLapsSettings.store.lastLapActive then
        laps.drawLast(data)
    end

    -- Melhor volta
    if sessionLapsSettings.store.bestLapActive then
        laps.drawBest(data)
    end

    -- Setores
    if sessionLapsSettings.store.sectorsLapActive then
        sectors.drawSectors(data)
    end
    
    
    data.currentWindowSize = vec2(data.currentWindowWidth, data.currentWindowHeight * sessionLapsSettings.store.sessionLapsScale)

    window.resize(data.currentWindowSize, "Session Laps")
    pinCheckBox.main(sessionLapsSettings.store.sessionLapsScale, "Session Laps",
        window.getWindow("Session Laps"):pinned(), data.currentWindowSize)
end

return sessionLaps
