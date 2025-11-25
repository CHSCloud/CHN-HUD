local config = require("common.config")

local startingLights = {}

local currentWindowWidth
local currentWindowHeight

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
    local radius = 20
    local pos = radius + radius / 2
    local distance = radius * 2 + 10
    local polygons = 50
    currentWindowHeight = 2 * radius + radius
    currentWindowWidth = (4 * distance) + radius * 2 + radius

    if(SIM.currentSessionTime < 0) then
        ui.drawRectFilled(vec2(0, 0), vec2(currentWindowWidth, currentWindowHeight), WindowsColor, 10)
        ui.drawCircleFilled(vec2(pos, currentWindowHeight / 2), map(SIM.currentSessionTime, -10000, -8000, 0, radius), COLOR.GREEN, polygons)
        ui.drawCircleFilled(vec2(pos + distance, currentWindowHeight / 2), map(SIM.currentSessionTime, -8000, -6000, 0, radius), COLOR.GREEN, polygons)
        ui.drawCircleFilled(vec2(pos + distance * 2, currentWindowHeight / 2), map(SIM.currentSessionTime, -6000, -4000, 0, radius), COLOR.GREEN, polygons)
        ui.drawCircleFilled(vec2(pos + distance * 3, currentWindowHeight / 2), map(SIM.currentSessionTime, -4000, -2000, 0, radius), COLOR.GREEN, polygons)
        ui.drawCircleFilled(vec2(pos + distance * 4, currentWindowHeight / 2), map(SIM.currentSessionTime, -2000, 0, 0, radius), COLOR.GREEN, polygons)
    elseif SIM.currentSessionTime < 4000 then
        ui.drawRectFilled(vec2(0, 0), vec2(currentWindowWidth, currentWindowHeight), WindowsColor, 10)
        if 6 * Timer % 2 > 1 then
            ui.drawCircleFilled(vec2(pos, currentWindowHeight / 2), radius, COLOR.RED, polygons)
            ui.drawCircleFilled(vec2(pos + distance, currentWindowHeight / 2), radius, COLOR.RED, polygons)
            ui.drawCircleFilled(vec2(pos + distance * 2, currentWindowHeight / 2), radius, COLOR.RED, polygons)
            ui.drawCircleFilled(vec2(pos + distance * 3, currentWindowHeight / 2), radius, COLOR.RED, polygons)
            ui.drawCircleFilled(vec2(pos + distance * 4, currentWindowHeight / 2), radius, COLOR.RED, polygons)
        end
    elseif SettingsActive then
        ui.drawRectFilled(vec2(0, 0), vec2(currentWindowWidth, currentWindowHeight), WindowsColor, 10)
        ui.drawCircleFilled(vec2(pos, currentWindowHeight / 2), radius, COLOR.BLUE, polygons)
        ui.drawCircleFilled(vec2(pos + distance, currentWindowHeight / 2), radius, COLOR.BLUE, polygons)
        ui.drawCircleFilled(vec2(pos + distance * 2, currentWindowHeight / 2), radius, COLOR.BLUE, polygons)
        ui.drawCircleFilled(vec2(pos + distance * 3, currentWindowHeight / 2), radius, COLOR.BLUE, polygons)
        ui.drawCircleFilled(vec2(pos + distance * 4, currentWindowHeight / 2), radius, COLOR.BLUE, polygons)
    end
    
    --ui.drawText(tostring(SIM.currentSessionTime), vec2(10,10), COLOR.WHITE)
    config.resize(vec2(currentWindowWidth, currentWindowHeight), "Starting Lights")
end

return startingLights