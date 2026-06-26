local sessionLapsSettings = require("src.settings.tabs.sessionLapsSettings")
local language = require("lang.language")
local pinCheckBox = require("src.ui.pinCheckBox")
local config = require("common.config")
local sessionLapsData = require("src.data.sessionLaps.sessionLapsData")

local laps = require("src.hud.sessionLaps.render.laps") 

local sessionLaps = {}
--- @type sessionLapsData
local data = sessionLapsData.new()

if ac.onSessionStart then
    ac.onSessionStart(function()
        data.previousBestlap = 0
    end)
end


function sessionLaps.windowMain()
    ui.pushDWriteFont("fonts/Montserrat-Bold.ttf") -- FONT TEXT

    data.currentWindowWidth = 240 * sessionLapsSettings.store.sessionLapsScale
    data.currentWindowHeight = 0
    
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
    if CAR.previousLapTimeMs == CAR.bestLapTimeMs and CAR.isLastLapValid then
        data.previousBestlap = CAR.bestLapTimeMs
    end
    if sessionLapsSettings.store.bestLapActive then
        laps.drawBest(data)
    end
    
    data.currentWindowSize = vec2(data.currentWindowWidth, data.currentWindowHeight * sessionLapsSettings.store.sessionLapsScale)

    config.resize(data.currentWindowSize, "Session Laps")
    pinCheckBox.main(sessionLapsSettings.store.sessionLapsScale, "Session Laps", config.getWindow("Session Laps"):pinned(), data.currentWindowSize)
end

return sessionLaps
