local utils = require("common.utils")
local wheels = {}

---@param lutData ac.DataLUT11
---@param currentTemp number
---@param initTemp number
---@param finalTemp number
---@return rgbm
local function getColorWheel(lutData, currentTemp, initTemp, finalTemp)
    local gripOptimum = lutData:get(initTemp)
    local currentGrip = lutData:get(currentTemp)
    local transition = utils.remapIntervalWithLimits(currentGrip, gripOptimum * 0.97, gripOptimum, 0, 1)
    if currentTemp < initTemp then
        return utils.colorLerp(COLOR.BLUE, COLOR.GREEN, transition)

    elseif currentTemp >= initTemp and currentTemp <= finalTemp then
        return COLOR.GREEN
        
    else
        return utils.colorLerp(COLOR.RED, COLOR.GREEN, transition)
    end
end


---@param lutData ac.DataLUT11
---@param wheel ac.StateWheel
---@param pos vec2
---@param initTemp number
---@param finalTemp number
local function drawWheel(lutData, wheel, pos, initTemp, finalTemp)
    local color = COLOR.BLUE
    ui.setCursor(pos + vec2(0, 70))
    ui.text(string.format("%.1f", wheel.tyreInsideTemperature))
    
    color = getColorWheel(lutData, wheel.tyreInsideTemperature, initTemp, finalTemp)
    ui.drawRectFilled(pos, pos + vec2(14,70), color, 10, ui.CornerFlags.Left)

    color = getColorWheel(lutData, wheel.tyreMiddleTemperature, initTemp, finalTemp)
    ui.drawRectFilled(pos + vec2(16), pos + vec2(30,70), color)
   
    color = getColorWheel(lutData, wheel.tyreOutsideTemperature, initTemp, finalTemp)
    ui.drawRectFilled(pos + vec2(32), pos + vec2(46,70), color, 10, ui.CornerFlags.Right)
end

---@param data tyresData
---@param pos vec2
---@param index number
function wheels.drawWheelInfo(data, pos, index)
    local posWheel = pos + vec2(50)
    local textAligment = ui.Alignment.End
    local posPsi = pos - vec2(30)
    local posCoreTemp = pos + vec2(-30, 50)
    local posWear = pos + vec2(50, -22)
    local lutData = data.lutRearData

    if index == 1 or index == 3 then
        posWheel = pos
        posPsi = pos + vec2(56)
        textAligment = ui.Alignment.Start
        posCoreTemp = pos + vec2(56, 50)
        posWear = pos + vec2(0, -22)
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
    ui.dwriteTextAligned(string.format("%0.f%%", (1 - wheel.tyreWear) * 100), 15, ui.Alignment.Center, ui.Alignment.Center, vec2(50,20))
    
    ui.setCursor(posPsi)
    ui.dwriteTextAligned(string.format("%0.f psi", wheel.tyrePressure), 15, textAligment, ui.Alignment.Center, vec2(70,20))

    local tyreCoreColor = COLOR.BLUE_SKY
    if wheel.tyreCoreTemperature > 50 then
        tyreCoreColor = utils.colorLerp(
            COLOR.BLUE_SKY, 
            COLOR.GREEN, 
            utils.remapIntervalWithLimits(wheel.tyreCoreTemperature, 50, 70, 0, 1)
        )
    end
    ui.setCursor(posCoreTemp)
    ui.dwriteTextAligned(string.format("%0.f ºC", wheel.tyreCoreTemperature), 15, textAligment, ui.Alignment.Center, vec2(70,20), false, tyreCoreColor)

end

return wheels