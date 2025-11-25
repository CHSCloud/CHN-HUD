local config = require("common.config")
local pinCheckBox = require("src.ui.pinCheckBox")
local startingLightsSettings = require("src.settings.tabs.startingLightsSettings")
local startingLights = {}

local function map(value, inMin, inMax, outMin, outMax)
    local output = outMin + (value - inMin) * (outMax - outMin) / (inMax - inMin)
    if output > outMax then
        output = outMax
    elseif output < outMin then
        output = outMin
    end
    return output
end

function startingLights.windowMain()
    local radius = 20 * startingLightsSettings.store.startingLightsScale
    local pos = radius + radius / 2 + 2 * startingLightsSettings.store.startingLightsScale
    local distance = radius * 2 + radius / 2
    local thickness = 1.5 * startingLightsSettings.store.startingLightsScale
    local distanceBorder = 4 * startingLightsSettings.store.startingLightsScale
    local polygons = 50
    local rounding = 10 * startingLightsSettings.store.startingLightsScale
    local rounding2 = 6 * startingLightsSettings.store.startingLightsScale
    local currentWindowHeight = 3 * radius + distanceBorder
    local currentWindowWidth = (4 * distance) + 3 * radius + distanceBorder

    if(SIM.currentSessionTime < 0) then
        ui.drawRectFilled(vec2(0, 0), vec2(currentWindowWidth, currentWindowHeight), WindowsColor, rounding)
        ui.drawRect(vec2(distanceBorder, distanceBorder), vec2(currentWindowWidth - distanceBorder, currentWindowHeight - distanceBorder), COLOR.WHITE, rounding2, ui.CornerFlags.All, thickness)

        ui.drawCircleFilled(vec2(pos, currentWindowHeight / 2), map(SIM.currentSessionTime, -10000, -8000, 0, radius), COLOR.GREEN, polygons)
        ui.drawCircleFilled(vec2(pos + distance, currentWindowHeight / 2), map(SIM.currentSessionTime, -8000, -6000, 0, radius), COLOR.GREEN, polygons)
        ui.drawCircleFilled(vec2(pos + distance * 2, currentWindowHeight / 2), map(SIM.currentSessionTime, -6000, -4000, 0, radius), COLOR.GREEN, polygons)
        ui.drawCircleFilled(vec2(pos + distance * 3, currentWindowHeight / 2), map(SIM.currentSessionTime, -4000, -2000, 0, radius), COLOR.GREEN, polygons)
        ui.drawCircleFilled(vec2(pos + distance * 4, currentWindowHeight / 2), map(SIM.currentSessionTime, -2000, 0, 0, radius), COLOR.GREEN, polygons)
    elseif SIM.currentSessionTime < 4000 then
        ui.drawRectFilled(vec2(0, 0), vec2(currentWindowWidth, currentWindowHeight), WindowsColor, rounding)
        ui.drawRect(vec2(distanceBorder, distanceBorder), vec2(currentWindowWidth - distanceBorder, currentWindowHeight - distanceBorder), COLOR.WHITE, rounding2, ui.CornerFlags.All, thickness)
        if 6 * Timer % 2 > 1 then
            ui.drawCircleFilled(vec2(pos, currentWindowHeight / 2), radius, COLOR.RED, polygons)
            ui.drawCircleFilled(vec2(pos + distance, currentWindowHeight / 2), radius, COLOR.RED, polygons)
            ui.drawCircleFilled(vec2(pos + distance * 2, currentWindowHeight / 2), radius, COLOR.RED, polygons)
            ui.drawCircleFilled(vec2(pos + distance * 3, currentWindowHeight / 2), radius, COLOR.RED, polygons)
            ui.drawCircleFilled(vec2(pos + distance * 4, currentWindowHeight / 2), radius, COLOR.RED, polygons)
        end
    elseif SettingsActive then
        ui.drawRectFilled(vec2(0, 0), vec2(currentWindowWidth, currentWindowHeight), WindowsColor, rounding)
        ui.drawRect(vec2(distanceBorder, distanceBorder), vec2(currentWindowWidth - distanceBorder, currentWindowHeight - distanceBorder), COLOR.WHITE, rounding2, ui.CornerFlags.All, thickness)
        ui.drawCircleFilled(vec2(pos, currentWindowHeight / 2), radius, COLOR.BLUE, polygons)
        ui.drawCircleFilled(vec2(pos + distance, currentWindowHeight / 2), radius, COLOR.BLUE, polygons)
        ui.drawCircleFilled(vec2(pos + distance * 2, currentWindowHeight / 2), radius, COLOR.BLUE, polygons)
        ui.drawCircleFilled(vec2(pos + distance * 3, currentWindowHeight / 2), radius, COLOR.BLUE, polygons)
        ui.drawCircleFilled(vec2(pos + distance * 4, currentWindowHeight / 2), radius, COLOR.BLUE, polygons)
    end

    config.resize(vec2(currentWindowWidth, currentWindowHeight), "Starting Lights")
    pinCheckBox.main(startingLightsSettings.store.startingLightsScale, "Starting Lights", config.getWindow("Starting Lights"):pinned(), vec2(currentWindowWidth, currentWindowHeight))
end

return startingLights