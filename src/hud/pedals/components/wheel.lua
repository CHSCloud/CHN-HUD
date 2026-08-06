local pedalsSettings = require("src.settings.tabs.pedalsSettings")
local wheel = {}

---@param data pedalsData
function wheel.drawWheel(data)
    local wheelBackgroundSize = vec2(55 * pedalsSettings.store.pedalsScale, data.currentWindowHeight)
    data.contentMidle = 73 * pedalsSettings.store.pedalsScale

    local p1 = data.currentWindowWidth - 4 * pedalsSettings.store.pedalsScale
    local p2 = 1 * pedalsSettings.store.pedalsScale + data.contentTop
    local width = 65 * pedalsSettings.store.pedalsScale
    local height = 72 * pedalsSettings.store.pedalsScale
    if pedalsSettings.store.wheelType == 1 then
        local thickness = 7 * pedalsSettings.store.pedalsScale
        local length = 5 * pedalsSettings.store.pedalsScale
        ui.beginRotation()
        ui.drawCircle(vec2(p1 + (width / 2), p2 + (height / 2)), width / 2 - thickness, COLOR.GRAY_BG, 50, thickness)
        ui.drawRectFilled(
            vec2(p1 + (width / 2) - length, p2 + thickness),
            vec2(p1 + (width / 2) + length, p2 + 15 * pedalsSettings.store.pedalsScale),
            COLOR.YELLOW_DARK,
            2 * pedalsSettings.store.pedalsScale
        )
        ui.endRotation(90 - CAR.steer)
    else
        ui.setCursor(vec2(p1, p2))
        ui.beginRotation()
        ui.image("assets/pedals/wheels/" .. Wheels[pedalsSettings.store.wheelType], vec2(width, height), ui.ImageFit.Fit)
        ui.endRotation(90 - CAR.steer)
        
    end
    
    data.currentWindowWidth = data.currentWindowWidth + wheelBackgroundSize.x + 12 * pedalsSettings.store.pedalsScale +
    data.barSpace
end

return wheel
