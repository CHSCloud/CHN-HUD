local tyresSettings = require("src.settings.tabs.tyresSettings")
local utils = require("common.utils")
local wheels = {}

---@param lutData ac.DataLUT11
---@param currentTemp number
---@param initTemp number
---@param finalTemp number
---@param initialColor rgbm
---@param middleColor rgbm
---@param finalColor rgbm
---@return rgbm
local function getColorByTemperature(lutData, currentTemp, initTemp, finalTemp, initialColor, middleColor, finalColor)
    local gripOptimum = lutData:get(initTemp)
    local currentGrip = lutData:get(currentTemp)
    local transition = utils.remapIntervalWithLimits(currentGrip, gripOptimum * 0.97, gripOptimum, 0, 1)
    if currentTemp < initTemp then
        return utils.colorLerp(initialColor, middleColor, transition)

    elseif currentTemp >= initTemp and currentTemp <= finalTemp then
        return middleColor

    else
        return utils.colorLerp(finalColor, middleColor, transition)
    end
end

---@param lutData ac.DataLUT11
---@param wheel ac.StateWheel
---@param pos vec2
---@param initTemp number
---@param finalTemp number
local function drawWheel(lutData, wheel, pos, initTemp, finalTemp)
    local color
    color = getColorByTemperature(lutData, wheel.tyreInsideTemperature, initTemp, finalTemp, COLOR.BLUE, COLOR.GREEN, COLOR.RED)
    ui.drawRectFilled(pos, pos + vec2(14,70):scale(tyresSettings.store.tyresScale), color, 10 * tyresSettings.store.tyresScale, ui.CornerFlags.Left)

    color = getColorByTemperature(lutData, wheel.tyreMiddleTemperature, initTemp, finalTemp, COLOR.BLUE, COLOR.GREEN, COLOR.RED)
    ui.drawRectFilled(pos + vec2(16):scale(tyresSettings.store.tyresScale), pos + vec2(30,70):scale(tyresSettings.store.tyresScale), color)
   
    color = getColorByTemperature(lutData, wheel.tyreOutsideTemperature, initTemp, finalTemp, COLOR.BLUE, COLOR.GREEN, COLOR.RED)
    ui.drawRectFilled(pos + vec2(32):scale(tyresSettings.store.tyresScale), pos + vec2(46,70):scale(tyresSettings.store.tyresScale), color, 10 * tyresSettings.store.tyresScale, ui.CornerFlags.Right)
end

---@param data tyresData
---@param pos vec2
---@param index number
function wheels.drawWheelInfo(data, pos, index)
    local posWheel = pos + vec2(50):scale(tyresSettings.store.tyresScale)
    local textAligment = ui.Alignment.End
    local posPsi = pos - vec2(30):scale(tyresSettings.store.tyresScale)
    local posCoreTemp = pos + vec2(-30, 50):scale(tyresSettings.store.tyresScale)
    local posWear = pos + vec2(50, -22):scale(tyresSettings.store.tyresScale)
    local lutData = data.lutRearData

    if index == 1 or index == 3 then
        posWheel = pos
        posPsi = pos + vec2(56):scale(tyresSettings.store.tyresScale)
        textAligment = ui.Alignment.Start
        posCoreTemp = pos + vec2(56, 50):scale(tyresSettings.store.tyresScale)
        posWear = pos + vec2(0, -22):scale(tyresSettings.store.tyresScale)
    end

    local wheel = data.wheels[index]

    local initTemp = data.rearMinTemp
    local finalTemp = data.rearMaxTemp
    if index == 0 or index == 1 then
        initTemp = data.frontMinTemp
        finalTemp = data.frontMaxTemp  
        lutData = data.lutFrontData
    end
    drawWheel(lutData, wheel, posWheel, initTemp, finalTemp)

    ui.setCursor(posWear)
    ui.dwriteTextAligned(string.format("%0.f%%", (1 - wheel.tyreWear) * 100), 15 * tyresSettings.store.tyresScale, ui.Alignment.Center, ui.Alignment.Center, vec2(50,20):scale(tyresSettings.store.tyresScale))
    
    ui.setCursor(posPsi)
    ui.dwriteTextAligned(string.format("%0.f psi", wheel.tyrePressure), 15 * tyresSettings.store.tyresScale, textAligment, ui.Alignment.Center, vec2(70,20):scale(tyresSettings.store.tyresScale))

    local tyreCoreColor = getColorByTemperature(data.lutFrontData, wheel.tyreCoreTemperature, data.frontMinTemp, data.frontMaxTemp, COLOR.BLUE_SKY, COLOR.GREEN, COLOR.RED)
    ui.setCursor(posCoreTemp)
    ui.dwriteTextAligned(string.format("%0.f ºC", wheel.tyreCoreTemperature), 15 * tyresSettings.store.tyresScale, textAligment, ui.Alignment.Center, vec2(70,20):scale(tyresSettings.store.tyresScale), false, tyreCoreColor)

end

return wheels