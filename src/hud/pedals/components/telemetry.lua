local pedalsSettings = require("src.settings.tabs.pedalsSettings")
local utils = require("common.utils")

local telemetry = {}
---@param telemetryData table
---@param parameter number
---@param color rgbm
---@param min vec2
---@param max vec2
local function drawGraph(telemetryData, parameter, color, min, max)
    telemetryData[#telemetryData+1] = utils.smoothValue(telemetryData[#telemetryData], parameter, 0.4)
    table.remove(telemetryData, 1)

    local lenght = (max.x - min.x) / pedalsSettings.store.telemetryLenght * 1.5

    ui.pathClear()
    for i, value in ipairs(telemetryData) do
        local xAxis = max.x - (#telemetryData - i) * lenght
        
        if xAxis >= min.x then
            ui.pathLineTo(vec2(xAxis, max.y - value * (max.y - 10 * pedalsSettings.store.pedalsScale)))
        end
    end
    ui.pathSimpleStroke(color, false, 2)
end

---@param telemetryData table
---@param parameter number
---@param color rgbm
---@param min vec2
---@param max vec2
local function drawGraphInverted(telemetryData, parameter, color, min, max)
    table.insert(telemetryData, 1, utils.smoothValue(telemetryData[1], parameter, 0.4))
    table.remove(telemetryData, #telemetryData)
    
    local lenght = (max.x - min.x) / pedalsSettings.store.telemetryLenght * 1.5

    ui.pathClear()
    for i, value in ipairs(telemetryData) do
        local xAxis = min.x + i * lenght
        if xAxis < max.x then
            ui.pathLineTo(vec2(xAxis, max.y - value * (max.y - 10 * pedalsSettings.store.pedalsScale)))
        end
    end
    ui.pathSimpleStroke(color, false, 2)
end

---@param data pedalsData
function telemetry.drawTelemetry(data)
    local min = vec2(data.currentWindowWidth + 10 * pedalsSettings.store.pedalsScale, 10 * pedalsSettings.store.pedalsScale)
    local max = vec2(data.currentWindowWidth + pedalsSettings.store.telemetryLenght * pedalsSettings.store.pedalsScale - 10 * pedalsSettings.store.pedalsScale, data.currentWindowSize.y - 10 * pedalsSettings.store.pedalsScale)

    local totalHeight = max.y - min.y
    local rectHeight = totalHeight / 4
    local rectWidth = max.x - min.x 
    local padding
    local init = min
    for i = 1, 4, 1 do
        if i == 4 then
            padding =  0
        else
            padding =  2 * pedalsSettings.store.pedalsScale
        end
        ui.drawRectFilled(
            init, 
            init + vec2(rectWidth, rectHeight - padding), 
            COLOR.GRAY_BG
        )
        init = init + vec2(0, rectHeight)
    end
    
    local functionGraph
    if pedalsSettings.store.telemetryInverted then
        functionGraph = drawGraphInverted
    else
        functionGraph = drawGraph
    end

    if pedalsSettings.store.telemetryThrottle then
        functionGraph(data.throttleTelemetry, CAR.gas, COLOR.GREEN, min, max)
    end

    if pedalsSettings.store.telemetryBrake then
        functionGraph(data.brakeTelemetry, CAR.brake, COLOR.RED, min, max)
    end

    if pedalsSettings.store.telemetryClucth then
        functionGraph(data.clutchTelemetry, 1 - CAR.clutch, COLOR.BLUE, min, max)
    end

    if pedalsSettings.store.telemetryHandbrake then
        functionGraph(data.handbrakeTelemetry, CAR.handbrake, COLOR.YELLOW, min, max)
    end
end

return telemetry