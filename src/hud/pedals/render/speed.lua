local pedalsSettings = require("src.settings.tabs.pedalsSettings")
local speed = {}

---@param data pedalsData
function speed.drawSpeed(data)
    data.contentMidle = 73 * pedalsSettings.store.pedalsScale
    data.gearBackgroundWidth = 60 * pedalsSettings.store.pedalsScale
    data.currentWindowWidth = data.gearBackgroundWidth
    data.fontSpeed = 20 * pedalsSettings.store.pedalsScale
    local speed
    if SelectedSpeed == 1 then
        speed = string.format("%.0f", CAR.speedKmh)
    else
        speed = string.format("%.0f", CAR.speedKmh * 0.621371)
    end

    if pedalsSettings.store.gearActive then
        ui.setCursor(vec2(11, 41):scale(pedalsSettings.store.pedalsScale) + vec2(0, data.contentTop))
        ui.dwriteTextAligned(speed, data.fontSpeed, ui.Alignment.Center, ui.Alignment.Center,
            vec2(50, 30):scale(pedalsSettings.store.pedalsScale), false, COLOR.WHITE)
    else
        data.fontSpeed = 25 * pedalsSettings.store.pedalsScale
        ui.setCursor(vec2(11, 19):scale(pedalsSettings.store.pedalsScale) + vec2(0, data.contentTop))
        ui.dwriteTextAligned(speed, data.fontSpeed, ui.Alignment.Center, ui.Alignment.Center,
            vec2(50, 35):scale(pedalsSettings.store.pedalsScale), false, COLOR.WHITE)
    end
end

return speed
