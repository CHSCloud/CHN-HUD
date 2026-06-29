local utils = require("common.utils")
local wheels = {}

---comment
---@param data tyresData
---@param pos vec2
---@param index number
function wheels.drawWheel(data, pos, index)
    local posWheel = pos + vec2(50)
    local textAligment = ui.Alignment.End
    local posPsi = pos - vec2(30)
    local posCoreTemp = pos + vec2(-30, 60)
    local posWear = pos + vec2(44, -22)
    
    if index == 1 or index == 3 then
        posWheel = pos
        posPsi = pos + vec2(42)
        textAligment = ui.Alignment.Start
        posCoreTemp = pos + vec2(42, 60)
        posWear = pos + vec2(-4, -22)
    end



    local wheel = data.wheels[index]
    ui.drawRectFilled(posWheel, posWheel + vec2(10,80), COLOR.WHITE, 10, ui.CornerFlags.Left)
    ui.drawRectFilled(posWheel + vec2(12), posWheel + vec2(22,80), COLOR.WHITE)
    ui.drawRectFilled(posWheel + vec2(24), posWheel + vec2(34,80), COLOR.WHITE, 10, ui.CornerFlags.Right)

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