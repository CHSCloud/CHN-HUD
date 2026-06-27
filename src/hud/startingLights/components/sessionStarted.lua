local startingLightsSettings = require("src.settings.tabs.startingLightsSettings")
local sessionStarted = {}

--- @param data startingLightsData
function sessionStarted.drawSessionStarted(data)
    -- Background
    ui.drawRectFilled(vec2(0, 0), vec2(data.currentWindowWidth, data.currentWindowHeight), WindowsColor, data.rounding)
    ui.drawRect(vec2(data.distanceBorder, data.distanceBorder),
        vec2(data.currentWindowWidth - data.distanceBorder, data.currentWindowHeight - data.distanceBorder), COLOR.WHITE,
        data.rounding, ui.CornerFlags.All, data.thickness)

    -- Cículos verdes
    if 2 * TIMER % 2 > 1 then
        for i = 0, startingLightsSettings.store.numStartingLights - 1, 1 do
            if i % 2 == 0 then
                ui.drawCircleFilled(vec2(data.pos + i * data.distance, data.currentWindowHeight / 2), data.radius,
                    COLOR.GREEN, data.polygons)
            else
                ui.drawCircleFilled(vec2(data.pos + i * data.distance, data.currentWindowHeight / 2), data.radius,
                    COLOR.GRAY_BG, data.polygons)
            end
            ui.drawCircle(vec2(data.pos + i * data.distance, data.currentWindowHeight / 2), data.radius, COLOR.WHITE,
                data.polygons, data.thickness)
        end
    else
        for i = 0, startingLightsSettings.store.numStartingLights - 1, 1 do
            if i % 2 == 1 then
                ui.drawCircleFilled(vec2(data.pos + i * data.distance, data.currentWindowHeight / 2), data.radius,
                    COLOR.GREEN, data.polygons)
            else
                ui.drawCircleFilled(vec2(data.pos + i * data.distance, data.currentWindowHeight / 2), data.radius,
                    COLOR.GRAY_BG, data.polygons)
            end
            ui.drawCircle(vec2(data.pos + i * data.distance, data.currentWindowHeight / 2), data.radius, COLOR.WHITE,
                data.polygons, data.thickness)
        end
    end
end

return sessionStarted
