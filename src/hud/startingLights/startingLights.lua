local config = require("common.config")
local pinCheckBox = require("src.ui.buttons.pinCheckBox")
local startingLightsSettings = require("src.settings.tabs.startingLightsSettings")
local startingLightsData = require("src.data.startingLights.startingLightsData")

local sessionStarting = require("src.hud.startingLights.render.sessionStarting")
local sessionStarted = require("src.hud.startingLights.render.sessionStarted")
local settingsActive = require("src.hud.startingLights.render.settingsActive")

local startingLights = {}

---@type startingLightsData
local data = startingLightsData.new()

function startingLights.windowMain()
    -- Raio
    data.radius = 20 * startingLightsSettings.store.startingLightsScale
    -- Posição do primeiro círculo
    data.pos = data.radius + data.radius / 2 + 2 * startingLightsSettings.store.startingLightsScale
    -- Distância entre os círculos
    data.distance = data.radius * 2 + data.radius / 2
    -- Grossura
    data.thickness = 1.5 * startingLightsSettings.store.startingLightsScale
    -- Distancia da borda
    data.distanceBorder = 4 * startingLightsSettings.store.startingLightsScale
    --Polígonos dos círculos
    data.polygons = 50
    data.rounding = 50 * startingLightsSettings.store.startingLightsScale

    -- Proporções da tela
    data.currentWindowHeight = 3 * data.radius + data.distanceBorder
    data.currentWindowWidth = ((startingLightsSettings.store.numStartingLights - 1) * data.distance) + 3 * data.radius + data.distanceBorder
    
    config.resize(vec2(data.currentWindowWidth, data.currentWindowHeight), "Starting Lights")

    if SIM.raceSessionType == ac.SessionType.Race then
        if SIM.timeToSessionStart < 10000 and SIM.timeToSessionStart > 0 then
            sessionStarting.drawSessionStarting(data)

        elseif SIM.timeToSessionStart > -6000 and SIM.timeToSessionStart < 0 then
            sessionStarted.drawSessionStarted(data)

        elseif SettingsActive then
            settingsActive.drawSettingsActive(data)
        end

    elseif SettingsActive then
        settingsActive.drawSettingsActive(data)
    end
    pinCheckBox.main(startingLightsSettings.store.startingLightsScale, "Starting Lights", config.getWindow("Starting Lights"):pinned(), vec2(data.currentWindowWidth, data.currentWindowHeight))
end

return startingLights
