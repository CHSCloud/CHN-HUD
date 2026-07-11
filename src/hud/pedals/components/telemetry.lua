local pedalsSettings = require("src.settings.tabs.pedalsSettings")

local telemetry = {}

local function drawGrafh(telemetryData, parameter, color, min, max, data)
    telemetryData[#telemetryData+1] = parameter
    table.remove(telemetryData, 1)
    
    local lenght = (max.x - min.x) / data.maxPointsTelemetry
    ui.pathClear()
    for i, value in ipairs(telemetryData) do
        ui.pathLineTo(vec2(min.x + i * lenght, max.y - value * (max.y - data.contentTop - 8 * pedalsSettings.store.pedalsScale)))
    end
    ui.pathSimpleStroke(color, false, 2)
end


---@param data pedalsData
function telemetry.drawTelemetry(data)
    
    local min = vec2(10 * pedalsSettings.store.pedalsScale, 8 * pedalsSettings.store.pedalsScale + data.contentTop)
    local max = vec2(200 * pedalsSettings.store.pedalsScale, data.currentWindowSize.y - (8 * pedalsSettings.store.pedalsScale + data.contentBottom))
    ui.drawRectFilled(
        min, 
        max, 
        COLOR.GRAY_BG
    )

    if pedalsSettings.store.telemetryThrottle then
        drawGrafh(data.throttleTelemetry, CAR.gas, COLOR.GREEN, min, max, data)  
    end

    if pedalsSettings.store.telemetryBrake then
        drawGrafh(data.brakeTelemetry, CAR.brake, COLOR.RED, min, max, data)
    end

    if pedalsSettings.store.telemetryClucth then
        drawGrafh(data.clutchTelemetry, 1 - CAR.clutch, COLOR.BLUE, min, max, data)
    end

    if pedalsSettings.store.telemetryHandbrake then
        drawGrafh(data.handbrakeTelemetry, CAR.handbrake, COLOR.YELLOW, min, max, data)
    end
end

return telemetry