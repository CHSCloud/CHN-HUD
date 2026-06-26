local startingLightsSettings = require("src.settings.tabs.startingLightsSettings")
local utils = require("common.utils")
local sessionStarting = {}

--- @param data startingLightsData
function sessionStarting.drawSessionStarting(data)
    -- Background
    ui.drawRectFilled(vec2(0, 0), vec2(data.currentWindowWidth, data.currentWindowHeight), WindowsColor, data.rounding)
    ui.drawRect(vec2(data.distanceBorder, data.distanceBorder), vec2(data.currentWindowWidth - data.distanceBorder, data.currentWindowHeight - data.distanceBorder), COLOR.WHITE, data.rounding, ui.CornerFlags.All, data.thickness)

    -- Círculos do background
    for i = 0, startingLightsSettings.store.numStartingLights - 1, 1 do
        ui.drawCircleFilled(vec2(data.pos + i * data.distance , data.currentWindowHeight / 2), data.radius, COLOR.GRAY_BG, data.polygons)
        ui.drawCircle(vec2(data.pos + i * data.distance , data.currentWindowHeight / 2), data.radius, COLOR.WHITE, data.polygons, data.thickness)
    end

    -- Círculos Vermelhos
    local add = -(5000 / startingLightsSettings.store.numStartingLights)
    local current = 0
    for i = 7000, 2000, add do
        
        if SIM.timeToSessionStart < i and i > 2000 and current <= startingLightsSettings.store.numStartingLights - 1 then
            ui.drawCircleFilled(vec2(data.pos + current * data.distance , data.currentWindowHeight / 2), utils.remapIntervalWithLimits(SIM.timeToSessionStart, i, i + add, 0, data.radius), COLOR.RED, data.polygons)
            ui.drawCircle(vec2(data.pos + current * data.distance , data.currentWindowHeight / 2), data.radius, COLOR.WHITE, data.polygons, data.thickness)
        end 
        current = current + 1
    end
    
end

return sessionStarting