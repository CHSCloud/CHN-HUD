local pedalsSettings = require("src.settings.tabs.pedalsSettings")
local pedalsData = require("src.data.pedals.pedalsData")
local fuel = {}

---@param data pedalsData
function fuel.drawFuel(data)
    local fuelColor = COLOR.WHITE
    if CAR.fuel < 5.005 then
        fuelColor = COLOR.RED_DARK
    elseif CAR.fuel < 9.995 then
        fuelColor = COLOR.YELLOW_DARK
    end

    pedalsData.setPositionContentBorder(data, pedalsSettings.store.fuelPos,
        vec2(65, 20):scale(pedalsSettings.store.pedalsScale))
    ui.setCursor(data.contentPositions[pedalsSettings.store.fuelPos][1] + vec2(22) * pedalsSettings.store.pedalsScale)
    ui.dwriteTextAligned(string.format("%.2f", math.max(0, CAR.fuel)), data.fontContentBottom, ui.Alignment.Start,
        ui.Alignment.Center, vec2(50, 20):scale(pedalsSettings.store.pedalsScale), false, fuelColor)
    ui.setCursor(data.contentPositions[pedalsSettings.store.fuelPos][1] +
    vec2(4, 2.5):scale(pedalsSettings.store.pedalsScale))
    if CAR.fuel < 5.005 then
        if (4 * TIMER) % 2 >= 1 then
            ui.image("assets/pedals/Fuel.png", vec2(16, 16):scale(pedalsSettings.store.pedalsScale), fuelColor,
                ui.ImageFit.Fit)
        end
    else
        ui.image("assets/pedals/Fuel.png", vec2(16, 16):scale(pedalsSettings.store.pedalsScale), fuelColor,
            ui.ImageFit.Fit)
    end
end

return fuel
